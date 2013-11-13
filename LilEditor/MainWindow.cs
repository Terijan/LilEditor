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
        public string appPath = Application.StartupPath + @"";
        public string assetsPath = Application.StartupPath + @"assets\";
        public const string appName = @"\..\..\..\export\flash\bin\Adapter2.swf";

        public MainWindow()
        {
            InitializeComponent();
            lilWindow.Movie = appPath + appName;
            //lilWindow.SetReturnValue("<string>test</string>");

            lilWindow.Play();

        }

        private void ViewPort_FlashCall(object sender, AxShockwaveFlashObjects._IShockwaveFlashEvents_FlashCallEvent e)
        {
            // message is in xml format so we need to parse it
            XmlDocument document = new XmlDocument();
            document.LoadXml(e.request);
            // get attributes to see which command flash is trying to call
            XmlAttributeCollection attributes = document.FirstChild.Attributes;
            String command = attributes.Item(0).InnerText;
            // get parameters
            XmlNodeList list = document.GetElementsByTagName("arguments");
            // Interpret command
            switch (command)
            {
                //case "sendText": resultTxt.Text = list[0].InnerText; break;
                // case "Some_Other_Command": break;
                case "E_RightMouse":
                    contextMenuStrip1.Show(MousePosition);
                    break;
                case "sendLayer":
                    string path = appPath + @"assets\Levels\" + list[0].FirstChild.InnerText + @".csv";
                    if (File.Exists(path))
                    {
                        string v = list[0].LastChild.InnerText;
                        //using (StreamReader s = new StreamReader(path))
                        //{
                        //    var f = s.ReadToEnd();
                        //    if (v == f)
                        //    {

                        //    }
                        //}
                        using (StreamWriter s = new StreamWriter(path))
                        {
                            s.Write(v);
                        }
                    }
                    break;
                case "Initialize":
                    string response;

                    try
                    {
                        using (StreamReader sr = new StreamReader("SaveData/testData.txt"))
                        {
                            string fileData = sr.ReadToEnd();
                            string msg = "<invoke name=\"loadData\" returntype=\"string\"><arguments><string>" + fileData + "</string></arguments></invoke>";

                            


                            var data = lilWindow.CallFunction(msg);
                            
                           //currently not used for anything, but may be useful for validation
                            response = data.Replace("%22", @"\""")
                                .Replace("%5c", @"\\")
                                .Replace("%26", @"&")
                                .Replace("%25", @"%")
                                .Replace("<string>", "")
                                .Replace("</string>", "");
                               
                            //deserializing to CharData, which we'll also be saving later on
                           var serializer = new JsonSerializer();
                           CharData jObj = JsonConvert.DeserializeObject<CharData>(fileData);
                           
                         
                           var jdata = JsonConvert.SerializeObject(jObj, Newtonsoft.Json.Formatting.Indented);
                            if (jdata == fileData)
                            {
                                
                            }
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                    break;
            }
        }

        public class CharData
        {
            public Object Sprite { get; set; }
            public List<AnimData> Animations { get; set; }
            public Object Properties { get; set; }
        }

        public class AnimData
        {
            public string Name { get; set; }
            public List<KeyData> Keys { get; set; }
        }

        public class KeyData
        {
            public int Frame { get; set; }
            public int Length { get; set; }
            public List<String> scripts { get; set; }
        }

        private void testToolStripMenuItem_Click(object sender, EventArgs e)
        {
            lilWindow.CallFunction("<invoke name=\"getLayer\"  returntype=\"void\"><arguments></arguments></invoke>");
        }

        private void MainWindow_Load(object sender, EventArgs e)
        {
            //load and send test json

        }
    }
}
