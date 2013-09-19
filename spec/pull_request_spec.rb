require 'spec_helper'
require_relative '../lib/redis_gateway'

describe PullRequest do
  describe '#by_id' do
    it 'returns a pull_request' do
      rg = double('redis gateway')
      rg.stub(:pull_request_by_id)
      pr = PullRequest.by_id(rg, 8002141)
      expect(pr.id).to eq 8002141
    end
  end

  describe '.comments_url' do
    it 'returns comments_url for pull request of given id' do
      populate_fake_redis
      fake_redis_gateway = RedisGateway.new(@redis)
      pr = PullRequest.by_id(fake_redis_gateway, 8002141)
      expect(pr.comments_url).to eq 'https://api.github.com/repos/rails/rails/issues/12093/comments'
    end
  end
end
