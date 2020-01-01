# frozen_string_literal: true

RSpec.describe Bitly::API::Group::Preferences do
  let(:preference_data) {
    {
      "group_guid" => "def456",
      "domain_preference" => "bit.ly"
    }
  }

  it "can be fetched with a client and a group guid" do
    client = double("client")
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: preference_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request)
      .with(path: "/groups/def456/preferences")
      .and_return(response)

    preferences = Bitly::API::Group::Preferences.fetch(client: client, group_guid: "def456")
    expect(preferences.group_guid).to eq("def456")
    expect(preferences.domain_preference).to eq("bit.ly")
  end
end