using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Offer
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("venue_id")] public string? VenueId { get; set; }
    [JsonPropertyName("title")] public string Title { get; set; } = "";
    [JsonPropertyName("description")] public string? Description { get; set; }
    [JsonPropertyName("discount_percent")] public int DiscountPercent { get; set; }
    [JsonPropertyName("valid_from")] public string ValidFrom { get; set; } = "";
    [JsonPropertyName("valid_to")] public string ValidTo { get; set; } = "";
    [JsonPropertyName("venue_name")] public string? VenueName { get; set; }
}
