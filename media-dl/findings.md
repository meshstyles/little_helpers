# netzkino

## redesign

-   now uses gql ( so an update is in order)
-   old api still works so old code can be retained for the time being
-   needs watch and filme filter now

## a look at the gql api

-   a request could be massively cut down in query size but I won't for prod in order to not be extremely visible
-   gql does no longer use movie title but new movie id
-   cookie can be supplied but you really don't have to (ideally we figure out to obtain one to not draw more attention)
-   movie id can be figured out via movie page (a.r-1ui2xcl => elem.href)

