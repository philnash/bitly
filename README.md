# Bitly

A Ruby gem for using the version 4 [Bitly API](https://dev.bitly.com/) to shorten links, expand short links and view metrics across users, links and organizations.

[![Gem version](https://badge.fury.io/rb/bitly.svg)](https://rubygems.org/gems/bitly) ![Build status](https://github.com/philnash/bitly/workflows/tests/badge.svg) [![Maintainability](https://api.codeclimate.com/v1/badges/f8e078b468c1f2aeca53/maintainability)](https://codeclimate.com/github/philnash/bitly/maintainability) [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=philnash_bitly&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=philnash_bitly) [![Inline docs](https://inch-ci.org/github/philnash/bitly.svg?branch=master)](https://inch-ci.org/github/philnash/bitly)

* [Installation](#installation)
* [Usage](#usage)
  * [Authentication](#authentication)
  * [Creating an API client](#creating-an-api-client)
  * [Shorten a link](#shorten-a-link)
  * [Expand a link](#expand-a-link)
* [Available API Endpoints](#available-api-endpoints)
  * [Groups](#groups)
  * [Organizations](#organizations)
  * [Users](#users)
  * [Bitlinks](#bitlinks)
  * [Custom Bitlinks](#custom-bitlinks)
  * [Campaigns](#campaigns)
  * [BSDs (Branded Short Domains)](#bsds-branded-short-domains)
  * [OAuth Apps](#oauth-apps)
  * [Webhooks](#webhooks)
* [Customising HTTP requests](#customising-http-requests)
  * [Build your own adapter](#build-your-own-adapter)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)
* [Code of Conduct](#code-of-conduct)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitly'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install bitly
```

## Usage

### Authentication

All API endpoints require authentication with an OAuth token. You can get your own OAuth token from the [Bitly console](https://app.bitly.com/). Click on the account drop down menu, then _Profile Settings_ then _Generic Access Token_. Fill in your password and you can generate an OAuth access token.

For other methods to generate access tokens for users via OAuth flows, see the [Authentication documentation](docs/authentication.md).

Once you have an access token you can use all the API methods.

### Creating an API client

All API methods are available through the `Bitly::API::Client`. Initialise the client with the access token like so:

```ruby
client = Bitly::API::Client.new(token: token)
```

You can then use the client to perform actions with the API

### Shorten a link

With an authenticated client you can shorten a link like so:

```ruby
bitlink = client.shorten(long_url: "http://example.com")
bitlink.link
# => http://bit.ly/2OUJim0
```

### Expand a link

With an authorised you can expand any Bitlink.

```ruby
bitlink = client.expand(bitlink: "bit.ly/2OUJim0")
bitlink.long_url
# => http://example.com
```

## Available API Endpoints

This gem supports the following active v4 API endpoints for the[Bitly API](https://dev.bitly.com/api-reference).

### Groups

[Groups documentation](docs/groups.md)

- [x] [Retrieve groups (`GET /v4/groups`)](https://dev.bitly.com/api-reference/#getGroups)
- [x] [Retrieve group (`GET /v4/groups/{group_guid}`)](https://dev.bitly.com/api-reference/#getGroup)
- [x] [Update group (`PATCH /v4/groups/{group_guid}`)](https://dev.bitly.com/api-reference/#updateGroup)
- [x] Delete group (`DELETE /v4/groups/{group_guid}`)
- [x] [Retrieve tags by group (`GET /v4/groups/{group_guid}/tags`)](https://dev.bitly.com/api-reference/#getGroupTags)
- [x] [Retrieve group preferences (`GET /v4/groups/{group_guid}/preferences`)](https://dev.bitly.com/api-reference/#getGroupPreferences)
- [x] [Update group preferences (`PATCH /v4/groups/{group_guid}/preferences`)](https://dev.bitly.com/api-reference/#updateGroupPreferences)
- [x] [Retrieve Bitlinks by group (`GET /v4/groups/{group_guid}/bitlinks`)](https://dev.bitly.com/api-reference/#getBitlinksByGroup)
- [x] [Retrieve sorted Bitlinks by group (`GET /v4/groups/{group_guid}/bitlinks/{sort}`)](https://dev.bitly.com/api-reference/#getSortedBitlinks)
- [x] [Retrieve group shorten counts (`GET /v4/groups/{group_guid}/shorten_counts`)](https://dev.bitly.com/api-reference/#getGroupShortenCounts)
- [x] [Retrieve click metrics for a group by referring networks (`GET /v4/groups/{group_guid}/referring_networks`)](https://dev.bitly.com/api-reference/#GetGroupMetricsByReferringNetworks)
- [x] [Retrieve click metrics for a group by countries (`GET /v4/groups/{group_guid}/countries`)](https://dev.bitly.com/api-reference/#getGroupMetricsByCountries)
- [ ] __[premium]__ [Retrieve click metrics for a group by city (`GET /v4/groups/{group_guid}/cities`)](https://dev.bitly.com/api-reference/#getGroupMetricsByCities)
- [ ] __[premium]__ [Get group overrides (`GET /v4/groups/{group_guid}/overrides`)](https://dev.bitly.com/api-reference/#getOverridesForGroups)

### Organizations

[Organizations documentation](docs/organizations.md)

- [x] [Retrieve organizations (`GET /v4/organizations`)](https://dev.bitly.com/api-reference/#getOrganizations)
- [x] [Retrieve organization (`GET /v4/organizations/{organization_guid}`)](https://dev.bitly.com/api-reference/#getOrganization)
- [x] [Retrieve organization shorten counts (`GET /v4/organizations/{organization_guid}/shorten_counts`)](https://dev.bitly.com/api-reference/#getOrganizationShortenCounts)

### Users

[Users documentation](docs/users.md)

- [x] [Retrieve user (`GET /v4/user`)](https://dev.bitly.com/api-reference/#getUser)
- [x] [Update user (`PATCH /v4/user`)](https://dev.bitly.com/api-reference/#updateUser)

### Bitlinks

[Bitlinks documentation](docs/bitlinks.md)

- [x] [Shorten a link (`POST /v4/shorten`)](https://dev.bitly.com/api-reference/#createBitlink)
- [x] [Expand a Bitlink (`POST /v4/expand`)](https://dev.bitly.com/api-reference/#expandBitlink)
- [x] [Retrieve a Bitlink (`GET /v4/bitlinks/{bitlink}`)](https://dev.bitly.com/api-reference/#getBitlink)
- [x] [Create a Bitlink (`POST /v4/bitlinks`)](https://dev.bitly.com/api-reference/#createFullBitlink)
- [x] [Update a Bitlink (`PATCH /v4/bitlinks/{bitlink}`)](https://dev.bitly.com/api-reference/#updateBitlink)
- [ ] [Delete an unedited hash Bitlink (`DELETE /v4/bitlinks/{bitlink}`)](https://dev.bitly.com/api-reference/#deleteBitlink)
- [x] [Get clicks for a Bitlink (`GET /v4/bitlinks/{bitlink}/clicks`)](https://dev.bitly.com/api-reference/#getClicksForBitlink)
- [x] [Get clicks summary for a Bitlink (`GET /v4/bitlinks/{bitlink}/clicks/summary`)](https://dev.bitly.com/api-reference/#getClicksSummaryForBitlink)
- [x] [Get metrics for a Bitlink by countries (`GET /v4/bitlinks/{bitlink}/countries`)](https://dev.bitly.com/api-reference/#getMetricsForBitlinkByCountries)
- [x] [Get metrics for a Bitlink by referrers (`GET /v4/bitlinks/{bitlink}/referrers`)](https://dev.bitly.com/api-reference/#getMetricsForBitlinkByReferrers)
- [x] [Get metrics for a Bitlink by referring domains (`GET /v4/bitlinks/{bitlink}/referring_domains`)](https://dev.bitly.com/api-reference/#getMetricsForBitlinkByReferringDomains)
- [x] [Get metrics for a Bitlink by referrers by domain (`GET /v4/bitlinks/{bitlink}/referrers_by_domains`)](https://dev.bitly.com/api-reference/#getMetricsForBitlinkByReferrersByDomains)
- [ ] __[premium]__ [Get metrics for a Bitlink by city (`GET /v4/bitlinks/{bitlink}/cities`)](https://dev.bitly.com/api-reference/#getMetricsForBitlinkByCities)
- [ ] __[premium]__ [Get metrics for a Bitlink by device type (`GET /v4/bitlinks/{bitlink}/devices`)](https://dev.bitly.com/api-reference/#getMetricsForBitlinkByDevices)
- [ ] __[premium]__ [Retrieve a QR code for a Bitlink (`GET /v4/bitlinks/{bitlink}/qr`)](https://dev.bitly.com/api-reference/#getBitlinkQRCode)
- [ ] __[premium]__ [Update a QR code (`PATCH /v4/bitlinks/{bitlink}/qr`)](https://dev.bitly.com/api-reference/#updateBitlinkQRCode)
- [ ] __[premium]__ [Create a QR code (`POST /v4/bitlinks/{bitlink}/qr`)](https://dev.bitly.com/api-reference/#createBitlinkQRCode)

### Custom Bitlinks

- [ ] [Add custom Bitlink (`POST /v4/custom_bitlinks`)](https://dev.bitly.com/api-reference/#addCustomBitlink)
- [ ] __[premium]__ [Retrieve custom Bitlink (`GET /v4/custom_bitlinks/{custom_bitlink}`)](https://dev.bitly.com/api-reference/#getCustomBitlink)
- [ ] __[premium]__ [Update custom Bitlink (`PATCH /v4/custom_bitlinks/{custom_bitlink}`)](https://dev.bitly.com/api-reference/#updateCustomBitlink)
- [ ] __[premium]__ [Get metrics for a custom Bitlink by destination (`GET /v4/custom_bitlinks/{custom_bitlink}/clicks_by_destination`)](https://dev.bitly.com/api-reference/#getCustomBitlinkMetricsByDestination)
- [ ] __[premium]__ [Get clicks for a custom Bitlin's entire history (`GET /v4/custom_bitlinks/{custom_bitlink}/clicks`)](https://dev.bitly.com/api-reference/#getClicksForCustomBitlink)

### Campaigns

- [ ] __[premium]__ [Retrieve campaigns (`GET /v4/campaigns`)](https://dev.bitly.com/api-reference/#getCampaigns)
- [ ] __[premium]__ [Create campaign (`POST /v4/campaigns`)](https://dev.bitly.com/api-reference/#createCampaign)
- [ ] __[premium]__ [Retrieve campaign (`GET /v4/campaigns/{campaign_guid}`)](https://dev.bitly.com/api-reference/#getCampaign)
- [ ] __[premium]__ [Update campaign (`PATCH /v4/campaigns/{campaign_guid}`)](https://dev.bitly.com/api-reference/#updateCampaign)
- [ ] __[premium]__ [Retrieve channels (`GET /v4/channels`)](https://dev.bitly.com/api-reference/#getChannels)
- [ ] __[premium]__ [Create channel (`POST /v4/channels`)](https://dev.bitly.com/api-reference/#createChannel)
- [ ] __[premium]__ [Retrieve channel (`GET /v4/channels/{channel_guid}`)](https://dev.bitly.com/api-reference/#getChannel)
- [ ] __[premium]__ [Update channel (`PATCH /v4/channels/{channel_guid}`)](https://dev.bitly.com/api-reference/#updateChannel)

### BSDs (Branded Short Domains)

[Branded Short Domains documentation](docs/branded_short_domains.md)

- [x] [Retrieve BSDs (`GET /v4/bsds`)](https://dev.bitly.com/api-reference/#getBSDs)

### OAuth Apps

[OAuth Apps documentation](docs/oauth_apps.md)

- [x] Retrieve OAuth App (`GET /v4/apps/{client_id}`)

### Webhooks

- [ ] __[premium]__ [Get webhooks (`GET /v4/organizations/{organization_guid}/webhooks`)](https://dev.bitly.com/api-reference/#getWebhooks)
- [ ] __[premium]__ [Create a webhook (`POST /v4/webhooks`)](https://dev.bitly.com/api-reference/#createWebhook)
- [ ] __[premium]__ [Retrieve a webhook (`GET /v4/webhooks/{webhook_guid}`)](https://dev.bitly.com/api-reference/#getWebhook)
- [ ] __[premium]__ [Update a webhook (`POST /v4/webhooks/{webhook_guid`)](https://dev.bitly.com/api-reference/#updateWebhook)
- [ ] __[premium]__ [Delete a webhook (`DELETE /v4/webhooks/{webhook_guid}`)](https://dev.bitly.com/api-reference/#deleteWebhook)
- [ ] __[premium]__ [Verify a webhook (`POST /v4/webhooks/{webhook_guid}/verify`)](https://dev.bitly.com/api-reference/#verifyWebhook)

## Customising HTTP requests

This gem comes with an HTTP client that can use different adapters. It ships with a `Net::HTTP` adapter that it uses by default.

If you want to control the connection, you can create your own instance of the `Net::HTTP` adapter and pass it options for an HTTP proxy or options that control the request. For example, to control the `read_timeout` you can do this:

```ruby
adapter = Bitly::HTTP::Adapters::NetHTTP.new(request_options: { read_timeout: 1 })
http_client = Bitly::HTTP::Client.new(adapter)
api_client = Bitly::API::Client.new(http: http_client, token: token)
```

Similarly, you can use an HTTP proxy with the adapter by passing the proxy variables to the adapter's constructor.

```ruby
adapter = Bitly::HTTP::Adapters::NetHTTP.new(proxy_addr: "example.com", proxy_port: 80, proxy_user: "username", proxy_pass: "password")
http_client = Bitly::HTTP::Client.new(adapter)
api_client = Bitly::API::Client.new(http: http_client, token: token)
```

### Build your own adapter

If you want even more control over the request, you can build your own adapter. An HTTP adapter within this gem must have a `request` instance method that receives a `Bitly::HTTP::Request` object and returns an array of four objects:

1. The response status code
2. The body of the response as a string
3. The response headers as a hash
4. A boolean denoting whether the response was a success or not

See `./src/bitly/http/adapters/net_http.rb` for an example.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/philnash/bitly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bitly project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/philnash/bitly/blob/master/CODE_OF_CONDUCT.md).
