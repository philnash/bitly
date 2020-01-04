# frozen_string_literal: true

RSpec.describe Bitly::API::Bitlink do
  let(:client) { double("client") }
  let(:bitlink_data) {
    {
      "created_at"=>"2020-01-02T23:51:47+0000",
      "id"=>"bit.ly/2Qj2niP",
      "link"=>"http://bit.ly/2Qj2niP",
      "custom_bitlinks"=>[],
      "long_url"=>"https://example.com/",
      "archived"=>false,
      "tags"=>[],
      "deeplinks"=>[],
      "references"=>{
        "group"=>"https://api-ssl.bitly.com/v4/groups/def456"
      }
    }
  }
  let(:public_bitlink_data) {
    {
      "created_at"=>"2020-01-02T23:51:47+0000",
      "link"=>"http://bit.ly/2Qj2niP",
      "id"=>"bit.ly/2Qj2niP",
      "long_url"=>"https://example.com/"
    }
  }

  it "can shorten a link with an API client" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: bitlink_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request)
      .with(
        path: "/shorten",
        method: "POST",
        params: { "long_url" => "https://example.com/", "group_guid" => nil, "domain" => nil }
      )
      .and_return(response)
    bitlink = Bitly::API::Bitlink.shorten(client: client, long_url: "https://example.com/")
    expect(bitlink.long_url).to eq("https://example.com/")
    expect(bitlink.id).to eq("bit.ly/2Qj2niP")
  end

  it "can create a bitlink with more details" do
    extra_bitlink_data = bitlink_data.clone
    extra_bitlink_data["title"] = "Test link"
    extra_bitlink_data["deeplinks"] = [{
      "app_uri_path" => "test_app_uri_path",
      "install_type" => "test_install_type",
      "install_url" =>	"test_install_url",
      "app_id" => "test_app_id"
    }]
    deeplink = Bitly::API::Bitlink::Deeplink.new(data: {
      "app_uri_path" => "test_app_uri_path",
      "install_type" => "test_install_type",
      "install_url" =>	"test_install_url",
      "app_id" => "test_app_id"
    })
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: extra_bitlink_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request)
      .with(
        path: "/bitlinks",
        method: "POST",
        params: {
          "long_url" => "https://example.com/",
          "group_guid" => nil,
          "domain" => nil,
          "title" => "Test link",
          "tags" => nil,
          "deeplinks" => [deeplink]
        }
      )
      .and_return(response)
    bitlink = Bitly::API::Bitlink.create(
      client: client,
      long_url: "https://example.com/",
      title: "Test link",
      deeplinks: [deeplink]
    )
    expect(bitlink.long_url).to eq("https://example.com/")
    expect(bitlink.id).to eq("bit.ly/2Qj2niP")
    expect(bitlink.title).to eq("Test link")
    expect(bitlink.deeplinks.first).to be_instance_of(Bitly::API::Bitlink::Deeplink)
    expect(bitlink.deeplinks.first.app_uri_path).to eq(deeplink.app_uri_path)
  end

  it "can fetch a bitlink" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: bitlink_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request)
      .with(path: "/bitlinks/#{bitlink_data["id"]}")
      .and_return(response)
    bitlink = Bitly::API::Bitlink.fetch(client: client, bitlink: "bit.ly/2Qj2niP")
    expect(bitlink.long_url).to eq("https://example.com/")
  end

  it "can expand a bitlink to public information" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: public_bitlink_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request)
      .with(path: "/expand", method: "POST", params: { "bitlink_id" => "bit.ly/2Qj2niP" })
      .and_return(response)
    bitlink = Bitly::API::Bitlink.expand(client: client, bitlink: "bit.ly/2Qj2niP")
    expect(bitlink.long_url).to eq("https://example.com/")
    expect(bitlink.id).to eq("bit.ly/2Qj2niP")
    expect(bitlink.link).to eq("http://bit.ly/2Qj2niP")
    expect(bitlink.created_at).to eq(Time.parse(public_bitlink_data["created_at"]))
  end
end