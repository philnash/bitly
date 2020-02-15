# Bitly

A Ruby gem for using the version 4 [Bitly API](https://dev.bitly.com/) to shorten links, expand short links and view metrics across users, links and organizations.

[![Gem Version](https://badge.fury.io/rb/bitly.svg)](https://rubygems.org/gems/bitly) [![Build Status](https://travis-ci.org/philnash/bitly.svg?branch=master)](https://travis-ci.org/philnash/bitly) [![Maintainability](https://api.codeclimate.com/v1/badges/f8e078b468c1f2aeca53/maintainability)](https://codeclimate.com/github/philnash/bitly/maintainability) [![Inline docs](https://inch-ci.org/github/philnash/bitly.svg?branch=master)](https://inch-ci.org/github/philnash/bitly)

- [Installation](#installation)
- [Usage](#usage)
  - [Authentication](#authentication)
  - [Creating an API client](#creating-an-api-client)
  - [Shorten a link](#shorten-a-link)
  - [Expand a link](#expand-a-link)
- [Available API Endpoints](#available-api-endpoints)
  - [Groups](#groups)
  - [Organizations](#organizations)
  - [Users](#users)
  - [Bitlinks](#bitlinks)
  - [Custom Bitlinks](#custom-bitlinks)
  - [Campaigns](#campaigns)
  - [BSDs (Branded Short Domains)](#bsds-branded-short-domains)
  - [OAuth Apps](#oauth-apps)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

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

This gem supports the following active v4 API endpoints for the[Bitly API](https://dev.bitly.com/v4_documentation.html).

### Groups

[Groups documentation](docs/groups.md)

- [x] [Retrieve groups (`GET /v4/groups`)](https://dev.bitly.com/v4/#operation/getGroups)
- [x] [Retrieve group (`GET /v4/groups/{group_guid}`)](https://dev.bitly.com/v4/#operation/getGroup)
- [x] [Update group (`PATCH /v4/groups/{group_guid}`)](https://dev.bitly.com/v4/#operation/updateGroup)
- [x] [Delete group (`DELETE /v4/groups/{group_guid}`)](https://dev.bitly.com/v4/#operation/deleteGroup)
- [x] [Retrieve tags by group (`GET /v4/groups/{group_guid}/tags`)](https://dev.bitly.com/v4/#operation/getGroupTags)
- [x] [Retrieve group preferences (`GET /v4/groups/{group_guid}/preferences`)](https://dev.bitly.com/v4/#operation/getGroupPreferences)
- [x] [Update group preferences (`PATCH /v4/groups/{group_guid}/preferences`)](https://dev.bitly.com/v4/#operation/updateGroupPreferences)
- [x] [Retrieve Bitlinks by group (`GET /v4/groups/{group_guid}/bitlinks`)](https://dev.bitly.com/v4/#operation/getBitlinksByGroup)
- [x] [Retrieve sorted Bitlinks by group (`GET /v4/groups/{group_guid}/bitlinks/{sort}`)](https://dev.bitly.com/v4/#operation/getSortedBitlinks)
- [x] [Retrieve group shorten counts (`GET /v4/groups/{group_guid}/shorten_counts`)](https://dev.bitly.com/v4/#operation/getGroupShortenCounts)
- [x] [Retrieve click metrics for a group by referring networks (`GET /v4/groups/{group_guid}/referring_networks`)](https://dev.bitly.com/v4/#operation/GetGroupMetricsByReferringNetworks)
- [x] [Retrieve click metrics for a group by countries (`GET /v4/groups/{group_guid}/countries`)](https://dev.bitly.com/v4/#operation/getGroupMetricsByCountries)

### Organizations

[Organizations documentation](docs/organizations.md)

- [x] [Retrieve organizations (`GET /v4/organizations`)](https://dev.bitly.com/v4/#operation/getOrganizations)
- [x] [Retrieve organization (`GET /v4/organizations/{organization_guid}`)](https://dev.bitly.com/v4/#operation/getOrganization)
- [x] [Retrieve organization shorten counts (`GET /v4/organizations/{organization_guid}/shorten_counts`)](https://dev.bitly.com/v4/#operation/getOrganizationShortenCounts)

### Users

[Users documentation](docs/users.md)

- [x] [Retrieve user (`GET /v4/user`)](https://dev.bitly.com/v4/#operation/getUser)
- [x] [Update user (`PATCH /v4/user`)](https://dev.bitly.com/v4/#operation/updateUser)

### Bitlinks

[Bitlinks documentation](docs/bitlinks.md)

- [x] [Shorten a link (`POST /v4/shorten`)](https://dev.bitly.com/v4/#operation/createBitlink)
- [x] [Expand a Bitlink (`POST /v4/expand`)](https://dev.bitly.com/v4/#operation/expandBitlink)
- [x] [Retrieve a Bitlink (`GET /v4/bitlink/{bitlink}`)](https://dev.bitly.com/v4/#operation/getBitlink)
- [x] [Create a Bitlink (`POST /v4/bitlinks`)](https://dev.bitly.com/v4/#operation/createFullBitlink)
- [x] [Update a Bitlink (`PATCH /v4/bitlink/{bitlink}`)](https://dev.bitly.com/v4/#operation/updateBitlink)
- [x] [Get clicks for a Bitlink (`GET /v4/bitlink/{bitlink}/clicks`)](https://dev.bitly.com/v4/#operation/getClicksForBitlink)
- [x] [Get clicks summary for a Bitlink (`GET /v4/bitlink/{bitlink}/clicks/summary`)](https://dev.bitly.com/v4/#operation/getClicksSummaryForBitlink)
- [x] [Get metrics for a Bitlink by countries (`GET /v4/bitlinks/{bitlink}/countries`)](https://dev.bitly.com/v4/#operation/getMetricsForBitlinkByCountries)
- [x] [Get metrics for a Bitlink by referrers (`GET /v4/bitlinks/{bitlink}/referrers`)](https://dev.bitly.com/v4/#operation/getMetricsForBitlinkByReferrers)
- [x] [Get metrics for a Bitlink by referring domains (`GET /v4/bitlinks/{bitlink}/referring_domains`)](https://dev.bitly.com/v4/#operation/getMetricsForBitlinkByReferringDomains)
- [x] [Get metrics for a Bitlink by referrers by domain (`GET /v4/bitlinks/{bitlink}/referrers_by_domains`)](https://dev.bitly.com/v4/#operation/getMetricsForBitlinkByReferrersByDomains)
- [ ] __[premium]__ [Get a QR code for a Bitlink (`GET /v4/{bitlink}/qr`)](https://dev.bitly.com/v4/#operation/getBitlinkQRCode)

### Custom Bitlinks

- [ ] [Add custom Bitlink (`POST /v4/custom_bitlinks`)](https://dev.bitly.com/v4/#operation/addCustomBitlink)
- [ ] __[premium]__ [Retrieve custom Bitlink (`GET /v4/custom_bitlinks/{custom_bitlink}`)](https://dev.bitly.com/v4/#operation/getCustomBitlink)
- [ ] __[premium]__ [Update custom Bitlink (`PATCH /v4/custom_bitlink/{custom_bitlink}`)](https://dev.bitly.com/v4/#operation/updateCustomBitlink)
- [ ] __[premium]__ [Get metrics for a custom Bitlink by destination (`GET /v4/custom_bitlinks/{custom_bitlink}/clicks_by_destination`)](https://dev.bitly.com/v4/#operation/getCustomBitlinkMetricsByDestination)

### Campaigns

- [ ] __[premium]__ [Retrieve campaigns (`GET /v4/campaigns`)](https://dev.bitly.com/v4/#operation/getCampaigns)
- [ ] __[premium]__ [Create campaign (`POST /v4/campaigns`)](https://dev.bitly.com/v4/#operation/createCampaign)
- [ ] __[premium]__ [Retrieve campaign (`GET /v4/campaigns/{campaign_guid}`)](https://dev.bitly.com/v4/#operation/getCampaign)
- [ ] __[premium]__ [Update campaign (`PATCH /v4/campaigns/{campaign_guid}`)](https://dev.bitly.com/v4/#operation/updateCampaign)
- [ ] __[premium]__ [Retrieve channels (`GET /v4/channels`)](https://dev.bitly.com/v4/#operation/getChannels)
- [ ] __[premium]__ [Create channel (`POST /v4/channels`)](https://dev.bitly.com/v4/#operation/createChannel)
- [ ] __[premium]__ [Retrieve channel (`GET /v4/channels/{channel_guid}`)](https://dev.bitly.com/v4/#operation/getChannel)
- [ ] __[premium]__ [Update channel (`PATCH /v4/channels/{channel_guid}`)](https://dev.bitly.com/v4/#operation/updateChannel)

### BSDs (Branded Short Domains)

[Branded Short Domains documentation](docs/branded_short_domains.md)

- [x] [Retrieve BSDs (`GET /v4/bsds`)](https://dev.bitly.com/v4/#operation/getBSDs)

### OAuth Apps

[OAuth Apps documentation](docs/oauth_apps.md)

- [x] [Retrieve OAuth App (`GET /v4/apps/{client_id}`)](https://dev.bitly.com/v4/#operation/getOAuthApp)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/philnash/bitly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bitly project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/philnash/bitly/blob/master/CODE_OF_CONDUCT.md).
