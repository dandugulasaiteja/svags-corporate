#requires -version 5.1

<#
.SYNOPSIS
Quick reference commands for managing Svags Corporate Azure deployment

.DESCRIPTION
Useful PowerShell functions for common Azure management tasks.
Dot-source this file to use the functions: . .\azure-commands.ps1

.EXAMPLE
. .\azure-commands.ps1
Get-AppLogs -Environment Dev
#>

# Configuration
$script:config = @{
    Dev = @{
        ResourceGroup = "svags-rg-dev"
        AppServiceName = "svags-corporate-api-dev"
        SqlServerName = "svags-corporate-sql-dev"
        DbName = "svags-corporate-db-dev"
    }
    Staging = @{
        ResourceGroup = "svags-rg-staging"
        AppServiceName = "svags-corporate-api-staging"
        SqlServerName = "svags-corporate-sql-staging"
        DbName = "svags-corporate-db-staging"
    }
    Prod = @{
        ResourceGroup = "svags-rg"
        AppServiceName = "svags-corporate-api"
        SqlServerName = "svags-corporate-sql"
        DbName = "svags-corporate-db"
    }
}

function Write-Log {
    param([string]$Message, [ValidateSet('Info', 'Success', 'Warning', 'Error')]$Level = 'Info')

    $prefix = switch ($Level) {
        'Info'    { "[*]" }
        'Success' { "[✓]" }
        'Warning' { "[⚠]" }
        'Error'   { "[✗]" }
    }

    $color = switch ($Level) {
        'Info'    { 'Cyan' }
        'Success' { 'Green' }
        'Warning' { 'Yellow' }
        'Error'   { 'Red' }
    }

    Write-Host "$prefix $Message" -ForegroundColor $color
}

# ============================================================================
# APPLICATION MANAGEMENT
# ============================================================================

function Get-AppStatus {
    <#
    .SYNOPSIS
    Get App Service status and health information

    .EXAMPLE
    Get-AppStatus -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Fetching App Service status for $Environment..."

    try {
        $app = az webapp show --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "{state:state, url:defaultHostName}" -o json | ConvertFrom-Json

        Write-Log "App Service: $($cfg.AppServiceName)" -Level 'Success'
        Write-Log "State: $($app.state)"
        Write-Log "URL: https://$($app.url)"

        $instances = az webapp list-instances --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "length(@)" -o tsv
        Write-Log "Instances: $instances"
    }
    catch {
        Write-Log "Failed to get app status: $_" -Level 'Error'
    }
}

