require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe "GET #search" do

    before do
      get :search, params: { "utf8"=>"✓", "query"=>"MyText", "search_type"=>"Question" }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns searched object" do
      expect(response).to render_template :search
    end

  end

end
