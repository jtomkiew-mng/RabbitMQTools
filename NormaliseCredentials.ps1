function NormaliseCredentials()
{
    switch ($PsCmdlet.ParameterSetName)
    {
        "defaultLogin" { return GetRabbitMqCredentials $defaultUserName $defaultPassword }
        "cred" { return $Credentials }
    }
}
