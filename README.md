[ ![Codeship Status for brightin/poms](https://codeship.com/projects/c2baf9b0-ea8d-0132-2258-628e55ad70cc/status?branch=master)](https://codeship.com/projects/83157)

# Poms

The Poms gem provides an interface to the Dutch public broadcaster API: POMS. It
is a couchdb service that is publicly available.

## Installation

Add this line to your application's Gemfile:

    gem 'poms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poms

## Usage

The `Poms` module contains various ways to query the Poms CouchDB service. The simplest way to get something is to use the `fetch` function, which takes a MID.

    Poms.fetch('mid')

This returns an OpenStruct-like object that wraps the json of the Poms response.

For some more advanced querying, you can use functions like `fetch_clip` which also takes a MID, but returns a `Clip` object, that is a little easier to work with.

You can also query collections in a way to get back multiple episodes. This is tied to the views in the Poms CouchDB service and is documented on the wiki of the NPO.


## Searching

For reference of possible search options, see the [POMS API wiki](http://wiki.publiekeomroep.nl/display/npoapi/Media-+en+gids-API).

For Ruby we try to adhere to conventional naming and we map this to the relevant Poms API fields.

Gem | API
---|---
`starts_at` | `"sortDates": { "begin" } `
`ends_at` | `"sortDates": { "end" } `
`type` | `{ "facets": { "subsearch": { "types" } } }`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
