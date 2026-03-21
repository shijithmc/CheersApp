using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class User
{
    [JsonPropertyName("uid")] public string Uid { get; set; } = "";
    [JsonPropertyName("name")] public string Name { get; set; } = "";
    [JsonPropertyName("phone")] public string Phone { get; set; } = "";
    [JsonPropertyName("age")] public int Age { get; set; }
    [JsonPropertyName("blood_group")] public string? BloodGroup { get; set; }
    [JsonPropertyName("email")] public string? Email { get; set; }
    [JsonPropertyName("location")] public string? Location { get; set; }
    [JsonPropertyName("address")] public string? Address { get; set; }
    [JsonPropertyName("pincode")] public string? Pincode { get; set; }
    [JsonPropertyName("points")] public int Points { get; set; }
    [JsonPropertyName("profile_image")] public string? ProfileImage { get; set; }
    [JsonPropertyName("created_at")] public string CreatedAt { get; set; } = DateTime.UtcNow.ToString("o");
}
