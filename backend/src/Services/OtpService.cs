using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;
using CheersApi.Models;

namespace CheersApi.Services;

public class OtpService
{
    private readonly IAmazonSimpleNotificationService _sns;
    private readonly DynamoService _db;
    private static readonly Random _rng = new();
    private const int OtpExpirySeconds = 300; // 5 minutes

    public OtpService(IAmazonSimpleNotificationService sns, DynamoService db)
    {
        _sns = sns;
        _db = db;
    }

    public async Task<string> GenerateAndSend(string phone)
    {
        var otp = _rng.Next(100000, 999999).ToString();
        var expiresAt = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + OtpExpirySeconds;

        // Store OTP in DynamoDB
        await _db.PutOtp(new OtpRecord { Phone = phone, Otp = otp, ExpiresAt = expiresAt });

        // Send via SNS
        var formattedPhone = phone.StartsWith("+") ? phone : $"+91{phone}";
        await _sns.PublishAsync(new PublishRequest
        {
            PhoneNumber = formattedPhone,
            Message = $"Your Cheers verification code is: {otp}. Valid for 5 minutes.",
            MessageAttributes = new Dictionary<string, MessageAttributeValue>
            {
                ["AWS.SNS.SMS.SMSType"] = new() { StringValue = "Transactional", DataType = "String" },
                ["AWS.SNS.SMS.SenderID"] = new() { StringValue = "Cheers", DataType = "String" },
            }
        });

        return otp;
    }

    public async Task<bool> Verify(string phone, string otp)
    {
        var record = await _db.GetOtp(phone);
        if (record == null) return false;
        if (record.Otp != otp) return false;
        if (DateTimeOffset.UtcNow.ToUnixTimeSeconds() > record.ExpiresAt) return false;

        // Delete used OTP
        await _db.DeleteOtp(phone);
        return true;
    }
}
