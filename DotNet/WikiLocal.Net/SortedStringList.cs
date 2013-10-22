using System;
using System.Collections;
using System.Text;
using System.IO;

namespace WikiLocal.Net
{
    class SortedStringList : IList, ICollection, IEnumerable
    {
        private int _size = 0;
        private const int _sizeGrowStep = 1024;
        private int _count = 0;
        private string[] _items = new string[0];

        public void Load(string FilePath)
        {
            Clear();
            if (File.Exists(FilePath))
                using (StreamReader sr = new StreamReader(FilePath))
                    while (!sr.EndOfStream)
                        Add(sr.ReadLine());
            //add does sorting
        }

        public void Save(string FilePath)
        {
            if (_count == 0)
            {
                if (File.Exists(FilePath))
                    File.Delete(FilePath);
            }
            else
                using (StreamWriter sw = new StreamWriter(FilePath, false, Encoding.UTF8))
                    for (int i = 0; i < _count; i++)
                        sw.WriteLine(_items[i]);
        }

        private int Search(out bool match, string value)
        {
            int a = 0;
            int b = _count;
            match = false;
            while (a < b && !match)
            {
                if (_items[a] == value)
                {
                    match = true;
                    return a;
                }
                if (_items[b - 1] == value)
                {
                    match = true;
                    return b - 1;
                }
                //TODO: setting case sensitivity?
                if (String.Compare(value, _items[a], true) < 0) return a;
                if (String.Compare(_items[b - 1], value, true) < 0) return b;
                int c = (b + a) / 2;
                if (String.Compare(_items[c], value, true) < 0) b = c; else a = c;
            }
            return a;
        }

        public int Add(string value)
        {
            bool match;
            int x = Search(out match, value);
            if (!match)
            {
                if (_count == _size)
                {
                    string[] ditems = new string[_size + _sizeGrowStep];
                    Array.Copy(_items, ditems, _count);
                    _items = ditems;
                    _size += _sizeGrowStep;
                }
                if (_count - x > 0) Array.Copy(_items, x, _items, x + 1, _count - x);
                _items[x] = value;
                _count++;
            }
            return x;
        }

        public bool Remove(string value)
        {
            bool match;
            int x = Search(out match, value);
            if (match) RemoveAt(x);
            return match;
        }

        #region IList Members

        public int Add(object value)
        {
            return Add(value as string);
        }

        public void Clear()
        {
            _items = new string[0];
            _size = 0;
            _count = 0;
        }

        public bool Contains(object value)
        {
            return IndexOf(value) != -1;
        }

        public int IndexOf(object value)
        {
            bool match;
            int x = Search(out match, value as string);
            if (match)
                return x;
            else
                return -1;
        }

        public void Insert(int index, object value)
        {
            //sorted unique: ignore index, revert to Add
            Add(value as string);
        }

        public bool IsFixedSize
        {
            get { return false; }
        }

        public bool IsReadOnly
        {
            get { return false; }
        }

        public void Remove(object value)
        {
            Remove(value as string);
        }

        public void RemoveAt(int index)
        {
            _count--;
            if (_count - index > 0)
                Array.Copy(_items, index + 1, _items, index, _count - index);
            _items[_count] = default(string);
        }

        public object this[int index]
        {
            get
            {
                return _items[index];
            }
            set
            {
                //sorted unique: revert to Add
                Add(value as string);
            }
        }

        #endregion

        #region ICollection Members

        public void CopyTo(Array array, int index)
        {
            Array.Copy(_items, 0, array, index, _count);
        }

        public int Count
        {
            get { return _count; }
        }

        public bool IsSynchronized
        {
            get { throw new Exception("IsSynchronized is not implemented."); }
        }

        public object SyncRoot
        {
            get { throw new Exception("SyncRoot is not implemented."); }
        }

        #endregion

        #region IEnumerable Members

        public IEnumerator GetEnumerator()
        {
            return new SortedStringListEnumerator(this);
        }

        #endregion

        #region SortedStringListEnumerator

        public struct SortedStringListEnumerator : IDisposable, IEnumerator //,IEnumerator<string>
        {
            private SortedStringList list;
            private int index;
            private string current;
            internal SortedStringListEnumerator(SortedStringList list)
            {
                this.list = list;
                this.index = 0;
                this.current = default(string);
            }

            public void Dispose()
            {
            }

            public bool MoveNext()
            {
                if (index < list._count)
                {
                    current = list._items[index];
                    index++;
                    return true;
                }
                index = list._count + 1;
                current = default(string);
                return false;
            }

            public string Current
            {
                get
                {
                    return current;
                }
            }
            object IEnumerator.Current
            {
                get
                {
                    return current;
                }
            }
            void IEnumerator.Reset()
            {
                index = 0;
                current = default(string);
            }
        }

        #endregion

    }
}
