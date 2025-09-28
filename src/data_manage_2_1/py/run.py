import psycopg2
import tkinter as tk
from datetime import datetime
from tkinter import ttk
from tkinter import messagebox
from tkcalendar import DateEntry

tables = [
	{
		"name": "players",
		"title": "Игроки",
		"fields": [
			{
				"name": "id",
				"title": "Номер игрока",
				"type": "number"
			},
			{
				"name": "account_id",
				"title": "ID аккаунта",
				"type": "number"
			},
			{
				"name": "pref_id",
				"title": "ID настроек",
				"type": "number"
			},
			{
				"name": "stat_id",
				"title": "ID статистики",
				"type": "number"
			},
			{
				"name": "rate_id",
				"title": "ID рейтинга",
				"type": "number"
			}
		]
	},
	{
		"name": "accounts",
		"title": "Аккаунты",
		"fields": [
			{
				"name": "id",
				"title": "ID аккаунта",
				"type": "number"
			},
			{
				"name": "username",
				"title": "Имя пользователя",
				"type": "string"
			},
			{
				"name": "password",
				"title": "Пароль",
				"type": "string"
			}
		]
	},
	{
		"name": "prefs",
		"title": "Настройки",
		"fields": [
			{
				"name": "id",
				"title": "ID настроек",
				"type": "number"
			},
			{
				"name": "lang",
				"title": "Язык",
				"type": "string"
			},
			{
				"name": "color",
				"title": "Цвет",
				"type": "number"
			}
		]
	},
	{
		"name": "stats",
		"title": "Статистика",
		"fields": [
			{
				"name": "id",
				"title": "ID статистики",
				"type": "number"
			},
			{
				"name": "playtime",
				"title": "Игровое время",
				"type": "number"
			}
		]
	},
	{
		"name": "rates",
		"title": "Рейтинг",
		"fields": [
			{
				"name": "id",
				"title": "ID рейтинга",
				"type": "number"
			},
			{
				"name": "bans",
				"title": "Количество банов",
				"type": "number"
			},
			{
				"name": "unbantime",
				"title": "Время снятия бана",
				"type": "date"
			}
		]
	}
];

# Precalculate data
pc_table_id = 0;
for table in tables:
	fields_names = [];
	fields_titles = [];
	table["id"] = pc_table_id;
	pc_table_id = pc_table_id + 1;
	pc_field_id = 0;
	for field in table["fields"]:
		fields_names.append(field["name"])
		fields_titles.append(field["title"])
		field["id"] = pc_field_id;
		pc_field_id = pc_field_id + 1;
	table["fields_names"] = fields_names;
	table["fields_titles"] = fields_titles;


class SQLClass:

	markers = {
		"number": "%s",
		"string": "%s",
		"date": "(EXTRACT(EPOCH FROM TO_TIMESTAMP(%s, 'DD.MM.YYYY')) * 1000)",
	}

	def __init__(self):
		self.a = "a";

	def values_from(self, table, name):
		values = [];
		for field in table["fields"]:
			value = field[name].get();
			if value == '':
				messagebox.showerror("Ошибка БД", f"Пустое значение \"{field["title"]}\"");
				return None;

			if field["type"] == 'number':
				try:
					int(value)
				except:
					messagebox.showerror("Ошибка БД", f"Ожидалось число в \"{field["title"]}\"");
					return
			values.append(value);
		return values;


SQL = SQLClass();

