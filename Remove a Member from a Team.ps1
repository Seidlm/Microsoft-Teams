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


#Get Team ID
$URLTeam = "https://graph.microsoft.com/v1.0//groups?$filter=resourceProvisioningOptions/Any(x:x eq 'Team')"
$ResultTeam=(Invoke-RestMethod -Headers $headers -Uri $URLTeam -Method Get).value | Where-Object -Property displayName -Value $TeamName -eq

#Get Members
$URLMembers = "https://graph.microsoft.com/v1.0//teams/$($ResultTeam.id)/members"
$ResultMembers = (Invoke-RestMethod -Headers $headers -Uri $URLMembers -Method Get).value | Where-Object -Property email -Value $Member -eq


#Add User
$URL = "https://graph.microsoft.com/v1.0/teams/$($ResultTeam.id)/members/$($ResultMembers.id)"  
Invoke-RestMethod -Headers $headers -Uri $URL -Method DELETE

