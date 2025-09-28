
using System.Linq.Expressions;
using DatabaseFrame.database;

namespace DatabaseFrame
{
    internal static class Program
    {
        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        static async Task Main()
        {
            try
            {
                Log.Reset();
                Log.Info("Starting...");
                await Database.Connect("Server = 127.0.0.1; Port = 5432; User Id = agzam; Password = a; Database = lab1");
                Log.Info("Frame");
                ApplicationConfiguration.Initialize();
                Application.Run(new App());
            } catch (Exception e) {
                Log.Info(e.Message);
                Log.Info(e.ToString());
            }
            finally
            {
                Database.Close();
            }
        }
    }
}