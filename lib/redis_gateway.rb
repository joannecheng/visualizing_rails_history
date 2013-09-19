class RedisGateway

  def initialize(redis)
    @redis = redis
  end

  def new_pull_request(data_hash)
    id = data_hash['id']
    @redis.set("pull-#{id}", data_hash.to_json)
    PullRequest.new self, id
  end

  def ids(prefix)
    keys = @redis.keys.grep /#{prefix}-/
    keys.map { |key| key.gsub("pull-", '').to_i }
  end

  def pull_request_by_id(id)
    JSON.parse @redis.get("pull-#{id}")
  end

  def set_comments(pull_request, comment_response)
    comment_hash = JSON.parse(comment_response)
    pull_request_hash = pull_request_by_id(pull_request.id)

    pull_request_hash[:comments] = comment_hash
    @redis.set("pull-#{pull_request.id}", pull_request_hash.to_json)
  end
end
