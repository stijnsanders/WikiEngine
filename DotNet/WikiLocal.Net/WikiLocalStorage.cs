using System;
using System.IO;
using System.Text;
using WikiEngine;

namespace WikiLocal.Net
{
    public class WikiLocalStorage : IWikiStorage
    {
        private const string ExtWikiData = ".wx";
        private const string ExtWikiLinks = ".wxa";
        private const string ExtWikiBackLinks = ".wxb";
        public const char WikiGroupSeparator = '.';
        public const string WikiDefaultGroup = "Main";

        private string dataDir;
        private string curGroup;
        private bool doLinks = false;
        private SortedStringList links = new SortedStringList();
        //TODO: a sorted string collection

        public WikiLocalStorage(string DataFolder)
        {
            dataDir = DataFolder;
            if (dataDir == "") dataDir = @".";
            if (dataDir[dataDir.Length - 1] != Path.DirectorySeparatorChar)
                dataDir += Path.DirectorySeparatorChar;
            curGroup = WikiDefaultGroup;
            if (!Directory.Exists(dataDir)) Directory.CreateDirectory(dataDir);
        }

        #region IWikiPageCheck Members

        public bool CheckPage(ref string Name)
        {
            string g = curGroup;
            string n = "";
            bool b = true;
            if (g != "" && Name != "" && File.Exists(GetFilePath(g, Name) + ExtWikiData))
                n = Name;
            else
            {
                StripGroup(Name, ref g, ref n);
                b = File.Exists(GetFilePath(g, n) + ExtWikiData);
            }
            Name = g + WikiGroupSeparator + n;
            if (doLinks) links.Add(Name);
            return b;
        }

        public void StripGroup(string Name, ref string Group, ref string NameOnly)
        {
            int i = 0;
            int l = Name.Length;
            while (i < l && Name[i] != WikiGroupSeparator) i++;
            if (i == l)
            {
                Group = curGroup;
                NameOnly = Name;
            }
            else
            {
                Group = Name.Substring(0, i);
                NameOnly = Name.Substring(i + 1);
            }
        }

        public bool SupportsGroups
        {
            get { return true; }
        }

        public bool Groups
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        public string CurrentGroup
        {
            get
            {
                return curGroup;
            }
            set
            {
                curGroup = value;
            }
        }

        #endregion

        private string GetFilePath(string Group, string Name)
        {
            return dataDir + FileNameSafe(Group + "." + Name);
        }

        #region IWikiStorage Members

        public bool GetPageData(ref string Name, string CurrentGroup, ref string Data)
        {
            links.Clear();
            curGroup = CurrentGroup;
            string n = "";
            StripGroup(Name, ref curGroup, ref n);
            FileInfo[] fis = new DirectoryInfo(dataDir).GetFiles(FileNameSafe(curGroup + "." + n + ExtWikiData));
            if (fis.Length == 1)
            {
                n = fis[0].Name;
                int i = curGroup.Length + 1;
                Name = curGroup + WikiGroupSeparator + n.Substring(i, n.Length - i - ExtWikiData.Length);
                using (StreamReader sr = new StreamReader(fis[0].FullName))
                    Data = sr.ReadToEnd();
                return true;
            }
            else
            {
                Name = curGroup + WikiGroupSeparator + n;
                //TODO: default data, see templates
                Data = "Describe [[" + n + "]] here...";
                return false;
            }
        }

        public void SetPageData(string Name, string Data)
        {
            curGroup = CurrentGroup;
            string n = "";
            StripGroup(Name, ref curGroup, ref n);
            string pn = curGroup + WikiGroupSeparator + n;
            string fn = GetFilePath(curGroup, n);
            if (Data == "" || Data == "delete")
            {
                SortedStringList curLinks = new SortedStringList();
                curLinks.Load(fn + ExtWikiLinks);
                foreach (string x in curLinks)
                {
                    SortedStringList newLinks = new SortedStringList();
                    string fn1 = dataDir + FileNameSafe(x) + ExtWikiBackLinks;
                    newLinks.Load(fn1);
                    newLinks.Remove(pn);
                    newLinks.Save(fn1);
                }

                File.Delete(fn + ExtWikiData);
                File.Delete(fn + ExtWikiLinks);
            }
            else
            {
                //TODO: encoding setting
                using (StreamWriter sw = new StreamWriter(fn + ExtWikiData, false, Encoding.UTF8))
                    sw.Write(Data);

                //assert links loaded from previous render
                //load previous first
                SortedStringList curLinks = new SortedStringList();
                curLinks.Load(fn + ExtWikiLinks);
                //save new
                links.Save(fn + ExtWikiLinks);
                //add new backreferences
                foreach (string x in links)
                    if (!curLinks.Remove(x))
                    {
                        SortedStringList newLinks = new SortedStringList();
                        string fn1 = dataDir + FileNameSafe(x) + ExtWikiBackLinks;
                        newLinks.Load(fn1);
                        newLinks.Add(pn);
                        newLinks.Save(fn1);
                    }
                //remove old backreferences
                foreach (string x in curLinks)
                {
                    SortedStringList newLinks = new SortedStringList();
                    string fn1 = dataDir + FileNameSafe(x) + ExtWikiBackLinks;
                    newLinks.Load(fn1);
                    newLinks.Remove(pn);
                    newLinks.Save(fn1);
                }
            }
        }

