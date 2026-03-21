using Microsoft.AspNetCore.Mvc;
using CheersApi.Services;

namespace CheersApi.Controllers;

[ApiController]
[Route("notifications")]
public class NotificationsController : ControllerBase
{
    private readonly DynamoService _db;

    public NotificationsController(DynamoService db) => _db = db;

    [HttpGet("{userId}")]
    public async Task<IActionResult> Get(string userId) => Ok(await _db.GetNotifications());
}
