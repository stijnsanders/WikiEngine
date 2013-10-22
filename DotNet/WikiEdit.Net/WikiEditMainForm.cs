using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.IO;
using System.Xml;
using System.Text;
using WikiEngine;

namespace WikiEdit
{
    /// <summary>
    /// Summary description for Form1.
    /// </summary>
    public class WikiEditMainForm : System.Windows.Forms.Form
    {
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.StatusBar statusBar1;
        private System.Windows.Forms.StatusBarPanel statusBarPanel1;
        private System.Windows.Forms.StatusBarPanel statusBarPanel2;
        private System.Windows.Forms.StatusBarPanel statusBarPanel3;
        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.Splitter splitter1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.MainMenu mainMenu1;
        private System.Windows.Forms.MenuItem menuItem1;
        private System.Windows.Forms.MenuItem menuItem2;
        private System.Windows.Forms.MenuItem menuItem3;
        private System.Windows.Forms.MenuItem menuItem4;
        private System.Windows.Forms.MenuItem menuItem5;
        private System.Windows.Forms.MenuItem menuItem6;
        private System.Windows.Forms.MenuItem menuItem7;
        private System.Windows.Forms.MenuItem menuItem8;
        private System.Windows.Forms.MenuItem menuItem9;
        private System.Windows.Forms.MenuItem menuItem10;
        private System.Windows.Forms.OpenFileDialog ofdWikiParseXML;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.MenuItem menuItem11;
        private System.Windows.Forms.MenuItem menuItem12;
        private WebBrowser webBrowser1;
        private Panel panel1;
        private IContainer components;