        public bool Links(string Name, WikiStorageProcessName Handler, object Context)
        {
            string g = CurrentGroup;
            string n = "";
            bool b = true;
            StripGroup(Name, ref g, ref n);
            FileInfo[] fis = new DirectoryInfo(dataDir).GetFiles(FileNameSafe(g + "." + n + ExtWikiLinks));
            if (fis.Length == 1)
                using (StreamReader sr = new StreamReader(fis[0].FullName))
                    while (!sr.EndOfStream && b)
                        b = Handler(sr.ReadLine(), Context);
            return b;
        }

        public bool Backlinks(string Name, WikiStorageProcessName Handler, object Context)
        {
            string g = CurrentGroup;
            string n = "";
            bool b = true;
            StripGroup(Name, ref g, ref n);
            FileInfo[] fis = new DirectoryInfo(dataDir).GetFiles(FileNameSafe(g + "." + n + ExtWikiBackLinks));
            if (fis.Length == 1)
                using (StreamReader sr = new StreamReader(fis[0].FullName))
                    while (!sr.EndOfStream && b)
                        b = Handler(sr.ReadLine(), Context);
            return b;
        }

        public bool HasLinks(string Name)
        {
            string g = CurrentGroup;
            string n = "";
            StripGroup(Name, ref g, ref n);
            FileInfo[] fis = new DirectoryInfo(dataDir).GetFiles(FileNameSafe(g + "." + n + ExtWikiLinks));
            return fis.Length == 1;
        }

        public bool HasBacklinks(string Name)
        {
            string g = CurrentGroup;
            string n = "";
            StripGroup(Name, ref g, ref n);
            FileInfo[] fis = new DirectoryInfo(dataDir).GetFiles(FileNameSafe(g + "." + n + ExtWikiBackLinks));
            return fis.Length == 1;
        }

        public bool CheckLock(string Name)
        {
            //TODO:
            throw new Exception("The method or operation is not implemented.");
        }

        public void LockPage(string Name)
        {
            //TODO:
            throw new Exception("The method or operation is not implemented.");
        }

        public void UnlockPage(string Name)
        {
            //TODO:
            throw new Exception("The method or operation is not implemented.");
        }

        public string Author
        {
            //TODO: login user name?
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        public string SessionInfo
        {
            //TODO:
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        public bool SupportsLocking
        {
            //TODO:
            get { throw new Exception("The method or operation is not implemented."); }
        }

        public bool SupportsLinks
        {
            get { return true; }
        }

        public bool SupportsTemplates
        {
            //TODO:
            get { return false; }
        }

        public bool SupportsHistory
        {
            //TODO:
            get { return false; }
        }

        public bool Templates
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        public string TemplateSuffix
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        public bool Pages(WikiStoragePageEnumerator Handler, object Context)
        {
            foreach (FileInfo fi in new DirectoryInfo(dataDir).GetFiles("*" + ExtWikiData))
                using (StreamReader sr = new StreamReader(fi.FullName))
                {
                    string g = CurrentGroup;
                    string n = "";
                    StripGroup(fi.Name.Substring(0, fi.Name.Length - ExtWikiData.Length), ref g, ref n);
                    if (!Handler(g + WikiGroupSeparator + n, sr.ReadToEnd(), Context))
                        return false;
                }
            return true;
        }

        #endregion

        private string FileNameSafe(string x)
        {
            StringBuilder y = new StringBuilder(x.Length);
            for (int i = 0; i < x.Length; i++)
                switch (x[i])
                {
                    case '\\':
                    case '/':
                    case ':':
                    case '*':
                    case '?':
                    case '\"':
                    case '<':
                    case '>':
                    case '|':
                        y.Append('_');
                        break;
                    default:
                        y.Append(x[i]);
                        break;
                }
            return y.ToString();
        }

        public bool StoreLinks
        {
            get
            {
                return doLinks;
            }
            set
            {
                doLinks = value;
                if (doLinks) links.Clear();
            }
        }

    }
}
