require 'httparty'
require 'base64'

class SpotifyClient
  include HTTParty

  ACCOUNTS_API = "https://accounts.spotify.com"
  SEARCH_API = "https://api.spotify.com/v1/search"

  def initialize(client_id, client_secret)
    @client_id = client_id
    @client_secret = client_secret
  end

  def generate_token
    auth_token = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
    options = {
      headers: {
        Authorization: "Basic #{auth_token}"
      },
      body: {
        grant_type: "client_credentials"
      }
    }

    response = self.class.post("#{ACCOUNTS_API}/api/token", options)

    access_token = JSON.parse(response.body)["access_token"]
  end

  def fetch_album_cover_image_by_title(access_token, album_title)
    options = {
      headers: {
        Authorization: "Bearer #{access_token}"
      },
      query: {
        q: album_title,
        type: 'album',
        limit: 1
      }
    }

    response = self.class.get(SEARCH_API, options)

    album = JSON.parse(response.body)["albums"]["items"][0]

    cover = album ? album["images"][0]["url"] : nil

    cover
  end
end