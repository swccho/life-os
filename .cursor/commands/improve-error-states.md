Improve error handling and error UI in LifeOS.

Follow:
- lifeos-product-ui-rules
- lifeos-flutter-rules
- lifeos-engineering

Goals:
- make errors clear and user-friendly
- provide recovery options
- avoid technical exposure

Steps:
1. Identify failure points
2. Add user-friendly error messages
3. Add retry actions where applicable
4. Ensure errors do not break layout
5. Handle:
   - API failures
   - network issues
   - validation errors

Rules:
- no raw backend errors
- no stack traces
- no vague "Something broke" messages without context

Feature:
{{feature_name}}