class Database:

	def __init__(self):
		self.open();
		for table in tables:
			args = "";
			values = "";
			keys = "";
			marks = "";
			key_field = None;
			for field in table["fields"]:
				field["datatype"] = self.query_type(table["name"], field["name"]);
				if not args == '':
					args += ', ';
					values += ', ';
					keys += ', ';
					marks += ",";
				if not key_field:
					key_field = field;
				args += f"arg_{field["name"]} {field["datatype"]}";
				values += f"arg_{field["name"]}";
				keys += f"{field["name"]}";
				marks += f"{SQL.markers[field["type"]]}::{field["datatype"]}";
			table["values"] = marks;
			table["keys"] = keys;
			insert = f"""
				CREATE OR REPLACE FUNCTION insert_{table["name"]}({args}) RETURNS VOID
				AS $$
					BEGIN
						INSERT INTO {table["name"]} ({keys}) VALUES ({values});
					END;
				$$ LANGUAGE plpgsql;
			"""
			delete = f"""
				CREATE OR REPLACE FUNCTION delete_{table["name"]}(arg_{key_field["name"]} {key_field["datatype"]}) RETURNS VOID
				AS $$
					BEGIN
						DELETE FROM {table["name"]} WHERE arg_{key_field["name"]} = {key_field["name"]};
							EXCEPTION
						WHEN foreign_key_violation THEN
							RAISE EXCEPTION 'Невозможно выполнить удаление, так как есть внешние ссылки.';
					END;
				$$ LANGUAGE plpgsql;
			"""
			self.query(insert);
			self.query(delete);

	def open(self):
		self.con = psycopg2.connect(dbname="lab1", host="localhost", user="agzam", password="a", port="5432");
		self.cursor = self.con.cursor();

	def close(self):
		self.con.close();
		print("closed");

	def query(self, query, parms=None, fetch=False, commit=True):
		try:
			self.cursor.execute(query, parms)
			if commit:
				self.con.commit()
			if fetch:
				return self.cursor.fetchall()
		except psycopg2.Error as e:
			if self.con:
				self.con.rollback()
			messagebox.showerror("Ошибка БД", f"Ошибка выполнения запроса: {e}")
			return []
		return []
	
	def query_type(self, table, column):
		return list(
			self.query(f"SELECT data_type FROM information_schema.columns WHERE table_name = '{table}' AND column_name = '{column}';", fetch=True)[0]
		)[0];

