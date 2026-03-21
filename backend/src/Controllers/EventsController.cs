using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("events")]
public class EventsController : ControllerBase
{
    private readonly DynamoService _db;

    public EventsController(DynamoService db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll() => Ok(await _db.GetEvents());

    [HttpPost]
    [AdminAuth]
    public async Task<IActionResult> Create([FromBody] Event evt)
    {
        evt.Id = Guid.NewGuid().ToString("N")[..12];
        await _db.PutEvent(evt);
        return Ok(new { message = "Created", id = evt.Id });
    }

    [HttpDelete("{id}")]
    [AdminAuth]
    public async Task<IActionResult> Delete(string id)
    {
        await _db.DeleteItem("cheers_events", id);
        return Ok(new { message = "Deleted" });
    }
}
