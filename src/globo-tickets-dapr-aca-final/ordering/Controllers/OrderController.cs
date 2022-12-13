using Dapr;
using GloboTicket.Ordering.Model;
using GloboTicket.Ordering.Services;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.AspNetCore.Mvc;

namespace GloboTicket.Ordering.Controllers;

[ApiController]
[Route("[controller]")]
public class OrderController : ControllerBase
{
    private readonly ILogger<OrderController> logger;
    private readonly EmailSender emailSender;
    private readonly TelemetryClient telemetryCient;

    public OrderController(ILogger<OrderController> logger, TelemetryClient telemetryClient, EmailSender emailSender)
    {
        this.logger = logger;
        this.emailSender = emailSender;
        telemetryCient = telemetryClient;
    }

    [HttpPost("", Name = "SubmitOrder")]
    [Topic("pubsub", "orders")]
    public IActionResult Submit(OrderForCreation order)
    {
        logger.LogInformation($"Received a new order from {order.CustomerDetails.Name}");
        SendAppInsightsTelemetryOrderProcessed();
        emailSender.SendEmailForOrder(order);
        return Ok();
    }

    private void SendAppInsightsTelemetryOrderProcessed()
    {
        var telemetry = new MetricTelemetry
        {
            Name = "Order processed",

            Count = 1
        };
        telemetryCient.TrackMetric(telemetry);
    }
}
