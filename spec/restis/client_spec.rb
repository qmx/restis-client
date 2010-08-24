require "spec_helper"

describe Restis::Client do

	context "on setup" do
		it "should pass connection parameters to redis" do
			args = {:host => "1.1.1.1"}
			Redis.stub!(:new).with(args)
			Restis::Client.new(args)
		end
	end
	context "when publishing" do
		it "should keep published items on backlog" do
			redis = Redis.new
			thread = Thread.new do
				redis.subscribe("channel1") do |on|
					on.message do |channel, message|
						@message = message
						redis.unsubscribe
					end
				end
			end
			client = Restis::Client.new
			client.publish("channel1", "message1")
			thread.join
			redis.llen("channel1:backlog").should == 1
			@message.should == "message1"
		end
	end
	context "when consuming" do
		it "should receive the unread backlog before the subscription" do
			publisher = Restis::Client.new
			10.times { publisher.publish("ch1", "1234") }
			thread = Thread.new do
				sleep 0.42 # preventing race condition
				publisher = Restis::Client.new
				50.times {publisher.publish("ch1", "1234")}
			end
			subscriber = Restis::Client.new
			subscriber.subscribe("ch1", "mykey") do |connection, channel, msg|
				count = Redis.new.incr("count")
				connection.unsubscribe if connection.subscribed? and count == 50
			end
			thread.join
			Redis.new.get("count").should == "60"
		end
	end
end