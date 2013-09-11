require 'spec_helper'
require_relative '../lib/redis_gateway'

describe RedisGateway do

  before do
    populate_fake_redis
    @rg = RedisGateway.new(@redis)
  end

  describe '.new_pull_request' do

    it 'populates redis with pull request' do
      data = {test: 'data', 'id' => 1231}
      pr = @rg.new_pull_request(data)

      expect(pr.id).to eq 1231
      expect(@rg.pull_request_by_id(1231)).to eq(
        {'test' => 'data', 'id' => 1231}
      )
    end
  end

  describe '.ids' do

    it 'return ids of given type' do
      expect(@rg.ids('pull')).to eq [8002141, 7999423, 7995484, 7985047, 7981832, 7979356, 7975906, 7966488, 7964250, 7943146, 7942904, 7941188, 7936009, 7933440, 7927977, 7913228, 7911791, 7906379, 7897808, 7894900, 7874493, 7873609, 7872586, 7872345, 7872028, 7871362, 7868718, 7864429, 7847923, 7847921, 7843518, 7842637, 7838256, 7838244, 7836977, 7825235, 7819663, 7818495, 7816091, 7810342, 7804714, 7802738, 7796194, 7783528, 7783122, 7782319, 7781318, 7780820, 7779268, 7777764, 7770477, 7769907, 7759138, 7757652, 7756356, 7752100, 7748895, 7748467, 7747018, 7744705, 7736379, 7733161, 7723507, 7716171, 7705014, 7687266, 7687122, 7686099, 7685434, 7683830, 7683474, 7683424, 7680461, 7679434, 7678471, 7677682, 7677129, 7677046, 7656546, 7656425, 7649424, 7647683, 7645692, 7625496, 7624260, 7621765, 7615073, 7612574, 7607051, 7592970, 7592948, 7586682, 7583010, 7568927, 7568460, 7565810, 7565216, 7561539, 7560074, 7547947]
    end
  end

  describe '.pull_request_by_id' do
    it 'returns correct pull request given an id' do
      expect(@rg.pull_request_by_id(8002141)['url']).to eq "https://api.github.com/repos/rails/rails/pulls/12093"
      expect(@rg.pull_request_by_id(8002141)['id']).to eq 8002141
    end
  end

  describe '.set_comments' do
    it 'sets comments to correct pull request' do
      pr = PullRequest.by_id(@rg, 7999423)

      VCR.use_cassette('comments_for_pull_requests_id_7999423') do
        response = ::Faraday.get(pr.comments_url).body
        @rg.set_comments(pr, response)
      end

      expect(@rg.pull_request_by_id(7999423)['comments']).to eq [{"url"=>"https://api.github.com/repos/rails/rails/issues/comments/23599587", "html_url"=>"https://github.com/rails/rails/pull/12091#issuecomment-23599587", "issue_url"=>"https://api.github.com/repos/rails/rails/issues/12091", "id"=>23599587, "user"=>{"login"=>"danfinnie", "id"=>92105, "avatar_url"=>"https://0.gravatar.com/avatar/f42ca7213b32b4382fb79e05f5ab7619?d=https%3A%2F%2Fidenticons.github.com%2Fafccff39c72885b3081b49bd6941da7b.png", "gravatar_id"=>"f42ca7213b32b4382fb79e05f5ab7619", "url"=>"https://api.github.com/users/danfinnie", "html_url"=>"https://github.com/danfinnie", "followers_url"=>"https://api.github.com/users/danfinnie/followers", "following_url"=>"https://api.github.com/users/danfinnie/following{/other_user}", "gists_url"=>"https://api.github.com/users/danfinnie/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/danfinnie/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/danfinnie/subscriptions", "organizations_url"=>"https://api.github.com/users/danfinnie/orgs", "repos_url"=>"https://api.github.com/users/danfinnie/repos", "events_url"=>"https://api.github.com/users/danfinnie/events{/privacy}", "received_events_url"=>"https://api.github.com/users/danfinnie/received_events", "type"=>"User"}, "created_at"=>"2013-08-31T03:08:14Z", "updated_at"=>"2013-08-31T03:08:14Z", "body"=>"This seems like a use for ```Enumerable#zip``` to me:\r\n\r\n```values.zip(columns).map { |value, column| column.type_cast value }```"}, {"url"=>"https://api.github.com/repos/rails/rails/issues/comments/23599606", "html_url"=>"https://github.com/rails/rails/pull/12091#issuecomment-23599606", "issue_url"=>"https://api.github.com/repos/rails/rails/issues/12091", "id"=>23599606, "user"=>{"login"=>"egilburg", "id"=>242532, "avatar_url"=>"https://2.gravatar.com/avatar/cc4f5494a8dcaaf577e678cb3901dab6?d=https%3A%2F%2Fidenticons.github.com%2F552d65b6e9616642fd0217dc7f8361bd.png", "gravatar_id"=>"cc4f5494a8dcaaf577e678cb3901dab6", "url"=>"https://api.github.com/users/egilburg", "html_url"=>"https://github.com/egilburg", "followers_url"=>"https://api.github.com/users/egilburg/followers", "following_url"=>"https://api.github.com/users/egilburg/following{/other_user}", "gists_url"=>"https://api.github.com/users/egilburg/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/egilburg/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/egilburg/subscriptions", "organizations_url"=>"https://api.github.com/users/egilburg/orgs", "repos_url"=>"https://api.github.com/users/egilburg/repos", "events_url"=>"https://api.github.com/users/egilburg/events{/privacy}", "received_events_url"=>"https://api.github.com/users/egilburg/received_events", "type"=>"User"}, "created_at"=>"2013-08-31T03:10:04Z", "updated_at"=>"2013-08-31T03:11:14Z", "body"=>"Zip was actually used before the `.next`, and removed to avoid creating an extra array.\r\n\r\nhttps://github.com/rails/rails/commit/1f75319a9af595d5de3dca55e26547c7f1b166fa"}, {"url"=>"https://api.github.com/repos/rails/rails/issues/comments/23599897", "html_url"=>"https://github.com/rails/rails/pull/12091#issuecomment-23599897", "issue_url"=>"https://api.github.com/repos/rails/rails/issues/12091", "id"=>23599897, "user"=>{"login"=>"rywall", "id"=>7904, "avatar_url"=>"https://2.gravatar.com/avatar/267de877a66aed6026e8ea4d88410a56?d=https%3A%2F%2Fidenticons.github.com%2Fb5d62aa6024ab6a65a12c78c4c2d4efc.png", "gravatar_id"=>"267de877a66aed6026e8ea4d88410a56", "url"=>"https://api.github.com/users/rywall", "html_url"=>"https://github.com/rywall", "followers_url"=>"https://api.github.com/users/rywall/followers", "following_url"=>"https://api.github.com/users/rywall/following{/other_user}", "gists_url"=>"https://api.github.com/users/rywall/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/rywall/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/rywall/subscriptions", "organizations_url"=>"https://api.github.com/users/rywall/orgs", "repos_url"=>"https://api.github.com/users/rywall/repos", "events_url"=>"https://api.github.com/users/rywall/events{/privacy}", "received_events_url"=>"https://api.github.com/users/rywall/received_events", "type"=>"User"}, "created_at"=>"2013-08-31T03:38:13Z", "updated_at"=>"2013-08-31T03:38:13Z", "body"=>"You're right @danfinnie, zip is nicer and seems to be as performant as my initial approach. Any other thoughts? Can you replicate my performance gains? I'm not crazy right? :)"}, {"url"=>"https://api.github.com/repos/rails/rails/issues/comments/23601428", "html_url"=>"https://github.com/rails/rails/pull/12091#issuecomment-23601428", "issue_url"=>"https://api.github.com/repos/rails/rails/issues/12091", "id"=>23601428, "user"=>{"login"=>"njakobsen", "id"=>87623, "avatar_url"=>"https://1.gravatar.com/avatar/f10c2645c2e6b7675b554a9f574e8c67?d=https%3A%2F%2Fidenticons.github.com%2F4d932faf92a348d3e290feacdae18ad9.png", "gravatar_id"=>"f10c2645c2e6b7675b554a9f574e8c67", "url"=>"https://api.github.com/users/njakobsen", "html_url"=>"https://github.com/njakobsen", "followers_url"=>"https://api.github.com/users/njakobsen/followers", "following_url"=>"https://api.github.com/users/njakobsen/following{/other_user}", "gists_url"=>"https://api.github.com/users/njakobsen/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/njakobsen/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/njakobsen/subscriptions", "organizations_url"=>"https://api.github.com/users/njakobsen/orgs", "repos_url"=>"https://api.github.com/users/njakobsen/repos", "events_url"=>"https://api.github.com/users/njakobsen/events{/privacy}", "received_events_url"=>"https://api.github.com/users/njakobsen/received_events", "type"=>"User"}, "created_at"=>"2013-08-31T06:19:12Z", "updated_at"=>"2013-08-31T06:19:12Z", "body"=>"I think it probably comes down to style at this point, not sure how much faster it is to call ```each_with_index``` vs. ```zip```, both of which have the benefit of not needing fibers."}]
    end
  end

end
