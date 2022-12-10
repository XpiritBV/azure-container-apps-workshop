using Dapr.Client;
using GloboTicket.Ordering.Model;

namespace GloboTicket.Ordering.Services;

public class EmailSender
{
    private readonly ILogger<EmailSender> logger;
    private readonly DaprClient daprClient;

    public EmailSender(ILogger<EmailSender> logger, DaprClient daprClient)
    {
        this.logger = logger;
        this.daprClient = daprClient;
    }

    public async Task SendEmailForOrder(OrderForCreation order)
    {
        logger.LogInformation($"Received a new order for {order.CustomerDetails.Email}");
        logger.LogInformation($"Sending email");
        var metadata = new Dictionary<string, string>
        {
            ["emailFrom"] = "noreply@globoticket.shop",
            ["emailTo"] = order.CustomerDetails.Email,
            ["subject"] = $"Thank you for your order"
        };
        var body = $"<h2>Your order has been received</h2>"
        + "<p>Your tickets are on the way!</p>";
        await daprClient.InvokeBindingAsync("sendmail", "create", body, metadata);        }
}