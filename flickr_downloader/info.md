
# scraping approach

## general information
-> site does only preload a few images
    -> likely needs interactive browser for scraping (can't use pup)

## gallery order 
-> div class:"view photo-list-view"
    |-> div class:"view photo-list-photo-view awake"
        |-> attr :style
            |-> transform: translate(0px, 4px); width: 226px; height: 341px; background-image: url("URL HERE");

# looking at the network tab and hoping for an api that loads while there is the other pictures load in approach

## api
in the html there is an included api key downloaded which can possibly be used to extract images directly via rest api
root.YUI_config.flickr.api.site_key = "KEY";

PHOTOSETID = gathered from url
APIKEY = gathered from HTML that needs to be downloaded

api.flickr.com/services/rest?extras=url_k&per_page=500&page=1&jump_to=&photoset_id=${PHOTOSETID}&viewerNSID=&method=flickr.photosets.getPhotos&csrf=&api_key=${APIKEY}&format=json&nojsoncallback=1

we can use the reduced api request with the help of jq and curl to create a bash downloader script without requiring an interactive full browser 

# approach indipendent intel

## url 
live.staticflickr.com/id1/id2_viewmodiefier.jpg
id1 => is possibly variable so cannot be extracted once
id2 => varries for each image cannot be extracted once
viewmodiefier =>    - has to be changed to h to get "fullsize image"
                    - usually is z(gallery view) or n (fullscreen preview)
                    
