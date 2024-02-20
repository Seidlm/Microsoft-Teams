$clientID = "your Client ID"
$Clientsecret = "your Secret"
$tenantID = "your Tenant ID"

$Graph_BaseURL = "https://graph.microsoft.com/v1.0"


#Calendar User
$TargetUser="michael.seidl@au2mator.com"


#Invite User
$RecipientMail="ahmed.uzejnovic@au2mator.com"
$RecipientName="Ahmed Uzejnovic"
$RecipientType="required" #required, optional



#Teams Event Details
$TeamsEventSubject = "My Teams-GRAPH API Event"
$TeamsEventBody = "Thats my awesome Teams-GRAPH API Event Body"

$TeamsEventStart = "2024-02-11T09:00:00"
$TeamsEventEnd = "2024-02-11T10:00:00"
$timeZone = "UTC"



#Authentication
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



$TeamsEventJson = @"
{
  "subject": "$TeamsEventSubject",
  "isOnlineMeeting": true,
  "onlineMeetingProvider": "teamsForBusiness",
  "attendees": [
    {
      "emailAddress": {
        "address":"$RecipientMail",
        "name": "$RecipientName"
      },
      "type": "$RecipientType"
    }
  ],
  "body": {
    "contentType": "HTML",
    "content": "$($TeamsEventBody)"
  },
  "start": {
      "dateTime": "$($TeamsEventStart)",
      "timeZone": "$timeZone"
  },
  "end": {
      "dateTime": "$($TeamsEventEnd)",
      "timeZone": "$timeZone"
  }
}
"@


$TeamsEvent = Invoke-RestMethod -Uri "$Graph_BaseURL/users/$TargetUser/calendar/events" -Method POST -Headers $headers -Body $TeamsEventJson -ContentType "application/json; charset=utf-8"
