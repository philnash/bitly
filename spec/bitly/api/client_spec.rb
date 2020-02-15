# frozen_string_literal: true

RSpec.describe Bitly::API::Client do
  let(:token) { "token" }
  let(:http) { double("http") }

  describe "#new" do
    it "requires at least one argument" do
      expect { Bitly::API::Client.new }.to raise_error(ArgumentError)
    end

    it "initializes with an API token" do
      expect { Bitly::API::Client.new(token: "token") }.not_to raise_error
    end

    it "initializes with an API token and http client" do
      expect { Bitly::API::Client.new(token: "token", http: http) }.not_to raise_error
    end
  end

  describe "#request" do
    let(:client) { Bitly::API::Client.new(token: token) }

    it "uses the http client to make a GET request to the base url" do
      stub_request(:get, Bitly::API::BASE_URL)
        .to_return(body: { "success" => true }.to_json)
      response = client.request(path: "")
      expect(response).to be_instance_of(Bitly::HTTP::Response)
      expect(response.body["success"]).to be true
    end

    describe "other methods" do
      it "POST" do
        stub_request(:post, Bitly::API::BASE_URL)
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "", method: "POST")
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end

      it "PATCH" do
        stub_request(:patch, Bitly::API::BASE_URL)
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "", method: "PATCH")
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end

      it "DELETE" do
        stub_request(:delete, Bitly::API::BASE_URL)
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "", method: "DELETE")
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end
    end

    describe "paths" do
      it "uses the http client to make a request to the base url with a path" do
        path = "/test"
        url = Bitly::API::BASE_URL.dup
        url.path += path
        stub_request(:get, url)
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: path)
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end
    end

    describe "params" do
      it "passes on params to the request object" do
        url = Bitly::API::BASE_URL.dup
        url.query = "test=success"
        stub_request(:get, url)
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "", params: { "test" => "success" })
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end

      it "doesn't pass on params that are nil" do
        url = Bitly::API::BASE_URL.dup
        url.query = "test=success"
        stub_request(:get, url)
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "", params: {
          "test" => "success",
          "not_here" => nil
        })
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end
    end

    describe "headers" do
      it "sends the default headers with the request" do
        stub_request(:get, Bitly::API::BASE_URL)
          .with(headers: {
            "User-Agent" => Bitly::API::Client::USER_AGENT,
            "Authorization" => "Bearer #{token}",
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          })
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "")
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end

      it "can override and add headers" do
        stub_request(:get, Bitly::API::BASE_URL)
          .with(headers: {
            "User-Agent" => "new user agent",
            "Authorization" => "Bearer #{token}",
            "Accept" => "application/json",
            "Content-Type" => "application/json",
            "X-Header-Test" => "success"
          })
          .to_return(body: { "success" => true }.to_json)
        response = client.request(path: "", headers: {
          "User-Agent" => "new user agent",
          "X-Header-Test" => "success"
        })
        expect(response).to be_instance_of(Bitly::HTTP::Response)
        expect(response.body["success"]).to be true
      end
    end
  end

  describe "API methods" do
    let(:client) { Bitly::API::Client.new(token: token) }

    describe "Bitlink" do
      let(:id) { "https://bit.ly/short" }

      it "shortens a URL" do
        long_url = "https://bitly.com"
        expect(Bitly::API::Bitlink).to receive(:shorten)
          .with(
            client: client,
            long_url: long_url,
            domain: nil,
            group_guid: nil
          )
        client.shorten(long_url: long_url)
      end

      it "creates a Bitlink" do
        long_url = "https://bitly.com"
        expect(Bitly::API::Bitlink).to receive(:create)
          .with(
            client: client,
            long_url: long_url,
            domain: nil,
            group_guid: nil,
            title: nil,
            tags: nil,
            deeplinks: nil
          )
        client.create_bitlink(long_url: long_url)
      end

      it "fetches a Bitlink" do
        expect(Bitly::API::Bitlink).to receive(:fetch)
          .with(client: client, bitlink: id)
        client.bitlink(bitlink: id)
      end

      it "expands a Bitlink" do
        expect(Bitly::API::Bitlink).to receive(:expand)
          .with(client: client, bitlink: id)
          client.expand(bitlink: id)
      end

      it "fetches sorted bitlinks by group" do
        group_guid = "abc123"
        expect(Bitly::API::Bitlink).to receive(:sorted_list)
          .with(
            client: client,
            group_guid: group_guid,
            sort: "clicks",
            size: nil,
            unit: nil,
            units: nil,
            unit_reference: nil
          )
        client.sorted_bitlinks(group_guid: group_guid)
      end

      it "updates a bitlink" do
        bitlink = double("bitlink")
        expect(bitlink).to receive(:update)
          .with(
            archived: nil,
            tags: nil,
            created_at: nil,
            title: "new title",
            deeplinks: nil,
            created_by: nil,
            long_url: nil,
            client_id: nil,
            custom_bitlinks: nil,
            link: nil,
            id: nil,
            references: nil
          )
        expect(Bitly::API::Bitlink).to receive(:new)
          .with(data: { "id" => id }, client: client)
          .and_return(bitlink)
        client.update_bitlink(bitlink: id, title: "new title")
      end

      it "gets the link clicks for a bitlink" do
        expect(Bitly::API::Bitlink::LinkClick).to receive(:list)
          .with(client: client, bitlink: id, unit: nil, units: nil, size: nil, unit_reference: nil)
        client.bitlink_clicks(bitlink: id)
      end
    end

    describe "Organization" do
      it "lists organizations" do
        expect(Bitly::API::Organization).to receive(:list)
          .with(client: client)
        client.organizations
      end

      it "fetches an organization" do
        organization_guid = "def456"
        expect(Bitly::API::Organization).to receive(:fetch)
          .with(client: client, organization_guid: organization_guid)
        client.organization(organization_guid: organization_guid)
      end

      it "fetches an organization's shorten counts" do
        organization_guid = "def456"
        expect(Bitly::API::ShortenCounts).to receive(:by_organization)
          .with(client: client, organization_guid: organization_guid)
        client.organization_shorten_counts(organization_guid: organization_guid)
      end
    end

    describe "User" do
      it "fetches the authorized user" do
        expect(Bitly::API::User).to receive(:fetch)
          .with(client: client)
        client.user
      end

      it "updates a user" do
        user = double("user")
        expect(Bitly::API::User).to receive(:new).and_return(user)
        expect(user).to receive(:update)
          .with(
            name: "New Name",
            default_group_guid: "abc123"
          )
        client.update_user(name: "New Name", default_group_guid: "abc123")
      end
    end

    describe "Group" do
      let(:group_guid) { "abc123" }

      it "fetches the list of groups" do
        expect(Bitly::API::Group).to receive(:list)
          .with(client: client, organization_guid: nil)
        client.groups
      end

      it "fetches the list of groups by organization" do
        expect(Bitly::API::Group).to receive(:list)
          .with(client: client, organization_guid: "abc123")
        client.groups(organization_guid: "abc123")
      end

      it "fetches a group by group_guid" do
        expect(Bitly::API::Group).to receive(:fetch)
          .with(client: client, group_guid: "def456")
        client.group(group_guid: "def456")
      end

      it "fetches shorten counts by group" do
        expect(Bitly::API::ShortenCounts).to receive(:by_group)
          .with(client: client, group_guid: group_guid)
        client.group_shorten_counts(group_guid: group_guid)
      end

      it "fetches a group's preferences" do
        expect(Bitly::API::Group::Preferences).to receive(:fetch)
          .with(client: client, group_guid: group_guid)
        client.group_preferences(group_guid: group_guid)
      end

      it "updates a group's preferences" do
        domain_preference = "j.mp"
        prefs = double("preferences")
        expect(Bitly::API::Group::Preferences).to receive(:new)
          .with(data: { "group_guid" => group_guid }, client: client)
          .and_return(prefs)
        expect(prefs).to receive(:update)
          .with(domain_preference: domain_preference)
        client.update_group_preferences(group_guid: group_guid, domain_preference: domain_preference)
      end

      it "updates a group" do
        group = double("group")
        expect(Bitly::API::Group).to receive(:new)
          .with(data: { "guid" => group_guid }, client: client)
          .and_return(group)
        expect(group).to receive(:update)
          .with(name: "New name", organization_guid: nil, bsds: nil)
        client.update_group(group_guid: group_guid, name: "New name")
      end

      it "deletes a group" do
        group = double("group")
        expect(Bitly::API::Group).to receive(:new)
          .with(data: { "guid" => group_guid }, client: client)
          .and_return(group)
        expect(group).to receive(:delete)
        client.delete_group(group_guid: group_guid)
      end

      it "gets a group's bitlinks" do
        expect(Bitly::API::Bitlink).to receive(:list)
          .with(
            client: client,
            group_guid: group_guid,
            size: nil,
            page: nil,
            keyword: nil,
            query: nil,
            created_before: nil,
            created_after: nil,
            modified_after: nil,
            archived: nil,
            deeplinks: nil,
            domain_deeplinks: nil,
            campaign_guid: nil,
            channel_guid: nil,
            custom_bitlink: nil,
            tags: nil,
            encoding_login: nil
          )
        client.group_bitlinks(group_guid: group_guid)
      end

      it "can get group referring networks metrics" do
        expect(Bitly::API::ClickMetric).to receive(:list_referring_networks)
          .with(
            client: client,
            group_guid: group_guid,
            unit: nil,
            units: nil,
            unit_reference: nil,
            size: nil
          )
        client.group_referring_networks(group_guid: group_guid)
      end

      it "can get country metrics" do
        expect(Bitly::API::ClickMetric).to receive(:list_countries_by_group)
          .with(
            client: client,
            group_guid: group_guid,
            unit: nil,
            units: nil,
            unit_reference: nil,
            size: nil
          )
        client.group_countries(group_guid: group_guid)
      end
    end

    describe "BSD" do
      it "fetches a list of BSDs" do
        expect(Bitly::API::BSD).to receive(:list)
          .with(client: client)
        client.bsds
      end
    end

    describe "OAuth app" do
      it "fetches an app by client id" do
        expect(Bitly::API::OAuthApp).to receive(:fetch)
          .with(client: client, client_id: "abc123")
        client.oauth_app(client_id: "abc123")
      end
    end
  end
end