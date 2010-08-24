require 'init'

Bundler.require :test

require 'rspec'

Rspec.configure do |conf|

	# cleaning redis before use
	conf.before(:suite) do
		redis = Redis.new
		redis.keys.each do |key|
			redis.del key
		end
	end
end

