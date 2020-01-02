# frozen_string_literal: true

RSpec.describe Bitly::HTTP::Adapters::NetHTTP do
  it "makes get requests using a Bitly::HTTP::Request object" do
    stub_request(:get, "https://example.com/")
      .to_return(body: { "success" => true }.to_json)
    request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/"))
    adapter = Bitly::HTTP::Adapters::NetHTTP.new
    response = adapter.request(request)
    expect(response).to eq(["200", { "success" => true }.to_json, {}, true])
  end

  it "makes get requests using query parameters" do
    stub_request(:get, "https://example.com/?test=success")
      .to_return(body: { "success" => true }.to_json)
    request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/?test=success"))
    adapter = Bitly::HTTP::Adapters::NetHTTP.new
    response = adapter.request(request)
    expect(response).to eq(["200", { "success" => true }.to_json, {}, true])
  end

  it "makes post requests using a Bitly::HTTP::Request object including a body" do
    stub_request(:post, "https://example.com/")
      .with(body: { "hello" => "world" }.to_json)
      .to_return(body: { "success" => true }.to_json)
    request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/"), method: "POST", params: { "hello" => "world"})
    adapter = Bitly::HTTP::Adapters::NetHTTP.new
    response = adapter.request(request)
    expect(response).to eq(["200", { "success" => true }.to_json, {}, true])
  end

  it "makes post requests using a Bitly::HTTP::Request object including headers" do
    stub_request(:post, "https://example.com/")
      .with(headers: { "UserAgent" => "BitlyTest" })
      .to_return(body: { "success" => true }.to_json)
    request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/"), method: "POST", headers: { "UserAgent" => "BitlyTest" })
    adapter = Bitly::HTTP::Adapters::NetHTTP.new
    response = adapter.request(request)
    expect(response).to eq(["200", { "success" => true }.to_json, {}, true])
  end
end