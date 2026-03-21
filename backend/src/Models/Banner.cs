using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Banner
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("title")] public string Title { get; set; } = "";
    [JsonPropertyName("subtitle")] public string Subtitle { get; set; } = "";
    [JsonPropertyName("emoji")] public string Emoji { get; set; } = "";
    [JsonPropertyName("image")] public string? Image { get; set; }
    [JsonPropertyName("sort_order")] public int SortOrder { get; set; }
}
