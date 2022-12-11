using GloboTicket.Frontend.Extensions;
using GloboTicket.Frontend.Models.Api;

namespace GloboTicket.Frontend.Services.ConcertCatalog;

public class ConcertCatalogService : IConcertCatalogService
{
    private readonly HttpClient client;

    public ConcertCatalogService(HttpClient client)
    {
        this.client = client;
    }

    public async Task<IEnumerable<Concert>> GetAll()
    {
        var response = await client.GetAsync("concert");
        return await response.ReadContentAs<List<Concert>>();
    }

    public async Task<Concert> GetConcert(Guid id)
    {
        var response = await client.GetAsync($"concert/{id}");
        return await response.ReadContentAs<Concert>();
    }
}
