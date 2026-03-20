# LifeOS API Endpoints Plan

## Base URL

/api

---

## Authentication

POST   /api/register  
POST   /api/login  
POST   /api/logout  
GET    /api/user  

---

## Tasks

GET    /api/tasks  
POST   /api/tasks  
GET    /api/tasks/{task}  
PUT    /api/tasks/{task}  
DELETE /api/tasks/{task}  

POST   /api/tasks/{task}/complete  

Optional filters:
- status (completed / pending)
- priority
- due_date

---

## Habits

GET    /api/habits  
POST   /api/habits  
GET    /api/habits/{habit}  
PUT    /api/habits/{habit}  
DELETE /api/habits/{habit}  

POST   /api/habits/{habit}/check-in  

---

## Habit Logs

GET    /api/habits/{habit}/logs  

Optional:
- date range filtering

---

## Journal

GET    /api/journal-entries  
POST   /api/journal-entries  
GET    /api/journal-entries/{entry}  
PUT    /api/journal-entries/{entry}  
DELETE /api/journal-entries/{entry}  

Optional:
- search
- date filter

---

## Mood Logs

GET    /api/mood-logs  
POST   /api/mood-logs  
GET    /api/mood-logs/{log}  
PUT    /api/mood-logs/{log}  
DELETE /api/mood-logs/{log}  

Optional:
- date range

---

## Insights

GET /api/insights/summary  

Returns:
- task stats
- habit stats
- journal stats
- mood summary

---

## Profile

GET /api/profile  

---

## API Behavior Rules

- all routes except auth must be protected
- all data must be scoped to authenticated user
- use API Resources
- use Form Requests
- use Policies

---

## Pagination

Use pagination for:
- tasks
- journal entries
- mood logs

---

## Action Endpoints

Use for:
- complete task
- check-in habit

---

## Future Endpoints (Not MVP)

- notifications
- reminders
- analytics charts
- AI insights

---

## Summary

This API structure is:
- RESTful
- clean
- scalable
- consistent

Do not deviate from naming conventions.
