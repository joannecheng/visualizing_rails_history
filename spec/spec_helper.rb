require 'rspec'
require 'vcr'
require 'fakeweb'
require 'fakeredis/rspec'
require_relative '../lib/pull_request'
require_relative '../lib/pull_request_comments'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :fakeweb
end

RSpec.configure do |config|

end

def populate_fake_redis
  @redis = Redis.new
  f = open(File.join('spec', 'fixtures', 'pull_requests.json'))
  data = JSON.parse(f.read())
  data.each do |d|
    key = "pull-#{d['id']}"
    @redis.set(key, d.to_json)
  end
end
