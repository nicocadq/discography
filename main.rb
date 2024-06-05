require 'dotenv/load'

require './classes/discography'
require './classes/trello'

bob_discography = DiscographyParser.read_discography_file("./discography.txt")
albums_sorted_by_decade = DiscographyParser.sort_albums_by_decade(bob_discography)

trello_client = TrelloClient.new(ENV["TRELLO_API_KEY"], ENV["TRELLO_API_TOKEN"])

board_id = trello_client.create_board("Bob Dylan Discography")

albums_sorted_by_decade.each do |decade, albums|
  list_id = trello_client.create_board_list(board_id, decade.to_s)

  albums.each do |album|
    trello_client.create_card(list_id, "#{album[:year]} - #{album[:title]}")
  end
end
