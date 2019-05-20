# InterviewProject

## Assumptions

Year formatting returned in `begin` field by the server can be in different formats e.g.
* 1973-04-14
* 1959-09
* 1981

This is causing usage of `DateFormatters` not very helpful. For this reason I am simply parsing the year manually.

## Known issues / Improvements

Querying server for places multiple times is sometimes responding with HTTP 503. This error is only logged and not handled (no retry is performed). If any of multiple requests fails then query is ignored and no results appear on the map.

Native logging (`print` usage) should be replaced with custom logger.