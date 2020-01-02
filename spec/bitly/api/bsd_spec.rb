# frozen_string_literal: true

RSpec.describe Bitly::API::BSD do
  let(:bsds) { ["bit.ly", "j.mp"] }

  it "calls to the /bsds path to retrieve bsds" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: { "bsds" => bsds }.to_json,
      headers: {}
    )
    client = double("client")
    expect(client).to receive(:request)
      .with(path: "/bsds")
      .and_return(response)
    bsds = Bitly::API::BSD.list(client: client)
    expect(bsds).to be_instance_of(Bitly::API::BSD::List)
    expect(bsds.first).to eq("bit.ly")
    expect(bsds.count).to eq(2)
  end
end