using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace RealTimeLocationTracker.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Unnamed3_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string name = username.Text.Trim();
                string psd = password.Text.Trim();

                using(SqlConnection con = DynamicConnectionStringClass.GetConnection())
                {
                    string query = "SELECT * FROM signup WHERE username=@name AND password=@psd";
                    using(SqlCommand cmd=new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@name",name);
                        cmd.Parameters.AddWithValue("@psd",psd);

                        cmd.Connection.Open();

                        using(SqlDataReader dtr = cmd.ExecuteReader())
                        {
                            if (dtr.Read())
                            {
                                Session["username"] = dtr["username"].ToString();
                                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Success : redirecting you to user page.');", true);
                                Response.Redirect("~/User/UserHome.aspx");
                            }
                            else
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error : username or password is incorrect.');", true);
                            }
                        }
                    }
                }
            }
        }
    }
}