using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BizBuddyProject.Classes
{
    public class Customer
    {
        private Guid id = Guid.NewGuid();
        private string firstName;
        private string middleName;
        private string lastName;
        private Dictionary<string, List<string>> contacts = new Dictionary<string, List<string>>();
        
        public int ID
        {
            get => this.id; 
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

        public int AddContact(string type, string contact)
        {
            int flag = 0;
            if(this.contacts.ContainsKey(type))
            {
                contacts[type].Add(contact);
                flag = 1;
            }
            else
            {
                contacts.Add(type, new List<string> {contact});
                flag = 1;
            }
            return flag;
        }

        public int RemoveContact(string type, string contact)
        {
            int flag = 0;
            if(this.contacts.ContainsKey(type))
            {
                contacts[type].Remove(contact);
                flag = 1;
            }
            return flag;
        }

        public int EditContact(string type, string oldContact, string newContact)
        {
            int index = contacts[type].IndexOf(oldContact);
            if(index != -1)
            {
                contacts[type][index] = newContact;
            }
            return (index != -1);
        }
    }
}
