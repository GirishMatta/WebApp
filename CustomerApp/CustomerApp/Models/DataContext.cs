using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace CustomerApp.Models
{
    public class DataContext : DbContext
    {
        public DataContext() : base("DataContext")
        {

        }
        public DbSet<Customer> Customers { get; set; }
    }
}