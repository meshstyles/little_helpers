document.addEventListener(
    "DOMContentLoaded",
    function onLoad() {
        let code = document.getElementById("code");
        // chrome.storage.sync.get(stored => {
        //   let retrieved = stored.selectedText;
        //   code.value = retrieved;
        // })

        chrome.tabs.executeScript(
            {
                code: "window.getSelection().toString();",
            },
            function (selection) {
                //this auto-decodes for convience because less clicks more better
                let decoded = decode(selection[0].trim())
                code.value = decoded;
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
            if (!(url.startsWith('https://') || url.startsWith('http://')))
                url = 'https://' + url
            chrome.tabs.create({ url: url });
        });
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
        }
    }
    return decoded;
}