# Intro
This twitter scraper does not actually scrape twitter for images but rather an alternative frontend site that does actually loads a functional page in Plain HTML.
This allows us to just download that page and use pup to than parse the page and get the infos we need.
We than go throught the image and post data that is associated with it and download the images.
We mark down the failing images with post link to make possible manual search with archival sites to find delted content.

# Dependencies
- pup
- curl and other linux stuff you already should have

# usage
run it like this
```./run.sh "user_name_goes_her" "max page count on whotwi goes here"```

# possibly will be fixed
automatically gauge the page count
