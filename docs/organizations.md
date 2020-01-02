# Organizations

An organization is the top level of the Bitly user hierarchy. Both [Users](./users.md) and [Groups](./groups.md) live within an organization.

See the full [Bitly API documentation for Organizations](https://dev.bitly.com/v4/#tag/Organizations).

## List organizations

With an API client you can list the organizations available to the authorized user.

```ruby
client = Bitly::API::Client.new(token: token)
organizations = client.organizations

# or with the class method

organizations = Bitly::API::Organization.list(client: client)
```

## Fetch an Organization

If you have the guid of an organization, you can fetch it directly.

```ruby
client = Bitly::API::Client.new(token: token)
organization = client.organization(guid)

# or with the class method

organization = Bitly::API::Organization.fetch(client: client, guid: guid)
```

## Organization attributes

Organizations have the following attributes:

* name
* guid
* is_active
* tier
* tier_family
* tier_display_name
* role
* bsds
* created
* modified

## Organization groups

With an organization you can fetch its related [groups](./groups.md).

```ruby
client = Bitly::API::Client.new(token: token)
organization = client.organization(guid)
groups = organization.groups
```

This is the same as fetching groups and filtering by an organization guid.

```ruby
client = Bitly::API::Client.new(token: token)
groups = Bitly::API::Group.list(client: client, organization: organization_guid)
```