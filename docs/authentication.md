# Authentication

Bitly requires OAuth access tokens to use the API. You will need to [register your application with the Bitly API](bitly.com/a/oauth_apps), you will get a `client_id` and `client_secret`.

There are 3 methods you can use to get an OAuth access token:

- [Account Generic Access Token](#account-generic-access-token)
- [OAuth Web Flow](#oauth-web-flow)
- [Resource Owner Credential Grant Flow](#resource-owner-credential-grant-flow)

## Account Generic Access Token

You can get your own OAuth token for your account from the [Bitly console](https://app.bitly.com/). Click on the account drop down menu, then _Profile Settings_ then _Generic Access Token_. Fill in your password and you can generate an OAuth access token.

## OAuth Web Flow

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

## Resource Owner Credential Grant Flow

If you cannot perform a web flow, the resource owner credential grant flow allows you to take a user's username and password and exchange it for an OAuth access token. If you use this method you _should_ store only the user's access token and never the password.

To use the resource owner credential grant flow, create an OAuth client object then request the access token with the username and password:

```ruby
oauth = Bitly::OAuth.new(client_id: client_id, client_secret: client_secret)
oauth.access_token(username: username, password: password)
#=> "<ACCESS_TOKEN>"
```