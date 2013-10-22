using System;
using System.Collections;
using System.Xml;

namespace WikiEngine
{
    public class Engine
    {

        public Engine()
        {
        }
        #region Helper methods

        private int CallTC1;
        private int CallTC2;
        private void CallStart()
        {
            CallTC1 = System.Environment.TickCount;
        }
        private void CallDone()
        {
            CallTC2 = System.Environment.TickCount;
        }

        #endregion

        private string FWikiParseXml;
        private int FWikiParseXmlTC;
        private ArrayList FModifications = new ArrayList();
        private Entry MainEntry;
        private Hashtable FNamedEntries = new Hashtable();

        public string WikiParseXml
        {
            get { return FWikiParseXml; }
            set
            {
                CallStart();
                try
                {
                    FWikiParseXml = value;
                    XmlDocument doc = new XmlDocument();
                    doc.PreserveWhitespace = true;

                    if (FWikiParseXml[0] == '<')
                        doc.LoadXml(FWikiParseXml);
                    else
                    {
                        doc.Load(FWikiParseXml);
                        //FWikiParseXml=doc.URL;
                    }

                    FNamedEntries.Clear();
                    int WikiParseXmlStartTC = System.Environment.TickCount;
                    try
                    {
                        XmlNode FirstEntry = doc.DocumentElement.FirstChild;
                        while (FirstEntry != null && FirstEntry.NodeType != XmlNodeType.Element) FirstEntry = FirstEntry.NextSibling;
                        MainEntry = Entry.LoadEntry(FirstEntry as XmlElement, null, this);
                    }
                    finally
                    {
                        FWikiParseXmlTC = System.Environment.TickCount - WikiParseXmlStartTC;
                    }

                }
                finally
                {
                    CallDone();
                }
            }
        }

        public string Render(string Data)
        {
            CallStart();
            try
            {
                FModifications.Clear();
                //TODO CurrentGroup?
                return MainEntry.Render(Data);
            }
            catch (WikiParseDebugBreak db)
            {
                return db.CurrentData;
            }
            finally
            {
                CallDone();
            }
        }

        public int LastCallTime
        {
            get { return CallTC2 - CallTC1; }
        }

        public int WikiParseXmlLoadTime
        {
            get { return FWikiParseXmlTC; }
        }

        public ArrayList Modifications
        {
            get { return FModifications; }
        }

        public IWikiPageCheck PageCheck;

        internal void AddNamedEntry(XmlDocument Doc, Entry Entry, string Name)
        {
            Hashtable DItems = FNamedEntries[Doc] as Hashtable;
            if (DItems == null) FNamedEntries[Doc] = DItems = new Hashtable();
            DItems[Name] = Entry;
        }

        internal Entry GetNamedEntry(XmlDocument Doc, string Name)
        {
            Hashtable DItems = FNamedEntries[Doc] as Hashtable;
            if (DItems == null) FNamedEntries[Doc] = DItems = new Hashtable();
            Entry Target = DItems[Name] as Entry;
            if (Target == null)
            {
                XmlElement TargetNode = Doc.DocumentElement.SelectSingleNode("*[@id=\"" + Name + "\"]") as XmlElement;
                if (TargetNode != null) Target = Entry.LoadEntry(TargetNode, null, this);
            }
            return Target;
        }

    }

    public class WikiModification
    {
        private string FName;
        private string FValue;
        public WikiModification(string Name, string Value)
        {
            FName = Name;
            FValue = Value;
        }
        public string Name { get { return FName; } }
        public string Value { get { return FValue; } }
    }

    public interface IWikiPageCheck
    {
        bool CheckPage(ref string Name);
        void StripGroup(string Name, ref string Group, ref string NameOnly);
        bool SupportsGroups { get; }
        bool Groups { get; set; }
        string CurrentGroup { get; set; }
    }

    public delegate bool WikiStorageProcessName(string Name, object Context);
    public delegate bool WikiStoragePageEnumerator(string Name, string Data, object Context);

    public interface IWikiStorage : IWikiPageCheck
    {
        bool GetPageData(ref string Name, string CurrentGroup, ref string Data);
        void SetPageData(string Name, string Data);
        bool CheckLock(string Name);
        void LockPage(string Name);
        void UnlockPage(string Name);
        //string GetDefaultData(ref string Name,string CurrentGroup);
        //? GetHistory(string Name);
        //TODO connection settings?
        string Author { get; set; }
        string SessionInfo { get; set; }
        bool SupportsLocking { get; }
        bool SupportsLinks { get; }
        bool SupportsTemplates { get; }
        bool SupportsHistory { get; }
        bool Templates { get; set; }
        string TemplateSuffix { get; set; }
        bool Links(string Name, WikiStorageProcessName Handler, object Context);
        bool Backlinks(string Name, WikiStorageProcessName Handler, object Context);
        bool Pages(WikiStoragePageEnumerator Handler, object Context);
    }
}