<%@ Page Title="Admin | Home" Language="C#" MasterPageFile="~/Admin/AdminLayout.Master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="RealTimeLocationTracker.Admin.AdminHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ml-16 mt-4">
        <a href="LocationViaUsername.aspx" class="border border-purple-400 rounded-xl flex items-center justify-center text-md w-fit p-3 px-5 font-semibold hover:bg-purple-500 hover:text-black transition duration-300 ease-in-out shadow-lg">Filter Location Data</a>
    </div>
</asp:Content>
