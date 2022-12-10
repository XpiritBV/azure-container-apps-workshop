using Dapr.Client;
using Dapr.Extensions.Configuration;
using GloboTicket.Catalog;
using GloboTicket.Catalog.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddHttpClient();
builder.Services.AddSingleton<IConcertRepository, ConcertRepository>();
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddApplicationInsightsTelemetry();

builder.WebHost.ConfigureAppConfiguration(config =>
{
    var daprClient = new DaprClientBuilder().Build();
    // var secretDescriptors = new List<DaprSecretDescriptor>
    // {
    //     new DaprSecretDescriptor("catalogconnectionstring")
    // };
    // config.AddDaprSecretStore("secretstore", secretDescriptors, daprClient);
});
builder.Services.Configure<CatalogOptions>(builder.Configuration);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();
app.MapPost("scheduled", (ILoggerFactory factory, IConcertRepository repository) => 
{
    factory.CreateLogger("GloboTicket.Catalog.Scheduler")
        .LogInformation("Scheduled endpoint called");
    repository.UpdateSpecialOffer();
});
app.MapControllers();

app.Run();
