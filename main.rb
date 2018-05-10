require 'httparty'
require 'active_support/all'
require 'config'
require 'pushbullet_ruby'

$config = Config.load_and_set_settings(Config.setting_files("config", 'production'))

class Push
  attr_reader :client

  def initialize
    @client = PushbulletRuby::Client.new("token": $config.pushbullet.token)
  end

  def push_android(content)
    client.push_note(
      receiver: :device,
      id: $config.pushbullet.android,
      params: {
        title: 'Where is my bus',
        body: content
      }
    )
  end
end

class Bus
  include HTTParty
  base_uri 'http://n2.basiapp.com'

  class << self

    def bus_info(type)
      parse_response(request(type).body)
    end

    private

    def request(type)
      self.post('/BashiGoService/GetMoreBus', body: $config.send(type).param)
    end

    def parse_response(body)
      bus_list = JSON.parse(body).deep_symbolize_keys[:list]
      result_string = ''
      return '等待发车' if bus_list.empty?
      bus_list[0,3].each do |item|
        result_string += "第#{item[:latsBus]}辆 #{item[:number]}站 #{item[:dis]} \n"
      end
    end
  end
end

Push.new().push_android(Bus.bus_info(ARGV[0].to_sym))
