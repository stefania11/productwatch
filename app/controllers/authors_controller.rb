class AuthorsController < ApplicationController

  skip_before_action :verify_authenticity_token
  
  def index
    map_data = authors_to_json(params)
    render :json => map_data
  end

  private

  def authors_to_json(params)
    map_data = []
    if params["urls"]
      params["urls"].each_with_index do |url,i|
        review = Review.find(params["ids"][i])
        author = Author.where(url: url)[0]
        info = {}
        if author != nil
          
          info = {
            name: author.name,
            url: author.url,
            location: author.location
          }
          
        else
          loc_name = ProfileParser.get_author_location_and_name(url)
          info = {
            name: loc_name[1],
            url: url,
            location: loc_name[0]
          }
          review.create_author(info)
          
        end
        map_datum = {
          rating: review.rating[0...2].to_f,
          state_abbr: info[:location]
        }
        map_data << map_datum
        
      end
    end
    return map_data
  end
  
end
