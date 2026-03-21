using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class OtpRecord
{
    [JsonPropertyName("phone")] public string Phone { get; set; } = "";
    [JsonPropertyName("otp")] public string Otp { get; set; } = "";
    [JsonPropertyName("expires_at")] public long ExpiresAt { get; set; }
}
