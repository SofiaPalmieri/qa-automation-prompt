# QA Automation Challenge

## Monitoring:

    This Ruby script monitors an API for 10 minutes by making POST requests with a name parameter read from a text file. The script logs the results of each request (including the status and body of the API response) into an SQLite database for later analysis.

### Uptime:

    This script reads the previously persisted information about the previous requests and calculates the time that the API has been up.

### Bug 1: Missing name Parameter in the Request Body

    Steps to Reproduce:
    1) Navigate to the API endpoint: https://qa-challenge-nine.vercel.app/api/name-checker
    Observe the error message that states the name parameter is missing in the request body.
    
    Cause:
    The script was not including the name parameter in the request body, which is required by the API to process the request.

    Fix:
    The script was updated to ensure that the name parameter is correctly included in the request body, formatted as a JSON object. Now, every request includes the necessary name parameter for the API to process.

### Bug 2: Incorrect HTTP Method (GET Instead of POST)

    Steps to Reproduce:
    1) Navigate to: https://qa-challenge-nine.vercel.app/api/name-checker?name=SomeName
    Observe the error message stating that the name parameter should be included in the request body.

    Cause:
    Initially, the script was sending GET requests instead of the required POST requests. While the name parameter was included in the query string, the API expects it to be sent in the body of a POST request, not as part of the URL in a GET request.

    Fix:
    The script was updated to use POST requests as required by the API specification. The name parameter was correctly placed in the request body, and the correct HTTP method (POST) was used for all requests.
