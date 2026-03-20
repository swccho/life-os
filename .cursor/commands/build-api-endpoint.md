Create or update a LifeOS API endpoint.

Follow:
- lifeos-backend-rules
- lifeos-api-style-rules
- lifeos-dev-workflow-rules
- lifeos-engineering

Process:
1. Understand the endpoint purpose
2. Identify the correct RESTful route and HTTP method
3. Add/update request validation
4. Add/update authorization
5. Add/update service logic if needed
6. Add/update controller method
7. Add/update API resource/response shape
8. Register/update route
9. Keep response format consistent with LifeOS API standards

Rules:
- use Form Requests for validation
- use Policies for protected resources
- use Resources for output
- use correct status codes
- keep naming explicit
- keep controllers thin
- scope all user data correctly

Endpoint description:
{{endpoint_description}}
