using System;
using System.Xml;
using System.Collections;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;

namespace WikiEngine
{
    #region Entry base declarations
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
    internal class EntryAttribute : Attribute
    {
        public EntryAttribute(string NodeName)
        {
            this.NodeName = NodeName;
        }
        public string NodeName;
    }

    internal class WikiParseException : Exception
    {
        public WikiParseException(string Message) : base(Message) { }
    }
    internal class WikiParseEntryException : Exception
    {
        public WikiParseEntryException(string Message, Exception InnerException) : base(Message, InnerException) { }
    }
    internal class WikiParseDebugBreak : Exception
    {
        public string CurrentData;
        public WikiParseDebugBreak(string CurrentData)
            : base()
        {
            this.CurrentData = CurrentData;
        }
    }

    internal abstract class Entry
    {
        public static Entry LoadEntry(XmlElement Node, Entry Parent, Engine Owner)
        {
            foreach (System.Type t in Assembly.GetExecutingAssembly().GetTypes())
                foreach (EntryAttribute a in t.GetCustomAttributes(typeof(EntryAttribute), true))
                    if (a.NodeName == Node.Name)
                    {
                        Entry e = t.GetConstructor(System.Type.EmptyTypes).Invoke(new object[0]) as Entry;
                        e.Owner = Owner;
                        e.Parent = Parent;
                        //e.NextEntry=NextEntry;//?
                        e.InitNode(Node);
                        e.Load(Node);//try?
                        if (e is EntryByPass)
                            return (e as EntryByPass).PassThrough;
                        else
                            return e;
                    }
            throw new WikiParseException("Unknown WikiParseXml element <" + Node.Name + ">");
        }

        private string EntryId;
        private string EntryName;
        internal Entry Parent = null;
        internal Engine Owner = null;
        internal Entry NextEntry = null;

        public virtual void LoadElement(XmlElement Node)
        {
            //inheritants: parse children
        }

        public void InitNode(XmlElement Node)
        {
            EntryName = Node.Name;
            EntryId = Node.GetAttribute("id");
            if (EntryId != "")
                Owner.AddNamedEntry(Node.OwnerDocument, this, EntryId);
        }

        public virtual void Load(XmlElement Node)
        {
            foreach (XmlNode n in Node.ChildNodes)
                if (n.NodeType == XmlNodeType.Element)
                    LoadElement(n as XmlElement);
            //inheritants override and don't call inherited to deviate
        }

        public abstract string Render(string Data);

        public static string RenderSequence(Entry Start, string Data)
        {
            string res = Data;
            Entry e = Start;
            while (e != null)
            {
                res = e.Render(res);
                e = e.NextEntry;
            }
            return res;
        }

        protected bool XmlToBool(XmlElement Node)
        {
            if (Node == null) return false;
            return Node.InnerText == "1";
        }

        protected void Throw(string Message, Exception InnerException)
        {
            throw new WikiParseEntryException("[WikiParse]<" + EntryName + (EntryId == "" ? "" : " id=\"" + EntryId + "\"") + ">" + Message, InnerException);
        }
        protected void Throw(string Message)
        {
            Throw(Message, null);
        }

        protected Entry LoadEntries(XmlElement Node, Engine Owner)
        {
            Entry LastEntry = null;
            Entry FirstEntry = null;
            foreach (XmlNode n in Node.ChildNodes)
                if (n.NodeType == XmlNodeType.Element)
                {
                    Entry e = LoadEntry(n as XmlElement, this, Owner);
                    if (LastEntry == null) FirstEntry = e; else LastEntry.NextEntry = e;
                    LastEntry = e;
                }
            return FirstEntry;
        }

    }

    internal abstract class EntryRegEx : Entry
    {
        protected bool Global = true;
        protected string Pattern; //property on set FRegEx=null?
        protected bool PatternSet = false;
        protected RegexOptions Options = RegexOptions.IgnoreCase | RegexOptions.Multiline;
        internal Match CurrentMatch;

        private void SetOption(RegexOptions ro, bool rs)
        {
            if (rs)
                Options |= ro;
            else
                Options ^= ro;
        }

        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "pattern":
                    Pattern = Node.InnerText;
                    PatternSet = true;
                    break;
                case "global":
                    Global = XmlToBool(Node);
                    break;
                case "ignorecase":
                    SetOption(RegexOptions.IgnoreCase, XmlToBool(Node));
                    break;
                case "multiline":
                    SetOption(RegexOptions.Multiline, XmlToBool(Node));
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        private Regex FRegex = null;

        protected Regex GetRegex()
        {
            //RegexOptions.Compiled? other?
            if (FRegex == null) FRegex = new Regex(Pattern, Options);
            return FRegex;
        }
    }

    internal abstract class EntrySimpleText : Entry
    {
        protected string Text;

