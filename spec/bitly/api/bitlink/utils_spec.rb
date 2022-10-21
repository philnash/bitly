# frozen_string_literal: true

RSpec.describe Bitly::API::Bitlink::Utils do
  describe "normalise_bitlink" do
    it "removes a leading https protocol from a bitlink" do
      expect(Bitly::API::Bitlink::Utils.normalise_bitlink(bitlink: "https://bit.ly/short")).to eq("bit.ly/short")
    end

    it "removes a leading http protocol from a bitlink" do
      expect(Bitly::API::Bitlink::Utils.normalise_bitlink(bitlink: "http://bit.ly/short")).to eq("bit.ly/short")
    end

    it "returns the same string if there is no leading protocol" do
      expect(Bitly::API::Bitlink::Utils.normalise_bitlink(bitlink: "ahttp://bit.ly/short")).to eq("ahttp://bit.ly/short")
    end
  end
end