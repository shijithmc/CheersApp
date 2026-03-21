using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Notification
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("title")] public string Title { get; set; } = "";
    [JsonPropertyName("body")] public string Body { get; set; } = "";
    [JsonPropertyName("type")] public string Type { get; set; } = "";
    [JsonPropertyName("emoji")] public string Emoji { get; set; } = "";
    [JsonPropertyName("bg_color")] public string BgColor { get; set; } = "";
    [JsonPropertyName("time_label")] public string TimeLabel { get; set; } = "";
    [JsonPropertyName("created_at")] public string CreatedAt { get; set; } = DateTime.UtcNow.ToString("o");
}
