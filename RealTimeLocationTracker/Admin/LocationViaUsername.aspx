<%@ Page Title="Location Filter" Language="C#" MasterPageFile="~/Admin/AdminLayout.Master" AutoEventWireup="true" CodeBehind="LocationViaUsername.aspx.cs" Inherits="RealTimeLocationTracker.Admin.LocationViaUsername" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="fixed top-16 left-0 p-5 bg-emerald-700 rounded" style="z-index:10000">
        <h1 class="text-xl tracking-widest mt-2 mb-5">Filter Map</h1>
        <div>
            <span class="font-semibold text-gray-200">by username :</span><br />
            <span>
                <asp:DropDownList
                    ID="DropDownList1"
                    runat="server"
                    DataSourceID="SqlDataSource1"
                    DataTextField="username"
                    DataValueField="username"
                    CssClass="w-full md:w-64 px-4 py-2 bg-gray-800 text-white border border-emerald-400 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition duration-200">
                </asp:DropDownList>
                <asp:SqlDataSource
                    ID="SqlDataSource1"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:stringOne %>"
                    SelectCommand="SELECT [username] FROM [signup]"></asp:SqlDataSource>
            </span>
        </div>
    </div>


    <div id="mapid" class="h-[100vh] w-full border-2 border-emerald-400"></div>

    <script>
        const map = L.map("mapid").setView([22.5937, 78.9629], 3);
        L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '&copy; OpenStreetMap contributors',
        }).addTo(map);

        let currentPathLayer = null;
        let currentMarkers = [];

        window.onload = () => {
            const drops = document.querySelector("#<%=DropDownList1.ClientID%>");
            let username = drops.value;
            showUserLocation(username);
            if (drops) {
                drops.addEventListener("change", (e) => {
                    username = e.target.value
                    showUserLocation(username);
                })
            } else { return }

        }
        function showUserLocation(username) {
            fetch(`../User/GetUserPath.aspx?username=${encodeURIComponent(username)}`)
                .then(res => res.json())
                .then(data => {
                    //polyLines
                    const points = data.map((item, index) => [item.latitude, item.longitude]);
                    if (currentPathLayer) {
                        map.removeLayer(currentPathLayer);
                    }
                    currentPathLayer = L.polyline(points, {
                        color: 'blue',
                        weight: 3,
                    }).addTo(map);
                    map.fitBounds(currentPathLayer.getBounds());
                    //markers
                    //deleting old markers
                    currentMarkers.forEach((markers => map.removeLayer(markers)));
                    currentMarkers = [];
                    data.map((item, currentIdx) => {
                        const isLast = currentIdx === data.length - 1;
                        let color = "red";
                        if (isLast && item.isOnline) {
                            color = 'green';
                        }
                        const marker = L.circleMarker([item.latitude, item.longitude], {
                            color: color,
                            fillColor: color,
                            fillOpacity: 0.9,
                        }).addTo(map).bindPopup(`
                            <label class='font-semibold'>${item.username}</label><br/>
                            <small>
                                ${isLast ?
                                (item.isOnline ?
                                    '<span class="bg-green-800 text-white font-semibold p-1 rounded-xl">online</span>'
                                    :
                                    '<span class="bg-red-600 text-white font-semibold p-1 rounded-xl">offline</span>'
                                ) : '<span class="bg-red-600 text-white font-semibold p-1 rounded-xl">offline</span>'
                            }
                                </small><br/>
                                <small>${item.recordedAt}</small>
                        `);
                        currentMarkers.push(marker);
                    })
                });
        }

    </script>
</asp:Content>
