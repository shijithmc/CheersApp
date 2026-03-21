using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("admin")]
public class AdminController : ControllerBase
{
    private readonly DynamoService _db;

    // TODO: Move to environment variables / AWS Secrets Manager
    private const string AdminEmail = "admin@cheers.app";
    private const string AdminPasswordHash = "admin123";
    private const string AdminTokenPrefix = "adm_";

    public AdminController(DynamoService db) => _db = db;

    [HttpPost("login")]
    public IActionResult Login([FromBody] AdminLoginRequest request)
    {
        if (request.Email == AdminEmail && request.Password == AdminPasswordHash)
        {
            var token = $"{AdminTokenPrefix}{Guid.NewGuid():N}";
            return Ok(new { token, message = "Admin authenticated" });
        }
        return Unauthorized(new { error = "Invalid credentials" });
    }

    [HttpGet("analytics")]
    [AdminAuth]
    public async Task<IActionResult> Analytics()
    {
        var venues = await _db.GetVenues();
        var events = await _db.GetEvents();
        var offers = await _db.GetOffers();
        var jobs = await _db.GetJobs();
        return Ok(new
        {
            venues = venues.Count,
            events = events.Count,
            offers = offers.Count,
            jobs = jobs.Count,
        });
    }
}
