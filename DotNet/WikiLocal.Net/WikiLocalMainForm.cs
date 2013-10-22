using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Xml;
using System.IO;
using WikiEngine;
using System.Text.RegularExpressions;

namespace WikiLocal.Net
{
    /// <summary>
    /// Summary description for Form1.
    /// </summary>
    public class WikiLocalMainForm : System.Windows.Forms.Form
    {
        private Panel panel1;
        private ComboBox cbPage;
        private Button btnEdit;
        private Button btnGo;
        private SplitContainer scMain;
        private Label lblSidebarTitle;
        private Label lblPageTitle;
        private SplitContainer scPage;
        private SplitContainer scPageEdit;
        private Panel panel2;
        private Button btnCancel;
        private Button btnReset;
        private Button btnSave;
        private ListBox lbModifications;
        private WebBrowser wbSidebar;
        private TextBox txtEdit;
        private Label lblPageInfo;
        private WebBrowser wbPage;
        private ContextMenuStrip cmsSideBar;
        private ContextMenuStrip cmsRedirect;
        private ContextMenuStrip cmsPage;
        private StatusStrip statusStrip1;
        private ToolStripStatusLabel toolStripStatusLabel1;
        private ToolStripStatusLabel toolStripStatusLabel2;
        private ToolStripStatusLabel toolStripStatusLabel3;
        private TreeView tvSideList;
        private Button btnCloseSideList;
        private Panel panSearch;
        private Button btnSearch;
        private Label label1;
        private CheckBox cbSearchCaseSensitive;
        private CheckBox cbSearchRegEx;
        private TextBox txtSearchText;
        private ToolStripMenuItem editSidebarToolStripMenuItem;
        private ToolStripMenuItem searchToolStripMenuItem1;
        private ToolStripSeparator toolStripMenuItem3;
        private ToolStripMenuItem linksToolStripMenuItem1;
        private ToolStripMenuItem backlinksToolStripMenuItem1;
        private ToolStripMenuItem editToolStripMenuItem;
        private ToolStripMenuItem searchToolStripMenuItem;
        private ToolStripSeparator toolStripMenuItem1;
        private ToolStripMenuItem homePAgeToolStripMenuItem;
        private ToolStripMenuItem mainHomePageToolStripMenuItem;
        private ToolStripSeparator toolStripMenuItem2;
        private ToolStripMenuItem linksToolStripMenuItem;
        private ToolStripMenuItem backlinksToolStripMenuItem;
        private MenuStrip menuStrip1;
        private ToolStripMenuItem wikiLocalToolStripMenuItem;
        private ToolStripMenuItem toolStripMenuItem4;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripMenuItem toolStripMenuItem6;
        private ToolStripMenuItem toolStripMenuItem7;
        private ToolStripMenuItem toolStripMenuItem8;
        private ToolStripMenuItem toolStripMenuItem9;
        private ToolStripSeparator toolStripSeparator2;
        private ToolStripMenuItem toolStripMenuItem10;
        private ToolStripMenuItem toolStripMenuItem11;
        private ToolStripSeparator toolStripSeparator3;
        private ToolStripMenuItem toolStripMenuItem12;
        private ToolStripMenuItem toolStripMenuItem13;
        private Label lblMatchCount;
        private IContainer components;

