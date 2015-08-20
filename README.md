collate
=======

Collate is an open source translation collation tool.

## Rationale

If you are running an open source project, getting high quality, appropriate translations
is often an issue. But, there are already huge repositories of open source translations
available.

Rather than trying to solve the same problem over and over, it would be awesome if we
could decentralize translation and share the load throughout the open source universe.
We don't need to translate the same thing hundreds of times, allowing translators
to focus on translating the phrases that actually need to be translated.

## Goals

1. A repository of open source projects with appropriate licenses
2. Tools to download and extract open source translations
3. Tools to help rank and evaluate open source projects for quality and relevance
4. Repositories of default language packs that can be quickly imported into any project (Rails, PHP, Java, ...)
5. Generate your own language packs with configurable goals and license compatibility
6. Define your own translations that can be imported into your language pack

## Features

TODO

## Design

* `Phrase` - the lingua franca of the project is English, with parameters like `Hello, :name`.
* `Repository` - a loaded open source repository, e.g. http://svn.apache.org/repos/asf/subversion/trunk/subversion/ for Subversion
* `Source` - a single file that has been loaded, e.g. http://svn.apache.org/repos/asf/subversion/trunk/subversion/po/fr.po for a French PO file
* `Translation` - a translated phrase from a source
* `License` - e.g. `GPL-3.0`
* `Language` - e.g. `fr`, `en_GB` using ISO codes

We use Ruby on Rails so we get some nice things for free, e.g. ActiveRecord, migrations, a web interface to observe progress.

## Loading sources

Sources are defined in [sources/](sources/).

Start a rails server with `rails s` and visit http://localhost:3000.

TODO have an API to load and generate sources automatically.

```
php -f load.php openttd
```

## Contributing

TODO
