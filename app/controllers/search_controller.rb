class SearchController < ApplicationController

  def index
    request = ProductParser.build_product_request(params[:q])
    items = ProductParser.get_product_response(request)
    @results = build_results_hash(items)
  end

  private

  def build_results_hash(items)
    results = {
      search_results: items['Items']['TotalResults'],
      items: []
    }
    items['Items']['Item'].each.with_index(1) do |item, i|
      if item['CustomerReviews']['HasReviews'] == 'true'
        results[:items] << {
          id: item['ASIN'],
          title: item['ItemAttributes']['Title'],
          image_url: item['LargeImage']['URL'],
          reviews: ReviewParser.parse_reviews(item['ASIN'])
        }
        break if i >= 1
      end
    end
    results
  end
end
