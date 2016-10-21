# bitly

## DESCRIPTION:

A Ruby API for [http://bitly.com](http://bitly.com)

[http://dev.bitly.com](http://dev.bitly.com)

## INSTALLATION:

    gem install bitly

## USAGE:

Please see the Bit.ly API documentation [http://api.bit.ly](http://api.bit.ly) for details on the API.

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
