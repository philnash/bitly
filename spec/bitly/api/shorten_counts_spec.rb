# frozen_string_literal: true

RSpec.describe Bitly::API::ShortenCounts do
  let(:data) {
    {
      "unit_reference"=>"2020-01-04T00:21:20+0000",
      "metrics"=>[
        {"value"=>2, "key"=>"2020-01-02T00:00:00+0000"},
        {"value"=>1, "key"=>"2019-04-17T00:00:00+0000"}
      ],
      "units"=>-1,
      "unit"=>"day",
      "facet"=>"shorten_counts"
    }
  }

  it "initializes with data" do
    counts = Bitly::API::ShortenCounts.new(data: data)
    expect(counts.unit_reference).to eq("2020-01-04T00:21:20+0000")
    expect(counts.units).to eq(-1)
    expect(counts.unit).to eq("day")
    expect(counts.facet).to eq("shorten_counts")
  end

  it "turns metrics into an array Metric objects" do
    counts = Bitly::API::ShortenCounts.new(data: data)
    expect(counts.metrics.length).to eq(2)
    expect(counts.metrics.first.key).to eq("2020-01-02T00:00:00+0000")
    expect(counts.metrics.first.value).to eq(2)
  end
end