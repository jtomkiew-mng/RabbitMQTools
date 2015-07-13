$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\TestSetup.ps1"
. "$here\..\Remove-RabbitMQVirtualHost.ps1"

Describe -Tags "Example" "Remove-RabbitMQVirtualHost" {
    It "should remove existing Virtual Host" {

        Add-RabbitMQVirtualHost -BaseUri $server "vh3"
        Remove-RabbitMQVirtualHost -BaseUri $server "vh3" -Confirm:$false
        
        $actual = Get-RabbitMQVirtualHost -BaseUri $server "vh*" | select -ExpandProperty name 
        
        $actual | Should Be $("vh1", "vh2")
    }
}