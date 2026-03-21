using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.Model;
using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;

namespace CheersApi.Controllers;

[ApiController]
[Route("seed")]
public class SeedController : ControllerBase
{
    private readonly DynamoService _db;
    private readonly IAmazonDynamoDB _client;

    private static readonly Dictionary<string, string> TableConfigs = new()
    {
        ["cheers_users"] = "uid",
        ["cheers_venues"] = "id",
        ["cheers_events"] = "id",
        ["cheers_offers"] = "id",
        ["cheers_jobs"] = "id",
        ["cheers_points"] = "user_id",
        ["cheers_otp"] = "phone",
        ["cheers_notifications"] = "id",
        ["cheers_banners"] = "id",
        ["cheers_posters"] = "id",
    };

    public SeedController(DynamoService db, IAmazonDynamoDB client)
    {
        _db = db;
        _client = client;
    }

    [HttpPost]
    public async Task<IActionResult> Seed()
    {
        await DropAllTables();
        await CreateAllTables();

        var now = DateTime.UtcNow;

        // ── VENUES (matching HTML bar locations) ──
        var venues = new List<Venue>
        {
            new() { Id = Guid.NewGuid().ToString(), Name = "Park Residency Ramanattukara", Rating = 3.5, Category = "4 Star Bars", Address = "G.H.Road, Ramanattukara, Kozhikode 673001", Phone = "+91 495 123456", Website = "https://parkresidency.com", StarLevel = 4, Description = "Leading Luxury hotel near airport road Calicut. with Multicuisine Restaurant, Bar, Health Club, Banquets, Room Service etc" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Zirkon Bar The Raviz Calicut", Rating = 4.5, Category = "5 Star Bars", Address = "Arayidathupalam, Kozhikode, Kerala 673004", Phone = "+91 495 234567", Website = "https://raviz.com", StarLevel = 5, Description = "5 Star experience with premium bar and dining" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Kovilakam Bar", Rating = 4.0, Category = "3 Star Bars", Address = "Near M.I.M.S Hospital, Govindapuram, Kozhikode 673016", Phone = "+91 495 345678", StarLevel = 3, Description = "Popular local bar with great ambiance" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Maharani Hotel", Rating = 4.0, Category = "3 Star Bars", Address = "Op. Sahakarna Bhavan, Puthiyara, Kozhikode 673004", Phone = "+91 495 456789", StarLevel = 3, Description = "Well-known hotel with bar and restaurant" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Beach Heritage", Rating = 4.2, Category = "4 Star Bars", Address = "Beach Rd, Near Gujarati School, Mananchira, Kozhikode 673032", Phone = "+91 495 567890", StarLevel = 4, Description = "Beachside dining and bar experience" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Copperfolia", Rating = 3.8, Category = "Pubs", Address = "Hilite Mall, Kozhikode", Phone = "+91 495 678901", StarLevel = 3, Description = "Modern pub with cocktail specials" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Alakapuri Hotel", Rating = 3.9, Category = "3 Star Bars", Address = "Mavoor Road, Kozhikode", Phone = "+91 495 789012", StarLevel = 3, Description = "Classic hotel with bar and restaurant" },
            new() { Id = Guid.NewGuid().ToString(), Name = "Hotel Amrutha", Rating = 3.7, Category = "Family Bars", Address = "Palayam, Kozhikode", Phone = "+91 495 890123", StarLevel = 3, Description = "Family-friendly hotel with bar" },
        };

        // ── BANNERS (matching HTML home slider) ──
        var banners = new List<Banner>
        {
            new() { Id = Guid.NewGuid().ToString(), Title = "SUPPORT SAINTS\nAT HOME", Subtitle = "10% OFF FOR SAINTS FANS\nExclusive discount with code SFC10", Emoji = "🍺🍺", SortOrder = 0 },
            new() { Id = Guid.NewGuid().ToString(), Title = "Zirkon Bar\nThe Raviz Calicut", Subtitle = "5 Star experience tonight\nArayidathupalam, Kozhikode", Emoji = "🌃", SortOrder = 1 },
            new() { Id = Guid.NewGuid().ToString(), Title = "Beach Heritage\nSpecial Offer", Subtitle = "Beachside dining & bar\nKozhikode", Emoji = "🌊", SortOrder = 2 },
        };

        // ── EVENTS (matching HTML events list) ──
        var events = new List<Event>
        {
            new() { Id = Guid.NewGuid().ToString(), Title = "New Malabar Gold showroom Lunching Ramanttukara", EventDate = now.AddDays(5).ToString("o"), EventStatus = "launching", Organizer = "Malabar Gold" },
            new() { Id = Guid.NewGuid().ToString(), Title = "New Bride Collation Malabar Gold", EventDate = now.AddDays(3).ToString("o"), EventStatus = "new", Organizer = "Malabar Gold" },
            new() { Id = Guid.NewGuid().ToString(), Title = "New Dasra festivals offers Kalyan Jewelers", EventDate = now.AddDays(1).ToString("o"), EventStatus = "join", Organizer = "Kalyan Jewelers" },
            new() { Id = Guid.NewGuid().ToString(), Title = "New Malabar Gold Showroom inauguration Calicut", EventDate = now.ToString("o"), EventStatus = "live", Organizer = "Malabar Gold" },
            new() { Id = Guid.NewGuid().ToString(), Title = "My-g Mega offers starting 11-october to 18-october enjoy offers", EventDate = now.AddDays(10).ToString("o"), EventStatus = "coming", Organizer = "My-G" },
            new() { Id = Guid.NewGuid().ToString(), Title = "New Dasra festivals offers Kalyan Jewelers", EventDate = now.AddDays(2).ToString("o"), EventStatus = "offers", Organizer = "Kalyan Jewelers" },
            new() { Id = Guid.NewGuid().ToString(), Title = "Hananshaah Team MVR – New Year Live", EventDate = now.AddDays(30).ToString("o"), EventStatus = "coming", Organizer = "Calicut Trade Centre", Description = "Calicut Trade Centre · Dec 31 · 9:00 PM" },
            new() { Id = Guid.NewGuid().ToString(), Title = "Grand Tandoori Food Fest", EventDate = now.AddDays(7).ToString("o"), EventStatus = "new", Organizer = "Park Residency", Description = "Park Residency · Dec 22 onwards" },
        };

        // ── OFFERS ──
        var offers = new List<Offer>
        {
            new() { Id = Guid.NewGuid().ToString(), VenueId = venues[0].Id, Title = "Happy Hour - Buy 1 Get 1", DiscountPercent = 50, ValidFrom = now.ToString("o"), ValidTo = now.AddDays(30).ToString("o"), VenueName = "Park Residency", Description = "Buy one get one free on all cocktails" },
            new() { Id = Guid.NewGuid().ToString(), VenueId = venues[5].Id, Title = "Ladies Night - Free Entry", DiscountPercent = 100, ValidFrom = now.ToString("o"), ValidTo = now.AddDays(7).ToString("o"), VenueName = "Copperfolia", Description = "Free entry and 20% off on drinks for ladies every Friday" },
            new() { Id = Guid.NewGuid().ToString(), VenueId = venues[1].Id, Title = "Peg Offer - Rs.99 Specials", DiscountPercent = 40, ValidFrom = now.ToString("o"), ValidTo = now.AddDays(14).ToString("o"), VenueName = "Zirkon Bar", Description = "Selected pegs at just Rs.99" },
        };

        // ── JOBS (matching HTML) ──
        var jobs = new List<Job>
        {
            new() { Id = Guid.NewGuid().ToString(), Title = "House keeping Staff-Male", CompanyName = "SASTHAPURI HOTEL", SalaryMin = 12086, SalaryMax = 17042, Shift = "Day", Location = "Calicut, Kerala", PostedDate = now.ToString("o") },
            new() { Id = Guid.NewGuid().ToString(), Title = "Commi Chef", CompanyName = "SASTHAPURI HOTEL", SalaryMin = 12273, SalaryMax = 22257, Shift = "Day", Location = "Calicut, Kerala", PostedDate = now.AddDays(-2).ToString("o") },
            new() { Id = Guid.NewGuid().ToString(), Title = "Waitress/Bar Staff required in a star hotel", CompanyName = "Heritage Hotel", SalaryMin = 15000, SalaryMax = 25000, Shift = "Evening", Location = "Kozhikode, Kerala", PostedDate = now.AddDays(-3).ToString("o") },
            new() { Id = Guid.NewGuid().ToString(), Title = "Bartender", CompanyName = "Zirkon Bar – The Raviz", SalaryMin = 18000, SalaryMax = 28000, Shift = "Night", Location = "Calicut, Kerala", PostedDate = now.AddDays(-5).ToString("o") },
        };

        // ── NOTIFICATIONS (matching HTML) ──
        var notifications = new List<Notification>
        {
            new() { Id = Guid.NewGuid().ToString(), Title = "New Bar Lunching at Calicut", Body = "A brand new bar is opening in Calicut. Check it out!", Type = "event", Emoji = "🍺", BgColor = "0xFF1A2A3A", TimeLabel = "2 hours ago" },
            new() { Id = Guid.NewGuid().ToString(), Title = "New Bevco outlet at Palazhi", Body = "New government beverage outlet now open near Palazhi.", Type = "offer", Emoji = "🥃", BgColor = "0xFFFADBD8", TimeLabel = "5 hours ago" },
            new() { Id = Guid.NewGuid().ToString(), Title = "BIRA New Beer Launching", Body = "Bira91 launches new beer – available at selected bars.", Type = "event", Emoji = "🐒", BgColor = "0xFF111111", TimeLabel = "Yesterday" },
            new() { Id = Guid.NewGuid().ToString(), Title = "Peg Offer at Park Residancy Bar Ramanattukara", Body = "Special peg offer available today.", Type = "offer", Emoji = "🍺", BgColor = "0xFFF39C12", TimeLabel = "2 days ago" },
            new() { Id = Guid.NewGuid().ToString(), Title = "Pub DJ at GOVA Bar – Girls Free Liquor", Body = "Live DJ night this weekend. Ladies get free entry + drinks.", Type = "event", Emoji = "🎵", BgColor = "0xFF2A0A3A", TimeLabel = "3 days ago" },
        };

        // ── POSTERS (matching HTML All Posters feed) ──
        var posters = new List<Poster>
        {
            new() { Id = Guid.NewGuid().ToString(), VenueName = "Park Residency", VenueMeta = "•••", AvatarEmoji = "🏨", Tag = "New", TagColor = "0xFFE07A3A", TopRightLabel = "22nd Dec onwards", BgColor1 = "0xFF8B2252", BgColor2 = "0xFFFF6B35", Height = 280, ContentTitle = "The Grand\nTANDOORI\nfood fest", ContentSubtitle = "Authentic Feast from the Mughal Era", Category = "5 Star Bar", LikeCount = 1600, CommentCount = 11, SortOrder = 0 },
            new() { Id = Guid.NewGuid().ToString(), VenueName = "Copperfolia", VenueMeta = "•••", AvatarEmoji = "🍃", Tag = "Offer", TagColor = "0xFFE07A3A", BgColor1 = "0xFF0A0A2A", BgColor2 = "0xFF0A0A2A", Height = 260, ContentTitle = "Cocktail\nFest", ContentSubtitle = "30th July • Wednesday\nEnjoy the Spirit of ROCKS", Category = "5 Star Bar", LikeCount = 1600, CommentCount = 11, SortOrder = 1 },
            new() { Id = Guid.NewGuid().ToString(), VenueName = "Park Residency", VenueMeta = "100% Safety", AvatarEmoji = "🏨", Tag = "Breakfast Included", TagColor = "0xFF27AE60", BgColor1 = "0xFF8B4513", BgColor2 = "0xFFD2691E", Height = 200, ContentTitle = "", ContentEmoji = "🛏", Category = "4 Star Bar", LikeCount = 1600, CommentCount = 11, SortOrder = 2 },
            new() { Id = Guid.NewGuid().ToString(), VenueName = "Zirkon – Raviz Calicut", VenueMeta = "Bar & Dine", AvatarText = "ZR", Tag = "Live", TagColor = "0xFF27AE60", BgColor1 = "0xFF1A2A1A", BgColor2 = "0xFF2D5A27", Height = 240, ContentTitle = "BOUNDARIES, WICKETS, AND A SIP OF DELIGHT.", ContentSubtitle = "+1 OFFER ON BEVERAGES DURING MATCH HOURS", ContentEmoji = "🏏🍺", Category = "5 Star Bar", LikeCount = 1600, CommentCount = 11, SortOrder = 3 },
            new() { Id = Guid.NewGuid().ToString(), VenueName = "Blue Rocks", VenueMeta = "Night Club", AvatarText = "BR", Tag = "Free", TagColor = "0xFFE07A3A", BgColor1 = "0xFF0A0A2E", BgColor2 = "0xFF1A0A4E", Height = 260, ContentTitle = "BEAT", ContentSubtitle = "MOVE THE BEAT\nUN LIMITED SHOOTERS FOR LADIES\nFEATURING SEBASTIAN TINU\nJULY 22, WEDNESDAY 7:30 PM ONWARDS", Category = "Pubs", LikeCount = 1600, CommentCount = 11, SortOrder = 4 },
            new() { Id = Guid.NewGuid().ToString(), VenueName = "Jane Doe", VenueMeta = "Bartender", AvatarEmoji = "👤", BgColor1 = "0xFF1A3A1A", BgColor2 = "0xFF2D6A1A", Height = 180, ContentTitle = "How To Make\nCocktail", ContentEmoji = "🍹", SaveLabel = "Start Apply", SaveColor = "0xFF27AE60", Category = "5 Star Bar", LikeCount = 1600, CommentCount = 11, SortOrder = 5 },
        };

        // ── SEED ALL ──
        var tasks = new List<Task>();
        foreach (var v in venues) tasks.Add(_db.PutVenue(v));
        foreach (var b in banners) tasks.Add(_db.PutBanner(b));
        foreach (var e in events) tasks.Add(_db.PutEvent(e));
        foreach (var o in offers) tasks.Add(_db.PutOffer(o));
        foreach (var j in jobs) tasks.Add(_db.PutJob(j));
        foreach (var n in notifications) tasks.Add(_db.PutNotification(n));
        foreach (var p in posters) tasks.Add(_db.PutPoster(p));

        var demoUid = Guid.NewGuid().ToString();
        tasks.Add(_db.PutUser(new User { Uid = demoUid, Name = "Demo User", Phone = "+919876543210", Age = 25, BloodGroup = "O+", Email = "demo@cheers.app", Location = "Kozhikode", Address = "Beach Road, Kozhikode", Pincode = "673001", Points = 789 }));
        tasks.Add(_db.AddPoints(demoUid, 789));
        await Task.WhenAll(tasks);

        return Ok(new
        {
            message = "Seed complete",
            venues = venues.Count, banners = banners.Count, events = events.Count,
            offers = offers.Count, jobs = jobs.Count, notifications = notifications.Count,
            posters = posters.Count, demoUserId = demoUid,
        });
    }

    private async Task DropAllTables()
    {
        var existing = await _client.ListTablesAsync();
        var deleteTasks = existing.TableNames
            .Where(t => TableConfigs.ContainsKey(t))
            .Select(async t =>
            {
                await _client.DeleteTableAsync(t);
                await WaitForTableDeletion(t);
            });
        await Task.WhenAll(deleteTasks);
    }

    private async Task CreateAllTables()
    {
        foreach (var (name, pk) in TableConfigs)
        {
            await _client.CreateTableAsync(new CreateTableRequest
            {
                TableName = name,
                KeySchema = [new KeySchemaElement(pk, KeyType.HASH)],
                AttributeDefinitions = [new AttributeDefinition(pk, ScalarAttributeType.S)],
                BillingMode = BillingMode.PAY_PER_REQUEST,
            });
            await WaitForTableActive(name);
        }
    }

    private async Task WaitForTableActive(string name)
    {
        while (true)
        {
            var desc = await _client.DescribeTableAsync(name);
            if (desc.Table.TableStatus == TableStatus.ACTIVE) break;
            await Task.Delay(300);
        }
    }

    private async Task WaitForTableDeletion(string name)
    {
        while (true)
        {
            try { await _client.DescribeTableAsync(name); await Task.Delay(300); }
            catch (ResourceNotFoundException) { break; }
        }
    }
}