        public WikiEditMainForm()
        {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();

            //
            // TODO: Add any constructor code after InitializeComponent call
            //
        }

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(WikiEditMainForm));
            this.statusBar1 = new System.Windows.Forms.StatusBar();
            this.statusBarPanel1 = new System.Windows.Forms.StatusBarPanel();
            this.statusBarPanel2 = new System.Windows.Forms.StatusBarPanel();
            this.statusBarPanel3 = new System.Windows.Forms.StatusBarPanel();
            this.ofdWikiParseXML = new System.Windows.Forms.OpenFileDialog();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.splitter1 = new System.Windows.Forms.Splitter();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.mainMenu1 = new System.Windows.Forms.MainMenu(this.components);
            this.menuItem1 = new System.Windows.Forms.MenuItem();
            this.menuItem2 = new System.Windows.Forms.MenuItem();
            this.menuItem3 = new System.Windows.Forms.MenuItem();
            this.menuItem4 = new System.Windows.Forms.MenuItem();
            this.menuItem10 = new System.Windows.Forms.MenuItem();
            this.menuItem7 = new System.Windows.Forms.MenuItem();
            this.menuItem8 = new System.Windows.Forms.MenuItem();
            this.menuItem11 = new System.Windows.Forms.MenuItem();
            this.menuItem9 = new System.Windows.Forms.MenuItem();
            this.menuItem12 = new System.Windows.Forms.MenuItem();
            this.menuItem5 = new System.Windows.Forms.MenuItem();
            this.menuItem6 = new System.Windows.Forms.MenuItem();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.webBrowser1 = new System.Windows.Forms.WebBrowser();
            this.panel1 = new System.Windows.Forms.Panel();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel3)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // statusBar1
            // 
            this.statusBar1.Location = new System.Drawing.Point(0, 297);
            this.statusBar1.Name = "statusBar1";
            this.statusBar1.Panels.AddRange(new System.Windows.Forms.StatusBarPanel[] {
            this.statusBarPanel1,
            this.statusBarPanel2,
            this.statusBarPanel3});
            this.statusBar1.ShowPanels = true;
            this.statusBar1.Size = new System.Drawing.Size(608, 22);
            this.statusBar1.TabIndex = 4;
            this.statusBar1.Text = "statusBar1";
            // 
            // statusBarPanel1
            // 
            this.statusBarPanel1.Name = "statusBarPanel1";
            this.statusBarPanel1.Text = "statusBarPanel1";
            // 
            // statusBarPanel2
            // 
            this.statusBarPanel2.Name = "statusBarPanel2";
            this.statusBarPanel2.Text = "statusBarPanel2";
            // 
            // statusBarPanel3
            // 
            this.statusBarPanel3.AutoSize = System.Windows.Forms.StatusBarPanelAutoSize.Spring;
            this.statusBarPanel3.Name = "statusBarPanel3";
            this.statusBarPanel3.Text = "statusBarPanel3";
            this.statusBarPanel3.Width = 391;
            // 
            // ofdWikiParseXML
            // 
            this.ofdWikiParseXML.Filter = "WikiParseXML (wikiparse_*.xml)|wikiparse_*.xml|XML (*.xml)|*.xml|All files (*.*)|" +
                "*.*";
            this.ofdWikiParseXML.InitialDirectory = ".";
            this.ofdWikiParseXML.Title = "Select WikiParseXML";
            // 
            // saveFileDialog1
            // 
            this.saveFileDialog1.DefaultExt = "txt";
            this.saveFileDialog1.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*";
            this.saveFileDialog1.InitialDirectory = ".";
            // 
            // splitter1
            // 
            this.splitter1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.splitter1.Location = new System.Drawing.Point(0, 152);
            this.splitter1.Name = "splitter1";
            this.splitter1.Size = new System.Drawing.Size(608, 3);
            this.splitter1.TabIndex = 2;
            this.splitter1.TabStop = false;
            // 
            // listBox1
            // 
            this.listBox1.Dock = System.Windows.Forms.DockStyle.Right;
            this.listBox1.HorizontalScrollbar = true;
            this.listBox1.IntegralHeight = false;
            this.listBox1.ItemHeight = 16;
            this.listBox1.Location = new System.Drawing.Point(360, 0);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(248, 152);
            this.listBox1.TabIndex = 1;
            this.listBox1.Visible = false;
            // 
            // textBox1
            // 
            this.textBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBox1.Location = new System.Drawing.Point(0, 0);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox1.Size = new System.Drawing.Size(360, 152);
            this.textBox1.TabIndex = 0;
            // 
            // mainMenu1
            // 
            this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
            this.menuItem1});
            // 
            // menuItem1
            // 
            this.menuItem1.Index = 0;
            this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
            this.menuItem2,
            this.menuItem3,
            this.menuItem4,
            this.menuItem10,
            this.menuItem7,
            this.menuItem8,
            this.menuItem11,
            this.menuItem9,
            this.menuItem12,
            this.menuItem5,
            this.menuItem6});
            this.menuItem1.Text = "Wiki";
            // 
            // menuItem2
            // 
            this.menuItem2.Index = 0;
            this.menuItem2.Shortcut = System.Windows.Forms.Shortcut.CtrlO;
            this.menuItem2.Text = "Open...";
            this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click);
            // 
            // menuItem3
            // 
            this.menuItem3.Index = 1;
            this.menuItem3.Shortcut = System.Windows.Forms.Shortcut.CtrlS;
            this.menuItem3.Text = "Save...";
            this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
            // 
            // menuItem4
            // 
            this.menuItem4.Index = 2;
            this.menuItem4.Shortcut = System.Windows.Forms.Shortcut.CtrlH;
            this.menuItem4.Text = "WikiParseXML...";
            this.menuItem4.Click += new System.EventHandler(this.menuItem4_Click);
            // 
            // menuItem10
            // 
            this.menuItem10.Index = 3;
            this.menuItem10.Text = "-";
            // 
            // menuItem7
            // 
            this.menuItem7.Index = 4;
            this.menuItem7.Shortcut = System.Windows.Forms.Shortcut.CtrlA;
            this.menuItem7.Text = "select all";
            this.menuItem7.Visible = false;
            this.menuItem7.Click += new System.EventHandler(this.menuItem7_Click);
            // 
            // menuItem8
            // 
            this.menuItem8.Index = 5;
            this.menuItem8.Shortcut = System.Windows.Forms.Shortcut.CtrlW;
            this.menuItem8.Text = "toggle wrap";
            this.menuItem8.Visible = false;
            this.menuItem8.Click += new System.EventHandler(this.menuItem8_Click);
            // 
            // menuItem11
            // 
            this.menuItem11.Index = 6;
            this.menuItem11.Shortcut = System.Windows.Forms.Shortcut.F5;
            this.menuItem11.Text = "Refresh";
            this.menuItem11.Click += new System.EventHandler(this.menuItem11_Click);
            // 
            // menuItem9
            // 
            this.menuItem9.Index = 7;
            this.menuItem9.Shortcut = System.Windows.Forms.Shortcut.F8;
            this.menuItem9.Text = "Show HTML";
            this.menuItem9.Click += new System.EventHandler(this.menuItem9_Click);
            // 
            // menuItem12
            // 
            this.menuItem12.Index = 8;
            this.menuItem12.Shortcut = System.Windows.Forms.Shortcut.F9;
            this.menuItem12.Text = "Show Wikis";
            this.menuItem12.Click += new System.EventHandler(this.menuItem12_Click);
            // 
            // menuItem5
            // 
            this.menuItem5.Index = 9;
            this.menuItem5.Text = "-";
            // 
            // menuItem6
            // 
            this.menuItem6.Index = 10;
            this.menuItem6.Text = "Exit";
            this.menuItem6.Click += new System.EventHandler(this.menuItem6_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.DefaultExt = "txt";
            this.openFileDialog1.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*";
            this.openFileDialog1.InitialDirectory = ".";
            // 
            // webBrowser1
            // 
            this.webBrowser1.AllowWebBrowserDrop = false;
            this.webBrowser1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webBrowser1.Location = new System.Drawing.Point(0, 0);
            this.webBrowser1.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser1.Name = "webBrowser1";
            this.webBrowser1.Size = new System.Drawing.Size(604, 138);
            this.webBrowser1.TabIndex = 5;
            this.webBrowser1.StatusTextChanged += new System.EventHandler(this.webBrowser1_StatusTextChanged);
            this.webBrowser1.Navigated += new System.Windows.Forms.WebBrowserNavigatedEventHandler(this.webBrowser1_Navigated);
            this.webBrowser1.Navigating += new System.Windows.Forms.WebBrowserNavigatingEventHandler(this.webBrowser1_Navigating);
            this.webBrowser1.NewWindow += new System.ComponentModel.CancelEventHandler(this.webBrowser1_NewWindow);
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel1.Controls.Add(this.webBrowser1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel1.Location = new System.Drawing.Point(0, 155);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(608, 142);
            this.panel1.TabIndex = 6;
            // 
            // WikiEditMainForm
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(7, 17);
            this.ClientSize = new System.Drawing.Size(608, 319);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.listBox1);
            this.Controls.Add(this.splitter1);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.statusBar1);
            this.Font = new System.Drawing.Font("Verdana", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Menu = this.mainMenu1;
            this.Name = "WikiEditMainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds;
            this.Text = "WikiEdit";
            this.Closed += new System.EventHandler(this.WikiEditMainForm_Closed);
            this.VisibleChanged += new System.EventHandler(this.WikiEditMainForm_VisibleChanged);
            this.Load += new System.EventHandler(this.WikiEditMainForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel3)).EndInit();
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.Run(new WikiEditMainForm());
        }

        private Engine Engine = new Engine();
        private bool AllowNavigate;
        private bool WebLoaded;
        private string IniPath = Application.LocalUserAppDataPath + Path.DirectorySeparatorChar + "WikiEdit.ini";
        private StubChecker Checker;

        private void WikiEditMainForm_Load(object sender, System.EventArgs e)
        {
            Application.ThreadException += new System.Threading.ThreadExceptionEventHandler(Application_ThreadException);

            //load settings
            XmlDocument ini = GetIniXml();
            XmlElement iniBounds = ini.DocumentElement.SelectSingleNode("bounds") as XmlElement;
            if (iniBounds != null)
            {
                if (Convert.ToInt32(iniBounds.GetAttribute("maximized")) != 0)
                    WindowState = FormWindowState.Maximized;
                else
                    Bounds = XmlToRect(iniBounds);
                webBrowser1.Height = Convert.ToInt32(iniBounds.GetAttribute("preview"));
            }
            XmlElement iniWrap = ini.DocumentElement.SelectSingleNode("wrap") as XmlElement;
            if (iniWrap != null) textBox1.WordWrap = Convert.ToBoolean(iniWrap.InnerText);

            //which WikiParseXML to load?
            string[] args = Environment.GetCommandLineArgs();
            string wpxml;
            if (args.Length <= 1)
            {
                if (ofdWikiParseXML.ShowDialog() == DialogResult.OK)
                    wpxml = ofdWikiParseXML.FileName;
                else
                {
                    Application.Exit();
                    return;
                }
            }
            else
                wpxml = args[1];

            //load WikiParseXml
            Checker = new StubChecker();
            Engine.PageCheck = Checker;
            Engine.WikiParseXml = wpxml;
            statusBarPanel1.Text = Engine.WikiParseXmlLoadTime.ToString() + " ms";
            Text = Engine.WikiParseXml;

            //set up flags, HTML is loaded on visible
            Application.Idle += new EventHandler(Application_Idle);
            AllowNavigate = false;
            WebLoaded = false;
        }

        private void WikiEditMainForm_VisibleChanged(object sender, System.EventArgs e)
        {
            AllowNavigate = true;
            webBrowser1.Navigate("file://" + Path.GetDirectoryName(Application.ExecutablePath) + Path.DirectorySeparatorChar + "WikiEdit.html");
        }

        private void WikiEditMainForm_Closed(object sender, System.EventArgs e)
        {
            XmlDocument ini = GetIniXml();
            XmlElement iniBounds = ForceElement(ini, "bounds");
            RectToXml(Bounds, iniBounds);
            iniBounds.SetAttribute("maximized", WindowState == FormWindowState.Maximized ? "1" : "0");
            iniBounds.SetAttribute("preview", webBrowser1.Height.ToString());
            ForceElement(ini, "wrap").InnerText = Convert.ToString(textBox1.WordWrap);
            ini.Save(IniPath);
        }

        private void Application_Idle(object sender, EventArgs e)
        {
            if (textBox1.Modified && WebLoaded)
            {
                try
                {
                    HtmlElement body = webBrowser1.Document.Body;
                    float pre = body.ScrollRectangle.Height - body.ClientRectangle.Height == 0 ? -1 : body.ScrollTop / body.ScrollRectangle.Height - body.ClientRectangle.Height;

                    body.InnerHtml = Engine.Render(textBox1.Text);
                    statusBarPanel2.Text = Engine.LastCallTime.ToString() + " ms";

                    if (pre == -1 || textBox1.SelectionStart == textBox1.Text.Length)
                        body.ScrollTop = body.ScrollRectangle.Height;
                    else
                        body.ScrollTop = Convert.ToInt32((body.ScrollRectangle.Height - body.ClientRectangle.Height) * pre);
                }
                catch (Exception ex)
                {
                    webBrowser1.Document.Body.InnerText = ex.ToString();
                    statusBarPanel2.Text = "ERROR " + Engine.LastCallTime.ToString() + " ms";
                }
                listBox1.Items.Clear();
                bool mods = Engine.Modifications.Count > 0;
                foreach (WikiModification mod in Engine.Modifications) listBox1.Items.Add(mod.Name + "=" + mod.Value);
                listBox1.Visible = mods;
                textBox1.Modified = false;
            }
        }

        private void webBrowser1_Navigating(object sender, WebBrowserNavigatingEventArgs e)
        {
            if (AllowNavigate)
            {
                AllowNavigate = false;
                WebLoaded = false;
            }
            else e.Cancel = true;
        }

        private void webBrowser1_Navigated(object sender, WebBrowserNavigatedEventArgs e)
        {
            WebLoaded = true;
            textBox1.Focus();
        }

        private void webBrowser1_StatusTextChanged(object sender, EventArgs e)
        {
            statusBarPanel3.Text = webBrowser1.StatusText;
        }

        private void webBrowser1_NewWindow(object sender, CancelEventArgs e)
        {
            e.Cancel = true;
        }

        private void menuItem6_Click(object sender, System.EventArgs e)
        {
            Close();
        }

        private void menuItem7_Click(object sender, System.EventArgs e)
        {
            textBox1.SelectAll();
        }

        private void menuItem8_Click(object sender, System.EventArgs e)
        {
            textBox1.WordWrap = !textBox1.WordWrap;
        }

        private void menuItem9_Click(object sender, System.EventArgs e)
        {
            webBrowser1.Document.Body.InnerText = Engine.Render(textBox1.Text);
        }

        private void menuItem12_Click(object sender, System.EventArgs e)
        {
            Checker.ListChecks = new ArrayList();
            Engine.Render(textBox1.Text);
            StringBuilder sb = new StringBuilder();
            foreach (string s in Checker.ListChecks)
            {
                sb.Append(s);
                sb.Append("\x0A\x0D");
            }
            webBrowser1.Document.Body.InnerText = sb.ToString();
            Checker.ListChecks = null;
        }

        private void menuItem2_Click(object sender, System.EventArgs e)
        {
            if (openFileDialog1.ShowDialog(this) == DialogResult.OK)
            {
                StreamReader s = new StreamReader(openFileDialog1.FileName);
                textBox1.Text = s.ReadToEnd();
                textBox1.Modified = true;
                s.Close();
            }
        }

        private void menuItem3_Click(object sender, System.EventArgs e)
        {
            if (saveFileDialog1.ShowDialog(this) == DialogResult.OK)
            {
                StreamWriter s = new StreamWriter(saveFileDialog1.FileName);
                s.Write(textBox1.Text);
                s.Close();
            }
        }

        private void menuItem4_Click(object sender, System.EventArgs e)
        {
            if (ofdWikiParseXML.ShowDialog(this) == DialogResult.OK)
            {
                Engine.WikiParseXml = ofdWikiParseXML.FileName;
                statusBarPanel1.Text = Engine.WikiParseXmlLoadTime.ToString() + " ms";
                Text = Engine.WikiParseXml;
                textBox1.Modified = true;
            }
        }

        private void menuItem11_Click(object sender, System.EventArgs e)
        {
            AllowNavigate = true;
            webBrowser1.Navigate("file://" + Path.GetDirectoryName(Application.ExecutablePath) + Path.DirectorySeparatorChar + "WikiEdit.html");
            Engine.WikiParseXml = Engine.WikiParseXml;
            statusBarPanel1.Text = Engine.WikiParseXmlLoadTime.ToString() + " ms";
            Text = Engine.WikiParseXml;
            textBox1.Modified = true;
        }

        private XmlDocument GetIniXml()
        {
            XmlDocument ini = new XmlDocument();
            if (File.Exists(IniPath)) ini.Load(IniPath); else ini.LoadXml("<settings />");
            return ini;
        }

        private Rectangle XmlToRect(XmlElement Element)
        {
            return new Rectangle(
                Convert.ToInt32(Element.GetAttribute("left")),
                Convert.ToInt32(Element.GetAttribute("top")),
                Convert.ToInt32(Element.GetAttribute("width")),
                Convert.ToInt32(Element.GetAttribute("height"))
                );
        }

        private void RectToXml(Rectangle Rect, XmlElement Element)
        {
            Element.SetAttribute("left", Rect.Left.ToString());
            Element.SetAttribute("top", Rect.Top.ToString());
            Element.SetAttribute("width", Rect.Width.ToString());
            Element.SetAttribute("height", Rect.Height.ToString());
        }

        private XmlElement ForceElement(XmlDocument doc, string NodeName)
        {
            XmlElement res = doc.DocumentElement.SelectSingleNode(NodeName) as XmlElement;
            //support advanced XPath?
            if (res == null)
            {
                res = doc.CreateElement(NodeName);
                doc.DocumentElement.AppendChild(res);
            }
            return res;
        }

        private void Application_ThreadException(object sender, System.Threading.ThreadExceptionEventArgs e)
        {
            MessageBox.Show(this, e.Exception.ToString(), "Exception occurred", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

    }

    internal class StubChecker : IWikiPageCheck
    {
        public ArrayList ListChecks = null;

        public bool CheckPage(ref string Name)
        {
            if (ListChecks != null) ListChecks.Add(Name);
            return true;
        }
        public void StripGroup(string Name, ref string Group, ref string NameOnly)
        {
            //stub, not used
        }
        public bool SupportsGroups { get { return false; } }
        public bool Groups { get { return false; } set { } }
        public string CurrentGroup { get { return ""; } set { } }
    }
}
