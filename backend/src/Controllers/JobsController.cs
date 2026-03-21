using Microsoft.AspNetCore.Mvc;
using CheersApi.Models;
using CheersApi.Services;
using CheersApi.Middleware;

namespace CheersApi.Controllers;

[ApiController]
[Route("jobs")]
public class JobsController : ControllerBase
{
    private readonly DynamoService _db;

    public JobsController(DynamoService db) => _db = db;

    [HttpGet]
    public async Task<IActionResult> GetAll() => Ok(await _db.GetJobs());

    [HttpPost("{id}/apply")]
    public IActionResult Apply(string id) => Ok(new { message = "Applied" });

    [HttpPost]
    [AdminAuth]
    public async Task<IActionResult> Create([FromBody] Job job)
    {
        job.Id = Guid.NewGuid().ToString("N")[..12];
        await _db.PutJob(job);
        return Ok(new { message = "Created", id = job.Id });
    }

    [HttpDelete("{id}")]
    [AdminAuth]
    public async Task<IActionResult> Delete(string id)
    {
        await _db.DeleteItem("cheers_jobs", id);
        return Ok(new { message = "Deleted" });
    }
}
