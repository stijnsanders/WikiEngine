using System;
using System.Text;
using System.Text.RegularExpressions;

namespace WikiEngine
{
    [Entry("command")]
    internal class wpCommand : Entry
    {
        private bool TableCellOpened = false;

        public override string Render(string Data)
        {
            StringBuilder res = new StringBuilder();
            wpCommandParser wp = new wpCommandParser(Data);

            string cmd = "";
            string val = "";
            //throw if none?
            while (wp.GetNext(ref cmd, ref val))
            {
                switch (cmd)
                {
                    case "fail":
                    case "throw":
                    case "raise":
                    case "error":
                    case "debug":
                        if (val == "")
                            Throw("fail requested");
                        else
                            Throw("fail requested: " + val);
                        break;
                    //case "include":?
                    case "now":
                        res.Append(DateTime.Now.ToString());//format?
                        break;
                    case "comment":
                        break;
                    case "table":
                        res.Append("<TABLE" + wp.AllAsAttributes() + "><TBODY><TR>\r\n");
                        TableCellOpened = false;
                        break;
                    case "tableend":
                        if (TableCellOpened) res.Append("</TD>\r\n");
                        res.Append("</TR></TBODY></TABLE>\r\n");
                        TableCellOpened = false;
                        break;
                    case "cell":
                        if (TableCellOpened) res.Append("</TD>\r\n");
                        res.Append("<TD" + wp.AllAsAttributes() + ">");
                        TableCellOpened = true;
                        break;
                    case "cellnr":
                        if (TableCellOpened) res.Append("</TD>\r\n");
                        res.Append("</TR>\r\n<TR><TD" + wp.AllAsAttributes() + ">");
                        TableCellOpened = true;
                        break;
                    case "div":
                        res.Append("<DIV" + wp.AllAsAttributes() + ">");
                        break;
                    case "divend":
                        res.Append("</DIV>\r\n");
                        break;
                    case "markup":
                        res.Append("[[[[");
                        break;
                    case "markupend":
                        res.Append("]]]]");
                        break;
                    case "title":
                        Owner.Modifications.Add(new WikiModification("title", wp.GetRemainder()));
                        break;
                    case "redirect":
                        Owner.Modifications.Add(new WikiModification("redirect", wp.GetRemainder()));
                        break;

                    //add new here
                    //case "include":?

                    default:
                        Owner.Modifications.Add(new WikiModification(cmd, val));
                        //throw?
                        break;
                }
            }
            return res.ToString();
        }
    }

    internal class wpCommandParser
    {
        private Regex reCommand = new Regex("([a-z]+)(=(\"([^\"]*)\"|\'([^\']*)\'|([^\\s]*)))?", RegexOptions.IgnoreCase);
        private MatchCollection mc;
        private string FData;
        private int mi;
        private int mp;
        public wpCommandParser(string Data)
        {
            FData = Data;
            mc = reCommand.Matches(Data);
            mi = 0;
            mp = 0;
        }
        public bool GetNext(ref string Command, ref string Value)
        {
            if (mi >= mc.Count)
                return false;
            else
            {
                Match m = mc[mi];
                Command = m.Groups[1].Value;
                Value = m.Groups[3].Value + m.Groups[4].Value + m.Groups[5].Value;
                mp = m.Index + m.Length;
                mi++;
                return true;
            }
        }
        public string AllAsAttributes()
        {
            //mp=?.Length;
            mi = mc.Count;
            string cmd = "";
            string val = "";
            StringBuilder res = new StringBuilder();
            while (GetNext(ref cmd, ref val))
                //if(cmd.Substring(0,2).ToLower()!="on")?
                res.Append(" " + cmd + "=\"" + val + "\"");//HTMLEncode(val)?
            return res.ToString();
        }
        public string GetRemainder()
        {
            //mp=?.Length;
            mi = mc.Count;
            return FData.Substring(mp).Trim();
        }
    }

    [Entry("wiki")]
    internal class wpWiki : EntryRegEx
    {
        protected Entry DoFound;
        protected Entry DoMissing;
        protected string ReplaceBy;
        protected Entry DoUpdate;
        protected bool UpdateSet;
        protected string UpdatePrefix = "";
        protected string UpdateSuffix = "";

        public override void Load(System.Xml.XmlElement Node)
        {
            //check the engine's page checker first
            if (Owner.PageCheck == null)
                Throw("Engine doesn't have a PageChecker/Storage object assigned.");
            base.Load(Node);
        }

        public override void LoadElement(System.Xml.XmlElement Node)
        {
            switch (Node.Name)
            {
                case "with":
                    ReplaceBy = Node.InnerText;
                    break;
                case "found":
                    DoFound = LoadEntries(Node, Owner);
                    break;
                case "missing":
                    DoMissing = LoadEntries(Node, Owner);
                    break;
                case "update":
                    UpdateSet = XmlToBool(Node);
                    break;
                case "updatedo":
                    DoUpdate = LoadEntries(Node, Owner);
                    break;
                case "updateprefix":
                    UpdatePrefix = Node.InnerText;
                    break;
                case "updatesuffix":
                    UpdateSuffix = Node.InnerText;
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        public override string Render(string Data)
        {
            string res = PatternSet ? GetRegex().Replace(Data, ReplaceBy) : Data;
            bool r = Owner.PageCheck.CheckPage(ref res);
            if (UpdatePrefix != "") res = res + UpdatePrefix + Data;
            if (UpdateSuffix != "") res = Data + UpdateSuffix + res;
            if (UpdateSet)
                res = RenderSequence(DoUpdate, res);
            return RenderSequence(r ? DoFound : DoMissing, res);
        }

    }

}
