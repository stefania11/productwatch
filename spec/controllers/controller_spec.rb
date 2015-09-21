require 'spec_helper'

describe ProductsController, :type => :controller do
  describe "GET index" do
    context 'when it loads page' do 
      it 'loads the index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET index" do

    it "renders the :index template" do
      expect(get: root_url(subdomain: nil)).to route_to(
                                                 alias: "root_url",
                                                 controller: "products",
                                                 action: "index")
    end
  end
end