        public WikiLocalMainForm()
        {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(WikiLocalMainForm));
            this.panel1 = new System.Windows.Forms.Panel();
            this.cbPage = new System.Windows.Forms.ComboBox();
            this.btnGo = new System.Windows.Forms.Button();
            this.btnEdit = new System.Windows.Forms.Button();
            this.scMain = new System.Windows.Forms.SplitContainer();
            this.tvSideList = new System.Windows.Forms.TreeView();
            this.btnCloseSideList = new System.Windows.Forms.Button();
            this.panSearch = new System.Windows.Forms.Panel();
            this.lblMatchCount = new System.Windows.Forms.Label();
            this.btnSearch = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.cbSearchCaseSensitive = new System.Windows.Forms.CheckBox();
            this.cbSearchRegEx = new System.Windows.Forms.CheckBox();
            this.txtSearchText = new System.Windows.Forms.TextBox();
            this.wbSidebar = new System.Windows.Forms.WebBrowser();
            this.lblSidebarTitle = new System.Windows.Forms.Label();
            this.cmsSideBar = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.editSidebarToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.searchToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripSeparator();
            this.linksToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.backlinksToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.scPage = new System.Windows.Forms.SplitContainer();
            this.scPageEdit = new System.Windows.Forms.SplitContainer();
            this.txtEdit = new System.Windows.Forms.TextBox();
            this.lbModifications = new System.Windows.Forms.ListBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnReset = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            this.wbPage = new System.Windows.Forms.WebBrowser();
            this.lblPageInfo = new System.Windows.Forms.Label();
            this.cmsRedirect = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.lblPageTitle = new System.Windows.Forms.Label();
            this.cmsPage = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.editToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.searchToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
            this.homePAgeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mainHomePageToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripSeparator();
            this.backlinksToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.linksToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel2 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel3 = new System.Windows.Forms.ToolStripStatusLabel();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.wikiLocalToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem8 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem9 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripMenuItem10 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem11 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripMenuItem12 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem13 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripMenuItem4 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem6 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem7 = new System.Windows.Forms.ToolStripMenuItem();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.scMain)).BeginInit();
            this.scMain.Panel1.SuspendLayout();
            this.scMain.Panel2.SuspendLayout();
            this.scMain.SuspendLayout();
            this.panSearch.SuspendLayout();
            this.cmsSideBar.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.scPage)).BeginInit();
            this.scPage.Panel1.SuspendLayout();
            this.scPage.Panel2.SuspendLayout();
            this.scPage.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.scPageEdit)).BeginInit();
            this.scPageEdit.Panel1.SuspendLayout();
            this.scPageEdit.Panel2.SuspendLayout();
            this.scPageEdit.SuspendLayout();
            this.panel2.SuspendLayout();
            this.cmsPage.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.cbPage);
            this.panel1.Controls.Add(this.btnGo);
            this.panel1.Controls.Add(this.btnEdit);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(566, 28);
            this.panel1.TabIndex = 0;
            // 
            // cbPage
            // 
            this.cbPage.Dock = System.Windows.Forms.DockStyle.Fill;
            this.cbPage.FormattingEnabled = true;
            this.cbPage.Location = new System.Drawing.Point(0, 0);
            this.cbPage.Name = "cbPage";
            this.cbPage.Size = new System.Drawing.Size(484, 24);
            this.cbPage.TabIndex = 2;
            this.cbPage.SelectedIndexChanged += new System.EventHandler(this.cbPage_SelectedIndexChanged);
            this.cbPage.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.cbPage_KeyPress);
            this.cbPage.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.cbPage_MouseDoubleClick);
            // 
            // btnGo
            // 
            this.btnGo.Dock = System.Windows.Forms.DockStyle.Right;
            this.btnGo.Location = new System.Drawing.Point(484, 0);
            this.btnGo.Name = "btnGo";
            this.btnGo.Size = new System.Drawing.Size(36, 28);
            this.btnGo.TabIndex = 0;
            this.btnGo.Text = "Go";
            this.btnGo.UseVisualStyleBackColor = true;
            this.btnGo.Click += new System.EventHandler(this.btnGo_Click);
            // 
            // btnEdit
            // 
            this.btnEdit.Dock = System.Windows.Forms.DockStyle.Right;
            this.btnEdit.Location = new System.Drawing.Point(520, 0);
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Size = new System.Drawing.Size(46, 28);
            this.btnEdit.TabIndex = 1;
            this.btnEdit.Text = "Edit";
            this.btnEdit.UseVisualStyleBackColor = true;
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // scMain
            // 
            this.scMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.scMain.Location = new System.Drawing.Point(0, 28);
            this.scMain.Name = "scMain";
            // 
            // scMain.Panel1
            // 
            this.scMain.Panel1.Controls.Add(this.tvSideList);
            this.scMain.Panel1.Controls.Add(this.btnCloseSideList);
            this.scMain.Panel1.Controls.Add(this.panSearch);
            this.scMain.Panel1.Controls.Add(this.wbSidebar);
            this.scMain.Panel1.Controls.Add(this.lblSidebarTitle);
            // 
            // scMain.Panel2
            // 
            this.scMain.Panel2.Controls.Add(this.scPage);
            this.scMain.Size = new System.Drawing.Size(566, 349);
            this.scMain.SplitterDistance = 188;
            this.scMain.TabIndex = 1;
            // 
            // tvSideList
            // 
            this.tvSideList.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.tvSideList.Location = new System.Drawing.Point(4, 255);
            this.tvSideList.Name = "tvSideList";
            this.tvSideList.Size = new System.Drawing.Size(42, 42);
            this.tvSideList.TabIndex = 4;
            this.tvSideList.Visible = false;
            this.tvSideList.BeforeExpand += new System.Windows.Forms.TreeViewCancelEventHandler(this.tvSideList_BeforeExpand);
            this.tvSideList.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.tvSideList_AfterSelect);
            // 
            // btnCloseSideList
            // 
            this.btnCloseSideList.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCloseSideList.Location = new System.Drawing.Point(158, 4);
            this.btnCloseSideList.Name = "btnCloseSideList";
            this.btnCloseSideList.Size = new System.Drawing.Size(25, 25);
            this.btnCloseSideList.TabIndex = 3;
            this.btnCloseSideList.Text = "x";
            this.btnCloseSideList.UseVisualStyleBackColor = true;
            this.btnCloseSideList.Visible = false;
            this.btnCloseSideList.Click += new System.EventHandler(this.btnCloseSideList_Click);
            // 
            // panSearch
            // 
            this.panSearch.Controls.Add(this.lblMatchCount);
            this.panSearch.Controls.Add(this.btnSearch);
            this.panSearch.Controls.Add(this.label1);
            this.panSearch.Controls.Add(this.cbSearchCaseSensitive);
            this.panSearch.Controls.Add(this.cbSearchRegEx);
            this.panSearch.Controls.Add(this.txtSearchText);
            this.panSearch.Dock = System.Windows.Forms.DockStyle.Top;
            this.panSearch.Location = new System.Drawing.Point(0, 32);
            this.panSearch.Name = "panSearch";
            this.panSearch.Size = new System.Drawing.Size(188, 169);
            this.panSearch.TabIndex = 2;
            this.panSearch.Visible = false;
            // 
            // lblMatchCount
            // 
            this.lblMatchCount.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lblMatchCount.Location = new System.Drawing.Point(1, 140);
            this.lblMatchCount.Name = "lblMatchCount";
            this.lblMatchCount.Size = new System.Drawing.Size(182, 21);
            this.lblMatchCount.TabIndex = 5;
            this.lblMatchCount.Text = "...";
            // 
            // btnSearch
            // 
            this.btnSearch.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSearch.Location = new System.Drawing.Point(4, 109);
            this.btnSearch.Name = "btnSearch";
            this.btnSearch.Size = new System.Drawing.Size(179, 28);
            this.btnSearch.TabIndex = 4;
            this.btnSearch.Text = "Search";
            this.btnSearch.UseVisualStyleBackColor = true;
            this.btnSearch.Click += new System.EventHandler(this.btnSearch_Click);
            // 
            // label1
            // 
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.Location = new System.Drawing.Point(1, 4);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(182, 17);
            this.label1.TabIndex = 3;
            this.label1.Text = "&Search";
            // 
            // cbSearchCaseSensitive
            // 
            this.cbSearchCaseSensitive.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cbSearchCaseSensitive.Location = new System.Drawing.Point(4, 81);
            this.cbSearchCaseSensitive.Name = "cbSearchCaseSensitive";
            this.cbSearchCaseSensitive.Size = new System.Drawing.Size(179, 21);
            this.cbSearchCaseSensitive.TabIndex = 2;
            this.cbSearchCaseSensitive.Text = "&Case sensitive";
            this.cbSearchCaseSensitive.UseVisualStyleBackColor = true;
            // 
            // cbSearchRegEx
            // 
            this.cbSearchRegEx.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cbSearchRegEx.Location = new System.Drawing.Point(4, 54);
            this.cbSearchRegEx.Name = "cbSearchRegEx";
            this.cbSearchRegEx.Size = new System.Drawing.Size(179, 21);
            this.cbSearchRegEx.TabIndex = 1;
            this.cbSearchRegEx.Text = "&Regular expression";
            this.cbSearchRegEx.UseVisualStyleBackColor = true;
            // 
            // txtSearchText
            // 
            this.txtSearchText.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtSearchText.Location = new System.Drawing.Point(4, 24);
            this.txtSearchText.Name = "txtSearchText";
            this.txtSearchText.Size = new System.Drawing.Size(179, 24);
            this.txtSearchText.TabIndex = 0;
            this.txtSearchText.Enter += new System.EventHandler(this.txtSearchText_Enter);
            this.txtSearchText.Leave += new System.EventHandler(this.txtSearchText_Leave);
            // 
            // wbSidebar
            // 
            this.wbSidebar.Location = new System.Drawing.Point(4, 207);
            this.wbSidebar.MinimumSize = new System.Drawing.Size(20, 20);
            this.wbSidebar.Name = "wbSidebar";
            this.wbSidebar.Size = new System.Drawing.Size(42, 42);
            this.wbSidebar.TabIndex = 1;
            this.wbSidebar.Navigated += new System.Windows.Forms.WebBrowserNavigatedEventHandler(this.wbSidebar_Navigated);
            this.wbSidebar.Navigating += new System.Windows.Forms.WebBrowserNavigatingEventHandler(this.wbSidebar_Navigating);
            this.wbSidebar.NewWindow += new System.ComponentModel.CancelEventHandler(this.wbSidebar_NewWindow);
            this.wbSidebar.StatusTextChanged += new System.EventHandler(this.wbSidebar_StatusTextChanged);
            // 
            // lblSidebarTitle
            // 
            this.lblSidebarTitle.BackColor = System.Drawing.SystemColors.InactiveCaption;
            this.lblSidebarTitle.ContextMenuStrip = this.cmsSideBar;
            this.lblSidebarTitle.Dock = System.Windows.Forms.DockStyle.Top;
            this.lblSidebarTitle.Font = new System.Drawing.Font("Verdana", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblSidebarTitle.ForeColor = System.Drawing.SystemColors.InactiveCaptionText;
            this.lblSidebarTitle.Location = new System.Drawing.Point(0, 0);
            this.lblSidebarTitle.Name = "lblSidebarTitle";
            this.lblSidebarTitle.Padding = new System.Windows.Forms.Padding(4);
            this.lblSidebarTitle.Size = new System.Drawing.Size(188, 32);
            this.lblSidebarTitle.TabIndex = 0;
            this.lblSidebarTitle.Text = "Main";
            this.lblSidebarTitle.DoubleClick += new System.EventHandler(this.lblSidebarTitle_DoubleClick);
            // 
            // cmsSideBar
            // 
            this.cmsSideBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.editSidebarToolStripMenuItem,
            this.searchToolStripMenuItem1,
            this.toolStripMenuItem3,
            this.linksToolStripMenuItem1,
            this.backlinksToolStripMenuItem1});
            this.cmsSideBar.Name = "cmsSideBar";
            this.cmsSideBar.Size = new System.Drawing.Size(206, 98);
            // 
            // editSidebarToolStripMenuItem
            // 
            this.editSidebarToolStripMenuItem.Name = "editSidebarToolStripMenuItem";
            this.editSidebarToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Shift | System.Windows.Forms.Keys.F2)));
            this.editSidebarToolStripMenuItem.Size = new System.Drawing.Size(205, 22);
            this.editSidebarToolStripMenuItem.Text = "Edit Sidebar";
            this.editSidebarToolStripMenuItem.Click += new System.EventHandler(this.lblSidebarTitle_DoubleClick);
            // 
            // searchToolStripMenuItem1
            // 
            this.searchToolStripMenuItem1.Name = "searchToolStripMenuItem1";
            this.searchToolStripMenuItem1.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.F)));
            this.searchToolStripMenuItem1.Size = new System.Drawing.Size(205, 22);
            this.searchToolStripMenuItem1.Text = "Search...";
            this.searchToolStripMenuItem1.Click += new System.EventHandler(this.searchToolStripMenuItem_Click);
            // 
            // toolStripMenuItem3
            // 
            this.toolStripMenuItem3.Name = "toolStripMenuItem3";
            this.toolStripMenuItem3.Size = new System.Drawing.Size(202, 6);
            // 
            // linksToolStripMenuItem1
            // 
            this.linksToolStripMenuItem1.Name = "linksToolStripMenuItem1";
            this.linksToolStripMenuItem1.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.L)));
            this.linksToolStripMenuItem1.Size = new System.Drawing.Size(205, 22);
            this.linksToolStripMenuItem1.Text = "Links...";
            this.linksToolStripMenuItem1.Click += new System.EventHandler(this.linksToolStripMenuItem1_Click);
            // 
            // backlinksToolStripMenuItem1
            // 
            this.backlinksToolStripMenuItem1.Name = "backlinksToolStripMenuItem1";
            this.backlinksToolStripMenuItem1.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.B)));
            this.backlinksToolStripMenuItem1.Size = new System.Drawing.Size(205, 22);
            this.backlinksToolStripMenuItem1.Text = "Backlinks...";
            this.backlinksToolStripMenuItem1.Click += new System.EventHandler(this.backlinksToolStripMenuItem1_Click);
            // 
            // scPage
            // 
            this.scPage.Dock = System.Windows.Forms.DockStyle.Fill;
            this.scPage.Location = new System.Drawing.Point(0, 0);
            this.scPage.Name = "scPage";
            this.scPage.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // scPage.Panel1
            // 
            this.scPage.Panel1.Controls.Add(this.scPageEdit);
            this.scPage.Panel1.Controls.Add(this.panel2);
            // 
            // scPage.Panel2
            // 
            this.scPage.Panel2.Controls.Add(this.wbPage);
            this.scPage.Panel2.Controls.Add(this.lblPageInfo);
            this.scPage.Panel2.Controls.Add(this.lblPageTitle);
            this.scPage.Size = new System.Drawing.Size(374, 349);
            this.scPage.SplitterDistance = 143;
            this.scPage.TabIndex = 1;
            // 
            // scPageEdit
            // 
            this.scPageEdit.Dock = System.Windows.Forms.DockStyle.Fill;
            this.scPageEdit.Location = new System.Drawing.Point(0, 0);
            this.scPageEdit.Name = "scPageEdit";
            // 
            // scPageEdit.Panel1
            // 
            this.scPageEdit.Panel1.Controls.Add(this.txtEdit);
            // 
            // scPageEdit.Panel2
            // 
            this.scPageEdit.Panel2.Controls.Add(this.lbModifications);
            this.scPageEdit.Size = new System.Drawing.Size(374, 115);
            this.scPageEdit.SplitterDistance = 191;
            this.scPageEdit.TabIndex = 1;
            // 
            // txtEdit
            // 
            this.txtEdit.Dock = System.Windows.Forms.DockStyle.Fill;
            this.txtEdit.HideSelection = false;
            this.txtEdit.Location = new System.Drawing.Point(0, 0);
            this.txtEdit.Multiline = true;
            this.txtEdit.Name = "txtEdit";
            this.txtEdit.ScrollBars = System.Windows.Forms.ScrollBars.Horizontal;
            this.txtEdit.Size = new System.Drawing.Size(191, 115);
            this.txtEdit.TabIndex = 0;
            // 
            // lbModifications
            // 
            this.lbModifications.Dock = System.Windows.Forms.DockStyle.Fill;
            this.lbModifications.FormattingEnabled = true;
            this.lbModifications.ItemHeight = 16;
            this.lbModifications.Location = new System.Drawing.Point(0, 0);
            this.lbModifications.Name = "lbModifications";
            this.lbModifications.Size = new System.Drawing.Size(179, 115);
            this.lbModifications.TabIndex = 0;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.btnCancel);
            this.panel2.Controls.Add(this.btnReset);
            this.panel2.Controls.Add(this.btnSave);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel2.Location = new System.Drawing.Point(0, 115);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(374, 28);
            this.panel2.TabIndex = 0;
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(156, 0);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(72, 28);
            this.btnCancel.TabIndex = 2;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnReset
            // 
            this.btnReset.Location = new System.Drawing.Point(78, 0);
            this.btnReset.Name = "btnReset";
            this.btnReset.Size = new System.Drawing.Size(72, 28);
            this.btnReset.TabIndex = 1;
            this.btnReset.Text = "Reset";
            this.btnReset.UseVisualStyleBackColor = true;
            this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
            // 
            // btnSave
            // 
            this.btnSave.Location = new System.Drawing.Point(0, 0);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(72, 28);
            this.btnSave.TabIndex = 0;
            this.btnSave.Text = "Save";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // wbPage
            // 
            this.wbPage.Dock = System.Windows.Forms.DockStyle.Fill;
            this.wbPage.Location = new System.Drawing.Point(0, 53);
            this.wbPage.MinimumSize = new System.Drawing.Size(20, 20);
            this.wbPage.Name = "wbPage";
            this.wbPage.Size = new System.Drawing.Size(374, 149);
            this.wbPage.TabIndex = 1;
            this.wbPage.Navigated += new System.Windows.Forms.WebBrowserNavigatedEventHandler(this.wbPage_Navigated);
            this.wbPage.Navigating += new System.Windows.Forms.WebBrowserNavigatingEventHandler(this.wbPage_Navigating);
            this.wbPage.NewWindow += new System.ComponentModel.CancelEventHandler(this.wbPage_NewWindow);
            this.wbPage.StatusTextChanged += new System.EventHandler(this.wbPage_StatusTextChanged);
            // 
            // lblPageInfo
            // 
            this.lblPageInfo.BackColor = System.Drawing.SystemColors.Info;
            this.lblPageInfo.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lblPageInfo.ContextMenuStrip = this.cmsRedirect;
            this.lblPageInfo.Dock = System.Windows.Forms.DockStyle.Top;
            this.lblPageInfo.ForeColor = System.Drawing.SystemColors.InfoText;
            this.lblPageInfo.Location = new System.Drawing.Point(0, 32);
            this.lblPageInfo.Name = "lblPageInfo";
            this.lblPageInfo.Padding = new System.Windows.Forms.Padding(1);
            this.lblPageInfo.Size = new System.Drawing.Size(374, 21);
            this.lblPageInfo.TabIndex = 2;
            this.lblPageInfo.Text = "page info...";
            this.lblPageInfo.Visible = false;
            // 
            // cmsRedirect
            // 
            this.cmsRedirect.Name = "cmsRedirect";
            this.cmsRedirect.Size = new System.Drawing.Size(61, 4);
            this.cmsRedirect.Opening += new System.ComponentModel.CancelEventHandler(this.cmsRedirect_Opening);
            // 
            // lblPageTitle
            // 
            this.lblPageTitle.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.lblPageTitle.ContextMenuStrip = this.cmsPage;
            this.lblPageTitle.Dock = System.Windows.Forms.DockStyle.Top;
            this.lblPageTitle.Font = new System.Drawing.Font("Verdana", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPageTitle.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.lblPageTitle.Location = new System.Drawing.Point(0, 0);
            this.lblPageTitle.Name = "lblPageTitle";
            this.lblPageTitle.Padding = new System.Windows.Forms.Padding(4);
            this.lblPageTitle.Size = new System.Drawing.Size(374, 32);
            this.lblPageTitle.TabIndex = 0;
            this.lblPageTitle.Text = "Main.HomePage";
            this.lblPageTitle.DoubleClick += new System.EventHandler(this.btnEdit_Click);
            // 
            // cmsPage
            // 
            this.cmsPage.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.editToolStripMenuItem,
            this.searchToolStripMenuItem,
            this.toolStripMenuItem1,
            this.homePAgeToolStripMenuItem,
            this.mainHomePageToolStripMenuItem,
            this.toolStripMenuItem2,
            this.backlinksToolStripMenuItem,
            this.linksToolStripMenuItem});
            this.cmsPage.Name = "cmsPage";
            this.cmsPage.Size = new System.Drawing.Size(209, 148);
            // 
            // editToolStripMenuItem
            // 
            this.editToolStripMenuItem.Name = "editToolStripMenuItem";
            this.editToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F2;
            this.editToolStripMenuItem.Size = new System.Drawing.Size(208, 22);
            this.editToolStripMenuItem.Text = "Edit";
            this.editToolStripMenuItem.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // searchToolStripMenuItem
            // 
            this.searchToolStripMenuItem.Name = "searchToolStripMenuItem";
            this.searchToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.F)));
            this.searchToolStripMenuItem.Size = new System.Drawing.Size(208, 22);
            this.searchToolStripMenuItem.Text = "Search...";
            this.searchToolStripMenuItem.Click += new System.EventHandler(this.searchToolStripMenuItem_Click);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(205, 6);
            // 
            // homePAgeToolStripMenuItem
            // 
            this.homePAgeToolStripMenuItem.Name = "homePAgeToolStripMenuItem";
            this.homePAgeToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.H)));
            this.homePAgeToolStripMenuItem.Size = new System.Drawing.Size(208, 22);
            this.homePAgeToolStripMenuItem.Text = "HomePage";
            this.homePAgeToolStripMenuItem.Click += new System.EventHandler(this.homePAgeToolStripMenuItem_Click);
            // 
            // mainHomePageToolStripMenuItem
            // 
            this.mainHomePageToolStripMenuItem.Name = "mainHomePageToolStripMenuItem";
            this.mainHomePageToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.M)));
            this.mainHomePageToolStripMenuItem.Size = new System.Drawing.Size(208, 22);
            this.mainHomePageToolStripMenuItem.Text = "Main.HomePage";
            this.mainHomePageToolStripMenuItem.Click += new System.EventHandler(this.mainHomePageToolStripMenuItem_Click);
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(205, 6);
            // 
            // backlinksToolStripMenuItem
            // 
            this.backlinksToolStripMenuItem.Name = "backlinksToolStripMenuItem";
            this.backlinksToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.B)));
            this.backlinksToolStripMenuItem.Size = new System.Drawing.Size(208, 22);
            this.backlinksToolStripMenuItem.Text = "Backlinks...";
            this.backlinksToolStripMenuItem.Click += new System.EventHandler(this.backlinksToolStripMenuItem_Click);
            // 
            // linksToolStripMenuItem
            // 
            this.linksToolStripMenuItem.Name = "linksToolStripMenuItem";
            this.linksToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.L)));
            this.linksToolStripMenuItem.Size = new System.Drawing.Size(208, 22);
            this.linksToolStripMenuItem.Text = "Links...";
            this.linksToolStripMenuItem.Click += new System.EventHandler(this.linksToolStripMenuItem_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Font = new System.Drawing.Font("Verdana", 10F);
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1,
            this.toolStripStatusLabel2,
            this.toolStripStatusLabel3});
            this.statusStrip1.Location = new System.Drawing.Point(0, 377);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(566, 22);
            this.statusStrip1.TabIndex = 2;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(23, 17);
            this.toolStripStatusLabel1.Text = "...";
            // 
            // toolStripStatusLabel2
            // 
            this.toolStripStatusLabel2.Name = "toolStripStatusLabel2";
            this.toolStripStatusLabel2.Size = new System.Drawing.Size(23, 17);
            this.toolStripStatusLabel2.Text = "...";
            // 
            // toolStripStatusLabel3
            // 
            this.toolStripStatusLabel3.Name = "toolStripStatusLabel3";
            this.toolStripStatusLabel3.Size = new System.Drawing.Size(23, 17);
            this.toolStripStatusLabel3.Text = "...";
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.wikiLocalToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 28);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(566, 24);
            this.menuStrip1.TabIndex = 3;
            this.menuStrip1.Text = "menuStrip1";
            this.menuStrip1.Visible = false;
            // 
            // wikiLocalToolStripMenuItem
            // 
            this.wikiLocalToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem8,
            this.toolStripMenuItem9,
            this.toolStripSeparator2,
            this.toolStripMenuItem10,
            this.toolStripMenuItem11,
            this.toolStripSeparator3,
            this.toolStripMenuItem12,
            this.toolStripMenuItem13,
            this.toolStripSeparator1,
            this.toolStripMenuItem4,
            this.toolStripMenuItem6,
            this.toolStripMenuItem7});
            this.wikiLocalToolStripMenuItem.Name = "wikiLocalToolStripMenuItem";
            this.wikiLocalToolStripMenuItem.Size = new System.Drawing.Size(70, 20);
            this.wikiLocalToolStripMenuItem.Text = "WikiLocal";
            // 
            // toolStripMenuItem8
            // 
            this.toolStripMenuItem8.Name = "toolStripMenuItem8";
            this.toolStripMenuItem8.ShortcutKeys = System.Windows.Forms.Keys.F2;
            this.toolStripMenuItem8.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem8.Text = "Edit";
            this.toolStripMenuItem8.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // toolStripMenuItem9
            // 
            this.toolStripMenuItem9.Name = "toolStripMenuItem9";
            this.toolStripMenuItem9.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.F)));
            this.toolStripMenuItem9.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem9.Text = "Search...";
            this.toolStripMenuItem9.Click += new System.EventHandler(this.searchToolStripMenuItem_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(205, 6);
            // 
            // toolStripMenuItem10
            // 
            this.toolStripMenuItem10.Name = "toolStripMenuItem10";
            this.toolStripMenuItem10.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.H)));
            this.toolStripMenuItem10.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem10.Text = "HomePage";
            this.toolStripMenuItem10.Click += new System.EventHandler(this.homePAgeToolStripMenuItem_Click);
            // 
            // toolStripMenuItem11
            // 
            this.toolStripMenuItem11.Name = "toolStripMenuItem11";
            this.toolStripMenuItem11.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.M)));
            this.toolStripMenuItem11.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem11.Text = "Main.HomePage";
            this.toolStripMenuItem11.Click += new System.EventHandler(this.mainHomePageToolStripMenuItem_Click);
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(205, 6);
            // 
            // toolStripMenuItem12
            // 
            this.toolStripMenuItem12.Name = "toolStripMenuItem12";
            this.toolStripMenuItem12.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.L)));
            this.toolStripMenuItem12.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem12.Text = "Links...";
            this.toolStripMenuItem12.Click += new System.EventHandler(this.linksToolStripMenuItem_Click);
            // 
            // toolStripMenuItem13
            // 
            this.toolStripMenuItem13.Name = "toolStripMenuItem13";
            this.toolStripMenuItem13.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.B)));
            this.toolStripMenuItem13.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem13.Text = "Backlinks...";
            this.toolStripMenuItem13.Click += new System.EventHandler(this.backlinksToolStripMenuItem_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(205, 6);
            // 
            // toolStripMenuItem4
            // 
            this.toolStripMenuItem4.Name = "toolStripMenuItem4";
            this.toolStripMenuItem4.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Shift | System.Windows.Forms.Keys.F2)));
            this.toolStripMenuItem4.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem4.Text = "Edit Sidebar";
            this.toolStripMenuItem4.Click += new System.EventHandler(this.lblSidebarTitle_DoubleClick);
            // 
            // toolStripMenuItem6
            // 
            this.toolStripMenuItem6.Name = "toolStripMenuItem6";
            this.toolStripMenuItem6.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.L)));
            this.toolStripMenuItem6.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem6.Text = "Links...";
            this.toolStripMenuItem6.Click += new System.EventHandler(this.linksToolStripMenuItem1_Click);
            // 
            // toolStripMenuItem7
            // 
            this.toolStripMenuItem7.Name = "toolStripMenuItem7";
            this.toolStripMenuItem7.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.B)));
            this.toolStripMenuItem7.Size = new System.Drawing.Size(208, 22);
            this.toolStripMenuItem7.Text = "Backlinks...";
            this.toolStripMenuItem7.Click += new System.EventHandler(this.backlinksToolStripMenuItem1_Click);
            // 
            // WikiLocalMainForm
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(7, 17);
            this.ClientSize = new System.Drawing.Size(566, 399);
            this.Controls.Add(this.scMain);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.menuStrip1);
            this.Controls.Add(this.panel1);
            this.Font = new System.Drawing.Font("Verdana", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "WikiLocalMainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds;
            this.Text = "WikiLocal";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.WikiLocalMainForm_FormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.WikiLocalMainForm_FormClosed);
            this.Load += new System.EventHandler(this.WikiLocalMainForm_Load);
            this.VisibleChanged += new System.EventHandler(this.WikiLocalMainForm_VisibleChanged);
            this.panel1.ResumeLayout(false);
            this.scMain.Panel1.ResumeLayout(false);
            this.scMain.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.scMain)).EndInit();
            this.scMain.ResumeLayout(false);
            this.panSearch.ResumeLayout(false);
            this.panSearch.PerformLayout();
            this.cmsSideBar.ResumeLayout(false);
            this.scPage.Panel1.ResumeLayout(false);
            this.scPage.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.scPage)).EndInit();
            this.scPage.ResumeLayout(false);
            this.scPageEdit.Panel1.ResumeLayout(false);
            this.scPageEdit.Panel1.PerformLayout();
            this.scPageEdit.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.scPageEdit)).EndInit();
            this.scPageEdit.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.cmsPage.ResumeLayout(false);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
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
            Application.Run(new WikiLocalMainForm());
        }

        private void WikiLocalMainForm_Load(object sender, System.EventArgs e)
        {
            Application.ThreadException += new System.Threading.ThreadExceptionEventHandler(Application_ThreadException);

            wbSidebar.Dock = DockStyle.Fill;
            tvSideList.Dock = DockStyle.Fill;

            //default view
            IsEditing = false;

            //load settings
            XmlDocument ini = GetIniXml();
            XmlElement iniBounds = ini.DocumentElement.SelectSingleNode("bounds") as XmlElement;
            if (iniBounds != null)
            {
                if (Convert.ToInt32(iniBounds.GetAttribute("maximized")) != 0)
                    WindowState = FormWindowState.Maximized;
                else
                    Bounds = XmlToRect(iniBounds);
                scMain.SplitterDistance = Convert.ToInt32(iniBounds.GetAttribute("sidebar"));
                scPage.SplitterDistance = Convert.ToInt32(iniBounds.GetAttribute("pageedit"));
                scPageEdit.SplitterDistance = Convert.ToInt32(iniBounds.GetAttribute("commands"));
            }
            //XmlElement iniWrap = ini.DocumentElement.SelectSingleNode("wrap") as XmlElement;
            //if (iniWrap != null) textBox1.WordWrap = Convert.ToBoolean(iniWrap.InnerText);
            ///TODO: wordwrap?

            string wikiDir = @".\WikiLocal";
            //TODO: applicationsetting?
            //TODO: optionally alternative path by parameter
            //expandpath?
            Storage = new WikiLocalStorage(wikiDir);
            RedirectTrail = new SortedStringList();

            //which WikiParseXML to load?

            string wpx = Path.GetDirectoryName(Application.ExecutablePath) + Path.DirectorySeparatorChar + "WikiLocal.xml";
            if (!File.Exists(wpx))
                MessageBox.Show("File not found \"" + wpx + "\"", "WikiLocal.Net", MessageBoxButtons.OK, MessageBoxIcon.Error);

            //load WikiParseXml
            Engine.PageCheck = Storage;
            try
            {
                Engine.WikiParseXml = wpx;
                toolStripStatusLabel1.Text = Engine.WikiParseXmlLoadTime.ToString() + " ms";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading WikiParseXML \"" + wpx + "\":\r\n" + ex.ToString(), "WikiLocal.Net", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            //set up flags, HTML is loaded on visible
            // (moved to first wbPage_Navigated
            //Application.Idle += new EventHandler(Application_Idle);
        }

        private bool wbPageAllowNav = false;
        private bool wbPageLoaded = false;
        private bool wbSidebarAllowNav = false;
        private bool wbSidebarLoaded = false;
        private bool wbPageFirstLoad = true;
        private bool pageModified = false;
        private bool SetEditing = false;
        private SortedStringList RedirectTrail;

        private void WikiLocalMainForm_VisibleChanged(object sender, EventArgs e)
        {
            string WikiLocalHtml = Path.GetDirectoryName(Application.ExecutablePath) + Path.DirectorySeparatorChar + "WikiLocal.html";
            if (!File.Exists(WikiLocalHtml))
                MessageBox.Show("File not found \"" + WikiLocalHtml + "\"", "WikiLocal.Net", MessageBoxButtons.OK, MessageBoxIcon.Error);
            wbPageAllowNav = true;
            wbPage.Navigate("file://" + WikiLocalHtml);
            wbSidebarAllowNav = true;
            wbSidebar.Navigate("file://" + WikiLocalHtml);
        }

        private void WikiLocalMainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            XmlDocument ini = GetIniXml();
            XmlElement iniBounds = ForceElement(ini, "bounds");
            RectToXml(Bounds, iniBounds);
            iniBounds.SetAttribute("maximized", WindowState == FormWindowState.Maximized ? "1" : "0");
            iniBounds.SetAttribute("sidebar", scMain.SplitterDistance.ToString());
            iniBounds.SetAttribute("pageedit", scPage.SplitterDistance.ToString());
            iniBounds.SetAttribute("commands", scPageEdit.SplitterDistance.ToString());
            //ForceElement(ini, "wrap").InnerText = Convert.ToString(textBox1.WordWrap);
            ini.Save(IniPath);
        }

        void Application_Idle(object sender, EventArgs e)
        {
            if (DoMain && wbPageLoaded)
            {
                try
                {
                    HtmlElement body = wbPage.Document.Body;
                    float pre = body.ScrollRectangle.Height - body.ClientRectangle.Height == 0 ? -1 : body.ScrollTop / body.ScrollRectangle.Height - body.ClientRectangle.Height;

                    RedirectTrail.Clear();
                    bool Loading = true;
                    bool LoopFound = false;
                    while (Loading)
                    {
                        Loading = false;
                        string pageData = "";
                        if (IsEditing)
                            pageData = txtEdit.Text;
                        else
                        {
                            if (Storage.GetPageData(ref WikiPage, WikiGroup, ref pageData) || SetEditing)
                            {
                                cbPage.Items.Remove(WikiPage);
                                cbPage.Items.Insert(0, WikiPage);
                                cbPage.SelectedIndex = 0;
                            }
                            txtEdit.Text = pageData;
                            if (WikiGroup != Storage.CurrentGroup)
                            {
                                DoSidebar = true;
                                WikiGroup = Storage.CurrentGroup;
                                WikiSideBarPage = WikiGroup + WikiGroupSeparator + WikiSideBar;
                            }
                            if (SetEditing)IsEditing = true;
                        }
                        Storage.StoreLinks = false;
                        body.InnerHtml = Engine.Render(pageData);
                        if(!IsEditing)
                                foreach (WikiModification mod in Engine.Modifications)
                                    switch (mod.Name)
                                    {
                                        case "redirect":
                                            if (RedirectTrail.Contains(WikiPage))
                                                LoopFound = true;
                                            else
                                            {
                                                RedirectTrail.Add(WikiPage);
                                                Loading = true;
                                                WikiPage = mod.Value;
                                            }
                                            break;
                                        //more?
                                    }
                    }
                    if (RedirectTrail.Count == 0)
                        lblPageInfo.Visible = false;
                    else
                    {
                        string s = LoopFound ? " !!! Redirect loop detected !!! " : "Redirected by ";
                        bool b = true;
                        foreach (string p in RedirectTrail)
                        {
                            if (b) b = false; else s = s + " > ";
                            s = s + p;
                        }
                        lblPageInfo.Text = s;
                        lblPageInfo.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    wbPage.Document.Body.InnerText = "ERROR " + ex.ToString();
                }
                toolStripStatusLabel2.Text = Engine.LastCallTime.ToString() + " ms";
                lblPageTitle.Text = WikiPage;
                if (IsEditing)
                {
                    lbModifications.Items.Clear();
                    foreach (WikiModification mod in Engine.Modifications)
                        lbModifications.Items.Add(mod.Name + "=" + mod.Value);
                    lbModifications.Visible = lbModifications.Items.Count != 0;
                }
                scPageEdit.Panel2Collapsed = Engine.Modifications.Count == 0;
                txtEdit.Modified = false;
                pageModified = false;
                DoMain = false;
            }
            if (DoSidebar && wbSidebarLoaded)
            {
                string sidebarName = WikiSideBarPage;
                try
                {
                    HtmlElement body = wbSidebar.Document.Body;
                    string pageData = "";
                    Storage.GetPageData(ref sidebarName, WikiGroup, ref pageData);
                    //TODO: use return value?
                    Storage.StoreLinks = false;
                    body.InnerHtml = Engine.Render(pageData);
                }
                catch (Exception ex)
                {
                    wbSidebar.Document.Body.InnerText = "ERROR " + ex.ToString();
                }
                if (!btnCloseSideList.Visible)
                    lblSidebarTitle.Text = sidebarName;
                DoSidebar = false;
            }
            if (IsEditing && txtEdit.Modified)
            {
                pageModified = true;
                txtEdit.Modified = false;
                try
                {
                    HtmlElement body = wbPage.Document.Body;
                    float pre = body.ScrollRectangle.Height - body.ClientRectangle.Height == 0 ? -1 : body.ScrollTop / body.ScrollRectangle.Height - body.ClientRectangle.Height;

                    Storage.StoreLinks = false;
                    body.InnerHtml = Engine.Render(txtEdit.Text);

                    lbModifications.Items.Clear();
                    foreach (WikiModification mod in Engine.Modifications)
                        lbModifications.Items.Add(mod.Name + "=" + mod.Value);
                    lbModifications.Visible = lbModifications.Items.Count != 0;

                    if (txtEdit.SelectionLength == 0 && txtEdit.SelectionStart == txtEdit.Text.Length)
                        body.ScrollTop = body.ScrollRectangle.Height;
                    else
                        body.ScrollTop = (int)((float)(body.ScrollRectangle.Height - body.ClientRectangle.Height) / pre);
                }
                catch (Exception ex)
                {
                    wbPage.Document.Body.InnerText = "ERROR " + ex.ToString();
                }
                toolStripStatusLabel2.Text = Engine.LastCallTime.ToString() + " ms";
            }
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
            MessageBox.Show(this, e.Exception.ToString(), "Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private const string WikiSideBar = "SideBar";
        private const string WikiHomePage = "HomePage";
        //storage needs these also!
        public const char WikiGroupSeparator = '.';
        public const string WikiDefaultGroup = "Main";

        private Engine Engine = new Engine();
        private WikiLocalStorage Storage;
        private string IniPath = Application.LocalUserAppDataPath + Path.DirectorySeparatorChar + "WikiLocal.ini";

        private bool DoMain = true;
        private bool DoSidebar = true;
        private bool wbPageLocked = true;
        private bool SideLinks = true;
        private const string SideLinkDummy = ".......";
        private string WikiGroup = WikiDefaultGroup;
        private string WikiSideBarPage = WikiDefaultGroup + WikiGroupSeparator + WikiSideBar;
        private string WikiPage = WikiDefaultGroup + WikiGroupSeparator + WikiHomePage;

        private void cbPage_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            cbPage.DroppedDown = true;
        }

        private void cbPage_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Return)
            {
                WikiPage = cbPage.Text;
                DoMain = true;
            }
        }

        private void lblPageTitle_DoubleClick(object sender, EventArgs e)
        {
            IsEditing = true;
        }

        private void btnGo_Click(object sender, EventArgs e)
        {
            if (CheckEditing())
            {
                WikiPage = cbPage.Text;
                cbPage.SelectAll();
                DoMain = true;
            }
        }

        private void wbSidebar_Navigating(object sender, WebBrowserNavigatingEventArgs e)
        {
            if (wbSidebarAllowNav)
            {
                wbSidebarAllowNav = false;
                wbSidebarLoaded = false;
            }
            else
            {
                e.Cancel = true;
                string url = e.Url.ToString();
                if (url.Substring(0, 12) == "wikilocal://")
                {
                    if (CheckEditing())
                    {
                        //if(url.Substring(11,6)=="/view/"
                        WikiPage = url.Substring(17);
                        DoMain = true;
                        if (url.Substring(11, 6) == "/edit/") SetEditing = true;
                    }
                    else
                        e.Cancel = false;
                }
                else
                {
                    wbPageLocked = false;
                    wbPage.Navigate(url, true);
                }
            }
        }

        private void wbPage_Navigating(object sender, WebBrowserNavigatingEventArgs e)
        {
            if (wbPageAllowNav)
            {
                wbPageAllowNav = false;
                wbPageLoaded = false;
            }
            else
            {
                e.Cancel = true;
                string url = e.Url.ToString();
                if (url.Substring(0, 12) == "wikilocal://")
                {
                    if (CheckEditing())
                    {
                        //if(url.Substring(11,6)=="/view/"
                        WikiPage = url.Substring(17);
                        DoMain = true;
                        if (url.Substring(11, 6) == "/edit/") SetEditing = true;
                    }
                    else
                        e.Cancel = false;
                }
                else
                {
                    wbPageLocked = false;
                    wbPage.Navigate(url, true);
                }
            }
        }

        private void wbSidebar_Navigated(object sender, WebBrowserNavigatedEventArgs e)
        {
            wbSidebarLoaded = true;
        }

        private void wbPage_Navigated(object sender, WebBrowserNavigatedEventArgs e)
        {
            wbPageLoaded = true;
            cbPage.Focus();
            if (wbPageFirstLoad)
            {
                wbPageFirstLoad = false;
                Application.Idle += new EventHandler(Application_Idle);
            }
        }

        void wbSidebar_StatusTextChanged(object sender, EventArgs e)
        {
            toolStripStatusLabel3.Text = wbSidebar.StatusText;
        }

        void wbPage_StatusTextChanged(object sender, EventArgs e)
        {
            toolStripStatusLabel3.Text = wbPage.StatusText;
        }

        private void wbSidebar_NewWindow(object sender, CancelEventArgs e)
        {
            e.Cancel = true;
        }

        private void wbPage_NewWindow(object sender, CancelEventArgs e)
        {
            e.Cancel = wbPageLocked;
            wbPageLocked = true;
        }

        private bool IsEditing
        {
            set
            {
                SetEditing = false;
                scPage.Panel1Collapsed = !value;
                scPageEdit.Panel2Collapsed = !value || Engine.Modifications.Count == 0;
                if (value)
                {
                    txtEdit.Focus();
                    //TODO: selectall when getpagedata returned false
                }
                else
                {
                    //reload;
                    DoMain = true;
                    if (WikiPage == WikiSideBarPage) DoSidebar = true;
                }
            }
            get
            {
                return !scPage.Panel1Collapsed;
            }
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            IsEditing = true;
        }

        private void Save()
        {
            Storage.StoreLinks = true;
            Engine.Render(txtEdit.Text);
            Storage.SetPageData(WikiPage, txtEdit.Text);
            scPage.Panel1Collapsed = true;
            IsEditing = false;
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            Save();
        }

        private bool CheckEditing()
        {
            if (IsEditing)
                if (txtEdit.Modified || pageModified)
                    switch (MessageBox.Show(this, "Save changes first?", "WikiLocal edit page", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question))
                    {
                        case DialogResult.Yes:
                            Save();
                            return true;
                        case DialogResult.No:
                            IsEditing = false;
                            return true;
                        //case DialogResult.Cancel:
                        default:
                            return false;
                    }
                else
                {
                    IsEditing = false;
                    return true;
                }
            else
                return true;
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            string pageData = "";
            Storage.GetPageData(ref WikiPage, WikiGroup, ref pageData);
            txtEdit.Text = pageData;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            IsEditing = false;
        }

        private void WikiLocalMainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = !CheckEditing();
        }

        private void lblSidebarTitle_DoubleClick(object sender, EventArgs e)
        {
            if (CheckEditing())
            {
                WikiPage = WikiSideBarPage;
                DoMain = true;
                SetEditing = true;
            }
        }

        private void cbPage_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!DoMain && cbPage.SelectedIndex != -1 && CheckEditing())
            {
                WikiPage = cbPage.Text;
                DoMain = true;
            }
        }

        private void btnCloseSideList_Click(object sender, EventArgs e)
        {
            panSearch.Visible = false;
            tvSideList.Visible = false;
            wbSidebar.Visible = true;
            btnCloseSideList.Visible = false;
            lblSidebarTitle.Text = WikiGroup;
        }

        private void searchToolStripMenuItem_Click(object sender, EventArgs e)
        {
            wbSidebar.Visible = false;
            panSearch.Visible = true;
            tvSideList.Visible = true;
            btnCloseSideList.Visible = true;
            lblSidebarTitle.Text = "Search";
            txtSearchText.SelectAll();
            txtSearchText.Focus();
        }

        private void homePAgeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            WikiPage = WikiGroup + WikiGroupSeparator + WikiHomePage;
            DoMain = true;
        }

        private void mainHomePageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            WikiPage = WikiDefaultGroup + WikiGroupSeparator + WikiHomePage;
        }

        private void linksToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ShowLinks(WikiPage);
        }

        private void backlinksToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ShowBacklinks(WikiPage);
        }

        private void ShowLinks(string w)
        {
            wbSidebar.Visible = false;
            panSearch.Visible = false;
            tvSideList.Visible = true;
            btnCloseSideList.Visible = true;
            lblSidebarTitle.Text = "\"" + w + "\" Links";
            SideLoadItems(w, true);
        }

        private void ShowBacklinks(string w)
        {
            wbSidebar.Visible = false;
            panSearch.Visible = false;
            tvSideList.Visible = true;
            btnCloseSideList.Visible = true;
            lblSidebarTitle.Text = "\"" + w + "\" Backlinks";
            SideLoadItems(w,false);
        }

        private void linksToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            ShowLinks(WikiGroup + WikiGroupSeparator + WikiSideBar);
        }

        private void backlinksToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            ShowBacklinks(WikiGroup + WikiGroupSeparator + WikiSideBar);
        }

        private void SideLoadItems(string w,bool isLinks)
        {
          SideLinks = isLinks;
          tvSideList.BeginUpdate();
          try
          {
              tvSideList.Nodes.Clear();
              if (SideLinks)
                  Storage.Links(w, SideLoadItem, null);
              else
                  Storage.Backlinks(w, SideLoadItem, null);
          }
          finally
          {
              tvSideList.EndUpdate();
          }
        }

        private bool SideLoadItem(string w, object n)
        {
            TreeNode n1 = null;
            if (n == null)
                n1 = tvSideList.Nodes.Add(w);
            else
            {
                TreeNode n0 = n as TreeNode;
                while (n0 != null && string.Compare(n0.Text, w, true) != 0) n0 = n0.Parent;
                if (n0 == null) n1 = (n as TreeNode).Nodes.Add(w);
            }
            if (n1 != null && ((SideLinks && Storage.HasLinks(w)) || (!SideLinks && Storage.HasBacklinks(w))))
                n1.Nodes.Add(SideLinkDummy);//dummy
            return true;
        }

        private void tvSideList_BeforeExpand(object sender, TreeViewCancelEventArgs e)
        {
            if (e.Node.Nodes.Count == 1 && e.Node.Nodes[0].Text == SideLinkDummy)
            {
                e.Node.Nodes.Clear();
                if (SideLinks)
                    Storage.Links(e.Node.Text, SideLoadItem, e.Node);
                else
                    Storage.Backlinks(e.Node.Text, SideLoadItem, e.Node);
            }
        }

        private void txtSearchText_Enter(object sender, EventArgs e)
        {
            AcceptButton = btnSearch;
        }

        private void txtSearchText_Leave(object sender, EventArgs e)
        {
            AcceptButton = null;
        }

        private int matchCount;
        private Regex searchEx;

        private void btnSearch_Click(object sender, EventArgs e)
        {
            SideLinks = true;//?
            lblMatchCount.Text = "...";
            matchCount = 0;
            RegexOptions op = RegexOptions.Compiled;//?
            if (!cbSearchCaseSensitive.Checked) op = op | RegexOptions.IgnoreCase;
            if (cbSearchRegEx.Checked)
                searchEx = new Regex(txtSearchText.Text, op);
            else
            {
                string p = "";
                foreach (char c in txtSearchText.Text)
                    switch (c)
                    {
                        case '*':
                        case '$':
                        case '|':
                        case '\\':
                        case '(':
                        case ')':
                        case '[':
                        case ']':
                        case '^':
                        case '+':
                        case '.':
                        case '?':
                            p = p + '\\' + c;
                            break;
                        default:
                            p = p + c;
                            break;
                    }
                searchEx = new Regex(p, op);
            }
            tvSideList.BeginUpdate();
            Cursor = Cursors.WaitCursor;
            try
            {
                tvSideList.Nodes.Clear();
                Storage.Pages(SideLoadPageSearch, null);
            }
            finally
            {
                tvSideList.EndUpdate();
                Cursor = Cursors.Default;
            }
            if (matchCount == 0)
                lblMatchCount.Text = "nothing found";
            else
                lblMatchCount.Text = matchCount.ToString() + " pages found";
        }

        private bool SideLoadPageSearch(string Name, string Data, object Context)
        {
            if (searchEx.IsMatch(Data))
            {
                matchCount++;
                TreeNode n = tvSideList.Nodes.Add(Name);
                if (Storage.HasLinks(Name))
                    n.Nodes.Add(SideLinkDummy);//dummy
            }
            return true;
        }

        private void cmsRedirect_Opening(object sender, CancelEventArgs e)
        {
            cmsRedirect.Items.Clear();
            foreach (string s in RedirectTrail)
            {
                ToolStripMenuItem i = new ToolStripMenuItem(s);
                i.Click += new EventHandler(redirectItemClick);
                cmsRedirect.Items.Add(i);
            }
        }

        private void redirectItemClick(object sender, EventArgs e)
        {
            WikiPage = (sender as ToolStripMenuItem).Text;
            DoMain = true;
            SetEditing = true;
        }

        private void tvSideList_AfterSelect(object sender, TreeViewEventArgs e)
        {
            string w = e.Node.Text;
            if (string.Compare(WikiPage, w, true) != 0)
            {
                WikiPage = w;
                DoMain = true;
            }
        }
    }
}
