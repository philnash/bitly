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

  describe "HTTP options" do
    it "sets use_ssl to true by default" do
      stub_request(:get, "https://example.com/")
        .to_return(body: { "success" => true }.to_json)
      allow(Net::HTTP).to receive(:start).and_call_original
      request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/"))
      adapter = Bitly::HTTP::Adapters::NetHTTP.new
      response = adapter.request(request)
      expect(Net::HTTP).to have_received(:start).with("example.com", 443, nil, nil, nil, nil, use_ssl: true)
    end

    it "can set http options when instantiating the adapter" do
      stub_request(:get, "https://example.com/")
        .to_return(body: { "success" => true }.to_json)
      allow(Net::HTTP).to receive(:start).and_call_original
      request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/"))
      adapter = Bitly::HTTP::Adapters::NetHTTP.new(request_opts: { read_timeout: 1 })
      response = adapter.request(request)
      expect(Net::HTTP).to have_received(:start).with("example.com", 443, nil, nil, nil, nil, use_ssl: true, read_timeout: 1)
    end

    it "can set proxy options when instantiating the adapter" do
      allow(Net::HTTP).to receive(:start)
      request = Bitly::HTTP::Request.new(uri: URI.parse("https://example.com/"))
      adapter = Bitly::HTTP::Adapters::NetHTTP.new(proxy_addr: "example.org", proxy_port: 80, proxy_user: "username", proxy_pass: "password")
      response = adapter.request(request)
      expect(Net::HTTP).to have_received(:start).with("example.com", 443, "example.org", 80, "username", "password", use_ssl: true)
    end
  end
end