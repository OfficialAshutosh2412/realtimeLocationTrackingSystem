<%@ Page Title="" Language="C#" MasterPageFile="~/User/UserLayout.Master" AutoEventWireup="true" CodeBehind="UserHome.aspx.cs" Inherits="RealTimeLocationTracker.User.UserHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%--welcome message--%>
    <div class="p-5 mb-5">
        <h1 class="text-3xl md:text-4xl font-bold text-emerald-400">Welcome,
        <asp:Label ID="lblUsername" runat="server" CssClass="text-white" />
        </h1>
    </div>
    <div>
        <%--table--%>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="userid" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None" Width="100%">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="userid" HeaderText="userid" InsertVisible="False" ReadOnly="True" SortExpression="userid" />
                <asp:BoundField DataField="username" HeaderText="username" SortExpression="username" />
                <asp:BoundField DataField="password" HeaderText="password" SortExpression="password" />
                <asp:BoundField DataField="gender" HeaderText="gender" SortExpression="gender" />
                <asp:BoundField DataField="state" HeaderText="state" SortExpression="state" />
                <asp:BoundField DataField="city" HeaderText="city" SortExpression="city" />
                <asp:BoundField DataField="pincode" HeaderText="pincode" SortExpression="pincode" />
                <asp:BoundField DataField="address" HeaderText="address" SortExpression="address" />
            </Columns>
            <EditRowStyle BackColor="#2461BF" />
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#EFF3FB" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#F5F7FB" />
            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
            <SortedDescendingCellStyle BackColor="#E9EBEF" />
            <SortedDescendingHeaderStyle BackColor="#4870BE" />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:stringOne %>" SelectCommand="SELECT * FROM [signup] WHERE ([username] = @username)">
            <SelectParameters>
                <asp:SessionParameter Name="username" SessionField="username" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div>
        <div class="mt-5">
            <%--link--%>
            <asp:HyperLink
                ID="lnkLocationHistory"
                runat="server"
                NavigateUrl="~/User/YourLocationHistory.aspx"
                CssClass="inline-block bg-emerald-500 hover:bg-emerald-600 text-white font-semibold py-3 px-6 rounded-lg transition duration-300 ease-in-out mr-5">
            View Location History
            </asp:HyperLink>
            <%--button--%>
            <button type="button" class="inline-block bg-emerald-500 hover:bg-emerald-600 text-white font-semibold py-3 px-6 rounded-lg transition duration-300 ease-in-out mr-5" onclick="startTracking()">
                Track your activity.
            </button>
            <%--stop button--%>
            <button type="button" class="inline-block bg-red-500 hover:bg-red-600 text-white font-semibold py-3 px-6 rounded-lg transition duration-300 ease-in-out" onclick="stopTracking()">
                stop tracking your activity.
            </button>
        </div>
    </div>
    <script>
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
        const username = '<%=Session["username"]%>';
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
                    alert("You are now offline.");
                })
            }
        }
        //onload calling
        window.onload=startTracking;
    </script>
</asp:Content>