class App:

	def __init__(self):
		self.database = Database();
		self.root = tk.Tk();

		root = self.root;

		root.title("Управление Базой данных");
		root.resizable(False, False);
		notebook = ttk.Notebook(root)

		trees = [];
		self.trees = trees;
		for table in tables:
			frame = ttk.Frame(notebook)
			notebook.add(frame, text=table["title"])

			label = tk.Label(frame, text=f"Таблица \"{table["title"]}\"")
			label.grid(row=0, column=0, padx=5, pady=5, sticky="w")

			# Filters
			filterFrame = ttk.Frame(frame);
			filterFrame.grid(row=1, column=0, padx=5, pady=5, sticky="w");

			column = 0;
			for field in table["fields"]:
				label = tk.Label(filterFrame, text=field["title"])
				label.grid(row=0, column=column, padx=5, pady=5, sticky="w")
				if field["type"] == 'date':
					minDate = DateEntry(filterFrame, selectmode='day', year=1970, month=1, day=1, date_pattern='dd.mm.yyyy')
					maxDate = DateEntry(filterFrame, selectmode='day', date_pattern='dd.mm.yyyy')
					minDate.grid(row=1, column=column, padx=5, pady=5, sticky="w")
					maxDate.grid(row=2, column=column, padx=5, pady=5, sticky="w")
					column = column + 1;
					field["entry-min"] = minDate;
					field["entry-max"] = maxDate;
				elif field["type"] == 'number':
					minEntry = tk.Entry(filterFrame);
					maxEntry = tk.Entry(filterFrame);
					minEntry.grid(row=1, column=column, padx=5, pady=5, sticky="w")
					maxEntry.grid(row=2, column=column, padx=5, pady=5, sticky="w")
					field["entry-min"] = minEntry;
					field["entry-max"] = maxEntry;
				else:
					entry = tk.Entry(filterFrame);
					field["entry"] = entry;
					entry.grid(row=1, column=column, padx=5, pady=5, sticky="w")
				column = column + 1;

			def create_apply_filter(table):
				def apply_filter():
					parms = [];
					sql = "";
					join = "WHERE";

					msgFilter = "";
					for field in table["fields"]:
						name = field["name"];
						# string
						if field["type"] == 'string':
							boolf = field["entry"].get();
							msgFilter += ' ' + boolf;
							if boolf == '':
								continue
							sql += f" {join} {name} ILIKE %s";
							join = "AND";
							parms.append(f"%{boolf}%");
							continue
						# number & date
						minEntry = field["entry-min"].get();
						maxEntry = field["entry-max"].get();
						marker = SQL.markers[field["type"]];
						if (minEntry == "") and (maxEntry == ""):
							continue
						sql += f" {join} ";
						join = "AND";
						if (not minEntry == "") and (not maxEntry == ""):
							sql += f"{name} BETWEEN LEAST({marker}, {marker}) AND GREATEST({marker}, {marker})";
							parms.append(minEntry);
							parms.append(maxEntry);
							parms.append(minEntry);
							parms.append(maxEntry);
							msgFilter += f' между {minEntry} и {maxEntry}';
							continue
						if (not minEntry == ""):
							sql += f"{name} >= {marker}";
							parms.append(minEntry);
							msgFilter += f' больше {minEntry}';
							continue
						sql += f"{name} <= {marker}";
						msgFilter += f' меньше {minEntry}';
						parms.append(maxEntry);
						continue

					sql = f"SELECT * FROM {table["name"]}{sql}";
					print(sql);
					if not self.tree_query(table, sql, parms):
						messagebox.showerror("Ошибка", f"Значения {msgFilter} не найдены");
				return apply_filter;

			table["apply"] = create_apply_filter(table);

			filterButton = ttk.Button(filterFrame, text="Применить", command=table["apply"]);
			filterButton.grid(row=1, column=column, padx=5, pady=5, sticky="w");

			# Table
			tree = ttk.Treeview(frame, columns=table["fields_names"], show="headings");
			table["tree"] = tree;
			trees.append(tree);

			for field in table["fields"]:
				tree.heading(field["name"], text=field["title"]);

			self.tree_query(table, f"SELECT * FROM {table["name"]}");

			tree.grid(row=2, column=0, padx=5, pady=5, sticky="w")

			def create_delete_line(table):
				def delete_line():
					response = messagebox.askyesno("Подтверждение", "Вы действительно уверены?")
					if not response:
						return
					tree = table["tree"];

					value = list(tree.item(tree.focus()).values())[2][0];
					# sql = f"DELETE from {table["name"]} WHERE {table["fields_names"][0]} = %s";
					sql = f"SELECT delete_{table["name"]}(%s)";
					self.database.query(sql, parms=[value]);
					table["apply"]();
					return
				return delete_line;

			deleteButton = ttk.Button(frame, text="Удалить запись", command=create_delete_line(table));
			deleteButton.grid(row=3, column=0, padx=5, pady=5, sticky="w");

			# Create
			addFrame = ttk.Frame(frame);
			addFrame.grid(row=4, column=0, padx=5, pady=5, sticky="w");

			column = 0;
			for field in table["fields"]:
				label = tk.Label(addFrame, text=field["title"])
				label.grid(row=0, column=column, padx=5, pady=5, sticky="w")

				if field["type"] == 'date':
					entry = DateEntry(addFrame, selectmode='day', date_pattern='dd.mm.yyyy')
				else:
					entry = tk.Entry(addFrame);
				entry.grid(row=1, column=column, padx=5, pady=5, sticky="w")
				column = column + 1;
				field["add"] = entry;

			def create_add_line(table):
				def add_line():
					values = SQL.values_from(table, "add");
					if not values:
						return
					self.database.query(f"SELECT insert_{table["name"]}({table["values"]})", parms=values);
					table["apply"]();
					return
				return add_line;

			deleteButton = ttk.Button(frame, text="Добавить запись", command=create_add_line(table));
			deleteButton.grid(row=5, column=0, padx=5, pady=5, sticky="w");
		notebook.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S));

	def tree_query(self, table, sql, parms=None):
		tree = self.trees[table["id"]];

		for item in tree.get_children():
			tree.delete(item)

		data = self.database.query(sql, parms=parms, fetch=True);
		found = False;
		for e in data:
			values = list(e);
			index = 0;
			for field in table["fields"]:
				if field["type"] == 'date':
					values[index] = datetime.fromtimestamp(values[index]/1000);
				index = index + 1;
			tree.insert("", tk.END, values=values);
			found = True;
		return found;

if __name__ == "__main__":
	app = App()
	app.root.mainloop()
	app.database.close();
