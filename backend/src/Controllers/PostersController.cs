using Microsoft.AspNetCore.Mvc;
using CheersApi.Services;
using CheersApi.Models;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("posters")]
public class PostersController : ControllerBase
{
    private readonly DynamoService _db;

    public PostersController(DynamoService db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? category)
    {
        var posters = await _db.GetPosters();
        if (!string.IsNullOrEmpty(category))
            posters = posters.Where(p => p.Category == category).ToList();
        return Ok(posters.OrderBy(p => p.SortOrder).ToList());
    }

    [HttpPost]
    [AdminAuth]
    public async Task<IActionResult> Create([FromBody] Poster poster)
    {
        poster.Id = Guid.NewGuid().ToString("N")[..12];
        await _db.PutPoster(poster);
        return Ok(new { message = "Created", id = poster.Id });
    }

    [HttpDelete("{id}")]
    [AdminAuth]
    public async Task<IActionResult> Delete(string id)
    {
        await _db.DeleteItem("cheers_posters", id);
        return Ok(new { message = "Deleted" });
    }
}
