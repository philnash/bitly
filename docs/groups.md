# Groups

Groups are a subdivision within an [organization](./organizations.md). A [user](./users.md) belongs to a group within an organization. Most actions in the API are on behalf of a group. For example, when you shorten a link, it will be on behalf of a user and a group.

See the full [Bitly API documentation for Groups](https://dev.bitly.com/v4/#tag/Groups).

## List Groups

With an API client you can list the groups available to the authorized user.

```ruby
client = Bitly::API::Client.new(token: token)
groups = client.groups
```

Or with the class method

```ruby
groups = Bitly::API::Group.list(client: client)
```

You can also filter groups by an organization guid or an organization object, using the client.

```ruby
groups = client.groups(organization: organization_guid)
groups = client.groups(organization: organization)
```

Or the class method

```ruby
groups = Bitly::API::Group.list(client: client, organization: organization_guid)
groups = Bitly::API::Group.list(client: client, organization: organization)
```

## Fetch a Group

If you have the guid of an group, you can fetch it directly.

```ruby
group = client.group(guid)
```

Or with the class method

```ruby
group = Bitly::API::Group.fetch(client: client, guid: guid)
```

## Group attributes

Groups have the following attributes:

* `name`
* `guid`
* `is_active`
* `role`
* `bsds`
* `organization_guid`
* `created`
* `modified`

### A Group's organization

With the `organization_guid` we can get the group's organization directly from the group object.

```ruby
organization = group.organization
```

### Group preferences

You can set one preference for a group, the domain that is used to shorten links. Free accounts can only choose `bit.ly` and pro accounts can use any domains they have set up.

```ruby
preferences = group.preferences
puts preferences.domain_preference

preferences.update(domain_preference: 'bit.ly')
```
