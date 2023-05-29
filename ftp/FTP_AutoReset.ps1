while($true){
    try
    {
        $ftprequest = [System.Net.FtpWebRequest]::Create("ftp://127.0.0.1")
        $ftprequest.Credentials = New-Object System.Net.NetworkCredential("wrong", "wrong") 
        $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::PrintWorkingDirectory
        $ftprequest.GetResponse()

        Write-Host "Unexpected success, but OK."
    }
    catch
    {
        if (($_.Exception.InnerException -ne $Null) -and
            ($_.Exception.InnerException.Response -ne $Null) -and
            ($_.Exception.InnerException.Response.StatusCode -eq
                 [System.Net.FtpStatusCode]::NotLoggedIn))
        {
            Write-Host "Connectivity OK."
        }
        else
        {
            net stop filezilla-server
            net start filezilla-server
            Write-Host "Unexpected error: $($_.Exception.Message)"
        }
    }
    Start-Sleep -Seconds 5
}