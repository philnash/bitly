# QR codes

QR codes can be created and customized with different dot patterns, corner shapes, colors, and more. They can contain bitlinks, links to microsites, or several kinds of static data. 

See the full [Bitly API documentation for QR codes](https://dev.bitly.com/api-reference/#createQRCodePublic).

## List QR codes for a group

With an API client you can list the QR codes by group ID.

```ruby
client = Bitly::API::Client.new(token: token)
group = client.group(guid)
qr_codes = group.qrcodes
```

Or with the class method

```ruby
qr_codes = Bitly::API::Qrcodes.list_by_grouo(client: client, group_guid: group_guid)
```

## Fetch a QR code

If you have the id of a QR code, you can fetch it directly.

```ruby
qr_code = client.qrcode(qrcode_id)
```

Or with the class method

```ruby
group = Bitly::API::Qrcode.fetch(client: client, qrcode_id: qrcode_id)
```