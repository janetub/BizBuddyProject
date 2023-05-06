using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace BizBuddyProject.Classes
{
    public class Customer
    {
        private int id;
        private string firstName;
        private string middleName;
        private string lastName;
        private Dictionary<string, List<string>> contacts = new Dictionary<string, List<string>>();
        
        public int ID
        {
            get => this.id; 
            set => this.id = value;
        }

        public string FirstName
        {
            get => this.firstName; 
            set => this.firstName = value;
        }

        public string MiddleName
        {
            get => this.middleName;
            set => this.middleName = value;
        }

        public string LastName
        {
            get => this.lastName;
            set => this.lastName = value;
        }
    }
}
