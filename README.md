# bitly

## DESCRIPTION:

A Ruby API for [http://bitly.com](http://bitly.com)

[http://dev.bitly.com](http://dev.bitly.com)

[![Build Status](https://travis-ci.org/philnash/bitly.svg?branch=master)](https://travis-ci.org/philnash/bitly)

## NOTE:

Bitly recently released their version 3 API. From this 0.5.0 release, the gem will continue to work the same but also provide a V3 module, using the version 3 API. The standard module will become deprecated, as Bitly do not plan to keep the version 2 API around forever.

To move to using the version 3 API, call:

```ruby
Bitly.use_api_version_3
```

Then, when you call ``Bitly.new(username, api_key)`` you will get a ``Bitly::V3::Client`` instead, which provides the version 3 api calls (``shorten``, ``expand``, ``clicks``, ``validate`` and ``bitly_pro_domain``). See [http://dev.bitly.com](http://dev.bitly.com) for details.

Eventually, this will become the default version used and finally, the V3 module will disappear, with the version 3 classes replacing the version 2 classes.

(Please excuse the lack of tests for the v3 classes, they are fully tested and ready to replace this whole codebase in the v3 branch of the GitHub repo, until I realized it would break everything.)

## INSTALLATION:

    gem install bitly

## USAGE:

### Version 2 API

Create a Bitly client using your username and api key as follows:

```ruby
bitly = Bitly.new(username, api_key)
```

You can then use that client to shorten or expand urls or return more information or statistics as so:

```ruby
bitly.shorten('http://www.google.com')
bitly.shorten('http://www.google.com', :history => 1) # adds the url to the api user's history
bitly.expand('wQaT')
bitly.info('http://bit.ly/wQaT')
bitly.stats('http://bit.ly/wQaT')
```

Each can be used in all the methods described in the API docs, the shorten function, for example, takes a url or an array of urls.

All four functions return a ``Bitly::Url`` object (or an array of ``Bitly::Url`` objects if you supplied an array as the input). You can then get all the information required from that object.

```ruby
u = bitly.shorten('http://www.google.com') #=> Bitly::Url

u.long_url #=> "http://www.google.com"
u.short_url #=> "http://bit.ly/Ywd1"
u.bitly_url #=> "http://bit.ly/Ywd1"
u.jmp_url #=> "http://j.mp/Ywd1"
u.user_hash #=> "Ywd1"
u.hash #=> "2V6CFi"
u.info #=> a ruby hash of the JSON returned from the API
u.stats #=> a ruby hash of the JSON returned from the API

bitly.shorten('http://www.google.com', 'keyword')
```

### Version 3 API

Please see the Bit.ly API documentation [http://api.bit.ly](http://api.bit.ly) for details on the V3 API.

Get your access token here: [https://bitly.com/a/oauth_apps](https://bitly.com/a/oauth_apps).

### Configure bitly through initializer

If you want to configure bitly through an initializer (e.g. `config/initializers/bitly.rb`), do the following:

```ruby
Bitly.use_api_version_3

Bitly.configure do |config|
  config.api_version = 3
  config.access_token = "API_KEY"
end
```

Instead of using `Bitly.new(username, api_key)` to get the client, use `Bitly.client`:

```ruby
Bitly.client.shorten('http://www.google.com')
```
