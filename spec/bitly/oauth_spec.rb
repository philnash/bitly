# frozen_string_literal: true

RSpec.describe Bitly::OAuth do
  let(:client_id) { ENV["CLIENT_ID"] || "client_id" }
  let(:client_secret) { ENV["CLIENT_SECRET"] || "client_secret" }

  it "initializes with a client_id and client_secret" do
    oauth = Bitly::OAuth.new(client_id: client_id, client_secret: client_secret)
    expect(oauth.client_id).to eq(client_id)
    expect(oauth.client_secret).to eq(client_secret)
  end

  let(:redirect_uri) { "http://example.com/oauth/redirect" }
  let(:oauth) { Bitly::OAuth.new(client_id: client_id, client_secret: client_secret) }

  describe "authorize_uri" do
    it "generates a URI for Bitly OAuth" do
      authorize_uri = oauth.authorize_uri(redirect_uri)
      expected_uri = "https://bitly.com/oauth/authorize"
      expect(authorize_uri).to match(/\A#{expected_uri}/)
    end

    it "includes a redirect_uri parameter" do
      authorize_uri = oauth.authorize_uri(redirect_uri)
      expect(authorize_uri).to match(/redirect_uri=#{CGI.escape(redirect_uri)}/)
    end

    it "includes the client_id" do
      authorize_uri = oauth.authorize_uri(redirect_uri)
      expect(authorize_uri).to match(/client_id=#{client_id}/)
    end

    it "includes an optional state" do
      state = "test_state"
      authorize_uri = oauth.authorize_uri(redirect_uri, state: state)
      expect(authorize_uri).to match(/state=#{state}/)
    end

    it "doesn't have a state parameter in the URL if there is no state" do
      authorize_uri = oauth.authorize_uri(redirect_uri)
      expect(authorize_uri).not_to match(/state=/)
    end
  end

  describe "access_token" do
    let(:code) { ENV["OAUTH_CODE"] || "abcde" }

    describe "without enough arguments" do
      it "raises an ArgumentError" do
        expect { oauth.access_token }.to raise_error(ArgumentError)
      end
    end

    describe "via the Authorization Code flow" do
      it "gets an access token" do
        VCR.use_cassette("access_token") do
          access_token = oauth.access_token(redirect_uri: redirect_uri, code: code)
          expect(access_token).to eq("<ACCESS_TOKEN>")
        end
      end

      it "raises an error when the code and redirect_uri don't match" do
        VCR.use_cassette("access_token_error") do
          expect {
            oauth.access_token(redirect_uri: redirect_uri, code: "blah")
          }.to raise_error(Bitly::Error)
        end
      end
    end

    describe "via the Resource Owner Credentials flow" do
      let(:username) { ENV["USERNAME"] || "test" }
      let(:password) { ENV["PASSWORD"] || "password" }

      it "gets an access token with a username and password" do
        VCR.use_cassette("access_token_username_password") do
          access_token = oauth.access_token(username: username, password: password)
          expect(access_token).to eq("<ACCESS_TOKEN>")
        end
      end
    end
  end


end