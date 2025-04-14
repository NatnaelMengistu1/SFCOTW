# SFCOTW
SF 

**Church JSON Generator README**

**Overview**

The Church JSON Generator is an Apex solution designed to push new or updated Church__c records to an external API. The class performs the following functions:

**Querying Records:**
It retrieves records from the Church__c object that have either:

Never been pushed (i.e., Last_Pushed_Date__c is NULL), or

Been updated after their last push (i.e., LastModifiedDate > Last_Pushed_Date__c).

**
JSON Generation:**
It maps the records to an inner class (ChurchData), serializes the list into a formatted (pretty-printed) JSON string, and optionally stores this JSON file in Salesforce Files (as a ContentVersion record).

Sending to an External API:
It sends the JSON payload to an external API via an HTTP POST callout. The callout leverages a Named Credential for secure authentication, which you configure with the external API endpoint and credentials.

Post-Callout Update:
On a successful API call (HTTP status 200 or 201), the code updates each processed record's custom field Last_Pushed_Date__c with the current timestamp. This prevents unnecessary re-pushing of unchanged records.

Prerequisites
Before deploying or running the code, ensure the following is set up in your Salesforce environment:

Custom Field on Church__c Object:

Field Name: Last_Pushed_Date__c

Type: Date/Time
(This field tracks when a church record was last pushed to the external system.)

Named Credential:

Example Name: My_External_API

URL: Set to the base URL of your external API (e.g., https://google.com or your actual API endpoint).

Authentication:

Identity Type: Named Principal

Authentication Protocol: e.g., Password Authentication

Username: gmail123

Password: kitkati1243

Note: Do not hard code these credentials in your Apex code. Use a Named Credential for secure management.

API Endpoint Adjustments:

Replace 'yourEndpointPath' in the code with the relative path for your API callout.

**Deployment Steps**
Create Apex Class:

Open the Developer Console in your Salesforce org.

Create a new Apex class (e.g., ChurchJSONGenerator) and paste the full code (provided below).

Save and compile the class.

Verify Named Credential:

Go to Setup → Named Credentials and confirm your Named Credential (My_External_API) is configured as described.

Custom Field Check:

Ensure that the Church__c object includes the custom field Last_Pushed_Date__c with the correct Date/Time type.

**Execution**
To push new or updated church records to your external API:

Open the Developer Console.

Go to Debug → Open Execute Anonymous Window.



**Code Details**

Query Filtering:

The SOQL query filters for records where Last_Pushed_Date__c is NULL or LastModifiedDate > Last_Pushed_Date__c. This logic ensures only new or changed records are processed.

Data Mapping:

Each queried record is mapped into a ChurchData inner class, which mirrors the field definitions of the Church__c object.

JSON Serialization:

The list of mapped records is serialized into a pretty-printed JSON string using JSON.serializePretty().

File Storage:

The code creates a ContentVersion record to store the generated JSON as a file in Salesforce Files. This provides an audit trail and a backup of the pushed data.

HTTP Callout:

An HTTP POST request is built using the Named Credential (callout:My_External_API/yourEndpointPath). The request sends the JSON string with a Content-Type header of application/json.

Post-Callout Update:

After a successful API response (HTTP status code 200 or 201), the code updates the Last_Pushed_Date__c field for each processed record to the current timestamp, ensuring that further pushes only include new or updated records.
