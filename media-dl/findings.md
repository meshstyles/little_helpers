# netzkino

## redesign

-   now uses gql ( so an update is in order)
-   old api still works so old code can be retained for the time being
-   needs watch and filme filter now

## a look at the gql api

-   a request could be massively cut down in query size but I won't for prod in order to not be extremely visible => (can't get it to work with full query and variable must be something simple for parsing)
-   gql does no longer use movie title but new movie id
-   movie id can be figured out via movie page (a.r-1ui2xcl => elem.href)
-   cookie can be supplied but you really don't have to (ideally we figure out to obtain one to not draw more attention)
