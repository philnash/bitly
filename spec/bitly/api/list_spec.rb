# frozen_string_literal: true

RSpec.describe Bitly::API::List do
  it "initializes with a list of items and a response" do
    response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
    expect { list = Bitly::API::List.new(["a", "b"], response) }.not_to raise_error
  end

  it "needs both an item and a response" do
    expect { Bitly::API::List.new(["a", "b"]) }.to raise_error(ArgumentError)
    expect { Bitly::API::List.new }.to raise_error(ArgumentError)
  end

  it "can iterate over the items" do
    response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
    items = ["a", "b"]
    list = Bitly::API::List.new(items, response)
    list.each_with_index do |item, index|
      expect(item).to eq(items[index])
    end
  end

  it "returns the response" do
    response = Bitly::HTTP::Response.new(status: "200", body: "{}", headers: {})
    list = Bitly::API::List.new(["a", "b"], response)
    expect(list.response).to eq(response)
  end
end