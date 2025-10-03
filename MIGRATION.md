# Migration: PHP to Java (JDBC + MySQL) with Static Frontend

This document explains the migration from the legacy PHP backend to a Java (Spring Boot) backend using JDBC and MySQL, with a static frontend deployable to Vercel.

## New Architecture
- Static frontend (Vercel) located at `frontend/`
- Java backend (Render) located at `backend/`
- MySQL database with schema initialized by `backend/src/main/resources/schema.sql`

## Local Setup
1. Create a MySQL database (e.g., `college_complaint_portal`).
2. Export environment variables for backend:
   - DB_HOST, DB_PORT, DB_NAME, DB_USERNAME, DB_PASSWORD, FRONTEND_ORIGIN
3. Start backend:
   - cd backend && mvn spring-boot:run
4. Open frontend:
   - Open `frontend/index.html` or serve with any static server.

## Deployment
- Frontend: Vercel using `vercel.json` at repo root (serves `frontend/*`).
- Backend: Render using `render.yaml` with service root `backend/`.

## API Summary
- POST /api/auth/register { name, email, password, role }
- POST /api/auth/login { email, password, role }
- POST /api/complaints { userId, title, description }
- GET  /api/complaints?userId=...

## Notes
- Passwords stored as BCrypt hashes.
- For production hardening, add JWT auth, input validation layers, and role-based authorization.
