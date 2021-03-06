require 'rails_helper'

RSpec.describe "Profiles API" do

  def do_request(options = {})
    get "/api/v1/profiles/me", params: { format: :json }.merge(options)
  end

  describe 'GET /me' do

    it_behaves_like "API is unauthorized"

    context "authorized" do
      let!(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get "/api/v1/profiles/me", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status code" do
        expect(response).to be_successful
      end

      %w[id email created_at updated_at admin].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w[password encrypted_password].each do |attr|
        it "doesnt contain #{attr}" do
          expect(response.body).to_not have_json_path("user/#{attr}")
        end
      end
    end
  end

  describe "GET /index" do

    it_behaves_like "API is unauthorized"

    context "authorized" do
      let!(:other) { create_list(:user, 3) }

      context "admin" do
        let(:admin) { create(:user, admin: true) }
        let(:access_token_admin) { create(:access_token, resource_owner_id: admin.id) }

        before do
          get "/api/v1/profiles", params: { format: :json, access_token: access_token_admin.token }
        end

        it "returns 200 status code" do
          expect(response).to be_successful
        end

        it "returns all users except current" do
          other.each do |user|
            expect(response.body).to include user.to_json
          end
          expect(response.body).to_not include admin.to_json
        end
      end

      context "user" do
        let(:me) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: me.id) }

        before do
          get "/api/v1/profiles", params: { format: :json, access_token: access_token.token }
        end

        it "return 403 status" do
          expect(JSON.parse(response.body)["status"]).to eq 403
        end

        %w[id email created_at updated_at admin].each do |attr|
          it "does not contains #{attr}" do
            expect(JSON.parse(response.body)[attr]).to be_nil
          end
        end
      end
    end
  end
end