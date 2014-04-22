require 'oauth'
require 'yaml'
require 'launchy'
require 'json'


class TwitterSession

  TOKEN_FILE = "access_token.yml"
  CONSUMER_KEY = File.read(Rails.root.join('lib/consumer_key')).chomp
  CONSUMER_SECRET = File.read(Rails.root.join('lib/consumer_secret')).chomp

  CONSUMER = OAuth::Consumer.new(
  CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def self.get(path, query_values)
    url = path_to_url(path, query_values)
    response = access_token
      .get(url)
      .body
    JSON.parse(response).each do |post|
      puts post["text"]
    end
  end

  def self.post(path, req_params)
    url = path_to_url(path, req_params)
    response = access_token
      .post(url)
      .body
  end

  def self.access_token

    if File.exist?(TOKEN_FILE)
      File.open(TOKEN_FILE) { |f| YAML.load(f) }
    else
      access_token = request_access_token
      File.open(TOKEN_FILE, "w") { |f| YAML.dump(access_token, f) }
      access_token
    end
  end

  def self.request_access_token

    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)


    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp
    access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
  end

  def self.path_to_url(path, query_values = nil)
    Addressable::URI.new(
    :scheme => "https",
    :host => "api.twitter.com",
    :path => "1.1/#{path}.json",
    :query_values => query_values
    ).to_s
  end

end

# a = TwitterSession.get(
#   "statuses/user_timeline",
#   { :username => "sam_el_lechero" }
# )

# TwitterSession.post(
#   "statuses/update",
#   { :status => "App Academy!" }
# )