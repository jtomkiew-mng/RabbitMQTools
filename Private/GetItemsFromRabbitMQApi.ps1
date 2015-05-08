function GetItemsFromRabbitMQApi
{
    [CmdletBinding(DefaultParameterSetName='login')]
    Param
    (
        [parameter(Mandatory=$true, Position = 0)]
        [alias("ComputerName", "cn")]
        [string]$BaseUri,

        [parameter(Mandatory=$true, ParameterSetName='login', Position = 1)]
        [string]$userName,

        [parameter(Mandatory=$true, ParameterSetName='login', Position = 2)]
        [string]$password,

        [parameter(Mandatory=$true, ParameterSetName='login', Position = 3)]
        [string]$fn,

        [parameter(Mandatory=$true, ParameterSetName='cred', Position = 1)]
        [PSCredential]$cred,
        
        [parameter(Mandatory=$true, ParameterSetName='cred', Position = 2)]
        [string]$function,

        [int]$Port = 15672
    )

    Add-Type -AssemblyName System.Web
    #Add-Type -AssemblyName System.Net
    
    if ($PsCmdlet.ParameterSetName -eq "login") 
    { 
        $cred = GetRabbitMqCredentials $userName $password 
        $function = $fn
    }
                
    $url = Join-Parts $BaseUri "/api/$function"
    Write-Verbose "Invoking REST API: $url"
    
    return Invoke-RestMethod $url -Credential $cred -DisableKeepAlive -AllowEscapedDotsAndSlashes
}
