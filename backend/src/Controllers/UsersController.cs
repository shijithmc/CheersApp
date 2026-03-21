using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;

namespace CheersApi.Controllers;

[ApiController]
[Route("users")]
public class UsersController : ControllerBase
{
    private readonly DynamoService _db;

    public UsersController(DynamoService db) => _db = db;

    [HttpGet("{uid}")]
    public async Task<IActionResult> Get(string uid)
    {
        var user = await _db.GetUser(uid);
        return user != null ? Ok(user) : NotFound(new { error = "Not found" });
    }

    [HttpPut("{uid}")]
    public async Task<IActionResult> Update(string uid, [FromBody] User user)
    {
        user.Uid = uid;
        await _db.PutUser(user);
        return Ok(new { message = "Updated" });
    }
}
