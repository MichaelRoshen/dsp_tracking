# HK Tracking expense node should use  Gadx redis
# BJ Tracking expense node should use  Baidurtb redis
# HK&BJ Frequency node each should use a separate redis
require 'yaml'
require 'redis'
require 'redis/distributed'
module RtbRedis
  def self.connect
    conf = YAML.load(File.read(File.expand_path("../../config/rtb_redis.yml", __FILE__)))
    @@expense_node = Redis::Distributed.new(conf["expense"]["urls"], 
      :password => conf["expense"]["password"],  :timeout => 0.5 , :reconnect => true)
    @@frequency_node = Redis.new(:host => conf["frequency"]["host"],
      :password => conf["frequency"]["password"],
      :port => conf["frequency"]["port"] , :timeout => 0.5 , :reconnect => true )
  end

  def self.expense_node
    @@expense_node
  end

  def self.frequency_node
    @@frequency_node
  end
end


RtbRedis.connect
