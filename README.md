[![CircleCI](https://circleci.com/gh/brightin/poms.svg?style=svg)](https://circleci.com/gh/brightin/poms)

# Poms

The Poms gem provides an interface to the Dutch public broadcaster API: POMS. It
reads from the Frontend API.

## Installation

Add this line to your application's Gemfile:

    gem 'poms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poms

## Configuration

The Poms API is only accessible to authenticated accounts. In order to make authenticated requests to the service, the module needs to be configured before making requests. This can be done in a Rails initializer for instance.

In order to configure the module:

    Poms.configure do |config|
      config.key    = '**poms key**'
      config.origin = '**poms origin**'
      config.secret = '**poms secret**'
    end

`configure` can also read environment variables. `ENV['POMS_KEY']`,  `ENV['POMS_ORIGIN']`, `ENV['POMS_SECRET']` are used in this case.

The `configure` function can also be provided with the `base_url` in case you want to access the test environment for instance.

## Usage

The `Poms` module contains various ways to interact with the Poms service based on the API it exposes. The simplest way to get something is to use the `first` of `first!` function, which takes a MID (Media ID) used internally to identify all objects.

    Poms.first('mid')

This returns a Hash of the json of the response provided by the Poms service. In this case this is a single object from Poms.

In order to do more advanced querying you might want to get the members or descendants of an object. `members` simply returns all objects that are members of the object with the requested mid.

    Poms.members('mid')

The result is a lazy enumerator (as the results are paginated on Poms) that contains all the members.

The `descendants` function allows query parameters to be entered that are taken in account by the Poms service.

    Poms.descendants('mid', {})

The result is similar to the members function, but each item contains metadata from the search query and the actual result is in the `result` key of the item hash.

The `poms` module contains a number of other functions that may be useful when you want to get some specific info from Poms. Also take a look at the examples in the `examples` directory of this project.

## Fields

The hashes that are returned from Poms can be nested to a high degree, making it harder to get some specific fields from them. The `Poms::Fields` module provides helper functions to access things like title, descriptions and images.

    Poms::Fields.title(poms_item)

This will return the title with the `MAIN` type.

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

## Releasing

Make sure to use [Semantic Versioning](https://semver.org/) when bumping the version. To release tag the master branch with the version and then push to rubygems. `rake release` does this for you.
