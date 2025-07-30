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

        
        //once page is loaded, then fire this event methods.
        <%--document.addEventListener("DOMContentLoaded", function () {
            const option = document.querySelector("#<%= DropDownList1.ClientID%>");
            let username = option.value;
            fetchData(username);
            if (option) {
                option.addEventListener("change", (e) => {
                    username = e.target.value
                    fetchData(username);
                })
            } else { return }
            setInterval(fetchData, 60000);
        });--%>
    </script>
</asp:Content>
