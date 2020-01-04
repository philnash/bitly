# frozen_string_literal: true

RSpec.describe Bitly::API::List do
  it "initializes with a list of items and a response" do
    response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
    expect { Bitly::API::List.new(items: ["a", "b"], response: response) }.not_to raise_error
  end

  it "needs both items and a response" do
    expect { Bitly::API::List.new(items: ["a", "b"]) }.to raise_error(ArgumentError)
    expect { Bitly::API::List.new }.to raise_error(ArgumentError)
  end

  it "can iterate over the items" do
    response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
    items = ["a", "b"]
    list = Bitly::API::List.new(items: items, response: response)
    list.each_with_index do |item, index|
      expect(item).to eq(items[index])
    end
  end

  it "returns the response" do
    response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
    list = Bitly::API::List.new(items: ["a", "b"], response: response)
    expect(list.response).to eq(response)
  end
end