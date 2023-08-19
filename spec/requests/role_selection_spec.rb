require 'rails_helper'

RSpec.describe "RoleSelections", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/role_selection/index"
      expect(response).to have_http_status(:success)
    end
  end

end
