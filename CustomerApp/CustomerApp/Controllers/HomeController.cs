using CustomerApp.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CustomerApp.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            using (DataContext db = new DataContext())
            {
                return View(db.Customers.ToList());
            }
        }

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(Customer customer)
        {
            try
            {
                using (DataContext db = new DataContext())
                {
                    db.Customers.Add(customer);
                    db.SaveChanges();
                }
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        public ActionResult Details(int id)
        {
            using (DataContext db = new DataContext())
            {
                return View(db.Customers.Where(x => x.CustomerID == id).FirstOrDefault());
            }
        }

        public ActionResult Edit(int id)
        {
            using (DataContext db = new DataContext())
            {
                return View(db.Customers.Where(x => x.CustomerID == id).FirstOrDefault());
            }
        }

        [HttpPost]
        public ActionResult Edit(int id, Customer customer)
        {
            try
            {
                using (DataContext db = new DataContext())
                {
                    db.Entry(customer).State = EntityState.Modified;
                    db.SaveChanges();
                }
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}