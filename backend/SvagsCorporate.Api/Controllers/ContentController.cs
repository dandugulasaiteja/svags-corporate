using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SvagsCorporate.Api.Data;
using SvagsCorporate.Api.Dtos;
using SvagsCorporate.Api.Models;
using System.Net.Mime;

namespace SvagsCorporate.Api.Controllers;

[ApiController]
[Route("api")]
[Produces("application/json")]
public class ContentController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly ILogger<ContentController> _logger;

    public ContentController(AppDbContext context, ILogger<ContentController> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Get all products
    /// </summary>
    [HttpGet("products")]
    public async Task<ActionResult<ApiResponse<List<ProductDto>>>> GetProducts()
    {
        try
        {
            var products = await _context.Products.ToListAsync();
            var dtos = products.Select(p => new ProductDto
            {
                Id = p.ExternalId,
                Name = p.Name,
                Tagline = p.Tagline,
                Description = p.Description,
                Status = p.Status,
                Url = p.Url,
                Icon = p.Icon,
                Color = p.Color,
                Technologies = p.Technologies,
                Features = p.Features,
            }).ToList();

            return Ok(new ApiResponse<List<ProductDto>>
            {
                Success = true,
                Data = dtos
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching products");
            return StatusCode(500, new ApiResponse<List<ProductDto>>
            {
                Success = false,
                Message = "An error occurred while fetching products",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Get all technologies
    /// </summary>
    [HttpGet("technologies")]
    public async Task<ActionResult<ApiResponse<List<TechnologyDto>>>> GetTechnologies()
    {
        try
        {
            var technologies = await _context.Technologies.ToListAsync();
            var dtos = technologies.Select(t => new TechnologyDto
            {
                Id = t.ExternalId,
                Name = t.Name,
                Category = t.Category,
                Description = t.Description,
                Icon = t.Icon,
                Color = t.Color,
                Proficiency = t.Proficiency,
            }).ToList();

            return Ok(new ApiResponse<List<TechnologyDto>>
            {
                Success = true,
                Data = dtos
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching technologies");
            return StatusCode(500, new ApiResponse<List<TechnologyDto>>
            {
                Success = false,
                Message = "An error occurred while fetching technologies",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Get all solutions
    /// </summary>
    [HttpGet("solutions")]
    public async Task<ActionResult<ApiResponse<List<SolutionDto>>>> GetSolutions()
    {
        try
        {
            var solutions = await _context.Solutions.ToListAsync();
            var dtos = solutions.Select(s => new SolutionDto
            {
                Id = s.ExternalId,
                Title = s.Title,
                Description = s.Description,
                Icon = s.Icon,
                Color = s.Color,
                Features = s.Features,
            }).ToList();

            return Ok(new ApiResponse<List<SolutionDto>>
            {
                Success = true,
                Data = dtos
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching solutions");
            return StatusCode(500, new ApiResponse<List<SolutionDto>>
            {
                Success = false,
                Message = "An error occurred while fetching solutions",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Get all industries
    /// </summary>
    [HttpGet("industries")]
    public async Task<ActionResult<ApiResponse<List<IndustryDto>>>> GetIndustries()
    {
        try
        {
            var industries = await _context.Industries.ToListAsync();
            var dtos = industries.Select(i => new IndustryDto
            {
                Id = i.ExternalId,
                Name = i.Name,
                Description = i.Description,
                Icon = i.Icon,
                Color = i.Color,
                UseCases = i.UseCases,
            }).ToList();

            return Ok(new ApiResponse<List<IndustryDto>>
            {
                Success = true,
                Data = dtos
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching industries");
            return StatusCode(500, new ApiResponse<List<IndustryDto>>
            {
                Success = false,
                Message = "An error occurred while fetching industries",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Get company information
    /// </summary>
    [HttpGet("company")]
    public async Task<ActionResult<ApiResponse<CompanyDto>>> GetCompany()
    {
        try
        {
            var company = await _context.CompanyProfiles
                .Include(c => c.Values)
                .Include(c => c.Milestones)
                .FirstOrDefaultAsync();

            if (company == null)
            {
                return NotFound(new ApiResponse<CompanyDto>
                {
                    Success = false,
                    Message = "Company information not found"
                });
            }

            var dto = new CompanyDto
            {
                Name = company.Name,
                Founded = company.Founded,
                Headquarters = company.Headquarters,
                Mission = company.Mission,
                Vision = company.Vision,
                Description = company.Description,
                Values = company.Values.Select(v => new CompanyValueDto
                {
                    Id = v.ExternalId,
                    Title = v.Title,
                    Description = v.Description,
                    Icon = v.Icon,
                    Color = v.Color,
                }).ToList(),
                Milestones = company.Milestones.Select(m => new MilestoneDto
                {
                    Year = m.Year,
                    Title = m.Title,
                    Description = m.Description,
                }).ToList(),
            };

            return Ok(new ApiResponse<CompanyDto>
            {
                Success = true,
                Data = dto
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching company information");
            return StatusCode(500, new ApiResponse<CompanyDto>
            {
                Success = false,
                Message = "An error occurred while fetching company information",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Get careers information
    /// </summary>
    [HttpGet("careers")]
    public async Task<ActionResult<ApiResponse<CareersDto>>> GetCareers()
    {
        try
        {
            var careers = await _context.CareersInfos
                .Include(c => c.Benefits)
                .Include(c => c.HiringProcess)
                .Include(c => c.OpenPositions)
                .Include(c => c.Programs)
                .FirstOrDefaultAsync();

            if (careers == null)
            {
                return NotFound(new ApiResponse<CareersDto>
                {
                    Success = false,
                    Message = "Careers information not found"
                });
            }

            var dto = new CareersDto
            {
                Headline = careers.Headline,
                Subheadline = careers.Subheadline,
                Benefits = careers.Benefits.Select(b => new BenefitDto
                {
                    Icon = b.Icon,
                    Title = b.Title,
                    Description = b.Description,
                }).ToList(),
                HiringProcess = careers.HiringProcess.OrderBy(h => h.Step).Select(h => new HiringStepDto
                {
                    Step = h.Step,
                    Title = h.Title,
                    Description = h.Description,
                }).ToList(),
                OpenPositions = careers.OpenPositions.Select(p => new JobPositionDto
                {
                    Id = p.ExternalId,
                    Title = p.Title,
                    Department = p.Department,
                    Type = p.Type,
                    Location = p.Location,
                    Experience = p.Experience,
                    Description = p.Description,
                }).ToList(),
                Programs = careers.Programs.Select(p => new CareerProgramDto
                {
                    Id = p.ExternalId,
                    Title = p.Title,
                    Description = p.Description,
                    Icon = p.Icon,
                }).ToList(),
            };

            return Ok(new ApiResponse<CareersDto>
            {
                Success = true,
                Data = dto
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching careers information");
            return StatusCode(500, new ApiResponse<CareersDto>
            {
                Success = false,
                Message = "An error occurred while fetching careers information",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Get all news articles
    /// </summary>
    [HttpGet("news")]
    public async Task<ActionResult<ApiResponse<List<NewsArticleDto>>>> GetNews()
    {
        try
        {
            var articles = await _context.NewsArticles.ToListAsync();
            var dtos = articles.Select(a => new NewsArticleDto
            {
                Id = a.ExternalId,
                Title = a.Title,
                Excerpt = a.Excerpt,
                Category = a.Category,
                Date = a.Date,
                ReadTime = a.ReadTime,
                Featured = a.Featured,
                Tags = a.Tags,
            }).ToList();

            return Ok(new ApiResponse<List<NewsArticleDto>>
            {
                Success = true,
                Data = dtos
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching news articles");
            return StatusCode(500, new ApiResponse<List<NewsArticleDto>>
            {
                Success = false,
                Message = "An error occurred while fetching news articles",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }
}
