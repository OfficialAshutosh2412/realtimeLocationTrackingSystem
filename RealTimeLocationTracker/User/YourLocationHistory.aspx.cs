using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RealTimeLocationTracker.User
{

    public partial class YourLocationHistory : System.Web.UI.Page
    {
        protected string Username;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                Username = Request.QueryString["username"];
                if (string.IsNullOrEmpty(Username))
                {
                    Response.Redirect("UserHome.aspx");
                }
            }
        }
    }
}