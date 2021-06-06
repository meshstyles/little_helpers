chrome.runtime.onMessage.addListener(data => {
    if (data.type === 'notification') {
        chrome.notifications.create(data.options);
    }
    if (data.type === 'err-log') {
        console.log(data.selection)
    }
});