Build the Flutter part of a LifeOS feature.

Follow:
- lifeos-flutter-rules
- lifeos-product-ui-rules
- lifeos-dev-workflow-rules
- flutter-feature-structure
- lifeos-engineering

Execution order:
1. Understand the feature and API contract
2. Create/update typed models
3. Create/update repository methods
4. Create/update Riverpod providers
5. Integrate route if needed
6. Build screen UI
7. Split large UI into feature widgets
8. Add:
   - loading state
   - empty state
   - error state
   - form state handling
9. Keep UI calm, modern, mobile-first, and production-ready

Requirements:
- no raw JSON use in UI
- no giant providers
- no giant build methods
- reusable components where useful
- predictable navigation
- clear UX hierarchy

Flutter feature:
{{feature_name}}
