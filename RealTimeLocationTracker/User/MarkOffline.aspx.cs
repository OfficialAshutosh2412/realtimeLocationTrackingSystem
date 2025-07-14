using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Newtonsoft.Json;
using System.IO;

namespace RealTimeLocationTracker.User
{
    public partial class MarkOffline : System.Web.UI.Page
    {
        public class OfflineData
        {
            public string Username { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            OfflineData data = JsonConvert.DeserializeObject<OfflineData>(body);
            using(SqlConnection con = DynamicConnectionStringClass.GetConnection())
            {
                string query = "UPDATE UserLocationHistory SET isOnline=0 WHERE username=@name";
                using(SqlCommand cmd=new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@name", data.Username);
                    con.Open();
                    int affectedRow = cmd.ExecuteNonQuery();
                    if (affectedRow > 0)
                    {
                        Session.Clear();
                        Session.Abandon();
                        Response.Write("You are offline.");
                    }
                    else
                    {
                        Response.Write("Server Error.");
                    }
                }
            }
        }
    }
}