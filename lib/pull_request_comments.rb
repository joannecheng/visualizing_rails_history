require 'faraday'

class PullRequestComments
  def self.populate(rg, pull_request)
    response = ::Faraday.get(pull_request.comments_url).body
    rg.set_comments(pull_request, response)
  end

  def initialize(pull_request)
    @pull_request = pull_request
  end

  def comment_timeline
    comments.map do |comment|
      { ts: Time.parse(comment['created_at']).to_i*1000, body: comment['body'], merged: @pull_request.merged? }
    end
  end

  private

  def comments
    @pull_request.pull_request_data['comments']
  end

end

