<%@ Page Title="Location Filter" Language="C#" MasterPageFile="~/Admin/AdminLayout.Master" AutoEventWireup="true" CodeBehind="LocationViaUsername.aspx.cs" Inherits="RealTimeLocationTracker.Admin.LocationViaUsername" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="fixed top-16 left-0 p-5 bg-emerald-700" style="z-index: 10000">
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
        <div class="border border-emerald-400 w-full mt-5"></div>
        <div class="mt-5">
            <h1 class="mb-2">By date range.</h1>
            <div class="mb-5">
                <asp:Label Text="Start Date:" runat="server" CssClass="font-semibold text-gray-200" /><br />
                <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SqlDataSource2" DataTextField="recordedAt" DataValueField="recordedAt"
                    CssClass="w-full md:w-64 px-4 py-2 bg-gray-800 text-white border border-emerald-400 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition duration-200">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:stringOne %>" SelectCommand="SELECT [recordedAt] FROM [UserLocationHistory]"></asp:SqlDataSource>

            </div>
            <div>
                <asp:Label Text="End Date:" runat="server" CssClass="font-semibold text-gray-200" /><br />
                <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDataSource2" DataTextField="recordedAt" DataValueField="recordedAt"
                    CssClass="w-full md:w-64 px-4 py-2 bg-gray-800 text-white border border-emerald-400 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition duration-200">
                </asp:DropDownList>

            </div>
            <button type="button" id="show" class="bg-gray-800 border border-purple-400 p-2 px-5 font-semibold rounded-lg mt-5">show data</button>
        </div>
    </div>

    <%--map--%>
    <div id="mapid" class="h-[100vh] w-full border-2 border-emerald-400"></div>
    <%--scripts--%>
    <script>
        //base map initiallisation
        const map = L.map("mapid").setView([22.5937, 78.9629], 3);
        L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 50,
            attribution: '&copy; OpenStreetMap contributors',
        }).addTo(map);

        //previous marker and polyline flushers
        let currentPathLayer = null;
        let currentMarkers = [];

        //onload function calling.
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

        //main function that fetch endpoint
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

        //filter by date processing
        document.getElementById('show').addEventListener('click', () => {
            const sdate = document.querySelector('#<%=DropDownList2.ClientID%>').value;
            const edate = document.querySelector('#<%=DropDownList3.ClientID%>').value;
            if (sdate >= edate) {
                alert("Error : please select date order correctly, past date comes first.");
                return;
            }

            //making request
            fetch(`GetUserLocationHistory.aspx?sdate=${encodeURIComponent(sdate)}&edate=${encodeURIComponent(edate)}`, { method: 'GET' })
                .then((res) => res.json())
                .then((data) => {
                    //grouping usernames in a single object.
                    const group = {};
                    data.forEach((item) => {
                        if (!group[item.username]) {
                            group[item.username] = [];
                        }
                        group[item.username].push(item);
                    });
                    
                    //polyline
                    const points = data.map((item) => [item.latitude, item.longitude])
                    if (currentPathLayer) {
                        map.removeLayer(currentPathLayer);
                    }
                    currentPathLayer = L.polyline(points, {
                        color: 'orange',
                        weight: 3
                    }).addTo(map);
                    map.fitBounds(currentPathLayer.getBounds());
                    //markers
                    //deleting old markers
                    for (let user in group) {
                        group[user].sort((a, b) => new Date(a.recordedAt) - new Date(b.recordedAt));
                    }

                    currentMarkers.forEach((markers => map.removeLayer(markers)));
                    currentMarkers = [];

                    data.map((item, index) => {
                        const userGroup = group[item.username];
                        //starting location
                        const userFirstLocation = userGroup[0];
                        //user last location
                        const userLastLocation = userGroup[userGroup.length - 1];
                        //cheking if user first?
                        const isFirstForUser = item === userFirstLocation;
                        console.log(isFirstForUser)
                        //checking last user location?
                        const isLastForUser = item === userLastLocation;
                        //setting default color.
                        let color = "red";
                        //checkin if onlin or last then green.
                        if (isLastForUser && item.isOnline) {
                            color = 'green';
                        }
                        
                        const marker = L.circleMarker([item.latitude, item.longitude], {
                            color: color,
                            fillColor: color,
                            fillOpacity: 0.9,
                        }).addTo(map);
                        marker.bindPopup(`
                            <label class='font-semibold'>${item.username}</label><br/>
                            <small>
                                ${isLastForUser ?
                                (item.isOnline ?
                                    '<span class="bg-green-800 text-white font-semibold p-1 rounded-xl">online</span>'
                                    :
                                    '<span class="bg-red-600 text-white font-semibold p-1 rounded-xl">offline</span>'
                                ) : '<span class="bg-red-600 text-white font-semibold p-1 rounded-xl">offline</span>'
                            }
                                </small><br/>
                                <small>${item.recordedAt}</small>
                        `);
                        if (isFirstForUser) {
                            marker.bindTooltip(`${item.username}<br/><span class='text-xs font-semibold'>Starting Point</span>`, {
                                permanent: true,
                                direction: 'top',
                                offset: [0, -5],
                                className: `${item.isOnline ? 'bg-green-600' : 'bg-red-600'} text-white rounded px-2 py-1 shadow-[1px_1px_5px_4px_black]`
                            }).openTooltip();
                        }
                        if (isLastForUser) {
                            marker.bindTooltip(`${item.username}<br/><span class='text-xs font-semibold'>Ending Point</span`, {
                                permanent: true,
                                direction: 'top',
                                offset: [0, -5],
                                className: `${item.isOnline? 'bg-green-600':'bg-red-600'} text-white rounded px-2 py-1 shadow-[1px_1px_5px_4px_black]`
                            }).openTooltip();
                        }
                        currentMarkers.push(marker);
                    })
                })
                .catch((err) => console.error("Error : " + err));
        })

    </script>
</asp:Content>
