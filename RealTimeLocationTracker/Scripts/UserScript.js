//for each locations
let watchID;
//startTracking
function startTracking() {
    if (navigator.geolocation) {
        watchID = navigator.geolocation.watchPosition(
            data => {
                SendPositionToDB(data.coords.latitude, data.coords.longitude);
            },
            err => { alert("unsupported browser"); },
            { enableHighAccuracy: true });
    }
}
/*const username = '<%=Session["username"]%>';*/
//send to db
function SendPositionToDB(lat, lon) {
    fetch('SaveLocationToDB.aspx', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            Username: username,
            Latitude: lat,
            Longitude: lon
        })
    }).then((res) => res.text())
        .then(data => {
            if (data === "success") {
                console.log("Success: You are now tracked.");
            } else {
                alert("Server error: Something went wrong!");
            }
        })
        .catch((err) => {
            console.log("Error : ".err);
            alert("Connection error: Please try again.")
        })
}
//stop tracking
function stopTracking() {
    if (watchID) {
        navigator.geolocation.clearWatch(watchID);
        fetch('MarkOffline.aspx', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ Username: username })
        }).then(() => {
            alert("You're now logout, and location service is stop.");
            window.location.href = "/Account/Login.aspx";
        })
    }
}
//onload calling
window.onload = startTracking;