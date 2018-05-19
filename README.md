# Bitly

A Ruby gem for using the [Bitly API](https://dev.bitly.com/) to shorten links, expand short links and view metrics across users, links and organizations.

[![Gem Version](https://badge.fury.io/rb/bitly.svg)](https://rubygems.org/gems/bitly) [![Build Status](https://travis-ci.org/philnash/bitly.svg?branch=master)](https://travis-ci.org/philnash/bitly) [![Maintainability](https://api.codeclimate.com/v1/badges/f8e078b468c1f2aeca53/maintainability)](https://codeclimate.com/github/philnash/bitly/maintainability) [![Inline docs](https://inch-ci.org/github/philnash/bitly.svg?branch=master)](https://inch-ci.org/github/philnash/bitly)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitly'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitly

## Usage

### Authentication

Bitly requires OAuth access tokens to use the API. You will need to [register your application with the Bitly API](bitly.com/a/oauth_apps), you will get a `client_id` and `client_secret`.

There are 3 methods you can use to get an OAuth access token:

#### OAuth Web Flow

Redirect the user to the Bitly authorization page using your `client_id` and a `redirect_uri` that Bitly should redirect your user to after authorization. You can get the URL like so:

```ruby
oauth = Bitly::OAuth.new(client_id, client_secret)
oauth.authorize_uri(redirect_uri)
#=> https://bitly.com/oauth/authorize?client_id=client_id&redirect_uri=http://myexamplewebapp.com/oauth_page
```

You can pass an optional `state` parameter that will be included, unchanged, in the redirect.

```ruby
oauth.authorize_uri(redirect_uri, state: "state")
```


### Available API Endpoints

This gem supports the active v3 API endpoints for the [Bitly API](https://dev.bitly.com/api.html).

#### Links

[ ] [/v3/shorten](https://dev.bitly.com/links.html#v3_shorten)
[ ] [/v3/expand](https://dev.bitly.com/links.html#v3_expand)
[ ] [/v3/info](https://dev.bitly.com/links.html#v3_info)
[ ] [/v3/link/lookup](https://dev.bitly.com/links.html#v3_link_lookup)
[ ] [/v3/link/info](https://dev.bitly.com/data_apis.html#v3_link_info)
[ ] [/v3/user/link_edit](https://dev.bitly.com/links.html#v3_user_link_edit)
[ ] [/v3/user/link_lookup](https://dev.bitly.com/links.html#v3_user_link_lookup)
[ ] [/v3/user/link_save](https://dev.bitly.com/links.html#v3_user_link_save)
[ ] [/v3/user/save_custom_domain_keyword](https://dev.bitly.com/links.html#v3_user_save_custom_domain_keyword)

#### Link Metrics

[ ] [/v3/link/clicks](https://dev.bitly.com/link_metrics.html#v3_link_clicks)
[ ] [/v3/link/countries](https://dev.bitly.com/link_metrics.html#v3_link_countries)
[ ] [/v3/link/encoders](https://dev.bitly.com/link_metrics.html#v3_link_encoders)
[ ] [/v3/link/encoders_by_count](https://dev.bitly.com/link_metrics.html#v3_link_encoders_by_count)
[ ] [/v3/link/encoders_count](https://dev.bitly.com/link_metrics.html#v3_link_encoders_count)
[ ] [/v3/link/keyword_clicks_by_destination](https://dev.bitly.com/link_metrics.html#v3_link_keyword_clicks_by_destination)
[ ] [/v3/link/referrers](https://dev.bitly.com/link_metrics.html#v3_link_referrers)
[ ] [/v3/link/referrers_by_domain](https://dev.bitly.com/link_metrics.html#v3_link_referrers_by_domain)
[ ] [/v3/link/referring_domains](https://dev.bitly.com/link_metrics.html#v3_link_referring_domains)

#### User info / History

[ ] [/v3/oauth/app](https://dev.bitly.com/user_info.html#v3_oauth_app)
[ ] [/v3/user/info](https://dev.bitly.com/user_info.html#v3_user_info)
[ ] [/v3/user/link_history](https://dev.bitly.com/user_info.html#v3_user_link_history)

#### User Metrics

[ ] [/v3/user/clicks](https://dev.bitly.com/user_metrics.html#v3_user_clicks)
[ ] [/v3/user/countries](https://dev.bitly.com/user_metrics.html#v3_user_countries)
[ ] [/v3/user/popular_links](https://dev.bitly.com/user_metrics.html#v3_user_popular_links)
[ ] [/v3/user/popular_owned_by_clicks](https://dev.bitly.com/user_metrics.html#v3_user_popular_owned_by_clicks)
[ ] [/v3/user/referrers](https://dev.bitly.com/user_metrics.html#v3_user_referrers)
[ ] [/v3/user/referring_domains](https://dev.bitly.com/user_metrics.html#v3_user_referring_domains)
[ ] [/v3/user/shorten_counts](https://dev.bitly.com/user_metrics.html#v3_user_shorten_counts)

#### Deeplink Metrics

[ ] [/v3/deeplink/event_clicks](https://dev.bitly.com/deeplink_metrics.html)

#### Orgnization Metrics

[ ] [/v3/organization/clicks](https://dev.bitly.com/organization_metrics.html#v3_organization_clicks)
[ ] [/v3/organization/missed_opportunities](https://dev.bitly.com/organization_metrics.html#v3_organization_missed_opportunities)
[ ] [/v3/organization/popular_links](https://dev.bitly.com/organization_metrics.html#v3_organization_popular_links)
[ ] [/v3/organization/shorten_counts](https://dev.bitly.com/organization_metrics.html#v3_organization_shorten_counts)

#### Domains

[ ] [/v3/bitly_pro_domain](https://dev.bitly.com/domains.html#v3_bitly_pro_domain)

#### Campaigns

[ ] [/v3/campaigns](https://dev.bitly.com/campaigns.html#v3_campaigns)
[ ] [/v3/campaigns/add_links](https://dev.bitly.com/campaigns.html#v3_campaigns_add_links)
[ ] [/v3/campaigns/channel/link_add](https://dev.bitly.com/campaigns.html#v3_campaigns_channel_link_add)
[ ] [/v3/campaigns/channel/link_remove](https://dev.bitly.com/campaigns.html#v3_campaigns_channel_link_remove)
[ ] [/v3/campaigns/channel_names](https://dev.bitly.com/campaigns.html#v3_campaigns_channel_names)
[ ] [/v3/campaigns/create](https://dev.bitly.com/campaigns.html#v3_campaigns_create)
[ ] [/v3/campaigns/get](https://dev.bitly.com/campaigns.html#v3_campaigns_get)
[ ] [/v3/campaigns/update](https://dev.bitly.com/campaigns.html#v3_campaigns_update)



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bitly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bitly project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bitly/blob/master/CODE_OF_CONDUCT.md).
