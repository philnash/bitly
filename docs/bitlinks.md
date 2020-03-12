# Bitlinks

Bitlinks are the core object in the Bitly API. They represent a long URL that has been shortened using Bitly, and they are the base for the metrics and clicks that can be read for each Bitlink.

See the full [Bitly API documentation for Bitlinks](https://dev.bitly.com/v4/#tag/Bitlinks).

## Creating Bitlinks

With an authenticated API client you can create Bitlinks in two ways: `shorten` or `create`.

### `shorten`

`shorten` is the simplest way of creating a Bitlink. You can set the `long_url` and optionally a `group_guid`, to create the Bitlink under a different group, or the `domain`, to change the shortened domain.

```ruby
client = Bitly::API::Client.new(token: token)
bitlink = client.shorten(long_url: 'https://example.com')
bitlink.link
# => https://bit.ly/2Qj2niP
```

You can also use the class method:

```ruby
bitlink = Bitly::API::Bitlink.shorten(client: client, long_url: 'https://example.com')
bitlink.link
# => https://bit.ly/2Qj2niP
```

### `create`

Using `create` you can set some other parameters for your Bitlink, including a `title`, some `tags` and `deeplinks`.

```ruby
bitlink = client.create_bitlink(long_url: 'https://example.com', title: 'An example page')
bitlink.link
# => https://bit.ly/2Qj2niP
bitlink.title
# => 'An example page'
```

You can also use the class method:

```ruby
bitlink = Bitly::API::Bitlink.create(client: client, long_url: 'https://example.com', title: 'An example page')
bitlink.link
# => https://bit.ly/2Qj2niP
bitlink.title
# => 'An example page'
```

## Expanding Bitlinks

You can expand or fetch Bitlinks. You can expand any Bitlink from a short URL back to the original long URL, it doesn't have to be your own. This will give you public data about the Bitlink. You can only fetch private data and stats about your own Bitlinks though.

### Expand

```ruby
client = Bitly::API::Client.new(token: token)
expanded = client.expand(bitlink: 'bit.ly/1c92v5e')
expanded.long_url
# => "http://www.techforluddites.com/"
```

Expanding a link doesn't have all the details of fetching your own link.

```ruby
expanded.title
# => nil
expanded.created_by
# => nil
```

You can also do this with the class method:

```ruby
expanded = Bitly::API::Bitlink.expand(client: client, bitlink: 'bit.ly/1c92v5e')
expanded.long_url
# => "http://www.techforluddites.com/"
```

### Fetch

Fetching your own links fetches all the data about the Bitlink that you can access.

```ruby
client = Bitly::API::Client.new(token: token)
bitlink = client.bitlink(bitlink: 'bit.ly/2OUJim0')
bitlink.long_url
# => "http://example.com/"
bitlink.title
# => "Example Domain"
bitlink.created_by
# => "philnash"
```

You can access this via the class method too.

```ruby
bitlink = Bitly::API::Bitlink.fetch(client: client, bitlink: 'bit.ly/2OUJim0')
bitlink.long_url
# => "http://example.com/"
```

## Updating Bitlinks

You can update a number of Bitlink attributes. Some attributes can only be updated by pro accounts.

You can either use the API client and pass the Bitlink:

```ruby
bitlink = client.update_bitlink(bitlink: 'bit.ly/2OUJim0', title: 'New title')
bitlink.title
# => "New title"
```

or if you have fetched a Bitlink you can use the object:

```ruby
bitlink = client.bitlink(bitlink: 'bit.ly/2OUJim0')
bitlink.update(title: "New title")
bitlink.title
# => "New title"
```

## Listing Bitlinks

### Sorted list

You can get a list of your Bitlinks sorted by clicks. See the Bitly docs for [information on the parameters](https://dev.bitly.com/v4/#operation/getSortedBitlinks).

```ruby
bitlinks = client.sorted_bitlinks(group_guid: guid)
bitlinks.each { |b| puts "#{b.clicks}: #{b.long_url}" }
```

### List by Group

You can also list the Bitlinks by group. This will return a `Bitly::API::Bitlink::PaginatedList` which can be used to navigate the pages of the results.

```ruby
bitlink_page = client.group_bitlinks(group_guid: guid)
bitlink_page.total
# => 503
bitlink_page.size
# => 50
bitlink_page.has_next_page?
# => true
bitlink_page.next_page
# => another page
bitlink_page.has_prev_page?
# => false
```

## Clicks

With your Bitlink you can also get the clicks for the link or a summary. See the [Bitlink documentation](https://dev.bitly.com/v4/#operation/getClicksSummaryForBitlink) for more details.

```ruby
bitlink.clicks_summary
bitlink.link_clicks
```