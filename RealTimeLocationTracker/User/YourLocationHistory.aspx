<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YourLocationHistory.aspx.cs" Inherits="RealTimeLocationTracker.User.YourLocationHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Location History</title>
    <style>
        #mapid{
            height:600px;
            width:100%;
            border:2px solid black;
        }
    </style>
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
</head>
<body>
    <div id="mapid"></div>

    <script>
        //map initialisation.
        const map = L.map('mapid').setView([20.5937, 78.9629], 5);

        //initialising default map tiles and layers.
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '© OpenStreetMap contributors',
        }).addTo(map);

        //main function
        function loadUserPath() {
            //function for get username fom query string.
            const username = getUsernameFromQueryString();
            if (username == null) {
                alert("User not found");
                return;
            }
            //now calling a backend for getting data from database.
            fetch(`GetUserPath.aspx?username=${encodeURIComponent(username)}`)
                .then((res) => res.json())
                .then((data) => {
                    const latlong = data.map(items => [items.latitude, items.longitude])
                    L.polyline(latlong, {
                        color: 'blue',
                        weight: 3
                    }).addTo(map);
                    map.fitBounds(latlong);

                    //now make markers
                    data.forEach((point, index) => {
                        //checking each element is last or not, for that, i am comparing upcomming index with last index, index whch match the last index will be the last element with last index and isLast becomes true.
                        const isLast = index === data.length - 1;
                        //setting color green for dots, by default
                        let color = 'red';
                        //setting color red, if element is last, otherwise rest ae green dots
                        if (isLast) {
                            color = point.isOnline ? 'green' : 'red';
                        }
                        //markers for creating dot on location
                        L.circleMarker([point.latitude, point.longitude], {
                            radius: isLast ? 8 : 5,
                            color: color,
                            fillColor: color,
                            fillOpacity: 0.9
                        }).addTo(map).bindPopup(`
                            <b>${point.username}</b><br>
                            ${isLast ? (point.isOnline ? "🟢 Online" : "🔴 offline"): "🔴 offline"}<br>
                            
                            <small>${point.recordedAt}</small>
                        `);
                    });
                })

        }
        //function definition to get username from query string.
        function getUsernameFromQueryString() {
            const urlParameters = new URLSearchParams(window.location.search);
            if (urlParameters == null) {
                alert("parameters not found");
            } else return urlParameters.get("username");
        }

        //loading main function on page load and after every 10s
        window.onload = loadUserPath;
        setInterval(loadUserPath, 5000);
    </script>
</body>
</html>
