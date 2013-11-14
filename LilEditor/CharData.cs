using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LilEditor
{
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
        public List<String> Scripts { get; set; }
    }
}
