require 'redis'
require 'time'
require_relative '../lib/pull_request_redis'

r = Redis.new host: 'localhost', port: 6379
rg = RedisGateway.new r

ids = rg.ids('pull')

comment_timeline = []

ids.each do |id|
  pr = PullRequest.new rg, id
  prc = PullRequestComments.new(pr)
  comment_timeline << { timestamps: prc.comment_timeline }
end

puts comment_timeline.to_json
