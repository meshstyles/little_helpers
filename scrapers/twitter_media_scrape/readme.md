# run.sh
This twitter scraper does not actually scrape twitter for images but rather an alternative frontend site that does actually loads a functional page in Plain HTML.
This allows us to just download that page and use pup to than parse the page and get the infos we need.
We than go throught the image and post data that is associated with it and download the images.
We mark down the failing images with post link to make possible manual search with archival sites to find delted content.

## usage
run it like this
```./run.sh "user_name_goes_her" "max page count on whotwi goes here"```

## Dependencies
- pup (run.sh only)
- curl and other linux stuff you already should have

## possibly will be fixed
automatically gauge the page count


# direct_tweet_scraper.sh
this use uses jq and other cli tools in order to just scrape with the twitter api.
a json for your tweet and the included media will be downloaded into the current directory.

## Dependencies
- jq (direct_tweet_scraper.sh)
- wget
- curl and other linux stuff you already should have

## usage
run it like this
```./direct_tweet_scraper.sh "link_to_some_tweet"```


## archiveTraverse.sh
looks for failed image urls if they are on archive org way back mashine, downloads the latest available if available
### usage
create url.list with urls (has to be unix format file)
run like ```./archiveTraverser.sh```
