<%@ Page Title="Signup Page" Language="C#" MasterPageFile="~/HomeLayout.Master" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="RealTimeLocationTracker.Account.Signup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bg-gray-900 flex items-center justify-center min-h-screen p-4 text-white">
        <div class="w-full max-w-md bg-gray-800 p-8 rounded-xl shadow-lg space-y-5">
            <h2 class="text-2xl font-bold text-center text-emerald-400">Create an Account</h2>
            <%--username--%>
            <asp:TextBox runat="server" ID="username" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400"  placeholder="Username"/>

            <asp:RequiredFieldValidator ErrorMessage="username required" ControlToValidate="username" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic" />

            <%--password--%>
              <asp:TextBox runat="server" ID="password" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400"  placeholder="Password" TextMode="Password"/>

            <asp:RequiredFieldValidator ErrorMessage="password required" ControlToValidate="password" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>

            <%--gender--%>
            <asp:DropDownList runat="server" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400" ID="gender">
                <asp:ListItem Text="Select Gender" Value=""/>
                <asp:ListItem Text="Male" Value="male"/>
                <asp:ListItem Text="Female" Value="female"/>
            </asp:DropDownList>

            <asp:RequiredFieldValidator ErrorMessage="Select gender" InitialValue="" ControlToValidate="gender" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>

            <%--state--%>
            <asp:TextBox runat="server" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400" ID="state" placeholder="State" />

            <asp:RequiredFieldValidator ErrorMessage="state required" ControlToValidate="state" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>

            <%--city--%>
            <asp:TextBox runat="server" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400" ID="city"  placeholder="City" />

            <asp:RequiredFieldValidator ErrorMessage="city required" ControlToValidate="city" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>

            <%--pincode--%>
             <asp:TextBox runat="server" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400" ID="pincode" placeholder="Pincode" TextMode="Number"/>

            <asp:RequiredFieldValidator ErrorMessage="pincode required" ControlToValidate="pincode" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>

            <asp:RegularExpressionValidator ErrorMessage="pincode should be 6 digits long" ControlToValidate="pincode" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic" ValidationExpression="^\d{6}$"/>

            <%--address--%>
            <asp:TextBox runat="server" CssClass="w-full p-3 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-emerald-400" ID="address" placeholder="Address" TextMode="MultiLine" Rows="3" />

            <asp:RequiredFieldValidator ErrorMessage="address required" ControlToValidate="address" runat="server" CssClass="text-red-300 text-sm font-semibold" Display="Dynamic"/>

            <%--button--%>
            <asp:Button Text="Sign Up" runat="server" CssClass="w-full bg-emerald-500 hover:bg-emerald-600 text-white font-semibold p-3 rounded-md transition-all" OnClick="Unnamed9_Click"/>

            <p class="text-center text-sm text-gray-400">
                Already have an account?
      <a href="login.aspx" class="text-emerald-400 hover:underline">Login here</a>
            </p>
        </div>
    </div>
</asp:Content>
