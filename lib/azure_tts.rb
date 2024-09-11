require "azure_tts/version"
require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'ruby_speech'

module AzureTTS
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key, :region

    def initialize
      @api_key = nil
      @region = nil
    end
  end

  class Client
    def initialize(api_key = nil, region = nil)
      @api_key = api_key || AzureTTS.configuration.api_key
      @region = region || AzureTTS.configuration.region
      raise Error, "API key and region must be set" if @api_key.nil? || @region.nil?
      @access_token = fetch_access_token
    end

    def speak(text, voice_options = {})
      tts_request(text, voice_options)
    end

    def speak_file(text, output_file = "output.wav", voice_options = {})
      audio_data = tts_request(text, voice_options)
      File.open(output_file, 'wb') { |file| file.write(audio_data) }
      output_file
    end

    def speak_to_active_storage(text, attachment, voice_options = {})
      audio_data = speak(text, voice_options)
      temp_file = Tempfile.new(['azure_tts', '.wav'])
      temp_file.binmode
      temp_file.write(audio_data)
      temp_file.rewind

      attachment.attach(
        io: File.open(temp_file.path),
        filename: "tts_output_#{Time.now.to_i}.wav",
        content_type: 'audio/wav'
      )
    ensure
      temp_file&.close
      temp_file&.unlink
    end

    private

    def fetch_access_token
      url = URI.parse("https://#{@region}.api.cognitive.microsoft.com/sts/v1.0/issueToken")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      headers = {
        'Ocp-Apim-Subscription-Key' => @api_key
      }

      resp = http.post(url.path, "", headers)
      raise Error, "Failed to fetch access token: #{resp.body}" unless resp.is_a?(Net::HTTPSuccess)

      resp.body
    end

    def tts_request(text, voice_options)
      url = URI.parse("https://#{@region}.tts.speech.microsoft.com/cognitiveservices/v1")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      headers = {
        'content-type' => 'application/ssml+xml',
        'X-Microsoft-OutputFormat' => 'audio-16khz-128kbitrate-mono-mp3',
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => 'AzureTTSRubyGem'
      }

      data = RubySpeech::SSML.draw do
        voice voice_options do
          string text
        end
      end

      resp = http.post(url.path, data.to_s, headers)
      raise Error, "TTS request failed: #{resp.body}" unless resp.is_a?(Net::HTTPSuccess)

      resp.body
    end
  end
end
