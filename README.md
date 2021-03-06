# Toptranslation Api

A ruby wrapper for the Toptranslation API.

[![Build Status](https://travis-ci.org/Toptranslation/toptranslation_ruby.svg?branch=master)](https://travis-ci.org/Toptranslation/toptranslation_ruby)

## Usage
### Authentication
Authenticate with access token

```
client = Toptranslation.new(access_token: 'access_token')
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
Find a translation

```
translation = client.translations.find('translation_identifier') #=> A translation
```

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

### Projects
Get projects of user

```
client.projects  #=> Enumerable of projects
```

Add document to a project

```
project.upload_document('/a/file/path', 'de')
```

List documents of a project

```
project.documents #=> Enumerable of documents
```

Get strings of a project

```
project.strings #=> Enumerable of strings
```

Create new string

```
string = project.strings.create(locale_code: 'de', value: 'Ein Test', key: 'a_test')
string.save
```

### Documents
Get strings of a project

```
document.strings #=> Enumerable of strings
```

Create new string

```
string = document.strings.create(locale_code: 'de', value: 'Ein Test', key: 'a_test')
string.save
```