        public override void Load(XmlElement Node)
        {
            //base.Load (Node); //no child items expected, take text!
            Text = Node.InnerText;
        }

    }

    internal abstract class EntryByPass : Entry
    {
        internal Entry PassThrough = null;

        public override void Load(XmlElement Node)
        {
            base.Load(Node);
            //inheritants set PassThrough to another entry to replace the current entry in the flow
        }

        public override sealed string Render(string Data)
        {
            Throw("EntrySimplePassThrough should have been by-passed but got Render() called!");
            return null;
        }

    }

    #endregion

    [Entry("replace")]
    internal class wpReplace : EntryRegEx
    {
        protected string ReplaceBy;
        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "with":
                    ReplaceBy = Node.InnerText;
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }
        public override string Render(string Data)
        {
            if (Global)
                return GetRegex().Replace(Data, ReplaceBy);
            else
                return GetRegex().Replace(Data, ReplaceBy, 1);
        }
    }

    [Entry("replaceif")]
    internal class wpReplaceIf : wpReplace
    {
        Entry CheckDo;
        Entry CheckElse;

        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "do":
                    CheckDo = LoadEntries(Node, Owner);
                    break;
                case "else":
                    CheckElse = LoadEntries(Node, Owner);
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        public override string Render(string Data)
        {
            Regex re = GetRegex();
            if (re.IsMatch(Data))
                return RenderSequence(CheckDo, re.Replace(Data, ReplaceBy));
            else
                return RenderSequence(CheckElse, Data);
        }

    }

    [Entry("split")]
    internal class wpSplit : EntryRegEx
    {
        protected Entry Match;
        protected Entry Inbetween;
        protected bool Required = false;

        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "match":
                    Match = LoadEntries(Node, Owner);
                    break;
                case "inbetween":
                    Inbetween = LoadEntries(Node, Owner);
                    break;
                case "required":
                    Required = XmlToBool(Node);
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        public override string Render(string Data)
        {
            Regex re = GetRegex();
            int Position = 0;
            MatchCollection mc = re.Matches(Data);
            if (mc.Count == 0)
            {
                return Required ? Data : RenderSequence(Inbetween, Data);
            }
            else
            {
                StringBuilder res = new StringBuilder(Data.Length);
                Match pm = CurrentMatch;
                foreach (Match m in mc)
                {
                    CurrentMatch = m;
                    //preceding bit
                    res.Append(RenderSequence(Inbetween, Data.Substring(Position, m.Index - Position)));
                    //match
                    res.Append(RenderSequence(Match, m.Value));
                    Position = m.Index + m.Length;
                }
                CurrentMatch = pm;
                //last bit
                res.Append(RenderSequence(Inbetween, Data.Substring(Position, Data.Length - Position)));
                return res.ToString();
            }
        }

    }

    [Entry("extract")]
    internal class wpExtract : EntryRegEx
    {
        protected Entry Match;
        protected Entry Inbetween;
        protected bool Required = false;
        private string FPrefix = "%%";
        private string FSuffix = "#";

        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "match":
                    Match = LoadEntries(Node, Owner);
                    break;
                case "inbetween":
                    Inbetween = LoadEntries(Node, Owner);
                    break;
                case "required":
                    Required = XmlToBool(Node);
                    break;
                case "prefix":
                    FPrefix = Node.InnerText;
                    break;
                case "suffix":
                    FSuffix = Node.InnerText;
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        public static string RegexPatternSafe(string Text)
        {
            StringBuilder s = new StringBuilder(Text.Length);
            foreach (char c in Text)
                switch (c)
                {
                    case '$':
                    case '(':
                    case ')':
                    case '*':
                    case '+':
                    case '-':
                    case '.':
                    case '[':
                    case '\\':
                    case ']':
                    case '^':
                    case '{':
                    case '|':
                    case '}':
                        s.Append('\\');
                        s.Append(c);
                        break;
                    default:
                        s.Append(c);
                        break;
                }
            return s.ToString();
        }

        protected string Marker(int Index)
        {
            return FPrefix + Index.ToString() + FSuffix;
        }

        public override string Render(string Data)
        {
            Regex re = GetRegex();
            Regex reOpen = new Regex(RegexPatternSafe(FPrefix));
            Regex reClose = new Regex(RegexPatternSafe(FPrefix) + "([0-9]+?)" + RegexPatternSafe(FSuffix));
            string Marker0 = Marker(0);
            int Position = 0;
            MatchCollection mc = re.Matches(Data);
            if (mc.Count == 0)
            {
                return Required ? Data : RenderSequence(Inbetween, Data);
            }
            else
            {
                StringBuilder res = new StringBuilder(Data.Length);
                Match pm = CurrentMatch;
                int mi;
                for (mi = 0; mi < mc.Count; mi++)
                {
                    Match m = mc[mi];
                    CurrentMatch = m;
                    //preceding bit, securing markers
                    res.Append(reOpen.Replace(Data.Substring(Position, m.Index - Position), Marker0));
                    //match
                    res.Append(Marker(mi + 1));
                    Position = m.Index + m.Length;
                }
                CurrentMatch = pm;
                //last bit
                res.Append(reOpen.Replace(Data.Substring(Position, Data.Length - Position), Marker0));

                //perform action
                string x = RenderSequence(Inbetween, res.ToString());
                res = new StringBuilder();

                //re-word extracted matches
                Position = 0;
                MatchCollection mc2 = reClose.Matches(x);
                pm = CurrentMatch;
                foreach (Match m2 in mc2)
                {
                    //preceding bit
                    res.Append(x.Substring(Position, m2.Index - Position));
                    //find match
                    mi = Convert.ToInt32(m2.Groups[1].Value);
                    if (mi == 0)
                        res.Append(FPrefix);//restore marker
                    else if (mi > mc.Count)
                        Throw("Incorrect extraction marker found, check prefix/suffix '" + m2.Value + "'");
                    else
                    {
                        CurrentMatch = mc[mi - 1];
                        res.Append(RenderSequence(Match, CurrentMatch.Value));
                    }
                    Position = m2.Index + m2.Length;
                }
                CurrentMatch = pm;
                //last bit
                res.Append(x.Substring(Position, x.Length - Position));

                return res.ToString();
            }
        }

    }

    [Entry("submatch")]
    internal class wpSubMatch : Entry
    {
        private int Number = -1;
        private int RepeatNumber = -1;

        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "id":
                case "index":
                case "number":
                    Number = Convert.ToInt32(Node.InnerText);
                    break;
                case "repeat":
                    RepeatNumber = Convert.ToInt32(Node.InnerText);
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        public override string Render(string Data)
        {
            Entry pe = Parent;
            while (pe != null && !(pe is EntryRegEx)) pe = pe.Parent;
            if (pe == null) Throw("No parent RegEx operation found");
            Match m = (pe as EntryRegEx).CurrentMatch;
            if (m == null) Throw("Parent RegEx operation is not processing a match");
            StringBuilder res = new StringBuilder();
            if (Number == -1) foreach (Group g in m.Groups) res.Append(g.Value);
            else
            {
                try
                {
                    res.Append(m.Groups[Number].Value);
                }
                catch (IndexOutOfRangeException e)
                {
                    Throw("Unable to retrieve submatch " + Number.ToString(), e);
                }
            }
            if (RepeatNumber != -1)
            {
                int rl = 0;
                try
                {
                    rl = m.Groups[RepeatNumber].Length;
                }
                catch (IndexOutOfRangeException e)
                {
                    Throw("Unable to retrieve submatch " + Number.ToString(), e);
                }
                string x = res.ToString();
                for (int i = 1; i < rl; i++) res.Append(x);
            }
            return res.ToString();
        }

    }

    [Entry("group")]
    internal class wpGroup : Entry
    {
        Entry GroupFirst;
        public override void Load(XmlElement Node)
        {
            //base.Load (Node); //deviate: children are entries
            GroupFirst = LoadEntries(Node, Owner);
        }
        public override string Render(string Data)
        {
            return RenderSequence(GroupFirst, Data);
        }
    }

    [Entry("check")]
    internal class wpCheck : EntryRegEx
    {
        private string Text;
        private bool TextSet = false;
        Entry CheckDo;
        Entry CheckElse;
        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "value":
                    Text = Node.InnerText;
                    TextSet = true;
                    break;
                case "do":
                    CheckDo = LoadEntries(Node, Owner);
                    break;
                case "else":
                    CheckElse = LoadEntries(Node, Owner);
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }
        public override string Render(string Data)
        {
            bool ChecksOut;
            if (TextSet)
                ChecksOut = Data == Text;
            else if (PatternSet)
                ChecksOut = GetRegex().IsMatch(Data);
            else
                ChecksOut = Data.Length != 0; //default
            return RenderSequence(ChecksOut ? CheckDo : CheckElse, Data);
        }
    }

    [Entry("text")]
    internal class wpText : EntrySimpleText
    {
        public override string Render(string Data)
        {
            return Text;
        }
    }

    [Entry("noop"), Entry("skip")]
    internal class wpNoop : Entry
    {
        public override string Render(string Data)
        {
            return Data;
        }
    }

    [Entry("uppercase")]
    internal class wpUpperCase : Entry
    {
        public override string Render(string Data)
        {
            return Data.ToUpper();
        }
    }

    [Entry("lowercase")]
    internal class wpLowerCase : Entry
    {
        public override string Render(string Data)
        {
            return Data.ToLower();
        }

    }

    [Entry("prepend")]
    internal class wpPrepend : EntrySimpleText
    {
        public override string Render(string Data)
        {
            return Text + Data;
        }
    }

    [Entry("append")]
    internal class wpAppend : EntrySimpleText
    {
        public override string Render(string Data)
        {
            return Data + Text;
        }

    }

    [Entry("length")]
    internal class wpLength : Entry
    {
        public override string Render(string Data)
        {
            return Data.Length.ToString();
        }
    }

    [Entry("concat")]
    internal class wpConcat : Entry
    {
        Entry ConcatFirst;
        public override void Load(XmlElement Node)
        {
            //base.Load (Node); //children are entries
            ConcatFirst = LoadEntries(Node, Owner);
        }
        public override string Render(string Data)
        {
            StringBuilder res = new StringBuilder();
            Entry e = ConcatFirst;
            while (e != null)
            {
                res.Append(e.Render(Data));
                e = e.NextEntry;
            }
            return res.ToString();
        }
    }

    [Entry("process")]
    internal class wpProcess : EntryRegEx
    {
        Entry CheckDo;
        Entry CheckElse;

        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "do":
                    CheckDo = LoadEntries(Node, Owner);
                    break;
                case "else":
                    CheckElse = LoadEntries(Node, Owner);
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }

        public override string Render(string Data)
        {
            MatchCollection mc = GetRegex().Matches(Data);
            if (mc.Count == 0)
                return RenderSequence(CheckElse, Data);
            else
            {
                string res = Data;
                Match pm = CurrentMatch;
                foreach (Match m in mc)
                {
                    CurrentMatch = m;
                    res = RenderSequence(CheckDo, res);
                }
                CurrentMatch = pm;
                return res;
            }
        }

    }

    [Entry("debug")]
    internal class wpDebugBreak : Entry
    {
        int SkipCount;
        Entry DebugDo;
        public override void LoadElement(XmlElement Node)
        {
            switch (Node.Name)
            {
                case "do":
                    DebugDo = LoadEntries(Node, Owner);
                    break;
                case "skip":
                    SkipCount = Convert.ToInt32(Node.InnerText);
                    break;
                default:
                    base.LoadElement(Node);
                    break;
            }
        }
        public override string Render(string Data)
        {
            if (SkipCount == 0)
                throw new WikiParseDebugBreak(RenderSequence(DebugDo, Data));
            else
            {
                SkipCount--;
                return Data;
            }
        }
    }

    [Entry("jump")]
    internal class wpJump : EntryByPass
    {
        public override void Load(XmlElement Node)
        {
            PassThrough = Owner.GetNamedEntry(Node.OwnerDocument, Node.InnerText);
            if (PassThrough == null) Throw("Jump target '" + Node.InnerText + "' not found");
        }
    }

    [Entry("htmlencode")]
    internal class wpHtmlEncode : Entry
    {
        public override string Render(string Data)
        {
            return Data.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;").Replace("\r\n", "<br />");
        }
    }

    [Entry("urlencode")]
    internal class wpUrlEncode : Entry
    {
        const string Hex = "0123456789ABCDEF";
        public override string Render(string Data)
        {
            StringBuilder s = new StringBuilder(Data.Length);
            //parameter: select encoding? Encoding.GetEncoding(
            foreach (byte b in Encoding.UTF8.GetBytes(Data))
            {
                char c = (char)b;
                if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
                    s.Append(c);
                else
                    switch (c)
                    {
                        //http://www.ietf.org/rfc/rfc2396.txt '-_.!~*''()'
                        //['0'..'9','A'..'Z','a'..'z','?','&','=','#',':','/',';','-','_','.','!','~','*','''','(',')'] then
                        case ' ':
                            s.Append('+');
                            break;
                        case '\'':
                        case '(':
                        case ')':
                        case '*':
                        case '-':
                        case '.':
                        case '_':
                        case '!':
                            s.Append(c);
                            break;
                        default:
                            s.Append('%');
                            s.Append(Hex[b >> 4]);
                            s.Append(Hex[b & 0x0F]);
                            break;
                    }
            }
            return s.ToString();
        }
    }

    [Entry("include")]
    internal class wpInclude : EntrySimpleText
    {
        protected Entry FMainEntry;
        public override void Load(XmlElement Node)
        {
            base.Load(Node);
            //relative URL/Path?
            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            doc.Load(Text);
            XmlNode FirstEntry = doc.DocumentElement.FirstChild;
            while (FirstEntry != null && FirstEntry.NodeType != XmlNodeType.Element) FirstEntry = FirstEntry.NextSibling;
            FMainEntry = LoadEntry(FirstEntry as XmlElement, this, Owner);//parent null?
        }

        public override string Render(string Data)
        {
            return FMainEntry.Render(Data);
        }

    }

}
