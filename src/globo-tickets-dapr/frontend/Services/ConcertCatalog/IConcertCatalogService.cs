using GloboTicket.Frontend.Models.Api;

namespace GloboTicket.Frontend.Services.ConcertCatalog;

public interface IConcertCatalogService
{
    Task<IEnumerable<Concert>> GetAll();

    Task<Concert> GetConcert(Guid id);

}
