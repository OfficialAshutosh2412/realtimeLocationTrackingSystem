<%@ Page Title="Sign-In" Language="C#" MasterPageFile="~/HomeLayout.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="RealTimeLocationTracker.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-gray-900 flex items-center justify-center min-h-screen p-4 text-white">
        <div class="w-full max-w-md bg-gray-800 p-8 rounded-xl shadow-lg space-y-5">
            <h2 class="text-2xl font-bold text-center text-emerald-400">Sign In to your account</h2>
            <%--username--%>
            <asp:TextBox runat="server" ID="username" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400"  placeholder="Username"/>

            <asp:RequiredFieldValidator ErrorMessage="username required" ControlToValidate="username" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic" />

            <%--password--%>
              <asp:TextBox runat="server" ID="password" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400"  placeholder="Password" TextMode="Password"/>

            <asp:RequiredFieldValidator ErrorMessage="password required" ControlToValidate="password" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>
             <%--button--%>
            <asp:Button Text="Sign In" runat="server" CssClass="w-full bg-emerald-500 hover:bg-emerald-600 text-white font-semibold p-3 rounded-md transition-all" OnClick="Unnamed3_Click"/>

            <p class="text-center text-sm text-gray-400">
                Create New Account?
      <a href="Signup.aspx" class="text-emerald-400 hover:underline">Signup here</a>
            </p>
        </div>
    </div>
</asp:Content>
