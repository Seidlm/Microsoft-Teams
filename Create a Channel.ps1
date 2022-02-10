$clientID = "your ID"
$Clientsecret = "your Secret"
$tenantID = "Your Tenant"


$TeamName = "Techguy Team"
$ChannelName = "My first Channel"
$ChannelDescription = "This is my Channel Description"
$ChannelPrivacy = "Standard" #Standard, Private
$ChannelOwner = "michael@techguy.at" #UPN of the Owner, needed for Private Channel

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


#Get Owner ID

$URLOwnwer = "https://graph.microsoft.com/v1.0/users/$Owner"
$ResultOwner = Invoke-RestMethod -Headers $headers -Uri $URLOwnwer -Method Get


#Get Team ID
$URLTeam = "https://graph.microsoft.com/v1.0//groups?$filter=resourceProvisioningOptions/Any(x:x eq 'Team')"
$ResultTeam=(Invoke-RestMethod -Headers $headers -Uri $URLTeam -Method Get).value | Where-Object -Property displayName -Value $TeamName -eq



#Create Channel
if ($ChannelPrivacy -eq "Standard") {
    $BodyJsonChannel = @"
            {
               
               "displayName":"$ChannelName",
               "description":"$ChannelDescription",
               "membershipType":"$ChannelPrivacy"
               
            }
"@
}
else {


    $BodyJsonChannel = @"
            {
            "@odata.type": "#Microsoft.Graph.channel",
            "displayName":"$ChannelName",
            "description":"$ChannelDescription",
            "membershipType":"$ChannelPrivacy",
            "members":
                [
                    {
                    "@odata.type":"#microsoft.graph.aadUserConversationMember",
                    "user@odata.bind":"https://graph.microsoft.com/v1.0/users('$ChannelOwner')",
                    "roles":["owner"]
                    }
                ]
            }
"@
}

$URL = "https://graph.microsoft.com/v1.0/teams/$($ResultTeam.id)/channels" 
Invoke-RestMethod -Headers $headers -Uri $URL -Method POST -Body $BodyJsonChannel




