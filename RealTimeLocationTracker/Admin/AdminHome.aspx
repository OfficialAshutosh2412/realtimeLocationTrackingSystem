<%@ Page Title="Admin | Home" Language="C#" MasterPageFile="~/Admin/AdminLayout.Master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="RealTimeLocationTracker.Admin.AdminHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="w-[60%] m-auto mt-4 flex gap-5 items-center">
        <a href="UserLocationHistory.aspx" class="border border-emerald-400 rounded-xl flex items-center justify-center h-32 w-full text-3xl font-semibold hover:bg-emerald-500 hover:text-black transition duration-300 ease-in-out shadow-lg">Location Via Date</a>

        <a href="LocationViaUsername.aspx" class="border border-purple-400 rounded-xl flex items-center justify-center h-32 w-full text-3xl font-semibold hover:bg-purple-500 hover:text-black transition duration-300 ease-in-out shadow-lg">Individual User Location</a>
    </div>
</asp:Content>
