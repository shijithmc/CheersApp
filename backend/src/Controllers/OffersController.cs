using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("offers")]
public class OffersController : ControllerBase
{
    private readonly DynamoService _db;

    public OffersController(DynamoService db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll() => Ok(await _db.GetOffers());

    [HttpPost]
    [AdminAuth]
    public async Task<IActionResult> Create([FromBody] Offer offer)
    {
        offer.Id = Guid.NewGuid().ToString("N")[..12];
        await _db.PutOffer(offer);
        return Ok(new { message = "Created", id = offer.Id });
    }

    [HttpDelete("{id}")]
    [AdminAuth]
    public async Task<IActionResult> Delete(string id)
    {
        await _db.DeleteItem("cheers_offers", id);
        return Ok(new { message = "Deleted" });
    }
}
