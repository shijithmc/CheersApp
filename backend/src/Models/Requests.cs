using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class OtpRequest
{
    [JsonPropertyName("phone")] public string Phone { get; set; } = "";
}

public class VerifyRequest
{
    [JsonPropertyName("phone")] public string Phone { get; set; } = "";
    [JsonPropertyName("otp")] public string Otp { get; set; } = "";
}

public class ReferralRequest
{
    [JsonPropertyName("user_id")] public string UserId { get; set; } = "";
    [JsonPropertyName("referral_code")] public string ReferralCode { get; set; } = "";
}

public class AdminLoginRequest
{
    [JsonPropertyName("email")] public string Email { get; set; } = "";
    [JsonPropertyName("password")] public string Password { get; set; } = "";
}
