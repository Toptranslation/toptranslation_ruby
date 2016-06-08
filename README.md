# Toptranslation Ruby

A ruby wrapper for the Toptranslation API.

## Usage
### Authentication
Authenticate with access token

```
client = Toptranslation.new('access_token')
```

or authenticate by email and password

```
client = Toptranslation.new(email: 'me@example.com', password: 'foobar')
```

### Orders
All orders of authenticated users

```
client.orders #=> Enumerable of orders
```

Find an order

```
order = client.orders.find('order_identifier') #=> An order
```

Add document to an order

```
order.upload_document('/a/file/path', 'de', 'en')
```

Request an order

```
order.request
```

Translations of an order

```
order.translations #=> Enumerable of translations
```

Creator of an order

```
order.creator #=> User
```

### Translations
Download of a translation

```
translation.download #=> Tempfile
```

Reference documents of a translation

```
translation.reference_documents #=> Enumerable of ReferenceDocuments
```

### ReferenceDocuments
Download a reference document

```
reference_document.download
```

