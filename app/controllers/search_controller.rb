class SearchController < ApplicationController

  def index
    #show a list of products w/o reviews
    request = ProductParser.build_product_request(params[:q])
    items = ProductParser.get_product_response(request)
    @results = build_results_hash(items)
  end

  def results
    #shows the review based on what the user clicks
    @item = params[:item]
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
          image_url: image_or_default(item),
          reviews_url: item['ASIN']
        }
      end
    end
    results
  end

  def image_or_default(item)
    if item['LargeImage']
      return item['LargeImage']['URL']
    else
      return 'default.jpg'
    end
  end
end
