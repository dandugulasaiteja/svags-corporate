namespace SvagsCorporate.Api.Models;

public class JobApplication
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Email { get; set; }
    public required string Phone { get; set; }
    public int? JobPositionId { get; set; }
    public string? PositionTitle { get; set; } // snapshot of position title at time of application
    public required string Message { get; set; }
    public string? ResumeFilePath { get; set; }
    public string? IpAddress { get; set; }
    public bool EmailSent { get; set; } = false;
    public DateTime AppliedAt { get; set; } = DateTime.UtcNow;

    public virtual JobPosition? JobPosition { get; set; }
}
