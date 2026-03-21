using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace CheersApi.Middleware;

[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
public class AdminAuthAttribute : Attribute, IAuthorizationFilter
{
    private const string AdminTokenPrefix = "adm_";

    public void OnAuthorization(AuthorizationFilterContext context)
    {
        var headers = context.HttpContext.Request.Headers;

        var hasAdminHeader = headers.TryGetValue("X-Admin", out var admin) && admin == "true";
        var hasToken = headers.TryGetValue("Authorization", out var auth)
                       && auth.ToString().StartsWith($"Bearer {AdminTokenPrefix}");

        if (!hasAdminHeader || !hasToken)
        {
            context.Result = new JsonResult(new { error = "Admin access required" }) { StatusCode = 403 };
        }
    }
}
