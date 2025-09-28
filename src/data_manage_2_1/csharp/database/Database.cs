using System.Data;
using Npgsql;

namespace DatabaseFrame.database
{
    internal static class Database
    {
        public static Table[] tables = {
            new Table {
                name = "players",
                title = "Игроки",
                fileds = [
                    new Filed { type = FiledType.Number, name = "id",           desc = "Номер игрока"},
                    new Filed { type = FiledType.Number, name = "account_id",   desc = "ID аккаунта"},
                    new Filed { type = FiledType.Number, name = "pref_id",      desc = "ID настроек"},
                    new Filed { type = FiledType.Number, name = "stat_id",      desc = "ID статистики"},
                    new Filed { type = FiledType.Number, name = "rate_id",      desc = "ID рейтинга"}
                ]
            },
            new Table {
                name = "accounts",
                title = "Аккаунты",
                fileds = [
                    new Filed { type = FiledType.Number, name = "id",           desc = "ID аккаунта"},
                    new Filed { type = FiledType.String, name = "username",     desc = "Имя пользователя"},
                    new Filed { type = FiledType.String, name = "password",     desc = "Пароль"},
                ]
            },
            new Table {
                name = "prefs",
                title = "Настройки",
                fileds = [
                    new Filed { type = FiledType.Number, name = "id",           desc = "ID настроек"},
                    new Filed { type = FiledType.String, name = "lang",         desc = "Язык"},
                    new Filed { type = FiledType.Number, name = "color",        desc = "Цвет"},
                ]
            },
            new Table {
                name = "stats",
                title = "Статистика",
                fileds = [
                    new Filed { type = FiledType.Number, name = "id",           desc = "ID статистики"},
                    new Filed { type = FiledType.Number, name = "playtime",     desc = "Игровое время"},
                ]
            },
            new Table {
                name = "rates",
                title = "Рейтинг",
                fileds = [
                    new Filed { type = FiledType.Number, name = "id",           desc = "ID рейтинга"},
                    new Filed { type = FiledType.Number, name = "bans",         desc = "Количество банов"},
                    new Filed { type = FiledType.Date,   name = "unbantime",    desc = "Время снятия бана"},
                ]
            },
        };


        private static NpgsqlDataSource src;
        private static NpgsqlConnection con;

        public static async Task Connect(string conString)
        {
            Log.Info("Connecting...");
            src = NpgsqlDataSource.Create(conString);
            con = src.OpenConnection();
            Log.Info("Src: " + src);

            foreach (var table in tables)
            {
                Log.Info($"Table {table.name}:");
                foreach (var field in table.fileds)
                {
                    QueryType(table, field);
                    Log.Info($"| {field.name}: {field.datatype}");
                }
                table.Refresh();
            }
        }

        public static void Close()
        {
            con.Close();
            src.Dispose();
        }

        public static void Query(string sql, string[] args, Action<string[]> cons)
        {
            Log.Info($"[SQL] > {sql}");
            Log.Info($"[SQL] | {string.Join(", ", args)}");
            using (var cmd = new NpgsqlCommand(sql, con))
            {
                for (int i = 0; i < args.Length; i++)
                {
                    cmd.Parameters.Add(new NpgsqlParameter($"m{i}", DbType.Object) { Value = args[i] });
                }
                using var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string[] objects = new string[reader.FieldCount];
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        objects[i] = $"{reader.GetValue(i)}";
                    }
                    cons(objects);
                }
                reader.Close();
            }
        }
        public static void Execute(string sql, string[] args)
        {
            Log.Info($"[SQL] > {sql}");
            Log.Info($"[SQL] | {string.Join(", ", args)}");
            using (var cmd = new NpgsqlCommand(sql, con))
            {
                for (int i = 0; i < args.Length; i++)
                {
                    cmd.Parameters.Add(new NpgsqlParameter($"m{i}", DbType.Object) { Value = args[i] });
                }
                cmd.ExecuteNonQuery();
            }
        }

        public static void QueryType(Table table, Filed filed)
        {
            using (var cmd = new NpgsqlCommand($"SELECT data_type FROM information_schema.columns WHERE table_name = '{table.name}' AND column_name = '{filed.name}'", con))
            {
                cmd.Parameters.Add(new NpgsqlParameter("data_type", DbType.String) { Direction = ParameterDirection.Output });
                cmd.ExecuteNonQuery();
                filed.datatype = cmd.Parameters[0].Value + "";
            }
        }

    }
}
