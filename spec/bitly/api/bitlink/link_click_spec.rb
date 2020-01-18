# frozen_string_literal: true

RSpec.describe Bitly::API::Bitlink::LinkClick do
  let(:links_list_data) {
    {
      "unit_reference"=>"2020-01-17T23:32:04+0000",
      "link_clicks"=>[
        {"date"=>"2016-08-31T00:00:00+0000", "clicks"=>1},
        {"date"=>"2014-03-28T00:00:00+0000", "clicks"=>1},
        {"date"=>"2014-03-19T00:00:00+0000", "clicks"=>1},
        {"date"=>"2014-03-15T00:00:00+0000", "clicks"=>1},
        {"date"=>"2014-03-14T00:00:00+0000", "clicks"=>13},
        {"date"=>"2014-03-13T00:00:00+0000", "clicks"=>1},
        {"date"=>"2014-03-11T00:00:00+0000", "clicks"=>17}
      ],
      "units"=>-1,
      "unit"=>"day"
    }
  }
  it "uses a client to list clicks" do
    bitlink_id = "bit.ly/jkl123"
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: links_list_data.to_json,
      headers: {}
    )
    client = double("client")
    expect(client).to receive(:request)
      .with(path: "/bitlinks/#{bitlink_id}/clicks", params: {
        "units" => nil,
        "unit" => nil,
        "unit_reference" => nil,
        "size" => nil
      })
      .and_return(response)

    link_clicks = Bitly::API::Bitlink::LinkClick.list(client: client, bitlink: bitlink_id)
    expect(link_clicks.unit).to eq(links_list_data["unit"])
    expect(link_clicks.units).to eq(links_list_data["units"])
    expect(link_clicks.unit_reference).to eq(Time.parse(links_list_data["unit_reference"]))
    expect(link_clicks.count).to eq(7)
    expect(link_clicks.first.date).to eq(Time.parse(links_list_data["link_clicks"].first["date"]))
    expect(link_clicks.first.clicks).to eq(links_list_data["link_clicks"].first["clicks"])
  end

  it "initializes with data" do
    link_click = Bitly::API::Bitlink::LinkClick.new(data: links_list_data["link_clicks"].first)
    expect(link_click.date).to eq(Time.parse(links_list_data["link_clicks"].first["date"]))
    expect(link_click.clicks).to eq(links_list_data["link_clicks"].first["clicks"])
  end
end