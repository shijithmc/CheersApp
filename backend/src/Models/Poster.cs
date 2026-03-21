using System.Text.Json.Serialization;

namespace CheersApi.Models;

public class Poster
{
    [JsonPropertyName("id")] public string Id { get; set; } = "";
    [JsonPropertyName("venue_name")] public string VenueName { get; set; } = "";
    [JsonPropertyName("venue_meta")] public string VenueMeta { get; set; } = "";
    [JsonPropertyName("avatar_emoji")] public string? AvatarEmoji { get; set; }
    [JsonPropertyName("avatar_text")] public string? AvatarText { get; set; }
    [JsonPropertyName("tag")] public string? Tag { get; set; }
    [JsonPropertyName("tag_color")] public string? TagColor { get; set; }
    [JsonPropertyName("top_right_label")] public string? TopRightLabel { get; set; }
    [JsonPropertyName("bg_color1")] public string BgColor1 { get; set; } = "";
    [JsonPropertyName("bg_color2")] public string BgColor2 { get; set; } = "";
    [JsonPropertyName("height")] public double Height { get; set; } = 260;
    [JsonPropertyName("content_title")] public string ContentTitle { get; set; } = "";
    [JsonPropertyName("content_subtitle")] public string? ContentSubtitle { get; set; }
    [JsonPropertyName("content_emoji")] public string? ContentEmoji { get; set; }
    [JsonPropertyName("image")] public string? Image { get; set; }
    [JsonPropertyName("save_label")] public string? SaveLabel { get; set; }
    [JsonPropertyName("save_color")] public string? SaveColor { get; set; }
    [JsonPropertyName("category")] public string Category { get; set; } = "";
    [JsonPropertyName("like_count")] public int LikeCount { get; set; } = 0;
    [JsonPropertyName("comment_count")] public int CommentCount { get; set; } = 0;
    [JsonPropertyName("sort_order")] public int SortOrder { get; set; }
}
