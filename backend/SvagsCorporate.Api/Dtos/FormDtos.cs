using System.ComponentModel.DataAnnotations;

namespace SvagsCorporate.Api.Dtos;

// Contact Form
public class ContactSubmissionDto
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(100, MinimumLength = 2)]
    public required string Name { get; set; }

    [Required(ErrorMessage = "Email is required")]
    [EmailAddress]
    public required string Email { get; set; }

    [StringLength(100)]
    public string? Company { get; set; }

    [Required(ErrorMessage = "Subject is required")]
    [StringLength(200, MinimumLength = 5)]
    public required string Subject { get; set; }

    [Required(ErrorMessage = "Message is required")]
    [StringLength(5000, MinimumLength = 10)]
    public required string Message { get; set; }
}

// Newsletter Subscribe
public class NewsletterSubscribeDto
{
    [Required(ErrorMessage = "Email is required")]
    [EmailAddress(ErrorMessage = "Invalid email address")]
    public required string Email { get; set; }
}

// Job Application
public class JobApplicationDto
{
    [Required(ErrorMessage = "Name is required")]
    [StringLength(100, MinimumLength = 2)]
    public required string Name { get; set; }

    [Required(ErrorMessage = "Email is required")]
    [EmailAddress]
    public required string Email { get; set; }

    [Required(ErrorMessage = "Phone is required")]
    [Phone]
    public required string Phone { get; set; }

    public int? JobPositionId { get; set; }

    [StringLength(200)]
    public string? PositionTitle { get; set; }

    [Required(ErrorMessage = "Message is required")]
    [StringLength(5000, MinimumLength = 10)]
    public required string Message { get; set; }

    [Required(ErrorMessage = "Resume file is required")]
    public required IFormFile Resume { get; set; }
}

// API Response
public class ApiResponse<T>
{
    public bool Success { get; set; }
    public string? Message { get; set; }
    public T? Data { get; set; }
    public List<string> Errors { get; set; } = new();
}
