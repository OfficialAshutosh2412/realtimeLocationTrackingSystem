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
     <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-white">
    <div id="mapid"></div>
    <script src="../Scripts/apis.js"></script>
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
            //api call
            FetchMyLocationHistory(username);
            

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
