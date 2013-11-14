using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;



namespace LilEditor
{
    public partial class MainWindow : Form
    {
        public static string appPath = Application.StartupPath + @"";
        public static string assetsPath = Application.StartupPath + @"assets\";
        public static string savePath = Application.StartupPath + @"\..\..\..\assets\testData.txt";
        public const string appName = @"\..\..\..\export\flash\bin\Adapter2.swf";
        public CharData Character;

        private Viewport vEventHandler;

        public MainWindow()
        {
            InitializeComponent();
            lilWindow.Movie = appPath + appName;
            vEventHandler = new Viewport(this);
            //lilWindow.SetReturnValue("<string>test</string>");

            lilWindow.Play();

        }

        private void ViewPort_FlashCall(object sender, AxShockwaveFlashObjects._IShockwaveFlashEvents_FlashCallEvent e)
        {
            vEventHandler.Handle(sender, e);
        }



        private void testToolStripMenuItem_Click(object sender, EventArgs e)
        {
            lilWindow.CallFunction("<invoke name=\"getLayer\"  returntype=\"void\"><arguments></arguments></invoke>");
        }

        private void MainWindow_Load(object sender, EventArgs e)
        {
            //load and send test json

        }

        private void saveButton_Click(object sender, EventArgs e)
        {
            FileHandler.SaveCharacterToPath(Character);
        }
    }
}
