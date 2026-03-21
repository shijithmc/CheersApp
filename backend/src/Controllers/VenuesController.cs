using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("venues")]
public class VenuesController : ControllerBase
{
    private readonly DynamoService _db;

    public VenuesController(DynamoService db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? category)
    {
        var venues = await _db.GetVenues();
        if (category != null)
            venues = venues.Where(v => v.Category == category).ToList();
        return Ok(venues);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(string id)
    {
        var venue = await _db.GetVenue(id);
        return venue != null ? Ok(venue) : NotFound(new { error = "Not found" });
    }

    [AdminAuth]
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] Venue venue)
    {
        venue.Id = Guid.NewGuid().ToString("N")[..12];
        await _db.PutVenue(venue);
        return Ok(new { message = "Created", id = venue.Id });
    }

    [AdminAuth]
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        await _db.DeleteItem("cheers_venues", id);
        return Ok(new { message = "Deleted" });
    }
}
