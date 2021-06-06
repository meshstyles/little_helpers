document.addEventListener(
    "DOMContentLoaded",
    function onLoad() {

        chrome.tabs.executeScript(
            {
                code: "window.getSelection().toString();",
            },
            function (selection) {
                let code = document.getElementById("code");
                // if (!(selection === null || selection === undefined)) {
                if (selection[0]) {
                    chrome.runtime.sendMessage('', {
                        type: 'err-log', selection
                    });
                    console.log(selection);
                    code.value = decode(selection);
                } else {
                    code.value = "";
                }
            }
        );


        let form = document.getElementById("form");
        form.addEventListener("submit", function (e) {
            e.preventDefault();
            // let value = e.target.children.code.value;
            let decoded = decode(code.value);

            document.getElementById("code").value = decoded;
            return;
        });

        let newTabButton = document.getElementById("openTab");
        newTabButton.addEventListener("click", function (e) {
            let code = document.getElementById("code");
            let url = code.value;
            // because people forget https at the begining of links
            // and chrome needs that when opening a new tab from extension
            // the user needs to see if it's a valid url
            // most https sites will redirect to https most http sites won't get redirected from https so http it is
            if (!(url.startsWith('https://') || url.startsWith('http://'))) {
                url = 'http://' + url
            }
            chrome.tabs.create({ url: url });
        });

        let copyClipboardButton = document.getElementById('copy');
        copyClipboardButton.addEventListener("click", function (e) {
            let value = code.value;
            if (value === null || value === undefined)
                value = ""
            navigator.clipboard.writeText(value).then(function () {
                /* clipboard successfully set */
                chrome.runtime.sendMessage('', {
                    type: 'notification',
                    options: {
                        title: 'copied to clipboard 🥳',
                        message: value,
                        iconUrl: '/icons/icon-64.png',
                        type: 'basic'
                    }
                });
            }, function () {
                /* clipboard write failed */
                chrome.runtime.sendMessage('', {
                    type: 'notification',
                    options: {
                        title: 'copy failed 😢',
                        message: value,
                        iconUrl: '/icons/icon-64.png',
                        type: 'basic'
                    }
                });
            });
        })

    },
    false
);

function decode(encoded) {
    let decoded = encoded;
    let needsDecoding = true;
    //tries decoding til it fails because it's not valid b64

    while (needsDecoding) {
        try {
            //
            decoded = decodeURIComponent(escape(window.atob(decoded)));
        } catch (err) {
            // TODO reuse error box
            needsDecoding = false;
            console.log(err)
        }
    }
    return decoded;
}