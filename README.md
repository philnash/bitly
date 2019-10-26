# Bitly

A Ruby gem for using the version 4 [Bitly API](https://dev.bitly.com/) to shorten links, expand short links and view metrics across users, links and organizations.

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

There are 2 methods you can use to get an OAuth access token:

#### OAuth Web Flow

Redirect the user to the Bitly authorization page using your `client_id` and a `redirect_uri` that Bitly should redirect your user to after authorization. You can get the URL like so:

```ruby
oauth = Bitly::OAuth.new(client_id: client_id, client_secret: client_secret)
oauth.authorize_uri("http://myexamplewebapp.com/oauth_page")
#=> "https://bitly.com/oauth/authorize?client_id=client_id&redirect_uri=http%3A%2F%2Fmyexamplewebapp.com%2Foauth_page"
```

You can pass an optional `state` parameter that will be included, unchanged, in the redirect.

```ruby
oauth.authorize_uri("http://myexamplewebapp.com/oauth_page", state: "state")
#=> "https://bitly.com/oauth/authorize?client_id=client_id&redirect_uri=http%3A%2F%2Fmyexamplewebapp.com%2Foauth_page&state=state"
```

Once the user has authorized you to use their Bitly account, you will get a
`code` parameter in the redirect. You can exchange that code, along with the
redirect_uri, for the access token.

```ruby
oauth.access_token(redirect_uri: "http://myexamplewebapp.com/oauth_page", code: "code")
#=> "<ACCESS_TOKEN>"
```

#### Resource Owner Credential Grant Flow

If you cannot perform a web flow, the resource owner credential grant flow allows you to take a user's username and password and exchange it for an OAuth access token. If you use this method you _should_ store only the user's access token and never the password.

To use the resource owner credential grant flow, create an OAuth client object then request the access token with the username and password:

```ruby
oauth = Bitly::OAuth.new(client_id: client_id, client_secret: client_secret)
oauth.access_token(username: username, password: password)
#=> "<ACCESS_TOKEN>"
```

### Available API Endpoints

This gem supports the active v4 API endpoints for the [Bitly API](https://dev.bitly.com/v4_documentation.html).

#### Organizations

- [ ][/v4/organizations](https://dev.bitly.com/v4/#operation/getOrganizations)
- [ ][/v4/organizations/{organization_guid}](https://dev.bitly.com/v4/#operation/getOrganization)
- [ ][/v4/organizations/{organization_guid}/shorten_counts](https://dev.bitly.com/v4/#operation/getOrganizationShortenCounts)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bitly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bitly project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bitly/blob/master/CODE_OF_CONDUCT.md).
