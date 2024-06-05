require "httparty"
require "json"

class TrelloClient
  include HTTParty
  base_uri "https://api.trello.com/1"

  # debug_output $stdout

  def initialize(api_key, api_token)
    @auth_params = {
      key: api_key,
      token: api_token
    }
  end

  def create_board(name)
    options = { 
      query: @auth_params.merge(name: name)
    }

    response = self.class.post("/boards/", options)

    board_id = JSON.parse(response.body)["id"]

    board_id
  end

  def create_board_list(board_id, list_name)
    options = {
      query: @auth_params.merge(name: list_name)
    }

    response = self.class.post("/boards/#{board_id}/lists", options)

    list_id = JSON.parse(response.body)["id"]

    list_id
  end

  def create_card(list_id, card_name)
    options = {
      query: @auth_params.merge(name: card_name, idList: list_id)
    }

    response = self.class.post("/cards", options)
  end
end
