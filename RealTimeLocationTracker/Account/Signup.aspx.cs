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
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Unnamed9_Click(object sender, EventArgs e)
        {
            //getting values
            if (Page.IsValid)
            {
                string uname = username.Text.Trim();
                string pwd = password.Text.Trim();
                string gen = gender.SelectedValue;
                string st = state.Text.Trim();
                string ct = city.Text.Trim();
                string pin = pincode.Text.Trim();
                string addr = address.Text.Trim();


                //sql processes
                using (SqlConnection con = DynamicConnectionStringClass.GetConnection())
                {
                    string query = "INSERT INTO signup VALUES(@name, @pswd, @gen, @st, @ct, @pin, @addr)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@name", uname);
                        cmd.Parameters.AddWithValue("@pswd",pwd);
                        cmd.Parameters.AddWithValue("@gen",gen);
                        cmd.Parameters.AddWithValue("@st",st);
                        cmd.Parameters.AddWithValue("@ct",ct);
                        cmd.Parameters.AddWithValue("@pin",pin);
                        cmd.Parameters.AddWithValue("@addr",addr);

                        cmd.Connection.Open();
                        int affectedRow = cmd.ExecuteNonQuery();

                        if (affectedRow <= 0)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Server Error : While saving data');",true);
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Success : Redirecting you to login page.');", true);
                            Response.Redirect("Login.aspx");
                        }
                    }
                }
            }
        }
    }
}