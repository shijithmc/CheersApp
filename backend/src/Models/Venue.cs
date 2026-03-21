using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Venue
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("name")] public string Name { get; set; } = "";
    [JsonPropertyName("rating")] public double Rating { get; set; }
    [JsonPropertyName("category")] public string Category { get; set; } = "";
    [JsonPropertyName("address")] public string Address { get; set; } = "";
    [JsonPropertyName("geo_location")] public string? GeoLocation { get; set; }
    [JsonPropertyName("images")] public List<string> Images { get; set; } = new();
    [JsonPropertyName("phone")] public string Phone { get; set; } = "";
    [JsonPropertyName("website")] public string? Website { get; set; }
    [JsonPropertyName("description")] public string? Description { get; set; }
    [JsonPropertyName("star_level")] public int StarLevel { get; set; }
}
