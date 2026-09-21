namespace SvagsCorporate.Api.Models;

public class ContactSubmission
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Email { get; set; }
    public string? Company { get; set; }
    public required string Subject { get; set; }
    public required string Message { get; set; }
    public string? IpAddress { get; set; }
    public bool EmailSent { get; set; } = false;
    public DateTime SubmittedAt { get; set; } = DateTime.UtcNow;
}
