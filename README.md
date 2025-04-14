Church JSON Generator



Overview
This Apex class pushes new or updated Church__c records to an external API by:

Querying records that have never been pushed or were updated since their last push.

Serializing the records into a JSON payload.

Storing the JSON as a Salesforce File (ContentVersion) for auditing.

Sending the JSON payload via an HTTP POST callout using a Named Credential.

Updating the records' Last_Pushed_Date__c field upon a successful API response.

Prerequisites
Custom Field on Church__c:

Last_Pushed_Date__c (Date/Time) – used to track the last push timestamp.

Named Credential:

Name: My_External_API

URL: e.g., https://google.com (or your actual API base URL)

Authentication: Use Password Authentication with:

Username: gmail123

Password: kitkati1243

API Endpoint Adjustment:
Replace yourEndpointPath in the code with your actual API path.

Deployment & Execution
Deploy the Apex Class:

Copy the provided Apex code into a new Apex class (e.g., ChurchJSONGenerator) in the Developer Console.

Verify the Named Credential:

Ensure My_External_API is set up correctly in Setup > Named Credentials.

Execute the Code:

In the Developer Console’s Execute Anonymous window, run:

apex
Copy
ChurchJSONGenerator.pushNewOrUpdatedChurches();
Check Results:

Review the debug logs for HTTP callout responses.

Verify that the file ChurchData.json appears under the Files tab.

Code Overview
Query Filtering:
Retrieves Church__c records where:

Last_Pushed_Date__c is NULL

OR LastModifiedDate > Last_Pushed_Date__c

Mapping & Serialization:
Maps records into an inner class (ChurchData) then converts the list into a pretty-printed JSON string.

File Storage:
The JSON payload is stored in Salesforce Files via a ContentVersion record.

HTTP Callout:
Uses a Named Credential (callout:My_External_API/yourEndpointPath) to securely authenticate and send the JSON.

Record Update:
Upon a successful response (HTTP 200 or 201), Last_Pushed_Date__c is updated to the current timestamp.

