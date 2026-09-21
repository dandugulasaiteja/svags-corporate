using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using SvagsCorporate.Api.Data;
using SvagsCorporate.Api.Dtos;
using SvagsCorporate.Api.Models;
using SvagsCorporate.Api.Services;

namespace SvagsCorporate.Api.Controllers;

[ApiController]
[Route("api")]
[Produces("application/json")]
public class FormsController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IEmailService _emailService;
    private readonly ILogger<FormsController> _logger;
    private readonly IConfiguration _config;

    public FormsController(AppDbContext context, IEmailService emailService, ILogger<FormsController> logger, IConfiguration config)
    {
        _context = context;
        _emailService = emailService;
        _logger = logger;
        _config = config;
    }

    /// <summary>
    /// Submit contact form
    /// </summary>
    [HttpPost("contact")]
    [EnableRateLimiting("forms")]
    public async Task<ActionResult<ApiResponse<string>>> SubmitContact([FromBody] ContactSubmissionDto dto, CancellationToken cancellationToken)
    {
        try
        {
            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();

            var submission = new ContactSubmission
            {
                Name = dto.Name,
                Email = dto.Email,
                Company = dto.Company,
                Subject = dto.Subject,
                Message = dto.Message,
                IpAddress = ipAddress,
            };

            _context.ContactSubmissions.Add(submission);
            await _context.SaveChangesAsync(cancellationToken);

            // Send confirmation email to user
            await _emailService.SendContactConfirmationAsync(dto.Email, dto.Name, cancellationToken);

            // Send notification email to admin
            await _emailService.SendContactNotificationAsync(dto.Name, dto.Email, dto.Subject, dto.Message, cancellationToken);

            submission.EmailSent = true;
            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Contact form submitted by {Name} ({Email})", dto.Name, dto.Email);

            return Ok(new ApiResponse<string>
            {
                Success = true,
                Message = "Thank you for your message. We'll get back to you soon!",
                Data = submission.Id.ToString()
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error submitting contact form");
            return StatusCode(500, new ApiResponse<string>
            {
                Success = false,
                Message = "An error occurred while submitting your message",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Subscribe to newsletter
    /// </summary>
    [HttpPost("newsletter/subscribe")]
    [EnableRateLimiting("forms")]
    public async Task<ActionResult<ApiResponse<string>>> SubscribeNewsletter([FromBody] NewsletterSubscribeDto dto, CancellationToken cancellationToken)
    {
        try
        {
            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();

            // Check if already subscribed
            var existing = await _context.NewsletterSubscribers
                .FirstOrDefaultAsync(ns => ns.Email == dto.Email, cancellationToken);

            if (existing != null)
            {
                if (existing.IsActive)
                {
                    return Ok(new ApiResponse<string>
                    {
                        Success = true,
                        Message = "You are already subscribed to our newsletter",
                        Data = existing.Id.ToString()
                    });
                }
                else
                {
                    // Reactivate subscription
                    existing.IsActive = true;
                    existing.UnsubscribedAt = null;
                    await _context.SaveChangesAsync(cancellationToken);
                    await _emailService.SendNewsletterWelcomeAsync(dto.Email, cancellationToken);

                    return Ok(new ApiResponse<string>
                    {
                        Success = true,
                        Message = "Welcome back! You're subscribed to our newsletter",
                        Data = existing.Id.ToString()
                    });
                }
            }

            // Create new subscription
            var subscriber = new NewsletterSubscriber
            {
                Email = dto.Email,
                IsActive = true,
                IpAddress = ipAddress,
            };

            _context.NewsletterSubscribers.Add(subscriber);
            await _context.SaveChangesAsync(cancellationToken);

            // Send welcome email
            await _emailService.SendNewsletterWelcomeAsync(dto.Email, cancellationToken);

            _logger.LogInformation("Newsletter subscription from {Email}", dto.Email);

            return Ok(new ApiResponse<string>
            {
                Success = true,
                Message = "Thank you for subscribing! Check your email for confirmation.",
                Data = subscriber.Id.ToString()
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error subscribing to newsletter");
            return StatusCode(500, new ApiResponse<string>
            {
                Success = false,
                Message = "An error occurred while subscribing to newsletter",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }

    /// <summary>
    /// Submit job application
    /// </summary>
    [HttpPost("careers/applications")]
    [Consumes("multipart/form-data")]
    [EnableRateLimiting("forms")]
    public async Task<ActionResult<ApiResponse<string>>> SubmitJobApplication(
        [FromForm] JobApplicationDto dto,
        CancellationToken cancellationToken)
    {
        try
        {
            // File-specific validation not expressible via DataAnnotations on IFormFile
            var errors = new List<string>();
            var resume = dto.Resume;

            if (resume.Length == 0)
                errors.Add("Resume file is required");
            else
            {
                if (resume.Length > 5 * 1024 * 1024) // 5MB
                    errors.Add("Resume file must not exceed 5MB");

                var allowedExtensions = new[] { ".pdf", ".doc", ".docx" };
                var fileExtension = Path.GetExtension(resume.FileName).ToLower();
                if (!allowedExtensions.Contains(fileExtension))
                    errors.Add("Resume must be PDF, DOC, or DOCX format");
            }

            if (errors.Any())
            {
                return BadRequest(new ApiResponse<string>
                {
                    Success = false,
                    Message = "Validation errors occurred",
                    Errors = errors
                });
            }

            // Save resume file
            var storagePath = _config["Storage:ResumeUploadPath"] ?? Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "uploads", "resumes");
            Directory.CreateDirectory(storagePath);

            var fileName = $"{Guid.NewGuid()}_{Path.GetFileName(resume.FileName ?? "resume")}";
            var filePath = Path.Combine(storagePath, fileName);

            await using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await resume.CopyToAsync(stream, cancellationToken);
            }

            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();

            // Create job application record
            var application = new JobApplication
            {
                Name = dto.Name,
                Email = dto.Email,
                Phone = dto.Phone,
                JobPositionId = dto.JobPositionId,
                PositionTitle = dto.PositionTitle,
                Message = dto.Message,
                ResumeFilePath = filePath,
                IpAddress = ipAddress,
            };

            _context.JobApplications.Add(application);
            await _context.SaveChangesAsync(cancellationToken);

            // Send confirmation email to applicant
            await _emailService.SendJobApplicationConfirmationAsync(
                dto.Email, dto.Name, dto.PositionTitle ?? "SVAGS Technologies", cancellationToken);

            // Send notification to HR
            await _emailService.SendJobApplicationNotificationAsync(
                dto.Name, dto.Email, dto.PositionTitle ?? "SVAGS Technologies", cancellationToken);

            application.EmailSent = true;
            await _context.SaveChangesAsync(cancellationToken);

            _logger.LogInformation("Job application from {Name} ({Email}) for position {PositionTitle}", dto.Name, dto.Email, dto.PositionTitle);

            return Ok(new ApiResponse<string>
            {
                Success = true,
                Message = "Your application has been submitted successfully!",
                Data = application.Id.ToString()
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error submitting job application");
            return StatusCode(500, new ApiResponse<string>
            {
                Success = false,
                Message = "An error occurred while submitting your application",
                Errors = new List<string> { "An unexpected error occurred. Please try again later." }
            });
        }
    }
}
