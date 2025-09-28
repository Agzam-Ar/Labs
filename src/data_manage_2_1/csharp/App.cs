using DatabaseFrame.database;

namespace DatabaseFrame
{
    public partial class App : Form
    {
        public App()
        {
            InitializeComponent();
        }

        protected void build()
        {
            TabControl tabs = new TabControl();
            tabs.Dock = DockStyle.Fill;
            this.Controls.Add(tabs);

            foreach (var table in Database.tables)
            {
                TabPage page = new TabPage($"Таблица \"{table.title}\"");
                tabs.Controls.Add(page);


                Select(page);
                //Button button1 = new Button();
                //button1.Text = "Click Me!";
                //button1.Location = new System.Drawing.Point(10, 10);
                //page.Controls.Add(button1);
                int y = 1;
                Label($"Таблица \"{table.title}\"", 0, y++, l =>
                {
                    l.Width = 9999;
                });

                int x = 0;
                TextBox[] mins = new TextBox[table.fileds.Length];
                TextBox[] maxs = new TextBox[table.fileds.Length];
                DateTimePicker[] minDates = new DateTimePicker[table.fileds.Length];
                DateTimePicker[] maxDates = new DateTimePicker[table.fileds.Length];

                foreach (var field in table.fileds)
                {
                    Label(field.desc, x, y);

                    if (field.type == FiledType.Date)
                    {
                        minDates[x] = DateEntry(DateTime.UnixEpoch, x, y + 1, null);
                        maxDates[x] = DateEntry(DateTime.Now, x, y + 2, null);
                    }
                    else
                    {
                        mins[x] = Entry(null, x, y + 1, null);
                        if (field.type == FiledType.Number) maxs[x] = Entry(null, x, y + 2);
                    }
                    x++;
                }
                var apply = Button("Применить", x, y + 1, null);
                apply.Click += (s, e) =>
                {
                    for (int i = 0; i < table.fileds.Length; i++)
                    {

                        if (minDates[i] != null) table.fileds[i].min = minDates[i].Value.ToString("dd.MM.yyyy");
                        if (maxDates[i] != null) table.fileds[i].max = maxDates[i].Value.ToString("dd.MM.yyyy");
                        if (mins[i] != null) table.fileds[i].min = mins[i].Text;
                        if (maxs[i] != null) table.fileds[i].max = maxs[i].Text;
                    }
                    table.Refresh();
                };
                y += 3;

                DataGridView grid = Treeview(0, y, table.fileds.Length, 10, t =>
                {
                    t.DataSource = table.data;
                    t.RowHeadersVisible = false;
                    t.ReadOnly = true;
                    t.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
                    t.AllowUserToResizeRows = false;
                    t.AllowUserToResizeColumns = false;
                    t.AllowUserToAddRows = false;
                    t.AllowUserToDeleteRows = false;
                    t.AllowUserToOrderColumns = false;
                    t.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
                });
                y += 10;

                var remove = Button("Удалить", 0, y++, null);
                remove.Click += (s, e) =>
                {
                    if (MessageBox.Show("Вы действительно уверены?", "Подтверждение", MessageBoxButtons.YesNo) != DialogResult.Yes) return;

                    foreach (DataGridViewRow row in grid.SelectedRows)
                    {
                        DataGridViewCell cell = row.Cells[0];

                        try
                        {
                            table.Delete(cell.Value);
                        }
                        catch (Exception exc)
                        {
                            MessageBox.Show(exc.Message);
                        }
                    }

                    table.Refresh();
                };

                x = 0;
                TextBox[] inputs = new TextBox[table.fileds.Length];
                DateTimePicker[] inputsDates = new DateTimePicker[table.fileds.Length];

                foreach (var field in table.fileds)
                {
                    Label(field.desc, x, y);

                    if (field.type == FiledType.Date)
                    {
                        inputsDates[x] = DateEntry(DateTime.Now, x, y + 1, null);
                    }
                    else
                    {
                        inputs[x] = Entry(null, x, y + 1, null);
                    }
                    x++;
                }
                y += 1;

                var add = Button("Добавить", x, y++);
                add.Click += (s, e) =>
                {
                    for (int i = 0; i < table.fileds.Length; i++)
                    {
                        if (inputsDates[i] != null) table.fileds[i].input = inputsDates[i].Value.ToString("dd.MM.yyyy");
                        if (inputs[i] != null) table.fileds[i].input = inputs[i].Text;
                        if (table.fileds[i].Assert(table.fileds[i].input)) continue;
                        MessageBox.Show($"Неверное занение в \"{table.fileds[i].desc}\"\n: \"{table.fileds[i].input}\"!");
                        return;
                    }
                    try
                    {
                        table.Insert();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                    table.Refresh();
                };
            }
        }
    }
}
