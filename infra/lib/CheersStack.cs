using Amazon.CDK;
using Amazon.CDK.AWS.DynamoDB;
using Amazon.CDK.AWS.ECS;
using Amazon.CDK.AWS.ECS.Patterns;
using Amazon.CDK.AWS.IAM;
using Constructs;

namespace CheersInfra;

public class CheersStack : Stack
{
    public CheersStack(Construct scope, string id, IStackProps? props = null) : base(scope, id, props)
    {
        // DynamoDB Tables
        var tableConfigs = new Dictionary<string, string>
        {
            ["cheers_users"] = "uid",
            ["cheers_venues"] = "id",
            ["cheers_events"] = "id",
            ["cheers_offers"] = "id",
            ["cheers_jobs"] = "id",
            ["cheers_points"] = "user_id",
            ["cheers_otp"] = "phone",
        };

        var dynamoTables = new List<Table>();
        foreach (var (name, pk) in tableConfigs)
        {
            var table = new Table(this, name, new TableProps
            {
                TableName = name,
                PartitionKey = new Attribute { Name = pk, Type = AttributeType.STRING },
                BillingMode = BillingMode.PAY_PER_REQUEST,
                RemovalPolicy = RemovalPolicy.DESTROY,
            });

            // TTL on OTP table for auto-expiry
            if (name == "cheers_otp")
                table.AddGlobalSecondaryIndex(new GlobalSecondaryIndexProps
                {
                    IndexName = "expires-index",
                    PartitionKey = new Attribute { Name = "phone", Type = AttributeType.STRING },
                });

            dynamoTables.Add(table);
        }

        // Fargate Web API
        var service = new ApplicationLoadBalancedFargateService(this, "CheersApiService",
            new ApplicationLoadBalancedFargateServiceProps
            {
                ServiceName = "cheers-api",
                Cpu = 256,
                MemoryLimitMiB = 512,
                DesiredCount = 1,
                TaskImageOptions = new ApplicationLoadBalancedTaskImageOptions
                {
                    Image = ContainerImage.FromAsset("../backend/src"),
                    ContainerPort = 8080,
                },
                PublicLoadBalancer = true,
            });

        // Grant DynamoDB access
        foreach (var t in dynamoTables)
            t.GrantReadWriteData(service.TaskDefinition.TaskRole);

        // Grant SNS publish for OTP
        service.TaskDefinition.TaskRole.AddManagedPolicy(
            ManagedPolicy.FromAwsManagedPolicyName("AmazonSNSFullAccess"));

        // Output the API URL
        new CfnOutput(this, "ApiUrl", new CfnOutputProps
        {
            Value = service.LoadBalancer.LoadBalancerDnsName,
            Description = "Cheers API URL",
        });
    }
}

public class Program
{
    public static void Main()
    {
        var app = new App();
        new CheersStack(app, "CheersStack", new StackProps
        {
            Env = new Amazon.CDK.Environment { Region = "ap-south-1" }
        });
        app.Synth();
    }
}
