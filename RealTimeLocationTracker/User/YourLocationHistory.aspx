<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="YourLocationHistory.aspx.cs" Inherits="RealTimeLocationTracker.User.YourLocationHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div id="map"></div>

    <script>
        //main function
        function loadUserPath() {
            //function for get username fom query string
            const username = getUsernameFromQueryString();
            if (username == null) {
                alert("User not found");
                return;
            }
            //now calling a backend for getting data from database.
            fetch(`GetUserPath.aspx?username=${encodeURIComponent(username)}`)
                .then((res) => res.json())
                .then((data) => {
                    console.log(data);
                })

        }
        //function definition to get username from query string.
        function getUsernameFromQueryString() {
            const urlParameters = new URLSearchParams(window.location.search);
            if (urlParameters == null) {
                alert("parameters not found");
            } else return urlParameters.get("username");
        }

    


        //loading main function on page load and after every 10s
        window.onload = loadUserPath;
        setInterval(loadUserPath, 10000);
    </script>
</body>
</html>
