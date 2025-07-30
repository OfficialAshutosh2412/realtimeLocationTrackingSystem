<%@ Page Title="Today's Location" Language="C#" MasterPageFile="~/User/UserLayout.Master" AutoEventWireup="true" CodeBehind="MyCurrentLocation.aspx.cs" Inherits="RealTimeLocationTracker.User.MyCurrentLocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%--welcome message--%>
    <div class="p-5 mb-5">
        <h1 class="text-3xl md:text-4xl font-semibold tracking-widest text-emerald-400">Welcome,
        <span class="text-white"><%=Session["username"].ToString() %></span>
        </h1>
    </div>
    <div id="mapid" class="h-[100vh] w-full border-2 border-emerald-400"></div>
    <%--scripts--%>

    <script src="../Scripts/apis.js"></script>
    <script>
        const map = L.map('mapid').setView([22.5937, 78.9629], 3);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '© OpenStreetMap contributors',
        }).addTo(map);

        //onload function(main)
        function LoadCurrentLocation() {
            const username = GetUsernameFromQuery();
            if (username == null) {
                alert("username not found");
                return;
            }
            fetchData(username);
        }
        //getting username
        function GetUsernameFromQuery() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams == null) {
                alert("Invalid url")
            }
            else { return urlParams.get("username"); }
        }
        //once page is loaded, then fire this event methods.
        document.addEventListener("DOMContentLoaded", function () {
            LoadCurrentLocation();
            setInterval(LoadCurrentLocation, 10000);
        });
    </script>
</asp:Content>
