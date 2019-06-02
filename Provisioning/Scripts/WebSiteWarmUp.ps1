$WebserverName = $args[0]
$WebAppUrl = "http://$WebserverName.local"

try {
    $HTTP_Request = [System.Net.WebRequest]::Create($WebAppUrl)
    $HTTP_Response = $HTTP_Request.GetResponse()
    $HTTP_Status = [int]$HTTP_Response.StatusCode
    Write-Host "Response code is: $HTTP_Status" 
    Write-Host "All done! Please navigate to $WebAppUrl to access the web application"
}
catch {
    $HTTP_Response = new-object psobject -prop @{StatusCode = ""; StatusDescription = ""; ContentLength = 0}
    Write-Host $HTTP_Response    
}
