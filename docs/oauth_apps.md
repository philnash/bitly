# OAuth Apps

You can fetch the details of an OAuth app you have in your account by the `client_id`.

See the full [Bitly documentation for OAuth apps](https://dev.bitly.com/v4/#operation/getOAuthApp)

## Fetch an OAuth app

With the `client_id` of an OAuth app, you can fetch it directly.

```ruby
client = Bitly::API::Client.new(token: token)
oauth_app = client.oauth_app(client_id: client_id)
```

Or with the class method

```ruby
oauth_app = Bitly::API::OAuthApp.fetch(client: client, client_id: client_id)
```