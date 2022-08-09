RSpec.describe "App / Database" do
  it "can start the persistence provider" do
    expect { Hanami.app.start(:persistence) }.not_to raise_error
  end
end
