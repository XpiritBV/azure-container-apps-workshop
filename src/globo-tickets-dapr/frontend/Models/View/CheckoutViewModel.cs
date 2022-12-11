using System.ComponentModel.DataAnnotations;

namespace GloboTicket.Frontend.Models.View;

public class CheckoutViewModel
{
    public Guid BasketId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string Town { get; set; } = string.Empty;
    public string PostalCode { get; set; } = string.Empty;
    [EmailAddress]
    public string Email { get; set; } = string.Empty;
    [CreditCard]
    public string CreditCard { get; set; } = string.Empty;
    public string CreditCardDate { get; set; } = string.Empty;

    public int BulkNumber { get; set; } = 1;
}
