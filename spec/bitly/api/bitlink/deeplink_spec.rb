# frozen_string_literal: true

RSpec.describe Bitly::API::Bitlink::Deeplink do
  let(:deeplink_data) {
    {
      "app_uri_path" => "test_app_uri_path",
      "install_type" => "test_install_type",
      "install_url" =>	"test_install_url",
      "app_id" => "test_app_id"
    }
  }

  it "initializes and sets all attributes" do
    deeplink = Bitly::API::Bitlink::Deeplink.new(data: deeplink_data)
    expect(deeplink.app_uri_path).to eq("test_app_uri_path")
    expect(deeplink.install_type).to eq("test_install_type")
    expect(deeplink.install_url).to eq("test_install_url")
    expect(deeplink.app_id).to eq("test_app_id")
  end

  it "can be converted to json" do
    deeplink = Bitly::API::Bitlink::Deeplink.new(data: deeplink_data)
    expect(deeplink.to_json).to eq("{\"app_uri_path\":\"test_app_uri_path\",\"install_type\":\"test_install_type\",\"install_url\":\"test_install_url\",\"app_id\":\"test_app_id\"}")
  end
end