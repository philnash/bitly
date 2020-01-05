# frozen_string_literal: true

RSpec.describe Bitly::API::Bitlink::ClicksSummary do
  let(:client) { double("client") }
  let(:clicks_summary_data) {
    {
      "unit_reference"=>"2020-01-05T05:17:43+0000",
      "total_clicks"=>100,
      "units"=>-1,
      "unit"=>"day"
    }
  }

  it "requests the summary from the API" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: clicks_summary_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request)
      .with(
        path: "/bitlinks/bit.ly/abc123/clicks/summary",
        params: {
          "unit" => nil,
          "units" => nil,
          "unit_reference" => nil,
          "size" => nil
        }
      )
      .and_return(response)
    clicks_summary = Bitly::API::Bitlink::ClicksSummary.fetch(client: client, bitlink: "bit.ly/abc123")
    expect(clicks_summary.total_clicks).to eq(100)
  end
end