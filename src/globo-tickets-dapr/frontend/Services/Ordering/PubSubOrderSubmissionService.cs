using Dapr.Client;
using GloboTicket.Frontend.Models.Api;
using GloboTicket.Frontend.Models.View;
using GloboTicket.Frontend.Services.ShoppingBasket;

namespace GloboTicket.Frontend.Services.Ordering;

public class PubSubOrderSubmissionService : IOrderSubmissionService
{
    private readonly IShoppingBasketService shoppingBasketService;
    private DaprClient orderingClient;

    public PubSubOrderSubmissionService(IShoppingBasketService shoppingBasketService, DaprClient orderingClient)
    {
        this.shoppingBasketService = shoppingBasketService;
        this.orderingClient = orderingClient;
    }
    public async Task<Guid> SubmitOrder(CheckoutViewModel checkoutViewModel)
    {

        var lines = await shoppingBasketService.GetLinesForBasket(checkoutViewModel.BasketId);
        var order = new OrderForCreation();
        order.Date = DateTimeOffset.Now;
        order.OrderId = Guid.NewGuid();
        order.Lines = lines.Select(line => new OrderLine() { ConcertId = line.ConcertId, Price = line.Price, TicketCount = line.TicketAmount }).ToList();
        order.CustomerDetails = new CustomerDetails()
        {
            Address = checkoutViewModel.Address,
            CreditCardNumber = checkoutViewModel.CreditCard,
            Email = checkoutViewModel.Email,
            Name = checkoutViewModel.Name,
            PostalCode = checkoutViewModel.PostalCode,
            Town = checkoutViewModel.Town,
            CreditCardExpiryDate = checkoutViewModel.CreditCardDate
        };

        for (var i = 0; i < checkoutViewModel.BulkNumber; i++)
        {
            await orderingClient.PublishEventAsync("pubsub", "orders", order);
        }

        return order.OrderId;
    }
}