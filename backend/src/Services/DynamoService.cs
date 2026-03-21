using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DocumentModel;
using System.Text.Json;
using CheersApi.Models;

namespace CheersApi.Services;

public class DynamoService
{
    private readonly IAmazonDynamoDB _client;

    public DynamoService(IAmazonDynamoDB client) => _client = client;

    private Table GetTable(string name) => Table.LoadTable(_client, name);

    private async Task<List<T>> ScanAll<T>(string tableName)
    {
        var table = GetTable(tableName);
        var search = table.Scan(new ScanFilter());
        var results = new List<T>();
        do
        {
            var docs = await search.GetNextSetAsync();
            results.AddRange(docs.Select(d => JsonSerializer.Deserialize<T>(d.ToJson())!));
        } while (!search.IsDone);
        return results;
    }

    private async Task<T?> GetById<T>(string tableName, string id) where T : class
    {
        var table = GetTable(tableName);
        var doc = await table.GetItemAsync(id);
        return doc == null ? null : JsonSerializer.Deserialize<T>(doc.ToJson());
    }

    private async Task Put(string tableName, object item)
    {
        var table = GetTable(tableName);
        var doc = Document.FromJson(JsonSerializer.Serialize(item));
        await table.PutItemAsync(doc);
    }

    public async Task DeleteItem(string tableName, string id)
    {
        var table = GetTable(tableName);
        await table.DeleteItemAsync(id);
    }

    // Users
    public Task<User?> GetUser(string uid) => GetById<User>("cheers_users", uid);
    public Task PutUser(User user) => Put("cheers_users", user);

    // Venues
    public Task<List<Venue>> GetVenues() => ScanAll<Venue>("cheers_venues");
    public Task<Venue?> GetVenue(string id) => GetById<Venue>("cheers_venues", id);
    public Task PutVenue(Venue venue) => Put("cheers_venues", venue);

    // Events
    public Task<List<Event>> GetEvents() => ScanAll<Event>("cheers_events");
    public Task PutEvent(Event evt) => Put("cheers_events", evt);

    // Offers
    public Task<List<Offer>> GetOffers() => ScanAll<Offer>("cheers_offers");
    public Task PutOffer(Offer offer) => Put("cheers_offers", offer);

    // Jobs
    public Task<List<Job>> GetJobs() => ScanAll<Job>("cheers_jobs");
    public Task PutJob(Job job) => Put("cheers_jobs", job);

    // Points
    public async Task<Points> GetPoints(string userId)
    {
        var p = await GetById<Points>("cheers_points", userId);
        return p ?? new Points { UserId = userId, TotalPoints = 0 };
    }

    public async Task AddPoints(string userId, int amount)
    {
        var p = await GetPoints(userId);
        p.TotalPoints += amount;
        p.LastUpdated = DateTime.UtcNow.ToString("o");
        await Put("cheers_points", p);
    }

    // Notifications
    public Task<List<Notification>> GetNotifications() => ScanAll<Notification>("cheers_notifications");
    public Task PutNotification(Notification n) => Put("cheers_notifications", n);

    // Banners
    public Task<List<Banner>> GetBanners() => ScanAll<Banner>("cheers_banners");
    public Task PutBanner(Banner b) => Put("cheers_banners", b);

    // Posters
    public Task<List<Poster>> GetPosters() => ScanAll<Poster>("cheers_posters");
    public Task PutPoster(Poster p) => Put("cheers_posters", p);

    // OTP
    public Task PutOtp(OtpRecord otp) => Put("cheers_otp", otp);
    public Task<OtpRecord?> GetOtp(string phone) => GetById<OtpRecord>("cheers_otp", phone);
    public Task DeleteOtp(string phone) => DeleteItem("cheers_otp", phone);
}
