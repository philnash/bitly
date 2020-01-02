# frozen_string_literal: true

RSpec.describe Bitly::API::OAuthApp do
  let(:oauth_app_data) {
    {
      "name"=>"Test",
      "client_id"=>"jkl123",
      "description"=>"This is a description.",
      "link"=>"http://example.com/"
    }
  }
  it "fetches an OAuth app from the API with a client_id" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: oauth_app_data.to_json,
      headers: {}
    )
    client = double("client")
    expect(client).to receive(:request)
      .with(path: "/apps/jkl123")
      .and_return(response)
    app = Bitly::API::OAuthApp.fetch(client: client, client_id: "jkl123")
    expect(app.name).to eq("Test")
    expect(app.client_id).to eq("jkl123")
    expect(app.description).to eq("This is a description.")
    expect(app.link).to eq("http://example.com/")
  end
end