<%@ Page Title="User Today's Location" Language="C#" MasterPageFile="~/Admin/AdminLayout.Master" AutoEventWireup="true" CodeBehind="OnlineUsers.aspx.cs" Inherits="RealTimeLocationTracker.Admin.OnlineUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="flex px-20 py-5 justify-between">
        <h1 class="text-3xl tracking-wider">User's today's locations.</h1>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" DataTextField="username" DataValueField="username" CssClass="w-full md:w-64 px-4 py-2 bg-gray-800 text-white border border-emerald-400 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition duration-200">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:stringOne %>" SelectCommand="SELECT DISTINCT [username] FROM [UserLocationHistory] WHERE ([isOnline] = @isOnline)">
            <SelectParameters>
                <asp:Parameter DefaultValue="true" Name="isOnline" Type="Boolean" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div>
        <div id="mapid" class="h-[600px] w-full "></div>
    </div>
    <%--script--%>
    <script src="../Scripts/apis.js"></script>
    <script>
        const map = L.map('mapid').setView([22.5937, 78.9629], 3);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '© OpenStreetMap contributors',
        }).addTo(map);

        let currentUserLayer = null; // Will hold previous user's markers + polyline

        function FetchOnlineData(username) {
            fetch(`../Shared Endpoint/CurrentLocationEndPoint.aspx?username=${encodeURIComponent(username)}`)
                .then((res) => res.json())
                .then((data) => {
                    // 🧹 Remove previous user markers/polyline
                    if (currentUserLayer) {
                        map.removeLayer(currentUserLayer);
                    }

                    const latlong = data.map(item => [item.latitude, item.longitude]);

                    // 🎯 Create a new group to hold all elements for this user
                    const userLayerGroup = L.layerGroup();

                    // 🔷 Add polyline to group
                    const polyline = L.polyline(latlong, {
                        color: 'blue',
                        weight: 3
                    }).addTo(userLayerGroup);

                    // Fit map to the polyline
                    map.fitBounds(polyline.getBounds());

                    // 🔘 Add markers to group
                    data.forEach((point, index) => {
                        const isLast = index === data.length - 1;
                        const color = isLast ? 'purple' : 'green';

                        const marker = L.circleMarker([point.latitude, point.longitude], {
                            radius: isLast ? 8 : 5,
                            color: color,
                            fillColor: color,
                            fillOpacity: 0.9
                        }).addTo(userLayerGroup);

                        marker.bindPopup(`
                    <b>${point.username}</b><br>
                    ${isLast ? (point.isOnline ? "🟣 Online" : "🔴 Offline") : "🟢 Previously Online"}<br>
                    <small>${point.recordedAt}</small>
                `);

                        if (isLast) {
                            marker.bindTooltip("Currently here", {
                                permanent: true,
                                direction: "top",
                                className: "current-tooltip"
                            }).openTooltip();
                        }
                    });

                    // 🆕 Add the group to the map
                    userLayerGroup.addTo(map);

                    // 💾 Store reference so we can clear it next time
                    currentUserLayer = userLayerGroup;
                })
                .catch((error) => {
                    console.error("Error loading user data:", error);
                });
        }

        //once page is loaded, then fire this event methods.
        document.addEventListener("DOMContentLoaded", function () {
            const option = document.querySelector("#<%= DropDownList1.ClientID%>");
            let username = option.value;
            FetchOnlineData(username);
            if (option) {
                option.addEventListener("change", (e) => {
                    username = e.target.value
                    FetchOnlineData(username);

                })
            } else { return }
            setInterval(() => {
                const currentUsername = document.querySelector("#<%= DropDownList1.ClientID %>").value;
                if (currentUsername) {
                    FetchOnlineData(currentUsername);
                }
            }, 10000);
        });

    </script>
</asp:Content>
