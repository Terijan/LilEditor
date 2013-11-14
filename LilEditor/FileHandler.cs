using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LilEditor
{
    class FileHandler
    {

        internal static CharData GetCharacterFromPath(string p)
        {
             try
                    {
                        using (StreamReader sr = new StreamReader(p))
                        {
                            string fileData = sr.ReadToEnd();
                            string msg = "<invoke name=\"loadData\" returntype=\"string\"><arguments><string>" + fileData + "</string></arguments></invoke>";

                            Viewport.CallFunction(msg);

                            //currently not used for anything, but may be useful for validation
                            //response = data.Replace("%22", @"\""")
                            //    .Replace("%5c", @"\\")
                            //    .Replace("%26", @"&")
                            //    .Replace("%25", @"%")
                            //    .Replace("<string>", "")
                            //    .Replace("</string>", "");

                            //deserializing to CharData, which we'll also be saving later on
                            return JsonConvert.DeserializeObject<CharData>(fileData);
                        }
                    }
             catch (Exception ex)
             {

             }
             return null;
        }

        internal static void SaveCharacterToPath(CharData Character)
        {
            var dataToSave = JsonConvert.SerializeObject(Character, Newtonsoft.Json.Formatting.None);
            var path = "SaveData/TestData2.txt";
            try
            {
                using (StreamWriter sw = new StreamWriter(path))
                {
                    sw.Write(dataToSave);
                    File.Copy(path, MainWindow.savePath);
                }
            }
            catch (Exception ex)
            {
            }
            
        }
    }
}
