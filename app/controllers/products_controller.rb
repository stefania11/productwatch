class ProductsController < ApplicationController

  def index
  end

  def show
    @product = ProductParser
    respond_to do |format|
      format.json
      format.tsv
    end
  end

  def search
  end

end
