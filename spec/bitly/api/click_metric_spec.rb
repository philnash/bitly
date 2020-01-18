# frozen_string_literal: true

RSpec.describe Bitly::API::ClickMetric do
  let(:group_guid) { 'abcdef' }
  let(:bitlink) { 'bit.ly/def456' }
  let(:click_metric_data_referring_networks) do
    {
      'unit_reference' => '2020-01-18T02:48:35+0000',
      'metrics' => [
        { 'value' => 'direct', 'clicks' => 167 },
        { 'value' => 'other', 'clicks' => 9 },
        { 'value' => 'twitter', 'clicks' => 4 },
        { 'value' => 'facebook', 'clicks' => 1 }
      ],
      'units' => -1,
      'unit' => 'day',
      'facet' => 'referring_networks'
    }
  end
  let(:click_metric_data_countries) do
    {
      'unit_reference' => '2020-01-18T05:51:46+0000',
      'metrics' => [
        { 'value' => 'PL', 'clicks' => 42 },
        { 'value' => 'GB', 'clicks' => 36 }
      ],
      'units' => -1,
      'unit' => 'day',
      'facet' => 'countries'
    }
  end
  let(:click_metric_bitlink_referrers) do
    {
      "unit_reference" => "2020-01-18T06:15:40+0000",
      "metrics"=>[
        {"value"=>"http://t.co/", "clicks"=>30},
        {"value"=>"direct", "clicks"=>4},
        {"value"=>"http://twitterrific.com/referrer", "clicks"=>1}
      ],
      "units"=>-1,
      "unit"=>"day",
      "facet"=>"referrers"
    }
  end
  let(:click_metric_bitlink_referring_domains) do
    {
      "unit_reference" => "2020-01-18T06:28:00+0000",
      "metrics"=>[
        {"value"=>"t.co", "clicks"=>30},
        {"value"=>"direct", "clicks"=>4},
        {"value"=>"twitterrific.com", "clicks"=>1}
      ],
      "units"=>-1,
      "unit"=>"day",
      "facet"=>"referring_domains"
    }
  end
  let(:click_metric_bitlink_referrers_by_domain) do
    {
      "units"=>-1,
      "unit"=>"day",
      "unit_reference"=>1579329107,
      "facet"=>"referrers_by_domain",
      "referrers_by_domain"=>[
        {
          "network"=>"twitter",
          "referrers"=>[
            {"value"=>"http://t.co/", "clicks"=>30},
            {"value"=>"http://twitterrific.com/referrer", "clicks"=>1}
          ]
        },
        {
          "network"=>"direct",
          "referrers"=>[{"value"=>"direct", "clicks"=>4}]
        }
      ]
    }
  end

  it 'gets referring networks for a group' do
    response = Bitly::HTTP::Response.new(
      status: '200',
      body: click_metric_data_referring_networks.to_json,
      headers: {}
    )
    client = double('client')
    expect(client).to receive(:request)
      .with(path: "/groups/#{group_guid}/referring_networks", params: {
        'units' => nil,
        'unit' => nil,
        'unit_reference' => nil,
        'size' => nil
      })
      .and_return(response)

    click_metrics = Bitly::API::ClickMetric.list_referring_networks(client: client, group_guid: group_guid)
    expect(click_metrics.unit).to eq(click_metric_data_referring_networks['unit'])
    expect(click_metrics.units).to eq(click_metric_data_referring_networks['units'])
    expect(click_metrics.unit_reference).to eq(Time.parse(click_metric_data_referring_networks['unit_reference']))
    expect(click_metrics.facet).to eq(click_metric_data_referring_networks['facet'])
    expect(click_metrics.first.value).to eq('direct')
    expect(click_metrics.first.clicks).to eq(167)
  end

  it 'gets referring countries for a group' do
    response = Bitly::HTTP::Response.new(
      status: '200',
      body: click_metric_data_countries.to_json,
      headers: {}
    )
    client = double('client')
    expect(client).to receive(:request)
      .with(path: "/groups/#{group_guid}/countries", params: {
        'units' => nil,
        'unit' => nil,
        'unit_reference' => nil,
        'size' => nil
      })
      .and_return(response)

    click_metrics = Bitly::API::ClickMetric.list_countries_by_group(client: client, group_guid: group_guid)
    expect(click_metrics.unit).to eq(click_metric_data_countries['unit'])
    expect(click_metrics.units).to eq(click_metric_data_countries['units'])
    expect(click_metrics.unit_reference).to eq(Time.parse(click_metric_data_countries['unit_reference']))
    expect(click_metrics.facet).to eq(click_metric_data_countries['facet'])
    expect(click_metrics.first.value).to eq('PL')
    expect(click_metrics.first.clicks).to eq(42)
  end

  it 'gets referrers for a bitlink' do
    response = Bitly::HTTP::Response.new(
      status: '200',
      body: click_metric_bitlink_referrers.to_json,
      headers: {}
    )
    client = double('client')
    expect(client).to receive(:request)
      .with(path: "/bitlinks/#{bitlink}/referrers", params: {
        'units' => nil,
        'unit' => nil,
        'unit_reference' => nil,
        'size' => nil
      })
      .and_return(response)

    click_metrics = Bitly::API::ClickMetric.list_referrers(client: client, bitlink: bitlink)
    expect(click_metrics.unit).to eq(click_metric_bitlink_referrers['unit'])
    expect(click_metrics.units).to eq(click_metric_bitlink_referrers['units'])
    expect(click_metrics.unit_reference).to eq(Time.parse(click_metric_bitlink_referrers['unit_reference']))
    expect(click_metrics.facet).to eq(click_metric_bitlink_referrers['facet'])
    expect(click_metrics.first.value).to eq('http://t.co/')
    expect(click_metrics.first.clicks).to eq(30)
  end

  it 'gets referring countries for a bitlink' do
    response = Bitly::HTTP::Response.new(
      status: '200',
      body: click_metric_data_countries.to_json,
      headers: {}
    )
    client = double('client')
    expect(client).to receive(:request)
      .with(path: "/bitlinks/#{bitlink}/countries", params: {
        'units' => nil,
        'unit' => nil,
        'unit_reference' => nil,
        'size' => nil
      })
      .and_return(response)

    click_metrics = Bitly::API::ClickMetric.list_countries_by_bitlink(client: client, bitlink: bitlink)
    expect(click_metrics.unit).to eq(click_metric_data_countries['unit'])
    expect(click_metrics.units).to eq(click_metric_data_countries['units'])
    expect(click_metrics.unit_reference).to eq(Time.parse(click_metric_data_countries['unit_reference']))
    expect(click_metrics.facet).to eq(click_metric_data_countries['facet'])
    expect(click_metrics.first.value).to eq('PL')
    expect(click_metrics.first.clicks).to eq(42)
  end

  it 'gets referring domains for a bitlink' do
    response = Bitly::HTTP::Response.new(
      status: '200',
      body: click_metric_bitlink_referring_domains.to_json,
      headers: {}
    )
    client = double('client')
    expect(client).to receive(:request)
      .with(path: "/bitlinks/#{bitlink}/referring_domains", params: {
        'units' => nil,
        'unit' => nil,
        'unit_reference' => nil,
        'size' => nil
      })
      .and_return(response)

    click_metrics = Bitly::API::ClickMetric.list_referring_domains(client: client, bitlink: bitlink)
    expect(click_metrics.unit).to eq(click_metric_bitlink_referring_domains['unit'])
    expect(click_metrics.units).to eq(click_metric_bitlink_referring_domains['units'])
    expect(click_metrics.unit_reference).to eq(Time.parse(click_metric_bitlink_referring_domains['unit_reference']))
    expect(click_metrics.facet).to eq(click_metric_bitlink_referring_domains['facet'])
    expect(click_metrics.first.value).to eq('t.co')
    expect(click_metrics.first.clicks).to eq(30)
  end

  it 'gets referrers by domains for a bitlink' do
    response = Bitly::HTTP::Response.new(
      status: '200',
      body: click_metric_bitlink_referrers_by_domain.to_json,
      headers: {}
    )
    client = double('client')
    expect(client).to receive(:request)
      .with(path: "/bitlinks/#{bitlink}/referrers_by_domains", params: {
        'units' => nil,
        'unit' => nil,
        'unit_reference' => nil,
        'size' => nil
      })
      .and_return(response)

    click_metrics = Bitly::API::ClickMetric.list_referrers_by_domain(client: client, bitlink: bitlink)
    expect(click_metrics.unit).to eq(click_metric_bitlink_referrers_by_domain['unit'])
    expect(click_metrics.units).to eq(click_metric_bitlink_referrers_by_domain['units'])
    expect(click_metrics.unit_reference).to eq(Time.at(click_metric_bitlink_referrers_by_domain['unit_reference']))
    expect(click_metrics.facet).to eq(click_metric_bitlink_referrers_by_domain['facet'])
    expect(click_metrics.first.network).to eq('twitter')
    puts click_metrics.first
    expect(click_metrics.first.count).to eq(2)
    expect(click_metrics.first.first.value).to eq('http://t.co/')
    expect(click_metrics.first.first.clicks).to eq(30)
  end
end
