using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace AksProxyDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        // GET api/values
        [HttpGet]
        public ActionResult<string> Get()
        {
            var response = new ExampleResponse();
            response.Values.Add("value1");
            response.Values.Add("value2");

            foreach (var requestHeader in HttpContext.Request.Headers.OrderBy(a => a.Key))
            {
                response.Headers.Add(requestHeader.Key, requestHeader.Value);
            }

            return JsonConvert.SerializeObject(response, Formatting.Indented, 
                new JsonSerializerSettings
                {
                    ContractResolver = new CamelCasePropertyNamesContractResolver()
                });
        }

        public class ExampleResponse
        {
            public List<string> Values = new List<string>();
            public Dictionary<string,string> Headers = new Dictionary<string, string>();
        }
    }
}