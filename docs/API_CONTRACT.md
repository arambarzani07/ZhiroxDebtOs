# Zhirox Debt Intelligence OS - Flutter API Contract

## Auth group

Base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-auth
```

### POST /login

Request:

```json
{
  "email": "admin@zhirox.os",
  "password": "123123123"
}
```

Expected response contains one of:

```json
{
  "authToken": "...",
  "user": {}
}
```

The Flutter app stores this token and sends it as:

```text
Authorization: Bearer <token>
```

### GET /me

Returns current user, role and permissions.

---

## Customers group

Expected base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-customers
```

### GET /list

Returns all customers for authenticated business.

### GET /id?id=2

Returns:

```json
{
  "customer": {},
  "profile": {}
}
```

### POST /create

Request:

```json
{
  "full_name": "Test Customer",
  "phone": "07700000000",
  "secondary_phone": "",
  "address": "Erbil",
  "notes": "Created from Flutter app",
  "branch_id": 0,
  "credit_limit": 500000
}
```

---

## Financial Events group

Expected base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-financial-events
```

### POST /debt

Request:

```json
{
  "customer_id": 2,
  "amount": 100000,
  "currency": "IQD",
  "description": "Debt from mobile app",
  "reference_number": "APP-DEBT-..."
}
```

If credit limit is exceeded, expected response:

```json
{
  "status": "pending_approval",
  "approval_request_id": 2,
  "financial_event_id": 4,
  "message": "Action requires manager approval: Credit limit exceeded"
}
```

### POST /payment

Request:

```json
{
  "customer_id": 2,
  "amount": 30000,
  "currency": "IQD",
  "description": "Payment from mobile app",
  "reference_number": "APP-PAY-..."
}
```

Expected response includes:

```json
{
  "financial_event": {},
  "ledger_posting": {},
  "receipt": {},
  "customer_profile": {},
  "current_balance": 70000
}
```

---

## Approvals group

Expected base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-approvals
```

### POST /approve

Request:

```json
{
  "id": 2
}
```

Expected response:

```json
{
  "success": true
}
```

---

## Dashboard group

Expected base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-dashboard
```

### GET /summary

Expected totals after validated test data:

```json
{
  "total_current_balance": 230000,
  "total_debt_given": 300000,
  "total_payment_received": 70000,
  "customers_count": 2,
  "active_customers_count": 2
}
```

---

## Reports group

Expected base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-reports
```

### GET /daily?branch_id=0&date=2026-06-20

Returns live daily financial report.

---

## Data Quality group

Expected base URL:

```text
https://x8ki-letl-twmt.n7.xano.io/api:zhirox-data-quality
```

### POST /scan

Expected response:

```json
{
  "issues_found": 0,
  "issues": [],
  "scan_completed": true
}
```

## Important note

The Auth base URL is confirmed. Other group base URLs are derived by naming convention in `ApiConfig`. If Xano shows a different base URL for any API group, update the matching value in `lib/main.dart`.
