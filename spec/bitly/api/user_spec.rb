# frozen_string_literal: true

RSpec.describe Bitly::API::User do
  let(:user_data) {
    {
      "created"=>"2009-01-08T07:11:59+0000",
      "modified"=>"2017-10-06T10:56:57+0000",
      "login"=>"testuser",
      "is_active"=>true,
      "is_2fa_enabled"=>false,
      "name"=>"Test User",
      "emails"=>[
        {
          "email"=>"test@example.com",
          "is_primary"=>true,
          "is_verified"=>true
        }
      ],
      "is_sso_user"=>false,
      "default_group_guid"=>"def456"
    }
  }
  let(:client) { double("client") }

  it "fetches the authorized user with an API client" do
    response = Bitly::HTTP::Response.new(
      status: "200",
      body: user_data.to_json,
      headers: {}
    )
    expect(client).to receive(:request).with(path: "/user").and_return(response)
    user = Bitly::API::User.fetch(client: client)
    expect(user).to be_instance_of(Bitly::API::User)
    expect(user.login).to eq("testuser")
  end

  describe "an existing user" do
    let(:user) { Bitly::API::User.new(data: user_data, client: client) }

    it "has an array of email objects" do
      expect(user.emails).to be_instance_of(Array)
      email = user.emails.first
      expect(email).to be_instance_of(Bitly::API::User::Email)
      expect(email.email).to eq("test@example.com")
      expect(email.is_verified).to be true
      expect(email.is_primary).to be true
    end

    it "fetches the default group from the API" do
      group = double("group")
      expect(Bitly::API::Group).to receive(:fetch).once
        .with(client: client, guid: "def456")
        .and_return(group)
      expect(user.default_group).to eq(group)
      expect(user.default_group).to eq(group)
    end

    it "can update the name" do
      response = Bitly::HTTP::Response.new(
        status: "200",
        body: { name: "New Name", default_group_guid: "def456" }.to_json,
        headers: {}
      )
      expect(client).to receive(:request)
        .with(
          path: "/user",
          method: "PATCH",
          params: { "name" => "New Name" }
        )
        .and_return(response)
      user.update(name: "New Name")
      expect(user.name).to eq("New Name")
    end

    it "can update the default group guid" do
      group1 = double("group")
      expect(Bitly::API::Group).to receive(:fetch).once
        .with(client: client, guid: "def456")
        .and_return(group1)
      group2 = double("group")
      expect(Bitly::API::Group).to receive(:fetch).once
        .with(client: client, guid: "ghi789")
        .and_return(group2)
      response = Bitly::HTTP::Response.new(
        status: "200",
        body: { name: "Test User", default_group_guid: "ghi789" }.to_json,
        headers: {}
      )
      expect(client).to receive(:request)
        .with(
          path: "/user",
          method: "PATCH",
          params: { "default_group_guid" => "ghi789", "name" => nil }
        )
        .and_return(response)

      expect(user.default_group).to eq(group1)
      user.update(default_group_guid: "ghi789")
      expect(user.default_group_guid).to eq("ghi789")
      expect(user.default_group).to eq(group2)
    end
  end
end