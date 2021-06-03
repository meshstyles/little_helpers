const axios = require('axios');

let baseURL = "http://raspi"
let tradeinAPI = "/api/tradein/"

axios.get(linkBuilder(tradeinAPI))
    .then(function (response) {
        // handle success
        let games = response.data.games
        games.forEach(game => {
            console.log(game);
        });
    })
    .catch(function (error) {
        // handle error
        console.log(error);
    })
    .then(function () {
        // always executed
    });

function linkBuilder(endpoint) {
    return baseURL + tradeinAPI;
}