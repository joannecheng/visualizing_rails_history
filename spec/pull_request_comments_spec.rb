require 'spec_helper'
require 'json'
require_relative '../lib/redis_gateway'

describe PullRequestComments do
  describe '#populate' do
    it 'populates db with pull request comments' do
      populate_fake_redis

      rg = RedisGateway.new(@redis)
      pr = PullRequest.by_id(rg, 7999423)

      VCR.use_cassette('comments_for_pull_requests_id_7999423') do
        PullRequestComments.populate(rg, pr)
      end
    end
  end

  describe '.comment_timeline' do
    it 'gets number of comments on a pull request from github' do
      populate_fake_redis

      rg = RedisGateway.new(@redis)
      pr = PullRequest.by_id(rg, 7999423)
      prc = PullRequestComments.new(pr)

      VCR.use_cassette('comments_for_pull_requests_id_7999423') do
        PullRequestComments.populate(rg, pr)
      end

      dates = %w(2013-08-31T03:08:14Z 2013-08-31T03:10:04Z 2013-08-31T03:38:13Z 2013-08-31T06:19:12Z)
      expect(prc.comment_timeline).to eq dates.map { |d| Time.parse(d).to_i*1000 }
    end
  end

end
