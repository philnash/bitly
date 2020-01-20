# frozen_string_literal: true

RSpec.describe Bitly::API::Group do
  let(:group_data) {
    {
      "created"=>"2009-01-08T07:11:59+0000",
      "modified"=>"2016-11-11T23:48:07+0000",
      "bsds"=>[],
      "guid"=>"def456",
      "organization_guid"=>"abc123",
      "name"=>"philnash",
      "is_active"=>true,
      "role"=>"org-admin",
      "references"=>{
        "organization"=>"https://api-ssl.bitly.com/v4/organizations/abc123"
      }
    }
  }

  it "uses a client to list groups" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: { "groups" => [group_data] }.to_json,
      headers: {}
    )
    client = double("client")
    expect(client).to receive(:request)
      .with(path: "/groups", params: { "organization_guid" => nil })
      .and_return(response)

    groups = Bitly::API::Group.list(client: client)
    expect(groups.count).to eq(1)
    expect(groups.first).to be_instance_of(Bitly::API::Group)
    expect(groups.response).to eq(response)
  end

  it "can list groups filtered by organization guid" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: { "groups" => [group_data] }.to_json,
      headers: {}
    )
    client = double("client")
    expect(client).to receive(:request)
      .with(path: "/groups", params: { "organization_guid" => "abc123" })
      .and_return(response)
    groups = Bitly::API::Group.list(client: client, organization_guid: "abc123")
    expect(groups.count).to eq(1)
    expect(groups.first).to be_instance_of(Bitly::API::Group)
    expect(groups.response).to eq(response)
  end

  it "can use a client to fetch a group with an guid" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: group_data.to_json,
      headers: {}
    )
    client = double("client")
    expect(client).to receive(:request).with(path: "/groups/def456").and_return(response)
    group = Bitly::API::Group.fetch(client: client, group_guid: "def456")
    expect(group.name).to eq("philnash")
    expect(group.role).to eq("org-admin")
  end

  describe "with a group" do
    let(:client) { double("client") }
    let(:organization) { double("organization") }
    let(:group) { Bitly::API::Group.new(data: group_data, client: client) }

    it "can fetch its organization" do
      expect(Bitly::API::Organization).to receive(:fetch)
        .with(client: client, organization_guid: "abc123")
        .and_return(organization)
      expect(group.organization).to eq(organization)
    end

    it "doesn't fetch the organization if it already has it" do
      group = Bitly::API::Group.new(data: group_data, client: client, organization: organization)
      expect(Bitly::API::Organization).not_to receive(:fetch)
      group.organization
    end

    it "doesn't fetch the organization more than once" do
      expect(Bitly::API::Organization).to receive(:fetch).once
        .with(client: client, organization_guid: "abc123")
        .and_return(organization)
      group.organization
      group.organization
    end

    it "fetches its preferences, only once" do
      preferences = double("preferences")
      expect(Bitly::API::Group::Preferences).to receive(:fetch).once
        .with(client: client, group_guid: "def456")
        .and_return(preferences)
      expect(group.preferences).to eq(preferences)
      expect(group.preferences).to eq(preferences)
    end

    it "fetches its tags, only once" do
      tags = ["a", "b"]
      response = Bitly::HTTP::Response.new(
        status: "200",
        body: { "tags" => tags }.to_json,
        headers: {}
      )
      expect(client).to receive(:request).once
        .with(path: "/groups/def456/tags")
        .and_return(response)
      expect(group.tags).to eq(tags)
      expect(group.tags).to eq(tags)
    end

    it "can update a group's bsds, name and organization guid" do
      new_group_data = group_data.clone
      new_group_data["bsds"] = ["hello"]
      new_group_data["organization_guid"] = "ghi789"
      new_group_data["name"] = "New Name"
      response = Bitly::HTTP::Response.new(
        status: "200",
        body: new_group_data.to_json,
        headers: {}
      )
      expect(client).to receive(:request)
        .with(
          path: "/groups/#{group.guid}",
          method: "PATCH",
          params: {
            "bsds" => ["hello"],
            "organization_guid" => "ghi789",
            "name" => "New Name"
          }
        )
        .and_return(response)
      group.update(bsds: ["hello"], organization_guid: "ghi789", name: "New Name")
      expect(group.bsds).to eq(["hello"])
      expect(group.organization_guid).to eq("ghi789")
      expect(group.name).to eq("New Name")
    end

    it "refetches the organization after updating the organization guid" do
      organization1 = double("organization1")
      expect(Bitly::API::Organization).to receive(:fetch).once
        .with(client: client, organization_guid: "abc123")
        .and_return(organization1)
      organization2 = double("organization2")
      expect(Bitly::API::Organization).to receive(:fetch).once
        .with(client: client, organization_guid: "ghi789")
        .and_return(organization2)
      new_group_data = group_data.clone
      new_group_data["organization_guid"] = "ghi789"
      response = Bitly::HTTP::Response.new(
        status: "200",
        body: new_group_data.to_json,
        headers: {}
      )
      expect(client).to receive(:request)
        .with(
          path: "/groups/#{group.guid}",
          method: "PATCH",
          params: { "organization_guid" => "ghi789", "name" => nil, "bsds" => nil }
        )
        .and_return(response)
      expect(group.organization).to eq(organization1)
      group.update(organization_guid: "ghi789")
      expect(group.organization_guid).to eq("ghi789")
      expect(group.organization).to eq(organization2)
    end

    it "can be deleted" do
      response = Bitly::HTTP::Response.new(
        status: "204",
        body: "",
        headers: {}
      )
      expect(client).to receive(:request).once
        .with(path: "/groups/#{group.guid}", method: "DELETE")
        .and_return(response)
      expect(group.delete).to be nil
    end

    it "can get shorten counts" do
      shorten_counts_mock = double("shorten_counts")
      expect(Bitly::API::ShortenCounts).to receive(:by_group)
        .with(client: client, group_guid: group.guid)
        .and_return(shorten_counts_mock)
      shorten_counts = group.shorten_counts
      expect(shorten_counts).to eq(shorten_counts_mock)
    end

    it "can get bitlinks" do
      bitlinks_mock = double("bitlinks")
      expect(Bitly::API::Bitlink).to receive(:list)
        .with(client: client, group_guid: group.guid)
        .and_return(bitlinks_mock)
      bitlinks = group.bitlinks
      expect(bitlinks).to eq(bitlinks_mock)
    end

    it "can get referring networks metrics" do
      click_metrics = double("referring_networks")
      expect(Bitly::API::ClickMetric).to receive(:list_referring_networks)
        .with(
          client: client,
          group_guid: group.guid,
          unit: nil,
          units: nil,
          unit_reference: nil,
          size: nil
        )
        .and_return(click_metrics)
      expect(group.referring_networks).to eq(click_metrics)
    end

    it "can get country metrics" do
      click_metrics = double("countries")
      expect(Bitly::API::ClickMetric).to receive(:list_countries_by_group)
        .with(
          client: client,
          group_guid: group.guid,
          unit: nil,
          units: nil,
          unit_reference: nil,
          size: nil
        )
        .and_return(click_metrics)
      expect(group.countries).to eq(click_metrics)
    end
  end
end