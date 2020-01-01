# frozen_string_literal: true

RSpec.describe Bitly::HTTP::Request do
  let(:uri) { URI.parse("http://example.com") }

  it "is initialized with a URI and the method is GET by default" do
    request = Bitly::HTTP::Request.new(uri: uri)
    expect(request.uri).to eq(uri)
    expect(request.method).to eq("GET")
  end

  it "is initialized with a URI and a method" do
    request = Bitly::HTTP::Request.new(uri: uri, method: "POST")
    expect(request.uri).to eq(uri)
    expect(request.method).to eq("POST")
  end

  it "is initialized with a URI and a method and an optional params hash" do
    request = Bitly::HTTP::Request.new(uri: uri, method: "GET", params: { "foo" => "bar" })
    expect(request.params).to eq({ "foo" => "bar" })
  end

  it "is initialized with a URI and a method and an optional headers hash" do
    request = Bitly::HTTP::Request.new(uri: uri, method: "GET", headers: { "foo" => "bar" })
    expect(request.headers).to eq({ "foo" => "bar" })
  end

  it "expects the uri to be an object of type URI" do
    expect {
      Bitly::HTTP::Request.new(uri: "http://example.com", method: "GET")
    }.to raise_error(ArgumentError)
  end

  it "expects the method to be an HTTP method" do
    expect {
      Bitly::HTTP::Request.new(uri: uri, method: "SLEEP")
    }.to raise_error(ArgumentError)
  end

  it "expects the params to be a hash" do
    expect {
      Bitly::HTTP::Request.new(uri: uri, method: "GET", params: "wrong")
    }.to raise_error(ArgumentError)
  end

  it "expects the headers to be a hash" do
    expect {
      Bitly::HTTP::Request.new(uri: uri, method: "GET", headers: "wrong")
    }.to raise_error(ArgumentError)
  end

  describe "when the method is GET" do
    let(:request) { Bitly::HTTP::Request.new(uri: uri, method: "GET", params: { "foo" => "bar" }) }

    it "adds the params to the URL query string" do
      expect(request.uri.to_s).to eq("http://example.com?foo=bar")
    end

    it "adds the params to the existing URL query string" do
      uri.query = "foo=baz"
      expect(request.uri.to_s).to eq("http://example.com?foo=baz&foo=bar")
    end

    it "builds a query string out of array parameters" do
      request = Bitly::HTTP::Request.new(uri: uri, method: "GET", params: { "foo" => ["bar", "baz"] })
      expect(request.uri.to_s).to eq("http://example.com?foo=bar&foo=baz")
    end

    it "builds a query string out of array parameters with an existing query string" do
      request = Bitly::HTTP::Request.new(uri: URI.parse("#{uri}?foo=qux"), method: "GET", params: { "foo" => ["bar", "baz"] })
      expect(request.uri.to_s).to match("foo=bar")
      expect(request.uri.to_s).to match("foo=baz")
      expect(request.uri.to_s).to match("foo=qux")
    end

    it "doesn't have a request body" do
      expect(request.body).to be_nil
    end
  end

  describe "when the method is POST" do
    let(:request) { Bitly::HTTP::Request.new(uri: uri, method: "POST", params: { "foo" => "bar" }) }

    it "doesn't add the params to the URL query string" do
      expect(request.uri.to_s).to eq("http://example.com")
    end

    it "keeps an existing query string, but doesn't add parameters" do
      uri.query = "foo=baz"
      expect(request.uri.to_s).to eq("http://example.com?foo=baz")
    end

    it "turns parameters into a JSON stringified body" do
      expect(request.body).to eq("{\"foo\":\"bar\"}")
    end
  end
end