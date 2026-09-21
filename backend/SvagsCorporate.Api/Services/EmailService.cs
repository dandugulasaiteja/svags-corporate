using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace SvagsCorporate.Api.Services;

public interface IEmailService
{
    Task SendContactConfirmationAsync(string toEmail, string name, CancellationToken cancellationToken = default);
    Task SendContactNotificationAsync(string name, string email, string subject, string message, CancellationToken cancellationToken = default);
    Task SendNewsletterWelcomeAsync(string email, CancellationToken cancellationToken = default);
    Task SendJobApplicationConfirmationAsync(string toEmail, string name, string positionTitle, CancellationToken cancellationToken = default);
    Task SendJobApplicationNotificationAsync(string name, string email, string positionTitle, CancellationToken cancellationToken = default);
}

public class EmailService : IEmailService
{
    private readonly IConfiguration _config;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IConfiguration config, ILogger<EmailService> logger)
    {
        _config = config;
        _logger = logger;
    }

    public async Task SendContactConfirmationAsync(string toEmail, string name, CancellationToken cancellationToken = default)
    {
        var safeName = System.Net.WebUtility.HtmlEncode(name);
        var subject = "We received your message - SVAGS TECHNOLOGIES";
        var body = $@"
            <html>
                <body style=""font-family: Arial, sans-serif; color: #333;"">
                    <div style=""max-width: 600px; margin: 0 auto;"">
                        <h2>Thank You, {safeName}!</h2>
                        <p>We received your message and appreciate you reaching out.</p>
                        <p>Our team will review your inquiry and get back to you within 24 hours.</p>
                        <hr style=""border: none; border-top: 1px solid #eee; margin: 30px 0;"" />
                        <p style=""color: #666; font-size: 12px;"">
                            SVAGS TECHNOLOGIES<br/>
                            Building Technology That Shapes Tomorrow<br/>
                            <a href=""https://svagstech.com"">svagstech.com</a>
                        </p>
                    </div>
                </body>
            </html>";

        await SendEmailAsync(toEmail, subject, body, cancellationToken);
    }

    public async Task SendContactNotificationAsync(string name, string email, string subject, string message, CancellationToken cancellationToken = default)
    {
        var safeName = System.Net.WebUtility.HtmlEncode(name);
        var safeEmail = System.Net.WebUtility.HtmlEncode(email);
        var safeSubject = System.Net.WebUtility.HtmlEncode(subject);
        var safeMessage = System.Net.WebUtility.HtmlEncode(message);

        var notificationEmail = _config["Email:NotificationEmail"] ?? "hello@svagstech.com";
        var emailSubject = $"New Contact Form Submission: {safeSubject}";
        var body = $@"
            <html>
                <body style=""font-family: Arial, sans-serif; color: #333;"">
                    <div style=""max-width: 600px; margin: 0 auto;"">
                        <h2>New Contact Submission</h2>
                        <p><strong>Name:</strong> {safeName}</p>
                        <p><strong>Email:</strong> {safeEmail}</p>
                        <p><strong>Subject:</strong> {safeSubject}</p>
                        <p><strong>Message:</strong></p>
                        <p style=""background-color: #f5f5f5; padding: 15px; border-radius: 5px; white-space: pre-wrap;"">{safeMessage}</p>
                        <p><a href=""mailto:{safeEmail}"">Reply to {safeName}</a></p>
                    </div>
                </body>
            </html>";

        await SendEmailAsync(notificationEmail, emailSubject, body, cancellationToken);
    }

    public async Task SendNewsletterWelcomeAsync(string email, CancellationToken cancellationToken = default)
    {
        var subject = "Welcome to SVAGS TECHNOLOGIES Newsletter";
        var body = $@"
            <html>
                <body style=""font-family: Arial, sans-serif; color: #333;"">
                    <div style=""max-width: 600px; margin: 0 auto;"">
                        <h2>Welcome to Our Newsletter!</h2>
                        <p>Thank you for subscribing to SVAGS TECHNOLOGIES newsletter.</p>
                        <p>Stay tuned for the latest updates, insights, and innovation from our team.</p>
                        <hr style=""border: none; border-top: 1px solid #eee; margin: 30px 0;"" />
                        <p style=""color: #666; font-size: 12px;"">
                            SVAGS TECHNOLOGIES<br/>
                            Building Technology That Shapes Tomorrow
                        </p>
                    </div>
                </body>
            </html>";

        await SendEmailAsync(email, subject, body, cancellationToken);
    }

    public async Task SendJobApplicationConfirmationAsync(string toEmail, string name, string positionTitle, CancellationToken cancellationToken = default)
    {
        var safeName = System.Net.WebUtility.HtmlEncode(name);
        var safePositionTitle = System.Net.WebUtility.HtmlEncode(positionTitle);
        var subject = $"Application Received - {safePositionTitle} - SVAGS TECHNOLOGIES";
        var body = $@"
            <html>
                <body style=""font-family: Arial, sans-serif; color: #333;"">
                    <div style=""max-width: 600px; margin: 0 auto;"">
                        <h2>Thank You for Applying, {safeName}!</h2>
                        <p>We received your application for the <strong>{safePositionTitle}</strong> position.</p>
                        <p>Our hiring team will review your submission carefully and reach out if we'd like to proceed to the next steps.</p>
                        <p>We appreciate your interest in joining SVAGS TECHNOLOGIES!</p>
                        <hr style=""border: none; border-top: 1px solid #eee; margin: 30px 0;"" />
                        <p style=""color: #666; font-size: 12px;"">
                            SVAGS TECHNOLOGIES<br/>
                            Building Technology That Shapes Tomorrow<br/>
                            <a href=""https://svagstech.com/careers"">Explore More Opportunities</a>
                        </p>
                    </div>
                </body>
            </html>";

        await SendEmailAsync(toEmail, subject, body, cancellationToken);
    }

    public async Task SendJobApplicationNotificationAsync(string name, string email, string positionTitle, CancellationToken cancellationToken = default)
    {
        var safeName = System.Net.WebUtility.HtmlEncode(name);
        var safeEmail = System.Net.WebUtility.HtmlEncode(email);
        var safePositionTitle = System.Net.WebUtility.HtmlEncode(positionTitle);

        var notificationEmail = _config["Email:NotificationEmail"] ?? "careers@svagstech.com";
        var subject = $"New Job Application: {safePositionTitle} from {safeName}";
        var body = $@"
            <html>
                <body style=""font-family: Arial, sans-serif; color: #333;"">
                    <div style=""max-width: 600px; margin: 0 auto;"">
                        <h2>New Job Application Received</h2>
                        <p><strong>Position:</strong> {safePositionTitle}</p>
                        <p><strong>Candidate Name:</strong> {safeName}</p>
                        <p><strong>Email:</strong> {safeEmail}</p>
                        <p><a href=""mailto:{safeEmail}"">Contact {safeName}</a></p>
                    </div>
                </body>
            </html>";

        await SendEmailAsync(notificationEmail, subject, body, cancellationToken);
    }

    private async Task SendEmailAsync(string toEmail, string subject, string htmlBody, CancellationToken cancellationToken = default)
    {
        try
        {
            var smtpServer = _config["Email:SmtpServer"];
            var smtpPort = int.Parse(_config["Email:SmtpPort"] ?? "587");
            var smtpUsername = _config["Email:SmtpUsername"];
            var smtpPassword = _config["Email:SmtpPassword"];
            var fromEmail = _config["Email:FromEmail"] ?? "noreply@svagstech.com";

            if (string.IsNullOrWhiteSpace(smtpServer) || string.IsNullOrWhiteSpace(smtpUsername))
            {
                _logger.LogWarning("Email not sent to {toEmail}: SMTP configuration is not set", toEmail);
                return;
            }

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("SVAGS TECHNOLOGIES", fromEmail));
            message.To.Add(new MailboxAddress(string.Empty, toEmail));
            message.Subject = subject;
            message.Body = new TextPart("html") { Text = htmlBody };

            using (var client = new SmtpClient())
            {
                await client.ConnectAsync(smtpServer, smtpPort, SecureSocketOptions.StartTls, cancellationToken);
                await client.AuthenticateAsync(smtpUsername, smtpPassword, cancellationToken);
                await client.SendAsync(message, cancellationToken);
                await client.DisconnectAsync(true, cancellationToken);
            }

            _logger.LogInformation("Email sent successfully to {toEmail}", toEmail);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {toEmail}", toEmail);
        }
    }
}
