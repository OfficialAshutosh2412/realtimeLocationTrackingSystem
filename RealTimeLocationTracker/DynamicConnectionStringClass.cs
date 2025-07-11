using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace RealTimeLocationTracker
{
    public class DynamicConnectionStringClass
    {
        public static SqlConnection GetConnection()
        {
            SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["stringOne"].ToString()
                );
            return con;
        }
    }
}