﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\..\GetVirtualHost.ps1"

$server = "192.168.232.129"

function AssertAreEqual($actual, $expected) {

    if ($actual -is [System.Array]) {
        if ($expected -isnot [System.Array]) { throw "Expected {$expected} to be an array, but it is not." }

        if ($actual.Length -ne $expected.Length)
        { 
            $al = $actual.Length
            $el = $expected.Length
            throw "Expected $al elements but were $el"
        }

        for ($i = 0; $i -lt $actual.Length; $i++)
        {
            $a = $actual[$i]
            $e = $expected[$i]
            if ($a -ne $e) 
            { 
                throw "Expected element at position $i to be {$e} but was {$a}" 
            }
        }
    }
}

Describe -Tags "Example" "Get-RabbitMQVirtualHost" {

    It "should get Virtual Hosts registered with the server" {

        $actual = Get-RabbitMQVirtualHost -ComputerName $server | select -ExpandProperty name 

        $expected = $("/", "vh1", "vh2")

        AssertAreEqual $actual $expected
    }

    It "should get Virtual Hosts filtered by name" {

        $actual = Get-RabbitMQVirtualHost -ComputerName $server vh* | select -ExpandProperty name 

        $expected = $("vh1", "vh2")

        AssertAreEqual $actual $expected
    }

    It "should get VirtualHost names to filter by from the pipe" {

        $actual = $('vh1', 'vh2') | Get-RabbitMQVirtualHost -ComputerName $server | select -ExpandProperty name 

        $expected = $("vh1", "vh2")

        AssertAreEqual $actual $expected
    }

    It "should get VirtualHost and ComputerName from the pipe" {

        $pipe = $(
            New-Object -TypeName psobject -Prop @{"ComputerName" = $server; "Name" = "vh1" }
            New-Object -TypeName psobject -Prop @{"ComputerName" = $server; "Name" = "vh2" }
        )

        $actual = $pipe | Get-RabbitMQVirtualHost | select -ExpandProperty name 

        $expected = $("vh1", "vh2")

        AssertAreEqual $actual $expected
    }

    It "should pipe result from itself" {

        $actual = Get-RabbitMQVirtualHost -ComputerName $server | Get-RabbitMQVirtualHost | select -ExpandProperty name 

        $expected = Get-RabbitMQVirtualHost -ComputerName $server | select -ExpandProperty name 

        AssertAreEqual $actual $expected
    }
}

