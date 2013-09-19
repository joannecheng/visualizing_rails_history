require 'redis'
require_relative '../lib/pull_request_redis'

r = Redis.new host: 'localhost', port: 6379
#r.flushdb

rg = RedisGateway.new(r)

data_file_path = File.expand_path('data')
files = Dir.entries(data_file_path)[2..-1]

files.each do |filename|
  f = open(File.join(data_file_path, filename))
  data = JSON.parse(f.read())
  data.each do |d|
    pull_request = rg.new_pull_request(d)
    puts "populating comments for: #{pull_request.id}"
    PullRequestComments.populate(rg, pull_request)
  end
end
