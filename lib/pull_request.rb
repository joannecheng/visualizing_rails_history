require 'json'

class PullRequest
  def self.by_id(rg, id)
    self.new rg, id
  end

  def self.create(rg, data)
    rg.new_pull_request(data)
  end

  attr_reader :id

  def initialize(rg, id)
    @rg = rg
    @id = id
  end

  def comments_url
    pull_request_data['comments_url']
  end

  def merged?
    pull_request_data['merged_at'] != nil
  end

  def title
    pull_request_data['title']
  end

  def html_url
    pull_request_data['html_url']
  end

  def pull_request_data
    @rg.pull_request_by_id(id)
  end

end
