# frozen_string_literal: true

RSpec.describe "Home page", :feature, :web do
  specify "Visiting the home page" do
    visit "/"
  end
end
