# Users

You can fetch and change data about the authenticated user using the API.

## Fetch a user

With an API client you can fetch the authenticated user.

```ruby
client = Bitly::API::Client.new(token: token)
user = client.user
```

Or you can use the class method:

```ruby
user = Bitly::API::User.fetch(client: client)
```

### User methods

User emails are objects themselves. A user can have more than one email address and they may be verified or the primary email.

```ruby
email = user.emails.first
email.email
# => bitly@example.com
email.is_verified
# => true
email.is_primary
# => true
```

With a user you can fetch their default group:

```ruby
user.default_group
# => <Bitly::API::Group>
```

You can update the user's name or default group guid:

```ruby
user.update(name: "New name", default_group_guid: "ab1234")
```