using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Points
{
    [JsonPropertyName("user_id")] public string UserId { get; set; } = "";
    [JsonPropertyName("total_points")] public int TotalPoints { get; set; }
    [JsonPropertyName("last_updated")] public string LastUpdated { get; set; } = DateTime.UtcNow.ToString("o");
}
