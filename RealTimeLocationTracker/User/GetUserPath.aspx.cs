using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Newtonsoft.Json;

namespace RealTimeLocationTracker.User
{
    public partial class GetUserPath : System.Web.UI.Page
    {
        public class UserLocationData
        {
            public int id { get; set; }
            public string username { get; set; }
            public double latitude { get; set; }
            public double longitude { get; set; }
            public string recordedAt { get; set; }
            public bool isOnline { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();
            Response.ContentType = "application/json";
            string username = Request.QueryString["username"];
            if (string.IsNullOrEmpty(username))
            {
                Response.Write("user is not found");
                return;
            }
            try
            {
                List<UserLocationData> list = new List<UserLocationData>();
                using (SqlConnection con = DynamicConnectionStringClass.GetConnection())
                {
                    string query = "Select id, username, latitude, longitude, recordedAt, isOnline FROM UserLocationHistory  WHERE username=@username";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        con.Open();
                        using (SqlDataReader dtr = cmd.ExecuteReader())
                        {
                            while (dtr.Read())
                            {
                                list.Add(new UserLocationData
                                {
                                    id = Convert.ToInt32(dtr["id"]),
                                    username = dtr["username"].ToString(),
                                    latitude = Convert.ToDouble(dtr["latitude"]),
                                    longitude = Convert.ToDouble(dtr["longitude"]),
                                    recordedAt = dtr["recordedAt"].ToString(),
                                    isOnline = Convert.ToBoolean(dtr["isOnline"]),
                                }); ;
                            }
                        }
                    }
                }
                string json = JsonConvert.SerializeObject(list);
                Response.Write(json);
            }
            catch(Exception ex)
            {
                Response.Write("Server Error : "+ex.Message);
            }
            Response.End();
        }
    }
}