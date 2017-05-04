using System;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace netcore
{
    public class PlaintextMiddleware
    {

        private static readonly byte[] _helloWorldPayload = Encoding.UTF8.GetBytes("Hello World");

        private readonly RequestDelegate _next;

        public PlaintextMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public Task Invoke(HttpContext httpContext)
        {
            httpContext.Response.StatusCode = 200;
            httpContext.Response.ContentType = "text/plain";
            httpContext.Response.Headers["Content-Length"] = $"{_helloWorldPayload.Length}";;
            return httpContext.Response.Body.WriteAsync(_helloWorldPayload, 0, _helloWorldPayload.Length);
        }
    }

    public static class PlaintextMiddlewareExtensions
    {
        public static IApplicationBuilder UsePlainText(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<PlaintextMiddleware>();
        }
    }
}
