using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Job
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("title")] public string Title { get; set; } = "";
    [JsonPropertyName("company_name")] public string CompanyName { get; set; } = "";
    [JsonPropertyName("salary_min")] public int SalaryMin { get; set; }
    [JsonPropertyName("salary_max")] public int SalaryMax { get; set; }
    [JsonPropertyName("shift")] public string? Shift { get; set; }
    [JsonPropertyName("location")] public string? Location { get; set; }
    [JsonPropertyName("description")] public string? Description { get; set; }
    [JsonPropertyName("posted_date")] public string PostedDate { get; set; } = DateTime.UtcNow.ToString("o");
}
