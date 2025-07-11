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
    public partial class SaveLocationToDB : System.Web.UI.Page
    {
        public class LocationData
        {
            public string Username { get; set; }
            public double Latitude { get; set; }
            public double Longitude { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            //read upcomming body
            string body = new StreamReader(Request.InputStream).ReadToEnd();

            //get values in location data variables
            LocationData data = JsonConvert.DeserializeObject<LocationData>(body);

            //sql processes
            using(SqlConnection con = DynamicConnectionStringClass.GetConnection())
            {
                string query = "INSERT INTO UserLocationHistory(username, latitude, longitude, recordedAt, isOnline) VALUES(@name, @lat, @lon, GETDATE(), 1)";
                using(SqlCommand cmd=new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@name", data.Username);
                    cmd.Parameters.AddWithValue("@lat", data.Latitude);
                    cmd.Parameters.AddWithValue("@lon", data.Longitude);
                    con.Open();
                    int affectedRow = cmd.ExecuteNonQuery();
                    if (affectedRow > 0)
                    {
                        Response.Clear();
                        Response.ContentType = "text/plain";
                        Response.Write("success");
                        Response.End();
                    }
                    else
                    {
                        Response.Clear();
                        Response.ContentType = "text/plain";
                        Response.Write("Server Error.");
                        Response.End();
                    }
                }
            }
        }
    }
}