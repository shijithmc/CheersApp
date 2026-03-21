using Amazon.DynamoDBv2;
using Amazon.Runtime;
using Amazon.SimpleNotificationService;
using CheersApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// Local DynamoDB - dummy credentials, no real AWS auth needed
builder.Services.AddSingleton<IAmazonDynamoDB>(_ => new AmazonDynamoDBClient(
    new BasicAWSCredentials("local", "local"),
    new AmazonDynamoDBConfig { ServiceURL = "http://localhost:8000" }));

builder.Services.AddSingleton<IAmazonSimpleNotificationService>(_ => new AmazonSimpleNotificationServiceClient(
    new BasicAWSCredentials("local", "local"),
    new AmazonSimpleNotificationServiceConfig { ServiceURL = "http://localhost:8000" }));

builder.Services.AddSingleton<DynamoService>();
builder.Services.AddSingleton<OtpService>();
builder.Services.AddCors(o => o.AddDefaultPolicy(p => p.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()));

var app = builder.Build();

app.UseCors();
app.MapControllers();
app.Run();
