require 'github_api'
require 'json'
require 'csv'

if ENV['COLLECT_GITHUB_DATA'] == 'true'
  url = 'https://api.github.com/repos/rails/rails/pulls?state=closed'
  (1..20).to_a.each do |page_number|
    puts "pulling page number #{page_number}"
    pulls = Faraday.get(url+"&page=#{page_number}&per_page=100").body
    f = open("data/page#{page_number}.json", 'wb')
    f.write pulls
    f.close
  end
end

data_file_path = File.expand_path('data')
pull_requests = []
files = Dir.entries(data_file_path)[2..-1]
columns = %w(id created_at closed_at merged_at)

puts 'gathering files'
files.each do |filename|
  f = open(File.join(data_file_path, filename))
  data = JSON.parse(f.read())
  data.each do |issue|
    pull_requests << columns.map { |column| issue[column] }
  end
  f.close
end

CSV.open('github_pulls.csv', 'wb') do |csv|
  csv << columns
  puts 'reading'
  pull_requests.each do |pull_request|
    csv << pull_request
  end
  puts 'done.'
end
