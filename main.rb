require 'dotenv/load'

require './classes/discography'
require './classes/trello'
require './classes/spotify'

bob_discography = DiscographyParser.read_discography_file("./discography.txt")
albums_sorted_by_decade = DiscographyParser.sort_albums_by_decade(bob_discography)

trello_client = TrelloClient.new(ENV["TRELLO_API_KEY"], ENV["TRELLO_API_TOKEN"])

board_id = trello_client.create_board("Bob Dylan Discography")

spotify_client = SpotifyClient.new(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
spotify_access_token = spotify_client.generate_token()

albums_sorted_by_decade.each do |decade, albums|
  list_id = trello_client.create_board_list(board_id, decade.to_s)

  albums.each do |album|
    album_cover = spotify_client.fetch_album_cover_image_by_title(spotify_access_token, album[:title])

    trello_client.create_card(list_id, "#{album[:year]} - #{album[:title]}", album_cover)
  end
end
