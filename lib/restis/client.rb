require 'redis'
module Restis
	class Client
		attr_accessor :redis
		def initialize(args = {})
			@args = args
			@redis = Redis.new(@args)
		end

		def publish(channel, message)
			@redis.rpush("#{channel}:backlog", message)
			@redis.publish(channel, message)
		end

		def subscribe(channel, key, &block)
			loop do
				last_read_msg = @redis.get(key)
				queue_size = @redis.llen("#{channel}:backlog")
				messages = @redis.lrange("#{channel}:backlog", last_read_msg, queue_size)
				break if messages.empty?
				messages.each do |msg|
					block.call(@redis, channel, msg)
					@redis.incr(key)
				end
				@redis.set(key, queue_size)
			end
			redis = Redis.new(:timeout => 0)
			redis.subscribe(channel) do |on|
				on.message do |channel, msg|
					block.call(redis, channel, msg)
					Redis.new(@args).incr(key)
				end
			end
		end
	end
end
