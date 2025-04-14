public with sharing class ChurchJSONGenerator {
    
    // Inner class to represent the structure of Church__c records
    // The field names and data types match your Salesforce object definitions.
    public class ChurchData {
        public String Name;                // Text(80)
        public String countryCode;         // Text(3)
        public String CreatedById;         // Lookup(User)
        public String dataSubtype;         // Picklist
        public String dataType;            // Picklist
        public Date dateSubmitted;         // Date
        public String isVersionOf;         // Picklist
        public String LastModifiedById;    // Lookup(User)
        public String latitude;            // Text(11)
        public String longitude;           // Text(11)
        public String OwnerId;             // Lookup(User,Group)
        public Decimal size;               // Number(18, 0)
        public String spatialReference;    // Text(8)
        public Date startDate;             // Date
    }
    
    /**
     * This method performs the following:
     *  1. Queries all Church__c records.
     *  2. Maps each record into a ChurchData object.
     *  3. Serializes the list of ChurchData objects into a pretty-printed JSON string.
     *  4. Creates and stores a JSON file (ContentVersion) in Salesforce Files.
     *  5. Sends the JSON payload to an external API using a Named Credential for authentication.
     *
     * The Named Credential (e.g., My_External_API) must be created in Setup with:
     *  - URL: https://google.com (or your actual API endpoint)
     *  - Username: gmail123
     *  - Password: kitkati1243
     *  - Appropriate Authentication settings.
     */
    public static void generateJSONFileAndSendToAPI() {
        // -------------------------------------------------------------------
        // Step 1: Query all records from Church__c object
        // -------------------------------------------------------------------
        List<Church__c> churches = [
            SELECT 
                Name,
                countryCode__c,
                CreatedById,
                dataSubtype__c,
                dataType__c,
                dateSubmitted__c,
                isVersionOf__c,
                LastModifiedById,
                latitude__c,
                longitude__c,
                OwnerId,
                size__c,
                spatialReference__c,
                startDate__c
            FROM Church__c
        ];
        
        // -------------------------------------------------------------------
        // Step 2: Map each Church__c record to a ChurchData instance
        // -------------------------------------------------------------------
        List<ChurchData> churchDataList = new List<ChurchData>();
        for (Church__c church : churches) {
            ChurchData data = new ChurchData();
            // Assign values from the queried record to our inner class fields
            data.Name             = church.Name;
            data.countryCode      = church.countryCode__c;
            data.CreatedById      = church.CreatedById;
            data.dataSubtype      = church.dataSubtype__c;
            data.dataType         = church.dataType__c;
            data.dateSubmitted    = church.dateSubmitted__c;
            data.isVersionOf      = church.isVersionOf__c;
            data.LastModifiedById = church.LastModifiedById;
            data.latitude         = church.latitude__c;   // Stored as text
            data.longitude        = church.longitude__c;  // Stored as text
            data.OwnerId          = church.OwnerId;
            data.size             = church.size__c;       // Number stored as Decimal
            data.spatialReference = church.spatialReference__c;
            data.startDate        = church.startDate__c;
            
            // Add the mapped object to the list
            churchDataList.add(data);
        }
        
        // -------------------------------------------------------------------
        // Step 3: Serialize the list of ChurchData objects to a JSON string
        // -------------------------------------------------------------------
        String jsonString = JSON.serializePretty(churchDataList);
        System.debug('Generated JSON: ' + jsonString);
        
        // -------------------------------------------------------------------
        // Step 4: Create a ContentVersion record to store the JSON file in Salesforce Files
        // -------------------------------------------------------------------
        ContentVersion cv = new ContentVersion();
        cv.Title = 'ChurchData.json';           // File title in Files
        cv.PathOnClient = 'ChurchData.json';      // Filename as it appears when downloaded
        cv.VersionData = Blob.valueOf(jsonString); // Convert JSON string to Blob for storage
        insert cv;                                // Insert the file into Salesforce Files
        System.debug('ContentVersion created with Id: ' + cv.Id);
        
        // -------------------------------------------------------------------
        // Step 5: Send the JSON payload to an external API using a Named Credential
        // -------------------------------------------------------------------
        // Create an HTTP request object
        HttpRequest req = new HttpRequest();
        // Use the Named Credential for authentication; append your specific endpoint path after the slash.
        req.setEndpoint('callout:My_External_API/yourEndpointPath');
        req.setMethod('POST');                        // Set the HTTP method to POST
        req.setHeader('Content-Type', 'application/json'); // Set the content type header to JSON
        req.setBody(jsonString);                      // Set the JSON payload as the request body
        
        // Execute the callout and capture the response
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            System.debug('Response Status: ' + res.getStatus());
            System.debug('Response Body: ' + res.getBody());
        } catch (Exception ex) {
            // Handle any callout errors
            System.debug('Callout error: ' + ex.getMessage());
        }
    }
}