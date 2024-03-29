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


