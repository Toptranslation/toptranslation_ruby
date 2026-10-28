<a name="4.1.0"></a>
### 4.1.0 (2026-10-28)

#### Features

* uploads now use the `attach_token` returned by the document store. It stays
  valid for attaching a document to an order or project much longer than the
  former 1-hour `token`. Falls back to `token` / `document_token` against
  older document stores, so the change is backward compatible.

**Update recommended:** integrations that wait a long time between uploading
a file and attaching it (`Order#add_document`, `Project#upload_document`)
benefit from the longer window. The old short-lived `token` is being phased
out, so please update to 4.1.0 or later.

#### Bug Fixes

* `Document#download`, `Translation#download` and `ReferenceDocument#download`
  close the downloaded file before returning it, so its content is completely
  written to disk. Before, the returned `File` stayed open for writing.

<a name="4.0.1"></a>
### 4.0.1 (2026-08-18)

#### Breaking Changes

* `sign_in!` (email/password) now raises `Toptranslation::SignInRemovedError`
  with guidance — the API removed `POST /v2/auth/sign_in` (authentication
  moved to the Toptranslation auth service). Initialize the client with a
  static access token: `Toptranslation.new(access_token: '...')`.

<a name="4.0.0"></a>
### 4.0.0 (2026-08-18)

#### Breaking Changes

The client now talks exclusively to Toptranslation API **v2** — API v0 is
being removed from the backend.

* file uploads go directly to the document store (`{files_url}/v2/documents`,
  idempotent) — the `/upload_tokens` roundtrip is gone
* `project.documents.find(identifier)` is now scoped to the project
  (`GET /v2/projects/:id/documents/:identifier`)
* `order.translations` uses `GET /v2/translations?order_identifier=…`
* removed without replacement (no v2 endpoint, dead against the current
  backend for years): `Document#add_translation`, `Document#save`,
  `DocumentList#find` (unscoped), all string resources
  (`Project#strings`, `Document#strings`, `StringList`, `String`)
* requires the backend deployment of 2026-08-18 or later
  (`/v2/projects/:id/documents/batch`, `/v2/translations`)

<a name="3.0.0"></a>
### 3.0.0 (2022-12-21)

#### Features

* allow for parameters to project documents list	 ([ba7783c](/../commit/ba7783c))

#### Maintain

* update ruby to 3.1.3 and gems	 ([098d7bd](/../commit/098d7bd))
* use ruby 2.6.3	 ([c6c9f97](/../commit/c6c9f97))

<a name="2.5.0"></a>
### 2.5.0 (2019-08-15)

#### Features

* pass sha1 of documents and translations to user api	 ([52e2759](/../commit/52e2759))

<a name="v2.4.0"></a>
### v2.4.0 (2018-06-21)


#### Features

* add sign_in! and access_token writer to Client	 ([f8d5ca1](/../../commit/f8d5ca1))


<a name="v2.3.0"></a>
### v2.3.0 (2018-06-18)


#### Features

* report progress for upload and download	 ([8a31a01](/../../commit/8a31a01))


<a name="v2.2.0"></a>
### v2.2.0 (2018-06-08)


#### Features

* add Document#download_url	 ([8ac86c6](/../../commit/8ac86c6))


<a name="v2.1.0"></a>
### v2.1.0 (2018-06-06)


#### Features

* make document sha1 accesible via reader	 ([5302ea3](/../../commit/5302ea3))


#### Bug Fixes

* don't pass the document file name to download	 ([6312205](/../../commit/6312205))


<a name="v2.0.0"></a>
### v2.0.0 (2018-05-30)


#### Features

* add bin/console script for experimenting with the gem	 ([809e30a](/../../commit/809e30a))
* convert quotes resource to API v2	 ([dc28333](/../../commit/dc28333))
* convert order resource to API v2	 ([05dbbc1](/../../commit/05dbbc1))
* convert order list resource to API v2	 ([e277ef5](/../../commit/e277ef5))
* convert reference document resource to API v2	 ([ab1129c](/../../commit/ab1129c))
* use locales api v2 for LocaleList	 ([75cdbbd](/../../commit/75cdbbd))
* add v2 API support to Connection class for get, post and patch	 ([7368009](/../../commit/7368009))


#### Bug Fixes

* reraise RestClient exception	 ([c1df09d](/../../commit/c1df09d))
* fix all resources that have not been migrated to v2 yet	 ([0d1b130](/../../commit/0d1b130))


