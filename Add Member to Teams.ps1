$clientID = "your ID"
$Clientsecret = "your Secret"
$tenantID = "Your Tenant"


$TeamName="Marketing"
$Member="michael@techguy.at"


#Connect to GRAPH API
$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $tokenBody
$headers = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-type"  = "application/json"
}


#Get Member ID

$URLMember = "https://graph.microsoft.com/v1.0/users/$Member"
$ResultMember = Invoke-RestMethod -Headers $headers -Uri $URLMember -Method Get

#Get Team ID
$URLTeam = "https://graph.microsoft.com/v1.0/groups?$filter=resourceProvisioningOptions/Any(x:x eq 'Team')"
$ResultTeam=(Invoke-RestMethod -Headers $headers -Uri $URLTeam -Method Get).value | Where-Object -Property displayName -Value $TeamName -eq



#Add User
$URL = "https://graph.microsoft.com/v1.0/groups/$($ResultTeam.id)/members/`$ref"  

$body = [ordered]@{
    "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($ResultMember.id)"
}

$bodyJSON = $body | ConvertTo-Json

Invoke-RestMethod -Headers $headers -Uri $URL -Method POST -Body $bodyJSON 

