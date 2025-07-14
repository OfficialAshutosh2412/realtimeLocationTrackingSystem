using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RealTimeLocationTracker.Admin
{
    public partial class GetAllUserLocationHistory : System.Web.UI.Page
    {
        public class AllUserLocationData
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
            Response.ContentType = "application/json";
            List<AllUserLocationData> list = new List<AllUserLocationData>();
            try
            {
                using(SqlConnection con = DynamicConnectionStringClass.GetConnection())
                {
                    string query = "SELECT id, username, latitude, longitude, recordedAt, isOnline FROM UserLocationHistory";
                    using(SqlCommand cmd=new SqlCommand(query, con))
                    {
                        con.Open();
                        using(SqlDataReader dtr = cmd.ExecuteReader())
                        {
                            while (dtr.Read())
                            {
                                list.Add(new AllUserLocationData { 
                                    id=Convert.ToInt32(dtr["id"]),
                                    username=dtr["username"].ToString(),
                                    latitude=Convert.ToDouble(dtr["latitude"]),
                                    longitude=Convert.ToDouble(dtr["longitude"]),
                                    recordedAt=dtr["recordedAt"].ToString(),
                                    isOnline=Convert.ToBoolean(dtr["isOnline"]),
                                });
                            }
                        }
                    }
                }
                string json = JsonConvert.SerializeObject(list);
                Response.Write(json);
            }catch(Exception ex)
            {
                Response.ContentType = "text/plain";
                Response.StatusCode = 500;
                Response.Write("Server Error : " + ex.Message);
            }
            Response.End();
        }
    }
}