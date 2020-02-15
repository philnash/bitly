# Branded Short Domains

BSDs is an acronym for branded short domains. A branded short domain is a custom 15 character or less domain for bitlinks. This allows you to customize the domain to your brand.

See the full [Bitly API documentation for BSDs](https://dev.bitly.com/v4/#tag/BSDs).

## List BSDs

With an API client you can list the BSDs available to the authorized user.

```ruby
client = Bitly::API::Client.new(token: token)
bsds = client.bsds
```

Or with the class method

```ruby
bsds = Bitly::API::BSD.list(client: client)
```