<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserLocationHistory.aspx.cs" Inherits="RealTimeLocationTracker.Admin.UserLocationHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <style>
        #mapid{
            height:600px;
            width:100%;
            border:2px solid black;
        }
    </style>
</head>
<body>
    <div id="mapid"></div>

    <script>
        //init map
        const map = L.map('mapid').setView([20.5937, 78.9629], 5);
        //base map with centered india.
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '© OpenStreetMap contributors',
        }).addTo(map);

        //function that load all user's path
        function LoadMapData() {
            fetch('GetAllUserLocationHistory.aspx')
                .then(res => res.json())
                .then(data => {
                    //creating empty object group
                    const group = {};
                    //going through all rows, and check if there i a group with username key then skip or init a new key with username as an empty array. And then push the row that has same username in their username group.
                    data.forEach(item => {
                        if (!group[item.username]) {
                            group[item.username] = [];
                        }
                        group[item.username].push(item);
                    })
                    //now we get the groups, now loop through every keys, to get the keys, and with the of those keys, you have to loop through groups[keys] to get each group data of each key, then extract latitude, longitude in an array, so this way you are creating an array or arrays for polylines.
                    Object.keys(group).forEach((username, index) => {
                        const points = group[username];
                        const paths = points.map(p=>[p.latitude, p.longitude])
                        //now draw pollylines
                        L.polyline(paths, {
                            color: 'blue', weight: 3,
                        }).addTo(map);
                        map.fitBounds(paths);
                        //points have an array of usernames, which have values of their location history.
                        //when loop on it, we get p as their values and index as curent index, we compared current index with the last index, if they are equal then w got the last element or index number.
                        //then we checked, if it is the last element and it contains isOnline as true, if both are tru then we made color green, which is bydefault set red.
                        points.forEach((p, index) => {
                            const isLast = index === points.length - 1;
                            let color = 'red';
                            if (isLast && p.isOnline) {
                                color = 'green';
                            }
                            //now we are making dots.
                            L.circleMarker([p.latitude, p.longitude], {
                                radius: 6,
                                color: color,
                                fillColor: color,
                                fillOpacity: 0.9
                            }).addTo(map).bindPopup(`
                                ${p.username}<br/>
                                <small>${isLast ? (p.isOnline ? "🟢 Online" : "🔴 Offline") : "🔴 Offline"}</small><br/>
                                <small>${p.recordedAt}</small>
                            `);
                        });
                    })
                    
                })
        }
        window.onload = LoadMapData;
        setInterval(LoadMapData, 50000);
    </script>
</body>
</html>