function Get-AppLogs {
    <#
    .SYNOPSIS
    Stream live application logs

    .PARAMETER Follow
    Follow logs in real-time (Ctrl+C to stop)

    .EXAMPLE
    Get-AppLogs -Environment Dev -Follow
    #>
    param(
        [ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev',
        [switch]$Follow
    )

    $cfg = $script:config[$Environment]

    Write-Log "Fetching logs from $($cfg.AppServiceName)..."

    try {
        if ($Follow) {
            az webapp log tail --resource-group $cfg.ResourceGroup --name $cfg.AppServiceName -f
        }
        else {
            az webapp log tail --resource-group $cfg.ResourceGroup --name $cfg.AppServiceName --lines 100
        }
    }
    catch {
        Write-Log "Failed to get logs: $_" -Level 'Error'
    }
}

function Restart-AppService {
    <#
    .SYNOPSIS
    Restart the App Service

    .EXAMPLE
    Restart-AppService -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Restarting $($cfg.AppServiceName)..."

    try {
        az webapp restart --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup
        Write-Log "App Service restarted successfully" -Level 'Success'
    }
    catch {
        Write-Log "Failed to restart app service: $_" -Level 'Error'
    }
}

function Get-AppSettings {
    <#
    .SYNOPSIS
    View all application settings

    .EXAMPLE
    Get-AppSettings -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Application settings for $($cfg.AppServiceName):"

    try {
        az webapp config appsettings list --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "[].{name:name, value:value}" --output table
    }
    catch {
        Write-Log "Failed to get app settings: $_" -Level 'Error'
    }
}

function Set-AppSetting {
    <#
    .SYNOPSIS
    Set an application setting

    .PARAMETER Name
    Setting name

    .PARAMETER Value
    Setting value

    .EXAMPLE
    Set-AppSetting -Environment Dev -Name "MyVar" -Value "myvalue"
    #>
    param(
        [ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev',
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Value
    )

    $cfg = $script:config[$Environment]

    Write-Log "Setting $Name = $Value..."

    try {
        az webapp config appsettings set --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --settings "$Name=$Value"
        Write-Log "Setting updated successfully" -Level 'Success'
    }
    catch {
        Write-Log "Failed to set app setting: $_" -Level 'Error'
    }
}

# ============================================================================
# DATABASE MANAGEMENT
# ============================================================================

function Get-DbStatus {
    <#
    .SYNOPSIS
    Get SQL Database status

    .EXAMPLE
    Get-DbStatus -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Database status for $($cfg.DbName)..."

    try {
        $db = az sql db show --name $cfg.DbName --server $cfg.SqlServerName --resource-group $cfg.ResourceGroup --query "{currentServiceObjectiveName:currentServiceObjectiveName, status:status, creationDate:creationDate}" -o json | ConvertFrom-Json

        Write-Log "Database: $($cfg.DbName)" -Level 'Success'
        Write-Log "Server: $($cfg.SqlServerName).database.windows.net"
        Write-Log "Status: $($db.status)"
        Write-Log "SKU: $($db.currentServiceObjectiveName)"
        Write-Log "Created: $($db.creationDate)"
    }
    catch {
        Write-Log "Failed to get database status: $_" -Level 'Error'
    }
}

function Get-ConnectionString {
    <#
    .SYNOPSIS
    Get the database connection string

    .EXAMPLE
    Get-ConnectionString -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Connection string:"

    try {
        $connStr = az webapp config connection-string list --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "[0].{name:name, value:value}" -o json | ConvertFrom-Json

        Write-Log "Name: $($connStr.name)"
        Write-Log "Value: $($connStr.value)" -Level 'Info'
    }
    catch {
        Write-Log "Failed to get connection string: $_" -Level 'Error'
    }
}

function Get-DbBackups {
    <#
    .SYNOPSIS
    List database backups

    .EXAMPLE
    Get-DbBackups -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Backups for $($cfg.DbName)..."

    try {
        az sql db backup list --server $cfg.SqlServerName --database $cfg.DbName --resource-group $cfg.ResourceGroup --query "[].{name:name, type:type, backupTime:backupTime}" --output table
    }
    catch {
        Write-Log "Failed to list backups: $_" -Level 'Error'
    }
}

function Restore-Database {
    <#
    .SYNOPSIS
    Restore database from backup (point-in-time)

    .PARAMETER PointInTime
    Time to restore to (e.g., "2024-09-28T10:00:00Z")

    .EXAMPLE
    Restore-Database -Environment Dev -PointInTime "2024-09-28T10:00:00Z"
    #>
    param(
        [ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev',
        [Parameter(Mandatory)][string]$PointInTime,
        [string]$RestoreName = "$($script:config[$Environment].DbName)-restored"
    )

    $cfg = $script:config[$Environment]

    Write-Log "Restoring database to $PointInTime..."
    Write-Log "New database name: $RestoreName" -Level 'Warning'

    try {
        az sql db restore --server $cfg.SqlServerName --name $RestoreName --resource-group $cfg.ResourceGroup --restore-point-in-time $PointInTime --source-server $cfg.SqlServerName --source-database $cfg.DbName
        Write-Log "Database restore initiated" -Level 'Success'
    }
    catch {
        Write-Log "Failed to restore database: $_" -Level 'Error'
    }
}

# ============================================================================
# DEPLOYMENT MANAGEMENT
# ============================================================================

function Get-DeploymentHistory {
    <#
    .SYNOPSIS
    View deployment history

    .PARAMETER Limit
    Number of deployments to show (default: 5)

    .EXAMPLE
    Get-DeploymentHistory -Environment Dev -Limit 10
    #>
    param(
        [ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev',
        [int]$Limit = 5
    )

    $cfg = $script:config[$Environment]

    Write-Log "Deployment history for $($cfg.AppServiceName) (last $Limit):"

    try {
        az webapp deployment list --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "[0:$Limit].{id:id, timestamp:timestamp, status:status, message:message}" --output table
    }
    catch {
        Write-Log "Failed to get deployment history: $_" -Level 'Error'
    }
}

function Activate-Deployment {
    <#
    .SYNOPSIS
    Activate a specific deployment

    .PARAMETER DeploymentId
    Deployment ID to activate

    .EXAMPLE
    Activate-Deployment -Environment Dev -DeploymentId "id123"
    #>
    param(
        [ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev',
        [Parameter(Mandatory)][string]$DeploymentId
    )

    $cfg = $script:config[$Environment]

    Write-Log "Activating deployment $DeploymentId..."

    try {
        az webapp deployment activate --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --deployment-id $DeploymentId
        Write-Log "Deployment activated successfully" -Level 'Success'
    }
    catch {
        Write-Log "Failed to activate deployment: $_" -Level 'Error'
    }
}

# ============================================================================
# MONITORING & DIAGNOSTICS
# ============================================================================

function Get-AppDiagnostics {
    <#
    .SYNOPSIS
    Get diagnostic information about the app

    .EXAMPLE
    Get-AppDiagnostics -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "=== App Service Diagnostics ===" -Level 'Info'

    try {
        # App details
        $app = az webapp show --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup -o json | ConvertFrom-Json
        Write-Log "Status: $($app.state)"
        Write-Log "Plan: $($app.appServicePlanId)"
        Write-Log "Runtime: $(az webapp config show --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query runtimeVersion -o tsv)"

        # Connection strings
        Write-Log "`n=== Connection Settings ===" -Level 'Info'
        az webapp config connection-string list --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "[].name" -o tsv | ForEach-Object { Write-Log "  - $_" }

        # App settings
        Write-Log "`n=== App Settings ===" -Level 'Info'
        az webapp config appsettings list --name $cfg.AppServiceName --resource-group $cfg.ResourceGroup --query "[].name" -o tsv | ForEach-Object { Write-Log "  - $_" }
    }
    catch {
        Write-Log "Failed to get diagnostics: $_" -Level 'Error'
    }
}

function Get-ResourceMetrics {
    <#
    .SYNOPSIS
    Get App Service resource metrics

    .EXAMPLE
    Get-ResourceMetrics -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Resource metrics for $($cfg.AppServiceName)..."

    try {
        $startTime = (Get-Date).AddHours(-1).ToString("yyyy-MM-ddTHH:mm:ssZ")
        $endTime = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

        az monitor metrics list `
            --resource-group $cfg.ResourceGroup `
            --resource-type "Microsoft.Web/sites" `
            --resource $cfg.AppServiceName `
            --start-time $startTime `
            --end-time $endTime `
            --metric "CpuTime,AverageCpuTime,Http5xx,Http4xx" `
            --query "value[*].{name:name.localizedValue, unit:unit, avg:timeseries[0].data[0].average}" `
            --output table
    }
    catch {
        Write-Log "Failed to get metrics: $_" -Level 'Error'
    }
}

# ============================================================================
# NETWORK & SECURITY
# ============================================================================

function Get-FirewallRules {
    <#
    .SYNOPSIS
    List SQL Server firewall rules

    .EXAMPLE
    Get-FirewallRules -Environment Dev
    #>
    param([ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev')

    $cfg = $script:config[$Environment]

    Write-Log "Firewall rules for $($cfg.SqlServerName)..."

    try {
        az sql server firewall-rule list --server $cfg.SqlServerName --resource-group $cfg.ResourceGroup --query "[].{name:name, startIp:startIpAddress, endIp:endIpAddress}" --output table
    }
    catch {
        Write-Log "Failed to list firewall rules: $_" -Level 'Error'
    }
}

function Add-FirewallRule {
    <#
    .SYNOPSIS
    Add IP to SQL Server firewall

    .PARAMETER RuleName
    Name of the firewall rule

    .PARAMETER IpAddress
    IP address to allow (or range: 1.1.1.1-1.1.1.10)

    .EXAMPLE
    Add-FirewallRule -Environment Dev -RuleName "MyIP" -IpAddress "203.0.113.42"
    #>
    param(
        [ValidateSet('Dev', 'Staging', 'Prod')][string]$Environment = 'Dev',
        [Parameter(Mandatory)][string]$RuleName,
        [Parameter(Mandatory)][string]$IpAddress
    )

    $cfg = $script:config[$Environment]
    $startIp, $endIp = if ($IpAddress -contains "-") { $IpAddress.Split("-").Trim() } else { $IpAddress, $IpAddress }

    Write-Log "Adding firewall rule: $RuleName ($IpAddress)..."

    try {
        az sql server firewall-rule create `
            --server $cfg.SqlServerName `
            --resource-group $cfg.ResourceGroup `
            --name $RuleName `
            --start-ip-address $startIp `
            --end-ip-address $endIp

        Write-Log "Firewall rule added successfully" -Level 'Success'
    }
    catch {
        Write-Log "Failed to add firewall rule: $_" -Level 'Error'
    }
}

# ============================================================================
# HELP & UTILITIES
# ============================================================================

function Show-AzureCommands {
    <#
    .SYNOPSIS
    Display all available commands in this module
    #>
    Write-Host @"
╔════════════════════════════════════════════════════════════════╗
║       Svags Corporate - Azure Management Commands              ║
╚════════════════════════════════════════════════════════════════╝

USAGE: . .\azure-commands.ps1

APPLICATIONS:
  Get-AppStatus -Environment Dev              # Show app status
  Get-AppLogs -Environment Dev -Follow         # Stream live logs
  Restart-AppService -Environment Dev          # Restart the app
  Get-AppSettings -Environment Dev             # View app settings
  Set-AppSetting -Environment Dev -Name X -Value Y  # Set app setting
  Get-DeploymentHistory -Environment Dev       # View deployments
  Activate-Deployment -Environment Dev -DeploymentId X  # Rollback

DATABASE:
  Get-DbStatus -Environment Dev                # Show DB status
  Get-ConnectionString -Environment Dev        # Get connection string
  Get-DbBackups -Environment Dev               # List backups
  Restore-Database -Environment Dev -PointInTime "2024-09-28T10:00:00Z"

MONITORING:
  Get-AppDiagnostics -Environment Dev          # Diagnostics info
  Get-ResourceMetrics -Environment Dev         # CPU, errors, etc.

NETWORK & SECURITY:
  Get-FirewallRules -Environment Dev           # List SQL firewall rules
  Add-FirewallRule -Environment Dev -RuleName "MyIP" -IpAddress "203.0.113.42"

HELP:
  Show-AzureCommands                           # Show this menu
  Get-Help Get-AppStatus -Full                 # Help on specific command

ENVIRONMENTS: Dev, Staging, Prod

EXAMPLES:
  Get-AppStatus -Environment Dev
  Get-AppLogs -Environment Prod -Follow
  Set-AppSetting -Environment Dev -Name "ASPNETCORE_ENVIRONMENT" -Value "Development"
  Get-ResourceMetrics -Environment Staging

"@
}

# Display help on load
if ($MyInvocation.CommandOrigin -eq 'External') {
    Show-AzureCommands
}

Export-ModuleMember -Function @(
    'Get-AppStatus',
    'Get-AppLogs',
    'Restart-AppService',
    'Get-AppSettings',
    'Set-AppSetting',
    'Get-DbStatus',
    'Get-ConnectionString',
    'Get-DbBackups',
    'Restore-Database',
    'Get-DeploymentHistory',
    'Activate-Deployment',
    'Get-AppDiagnostics',
    'Get-ResourceMetrics',
    'Get-FirewallRules',
    'Add-FirewallRule',
    'Show-AzureCommands'
)
