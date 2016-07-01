# Poms Release notes

## 2.2.0

* Add `last_modified` function to `Poms::Fields`.

## 2.1.1

* Add `addressable` to gemspec.

## 2.1.0

* Allow `schedule_events` to accept a block which allows you to filter the events.
* The `scheduled_now` and `scheduled_next` functions always return the most recent and upcoming shows. They shouldn't return nil anymore, even if something is not live at the moment (during a commercial break for instance).

## 2.0.1

* Fix search parameter `type`. This didn't get picked up properly before, but is now used in the search.

## 2.0.0

Complete rewrite of the Poms gem, which now interfaces with the Frontend API instead of CouchDB. Check the new documentation in the Readme and examples for ways in which the new API works. A short overview:

* The `Poms` module has a much smaller set of ways to get data from Poms, but these should be enough to get what you need now.
* These functions generally return a Hash or a LazyEnumerator for multiple results.
* Credentials for the Poms service are set in a config function.
* More fields can be accessed from the `Fields` module.

## 1.2.2

* Fix issue with description type that did not exist.
* Add some more specs to the field classes to catch values that are empty.

## 1.2.1

* [#25](https://github.com/brightin/poms/pull/25) Fix issue with `Timestamp.convert`

## 1.2.0

* [#24](https://github.com/brightin/poms/pull/24) Add functions to access the internals of a Poms broadcast hash.

## 1.1.1

* [#22](https://github.com/brightin/poms/pull/22) Refactor descendant-related code into views.

## 1.1.0

* Updated README with usage instruction.
* [#21](https://github.com/brightin/poms/pull/21) Allow access to the Poms API. This functionality is only used for merging series at this point.

## 1.0.1

* [#20](https://github.com/brightin/poms/pull/20) Return schedule event `starts_at` as DateTime.

## 1.0.0

Since we've been running live for a while, it made sense to do a big version bump.

* Add Rubocop for linting.
* [#18](https://github.com/brightin/poms/pull/18) Support for the series merging functionality.
