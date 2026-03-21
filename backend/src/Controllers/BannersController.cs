using Microsoft.AspNetCore.Mvc;
using CheersApi.Services;
using CheersApi.Models;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("banners")]
public class BannersController : ControllerBase
{
    private readonly DynamoService _db;

    public BannersController(DynamoService db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var banners = await _db.GetBanners();
        return Ok(banners.OrderBy(b => b.SortOrder).ToList());
    }

    [HttpPost]
    [AdminAuth]
    public async Task<IActionResult> Create([FromBody] Banner banner)
    {
        banner.Id = Guid.NewGuid().ToString("N")[..12];
        await _db.PutBanner(banner);
        return Ok(new { message = "Created", id = banner.Id });
    }

    [HttpDelete("{id}")]
    [AdminAuth]
    public async Task<IActionResult> Delete(string id)
    {
        await _db.DeleteItem("cheers_banners", id);
        return Ok(new { message = "Deleted" });
    }
}
