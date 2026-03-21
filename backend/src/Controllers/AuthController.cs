using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;

namespace CheersApi.Controllers;

[ApiController]
[Route("auth")]
public class AuthController : ControllerBase
{
    private readonly OtpService _otp;
    private readonly DynamoService _db;

    public AuthController(OtpService otp, DynamoService db)
    {
        _otp = otp;
        _db = db;
    }

    [HttpPost("otp")]
    public async Task<IActionResult> SendOtp([FromBody] OtpRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Phone))
            return BadRequest(new { error = "Phone number is required" });

        await _otp.GenerateAndSend(request.Phone);
        return Ok(new { message = "OTP sent", phone = request.Phone });
    }

    [HttpPost("verify")]
    public async Task<IActionResult> VerifyOtp([FromBody] VerifyRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Phone) || string.IsNullOrWhiteSpace(request.Otp))
            return BadRequest(new { error = "Phone and OTP are required" });

        var valid = await _otp.Verify(request.Phone, request.Otp);
        if (!valid)
            return Unauthorized(new { error = "Invalid or expired OTP" });

        // Check if user exists, otherwise create
        var existingUsers = await _db.GetUser(request.Phone);
        string uid;
        if (existingUsers != null)
        {
            uid = existingUsers.Uid;
        }
        else
        {
            uid = Guid.NewGuid().ToString("N")[..12];
            var user = new User { Uid = uid, Phone = request.Phone, Points = 50 };
            await _db.PutUser(user);
            await _db.AddPoints(uid, 50);
        }

        return Ok(new { uid, token = $"tok_{uid}", message = "Verified" });
    }
}
