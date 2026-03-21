using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Event
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("title")] public string Title { get; set; } = "";
    [JsonPropertyName("image")] public string? Image { get; set; }
    [JsonPropertyName("venue_id")] public string? VenueId { get; set; }
    [JsonPropertyName("event_date")] public string EventDate { get; set; } = "";
    [JsonPropertyName("event_status")] public string EventStatus { get; set; } = "new";
    [JsonPropertyName("description")] public string? Description { get; set; }
    [JsonPropertyName("organizer")] public string? Organizer { get; set; }
}
