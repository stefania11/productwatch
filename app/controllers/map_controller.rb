class MapController < ApplicationController
respond_to :html, :js
  def index
    # request = AWSProductParser.build_product_request(params[:q])
    # items = AWSProductParser.get_product_response(request)
    # @results = build_results_hash(items)
  end
  #
  # private
  #
  # def build_results_hash(items)
  #   results = {
  #     search_results: items['Items']['TotalResults'],
  #     items: []
  #   }
  #
  #   items['Items']['Item'].each do |item|
  #     if item['CustomerReviews']['HasReviews'] == 'true'
  #       results[:items] << {
  #         id: item['ASIN'],
  #         title: item['ItemAttributes']['Title'],
  #         image_url: item['MediumImage']['URL'],
  #         reviews: AWSReviewParser.parse_reviews(item['ASIN'])
  #       }
  #     end
  #   end
  #   results
  # end
end
