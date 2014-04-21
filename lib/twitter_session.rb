require 'oauth'
require 'yaml'

TOKEN_FILE = "access_token.yml"




class TwitterSession

  def self.get(path, query_values)

  end

  def self.post(path, req_params)
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
    # Put user through authorization flow; save access token to file
    CONSUMER_KEY = "consumer_key_from_service"
    CONSUMER_SECRET = "consumer_secret_from_service"

    CONSUMER = OAuth::Consumer.new(
      CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)


    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp
    access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
    response = access_token
      .get("https://api.twitter.com/1.1/statuses/user_timeline.json")
      .body
  end

  def self.path_to_url(path, query_values = nil)
    # All Twitter API calls are of the format
    # "https://api.twitter.com/1.1/#{path}.json". Use
    # `Addressable::URI` to build the full URL from just the
    # meaningful part of the path (`statuses/user_timeline`)
    Addressable::URI.new(


    )

  end
end

TwitterSession.get(
  "statuses/user_timeline",
  { :user_id => "737657064" }
)
TwitterSession.post(
  "statuses/update",
  { :status => "New Status!" }
)