using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;

namespace CheersApi.Controllers;

[ApiController]
public class PointsController : ControllerBase
{
    private readonly DynamoService _db;

    public PointsController(DynamoService db) => _db = db;

    [HttpGet("points/{userId}")]
    public async Task<IActionResult> Get(string userId) => Ok(await _db.GetPoints(userId));

    [HttpPost("referral")]
    public async Task<IActionResult> Referral([FromBody] ReferralRequest request)
    {
        await _db.AddPoints(request.UserId, 101);
        await _db.AddPoints(request.ReferralCode, 101);
        return Ok(new { message = "Referral applied", points = 101 });
    }
}
