<%@ Page Title="Home" Language="C#" MasterPageFile="~/HomeLayout.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="RealTimeLocationTracker.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="min-h-screen bg-gray-900 text-white flex items-center justify-center px-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-10 w-full max-w-5xl py-20">

            <!-- Login Card -->
            <a href="Account/Login.aspx"
               class="border border-emerald-400 rounded-xl flex items-center justify-center h-32 w-full text-3xl font-semibold hover:bg-emerald-500 hover:text-black transition duration-300 ease-in-out shadow-lg">
                User Login
            </a>

            <!-- Admin Dashboard Card -->
            <a href="Admin/AdminHome.aspx"
               class="border border-purple-400 rounded-xl flex items-center justify-center h-32 w-full text-3xl font-semibold hover:bg-purple-500 hover:text-black transition duration-300 ease-in-out shadow-lg">
                Administration Dashboard
            </a>

        </div>
    </div>
</asp:Content>
