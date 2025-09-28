namespace DatabaseFrame
{
    partial class App
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        static int yScl = 30;
        static int xScl = 200;
        static int frameWidth = 0;
        static int frameHeight = 0;
        //static int gridScl = 20;

        Control current = null;
        public void Select(Control c)
        {
            current = c;
        }

        public TextBox Entry(string Text, int x, int y, Action<TextBox> cons = null)
        {
            TextBox l = new TextBox();
            l.Left = x * xScl;
            l.Top = y * yScl;
            //l.Height = yScl/2;
            l.Width = xScl;
            //l.Location = new System.Drawing.Point(x * gridScl, y * gridScl);
            if (cons != null) cons(l);
            if (current != null) current.Controls.Add(l);
            Expand(x, y);
            return l;
        }

        public DateTimePicker DateEntry(DateTime time, int x, int y, Action<DateTimePicker> cons = null)
        {
            DateTimePicker l = new DateTimePicker();
            l.Left = x * xScl;
            l.Top = y * yScl;
            //l.Height = yScl/2;
            l.Width = xScl;
            l.Value = time;
            //l.Location = new System.Drawing.Point(x * gridScl, y * gridScl);
            if (cons != null) cons(l);
            if (current != null) current.Controls.Add(l);
            Expand(x, y);
            return l;
        }
        

        public DataGridView Treeview(int x, int y, int w, int h, Action<DataGridView> cons = null)
        {
            DataGridView l = new DataGridView();
            l.Text = Text;
            l.Left = x * xScl;
            l.Top = y * yScl;
            l.Width = w * xScl;
            l.Height = h * yScl;
            if (cons != null) cons(l);
            if (current != null) current.Controls.Add(l);
            Expand(x, y, w, h);
            return l;
        }

        public Button Button(string Text, int x, int y, Action<Button> cons = null)
        {
            Button l = new Button();
            l.Text = Text;
            l.Left = x * xScl;
            l.Top = y * yScl;
            l.Width = xScl;
            if (cons != null) cons(l);
            if (current != null) current.Controls.Add(l);
            Expand(x, y);
            return l;
        }

        public Label Label(string Text, int x, int y, Action<Label> cons = null)
        {
            Label l = new Label();
            l.Text = Text;
            l.Left = x * xScl;
            l.Top = y * yScl;
            l.Height = yScl;
            l.Width = xScl;

            //l.Location = new System.Drawing.Point(x * gridScl, y * gridScl);
            if (cons != null) cons(l);
            if (current != null) current.Controls.Add(l);

            Expand(x, y);
            //using (Graphics g = this.CreateGraphics())
            //{
            //    // Measure the string
            //    SizeF textSize = g.MeasureString(l.Text, l.Font);

            //    // The calculated width before rendering
            //    float calculatedWidth = textSize.Width;

            //    MessageBox.Show($"Calculated Label Width: {calculatedWidth} pixels");
            //}

            return l;
        }

        public void Expand(int x, int y, int w = 1, int h = 1)
        {
            frameWidth = Math.Max(frameWidth, (x + w + 1) * xScl);
            frameHeight = Math.Max(frameHeight, (y + h + 1) * yScl);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            SuspendLayout();
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            Name = "Управление Базой данных";
            Text = "Управление Базой данных";
            ResumeLayout(false);

            build();

            ClientSize = new Size(frameWidth, frameHeight);
        }

        #endregion
    }

}
