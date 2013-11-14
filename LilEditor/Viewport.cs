using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace LilEditor
{
    class Viewport
    {
        private static MainWindow container;

        public Viewport(MainWindow p)
        {
            container = p;
        }

        internal void Handle(object sender, AxShockwaveFlashObjects._IShockwaveFlashEvents_FlashCallEvent e)
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
                case "Initialize":
                    string response;

                    container.Character = FileHandler.GetCharacterFromPath("SaveData/TestData2.txt");
                    break;
            }
        }

        internal static void CallFunction(string msg)
        {
            container.lilWindow.CallFunction(msg);
        }
    }
}
