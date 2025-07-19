using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using Newtonsoft.Json;

namespace RealTimeLocationTracker.Admin
{
    public partial class GetUserLocationHistory : System.Web.UI.Page
    {
        public class DateParams
        {
            public DateTime sdate { get; set; }
            public DateTime edate { get; set; }
        }
        public class DataCollector
        {
            public string username { get; set; }
            public double latitude { get; set; }
            public double longitude { get; set; }
            public string recordedAt { get; set; }
            public Boolean isOnline { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            DateParams dates = new DateParams();
            //query string data
            dates.sdate = Convert.ToDateTime(Request.QueryString["sdate"]);
            dates.edate = Convert.ToDateTime(Request.QueryString["edate"]);

            List<DataCollector> list = new List<DataCollector>();

            //sql process
            using (SqlConnection con = DynamicConnectionStringClass.GetConnection())
            {
                string query = "SELECT username, latitude, longitude, recordedAt, isOnline FROM UserLocationHistory WHERE recordedAt BETWEEN @sdate AND @edate";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("sdate", dates.sdate);
                    cmd.Parameters.AddWithValue("edate", dates.edate);
                    con.Open();
                    using (SqlDataReader dtr = cmd.ExecuteReader())
                    {
                        while (dtr.Read())
                        {
                            list.Add(new DataCollector
                            {
                                username = dtr["username"].ToString(),
                                latitude = Convert.ToDouble(dtr["latitude"]),
                                longitude = Convert.ToDouble(dtr["longitude"]),
                                recordedAt = dtr["recordedAt"].ToString(),
                                isOnline=Convert.ToBoolean(dtr["isOnline"]),
                            });
                        }
                    }
                }
            }
            string json = JsonConvert.SerializeObject(list);
            Response.ContentType = "application/json";
            Response.Write(json);
            Response.End();
        }
    }
}