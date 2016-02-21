using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.UI;

namespace WebApplication1
{
    public class StringTable
    {
        public string[] ColumnNames { get; set; }
        public string[,] Values { get; set; }
    }







    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected async void Button1_Click(object sender, EventArgs e)
        {
            var values = new string[,] 
            { 
                { "0", "value", "value", "0", "0", "0", "0", "0", "0", "0" },
                { "0", "value", "value", "0", "0", "0", "0", "0", "0", "0" },
            };

            var result = await InvokeRequestResponseService(values);


            TextBox1.Text = result;
        }

        static async Task<string> InvokeRequestResponseService(string[,] values)
        {
            using (var client = new HttpClient())
            {
                var scoreRequest = new
                {

                    Inputs = new Dictionary<string, StringTable>() {
                        {
                            "input1",
                            new StringTable()
                            {
                                ColumnNames = new string[] {"Age", "Martial Status", "Job", "Price", "BD", "BT", "Size", "LIKE/NLIKE", "LAT", "LONG"},
                                Values = values
                            }
                        },
                    },
                    GlobalParameters = new Dictionary<string, string>()
                    {
                    }
                };
                const string apiKey = "ARsQ7plW80KOG1UclqKQgSijQKfy/yd9rFGBsq+3mjIYfU4zw0UBS+Irut9vuPTfgsseQwsIHUB0Lu3OVAJYpw=="; // Replace this with the API key for the web service
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

                client.BaseAddress = new Uri("https://asiasoutheast.services.azureml.net/workspaces/5dd1ce8a14f04df4b6fa235753249c68/services/b450537bc38f4dd4a53459c3e8e68baa/execute?api-version=2.0&details=true");

                // WARNING: The 'await' statement below can result in a deadlock if you are calling this code from the UI thread of an ASP.Net application.
                // One way to address this would be to call ConfigureAwait(false) so that the execution does not attempt to resume on the original context.
                // For instance, replace code such as:
                //      result = await DoSomeTask()
                // with the following:
                //      result = await DoSomeTask().ConfigureAwait(false)


                HttpResponseMessage response = await client.PostAsJsonAsync("", scoreRequest);

                if (response.IsSuccessStatusCode)
                {
                    string result = await response.Content.ReadAsStringAsync();
                    return result;
                    //Console.WriteLine("Result: {0}", result);
                }
                else
                {
                    return null;
                    //Console.WriteLine(string.Format("The request failed with status code: {0}", response.StatusCode));

                    //// Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
                    //Console.WriteLine(response.Headers.ToString());

                    //string responseContent = await response.Content.ReadAsStringAsync();
                    //Console.WriteLine(responseContent);
                }
            }
        }
    }
}