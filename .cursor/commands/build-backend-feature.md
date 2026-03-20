Build the backend part of a LifeOS feature.

Follow:
- lifeos-backend-rules
- lifeos-api-style-rules
- lifeos-dev-workflow-rules
- database-schema-plan
- api-endpoints-plan
- lifeos-engineering

Execution order:
1. Understand the feature and required data model
2. Add or update migration if needed
3. Add or update model and relationships
4. Create Form Request validation
5. Add Policy authorization
6. Add service/action for business logic when needed
7. Create/update controller
8. Create/update API resource
9. Register routes
10. Add or update tests when appropriate

Requirements:
- thin controllers
- clean service logic
- secure ownership enforcement
- consistent JSON responses
- no raw model responses
- correct status codes
- maintainable code only

Backend feature:
{{feature_name}}
