# frozen_string_literal: true

RSpec.describe Bitly::HTTP::Client do
  it "can be initialized with no arguments" do
    expect { Bitly::HTTP::Client.new }.not_to raise_error
  end

  it "can be initialized with an adapter (that has a request method)" do
    expect do
      Bitly::HTTP::Client.new(Bitly::HTTP::Adapters::NetHTTP.new)
    end.not_to raise_error
  end

  it "needs an adapter to have a request method" do
    expect do
      Bitly::HTTP::Client.new(Object.new)
    end.to raise_error(ArgumentError)
  end

  describe "#request" do
    it "returns a Bitly::HTTP::Response if the request is made successfully" do
      request = Bitly::HTTP::Request.new(uri: URI.parse("https://bitly.com"))
      adapter = double(:adapter)
      response_values = ["200", { response: "OK" }.to_json, {}, true]
      expect(adapter).to receive(:request).once.with(request).and_return(response_values)
      client = Bitly::HTTP::Client.new(adapter)
      response = client.request(request)
      expect(response.status).to eq(response_values[0])
      expect(response.body).to eq(JSON.parse(response_values[1]))
      expect(response.headers).to eq(response_values[2])
      expect(response.request).to eq(request)
    end

    it "raises a Bitly::Error if the request is not successful" do
      request = Bitly::HTTP::Request.new(uri: URI.parse("https://bitly.com"))
      adapter = double(:adapter)
      response_values = ["500", { response: "Not OK" }.to_json, {}, false]
      expect(adapter).to receive(:request).once.with(request).and_return(response_values)
      client = Bitly::HTTP::Client.new(adapter)
      expect { client.request(request) }.to raise_error(Bitly::Error)
    end
  end
end