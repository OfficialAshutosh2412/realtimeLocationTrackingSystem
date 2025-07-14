<%@ Page Title="Admin | Home" Language="C#" MasterPageFile="~/Admin/AdminLayout.Master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="RealTimeLocationTracker.Admin.AdminHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mt-4">
        <a href="UserLocationHistory.aspx" class="bg-blue-500 text-white p-3 m-2 mt-5 rounded hover:bg-blue-700">click to see all users's location history...</a>

        <a href="UserProfile.aspx" class="bg-blue-500 text-white p-3 m-2 mt-5 rounded hover:bg-blue-700">click to see all users's profile...</a>
    </div>
</asp:Content>
