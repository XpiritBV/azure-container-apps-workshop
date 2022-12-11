namespace GloboTicket.Frontend.Models.Api;

public class CustomerDetails
{
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string Town { get; set; } = string.Empty;
    public string PostalCode { get; set; } = string.Empty;
    public string CreditCardNumber { get; set; } = string.Empty;
    public string CreditCardExpiryDate { get; set; } = string.Empty;
}
