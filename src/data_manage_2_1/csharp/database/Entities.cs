using System.Data;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace DatabaseFrame.database
{


    public enum FiledType
    {
        Number, String, Date
    }

    public class Table
    {
        public Filed[] fileds {  get; set; }
        public string name { get; set; }
        public string title { get; set; }

        public DataTable data = new DataTable();

        private string marks = "";
        public void Refresh()
        {
            if (data.Columns.Count == 0) {
                int markId = 0;
                foreach (var field in fileds)
                {
                    var c = new DataColumn(field.name);
                    c.ColumnName = field.desc;
                    data.Columns.Add(c);
                    if (marks.Length != 0) marks += ", ";
                    marks += $"{field.Marker(markId++)}";
                }
            }

            data.Rows.Clear();

            string sql = "";
            List<string> args = new List<string>();
            string join = "WHERE";
            foreach (var f in fileds)
            {
                bool hasMin = !String.IsNullOrEmpty(f.min);
                bool hasMax = !String.IsNullOrEmpty(f.max);
                if (!hasMin && !hasMax) continue;

                sql += $" {join} {f.name} ";
                join = "AND";

                if (f.type == FiledType.String)
                {
                    sql += $"ILIKE {f.Marker(args.Count)}";
                    args.Add($"%{f.min}%");
                    continue;
                }

                if (hasMin && !f.Assert(f.min)) return;
                if (hasMax && !f.Assert(f.max)) return;

                if (hasMax && hasMin)
                {
                    sql += $"BETWEEN LEAST({f.Marker(args.Count)}, {f.Marker(args.Count+1)}) AND GREATEST({f.Marker(args.Count+2)}, {f.Marker(args.Count+3)})";
                    args.Add(f.min);
                    args.Add(f.max);
                    args.Add(f.min);
                    args.Add(f.max);
                    continue;
                }
                if(hasMax)
                {
                    sql += $"<= {f.Marker(args.Count)}";
                    args.Add(f.max);
                    continue;
                }
                sql += $">= {f.Marker(args.Count)}";
                args.Add(f.min);
            }

            sql = $"SELECT * FROM {name}{sql}";
            found = false;
            Database.Query(sql, args.ToArray(), e => {
                DataRow row = data.NewRow();
                row.ItemArray = e;
                found = true;
                for (int i = 0; i < e.Length; i++)
                {
                    if (fileds[i].type == FiledType.Date)
                    {
                        long value = 0;
                        if(long.TryParse(row[i]+"", out value))
                        {
                            row[i] = DateTimeOffset.FromUnixTimeMilliseconds(value).LocalDateTime;
                        }
                    }
                }
                data.Rows.Add(row);
            });

            if(!found)
            {
                MessageBox.Show($"Значения с задаными фильтрами не найдены");
            }
        }

        static bool found = false;

        public void Delete(object key)
        {
            Database.Execute($"SELECT delete_{name}(@m0::{fileds[0].datatype})", new string[] { $"{key}" });
        }

        public void Insert()
        {
            string[] values = new string[fileds.Length];
            for (int i = 0; i < fileds.Length; i++) {
                values[i] = fileds[i].input;
            }
            Database.Execute($"SELECT insert_{name}({marks})", values);
        }
        
    }

    public class Filed
    {
        public FiledType type { get; set; }
        public string name { get; set; }
        public string desc { get; set; }

        public string datatype;

        public string min = String.Empty, max = String.Empty, substring = String.Empty;

        public string input = String.Empty;

        public string Marker(object id)
        {
            if (type == FiledType.Date) return $"(EXTRACT(EPOCH FROM TO_TIMESTAMP(@m{id}, 'DD.MM.YYYY')) * 1000)::bigint";
            if (type == FiledType.String) return $"@m{id}";
            return $"@m{id}::{datatype}";
        }

        public bool Assert(string input)
        {
            if(type == FiledType.Number)
            {
                long o = 0;
                return long.TryParse(input, out o);
            }
            return !String.IsNullOrWhiteSpace(input);
        }
    }

    public class Player
    {
        public int id { get; set; }
        public int account_id { get; set; }
        public int pref_id { get; set; }
        public int stat_id { get; set; }
        public int rate_id { get; set; }
    }
}
