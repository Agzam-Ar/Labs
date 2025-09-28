namespace DatabaseFrame
{
    internal static class Log
    {
        public static void Reset()
        {
            File.WriteAllText("log.txt", "");
        }

        public static void Info(string message)
        {
            try
            {
                File.AppendAllText("log.txt", $"[{DateTime.Now}] [I]: {message}{Environment.NewLine}");
            }
            catch (Exception) { }
        }
    }
}
