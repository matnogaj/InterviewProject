# InterviewProject

## Assumptions

Year formatting returned in `begin` field by the server can be in different formats e.g.
* 1973-04-14
* 1959-09
* 1981

This is causing usage of `DateFormatters` not very helpful. For this reason I am simply parsing the year manually.

## Known issues / Improvements

1. Querying server for places multiple times is sometimes responding with HTTP 503. This error is only logged and not handled (no retry is performed). If any of multiple requests fails then query is ignored and no results appear on the map. This is an intentional design of the web service:
https://musicbrainz.org/doc/XML_Web_Service/Rate_Limiting

2. Native logging (`print` usage) should be replaced with custom logger.

3. `offset` and `limit` seem to be not working as expected. Splitting request into different amount of requests causes duplicates in returned results while overall total number of results is correct.
E.g. Requesting places with query "gre":
* limit 100, 4 requests, 318 total results, 0 duplicates
* limit 25, 13 requests, 318 total results, 11 duplicates
* limit 20, 16 requests, 318 total results, 18 duplicates
<br><br>Requesting max limit 100 seems to be working the best although with results 500+ there are still few duplicates.

4. Timer should be abstracted and injected into `SearchViewModel` so that it can be replaced in Unit Tests.