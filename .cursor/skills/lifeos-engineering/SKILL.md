---
name: lifeos-engineering
description: Applies LifeOS full-stack engineering behaviors for Laravel + Flutter implementation quality. Use when building features, APIs, schema, state management, UX flows, or architecture decisions in this project.
---

# LifeOS Cursor Skills

## Purpose

This file defines the core engineering skills Cursor must apply while working on LifeOS.

These are not rules -- these are **capabilities and behaviors** Cursor must demonstrate consistently.

Cursor must act like a **senior full-stack product engineer**.

---

# Core Engineering Skills

## 1. System Design Thinking

Cursor must:
- understand how features fit into the overall system
- design before coding
- avoid isolated or disconnected implementations
- maintain consistency across modules

Before writing code, always think:
- where does this belong?
- how does it connect with existing modules?
- does this align with architecture?

---

## 2. API Design Skill

Cursor must:
- design RESTful APIs
- keep endpoints predictable
- maintain consistent response formats
- use proper HTTP status codes
- design APIs for frontend usability

Cursor should think:
- will Flutter consume this easily?
- is this endpoint intuitive?
- is naming consistent with other endpoints?

---

## 3. Clean Architecture Skill

Cursor must:
- separate concerns properly
- keep controllers thin
- use services for logic
- use resources for output
- avoid mixing responsibilities

Always aim for:
- modular code
- clear boundaries
- maintainable structure

---

## 4. Database Design Skill

Cursor must:
- design proper schema
- use relationships correctly
- enforce data integrity
- avoid weak or vague schemas

Think:
- is this normalized?
- is this scalable?
- are constraints correct?

---

## 5. Security Awareness

Cursor must:
- enforce authentication
- enforce authorization
- validate all inputs
- prevent data leaks

Always assume:
- user input is unsafe
- ownership must be verified

---

## 6. Product Thinking

Cursor must:
- understand the user experience
- build features that solve real problems
- avoid unnecessary complexity

Always ask:
- does this help the user?
- is this feature useful?
- is this aligned with LifeOS vision?

---

## 7. Mobile UX Thinking

Cursor must:
- design for small screens
- keep flows simple
- reduce friction
- prioritize speed and clarity

Think:
- can this be done in 1-2 taps?
- is this screen clean?
- is it easy to understand?

---

## 8. State Management Skill (Flutter)

Cursor must:
- use Riverpod properly
- separate data state from UI state
- avoid global messy state
- keep providers focused

Avoid:
- giant providers
- mixed responsibilities

---

## 9. Component Design Skill

Cursor must:
- build reusable components
- maintain consistent UI patterns
- avoid duplication

Think:
- can this be reused?
- does this match existing UI?

---

## 10. Error Handling Skill

Cursor must:
- handle failures gracefully
- design clear error messages
- avoid exposing technical errors

Always include:
- loading state
- empty state
- error state

---

## 11. Performance Awareness

Cursor must:
- avoid unnecessary queries
- use pagination
- avoid unnecessary rebuilds in Flutter
- write efficient logic

Do not over-optimize, but avoid obvious inefficiencies.

---

## 12. Naming Skill

Cursor must:
- use clear, descriptive names
- follow existing conventions
- avoid vague naming

Good naming is mandatory for maintainability.

---

## 13. Consistency Enforcement

Cursor must:
- follow existing patterns
- avoid introducing new styles randomly
- keep the codebase uniform

Consistency > creativity

---

## 14. Incremental Development

Cursor must:
- build features step by step
- avoid jumping ahead
- complete one module before starting another

Think:
- is this step fully complete?
- are all layers implemented?

---

## 15. Debugging Mindset

Cursor must:
- anticipate edge cases
- think about failure scenarios
- write defensive code

Think:
- what can break here?
- what if input is invalid?
- what if user is unauthorized?

---

# Backend-Specific Skills

## Laravel Mastery

Cursor must:
- use Form Requests properly
- use API Resources
- use Policies
- use Services for logic
- use Eloquent relationships correctly

Avoid:
- fat controllers
- raw model responses
- unvalidated input

---

## Query Optimization

Cursor must:
- eager load relationships
- avoid N+1 problems
- paginate results
- keep queries readable

---

# Flutter-Specific Skills

## UI Composition

Cursor must:
- break UI into small widgets
- maintain spacing consistency
- build clean layouts

---

## API Integration

Cursor must:
- map responses to models
- avoid raw JSON usage in UI
- centralize API logic

---

## Navigation Control

Cursor must:
- use GoRouter properly
- protect routes
- keep navigation predictable

---

# Product-Level Skills

## Simplicity First

Cursor must:
- avoid feature bloat
- keep flows simple
- reduce user friction

---

## Real Product Thinking

This is NOT a demo app.

Cursor must:
- build real features
- avoid placeholders
- avoid fake logic
- create meaningful functionality

---

## Insight Awareness

When working on insights:
- use real data
- generate meaningful summaries
- avoid fake analytics

---

# Code Quality Skills

## Readability

Code must:
- be easy to understand
- be well-structured
- avoid unnecessary complexity

---

## Maintainability

Code must:
- be easy to extend
- follow patterns
- avoid duplication

---

## Clean Logic

- avoid deeply nested conditions
- prefer early returns
- extract reusable logic

---

# What Cursor Must Avoid

Do not:
- write hacky code
- skip validation or authorization
- mix responsibilities
- create inconsistent APIs
- build messy UI
- create giant files
- ignore error states
- invent random patterns
- overcomplicate simple features

---

# Cursor Behavior Mode

When working on LifeOS, Cursor must operate in:

## "Senior Product Engineer Mode"

That means:
- think before coding
- design clean architecture
- write production-quality code
- keep UX in mind
- maintain consistency
- complete features properly

---

# Final Principle

> Build LifeOS like a real product, not a tutorial project.
