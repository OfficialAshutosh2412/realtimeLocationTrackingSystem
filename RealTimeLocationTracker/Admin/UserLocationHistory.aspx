<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserLocationHistory.aspx.cs" Inherits="RealTimeLocationTracker.Admin.UserLocationHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>All User Location History</title>
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
    <script src="../Scripts/apis.js"></script>
    <script>
        //init map
        const map = L.map('mapid').setView([20.5937, 78.9629], 5);
        //base map with centered india.
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '© OpenStreetMap contributors',
        }).addTo(map);

        
        window.onload = LoadMapData;
        setInterval(LoadMapData, 10000);
    </script>
</body>
</html>
