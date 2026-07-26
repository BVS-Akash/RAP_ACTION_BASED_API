# Testing the RAP Action API

This project exposes a **RAP Action** that simulates travel expense approval using an **OData V4 API**.

---

# Action Endpoint

```http
POST /ZAKAI_EXPENSE_API/SAP__self.SimulateApproval
```

> The complete URL depends on your SAP BTP ABAP Environment tenant and Service Binding.

---

# Sample Request

```json
{
  "EmployeeID": "Akash",
  "ExpenseType": "Bike",
  "Amount": 190000,
  "Currency": "INR",
  "TravelCountry": "IND",
  "NumDays": 40
}
```

---

# Sample Response

```json
{
  "ApprovalLevel": "DIRECTOR",
  "ApprovalStatus": "PENDING",
  "ApprovedAmount": 190000,
  "Message": "Expense exceeds manager approval limit",
  "RiskCategory": "HIGH"
}
```

---

# Request Flow

```text
JSON Request
      │
      ▼
RAP Action
      │
      ▼
Behavior Handler
      │
      ▼
Business Rule Engine
      │
      ▼
Response JSON
```

---

# Test Cases

| Test Case | Input | Expected Result |
|------------|-------|-----------------|
| Manager Approval | Amount = 5,000 | Approved by Manager |
| Director Approval | Amount = 190,000 | Pending Director Approval |
| High Risk | Large Amount | Risk Category = HIGH |
| Invalid Country | Country length > CDS field length | Validation Error |
| Missing Required Field | EmployeeID omitted | Bad Request (400) |

---

# Testing Using Swagger

1. Publish the Service Binding.
2. Open the **Preview** of the Service Binding.
3. Expand the **SimulateApproval** action.
4. Click **Try it out**.
5. Paste the sample request.
6. Click **Execute**.
7. Verify the response.

---

# Testing Using Postman

**Method**

```
POST
```

**Headers**

```text
Content-Type: application/json
Accept: application/json
```

**Body**

```json
{
  "EmployeeID": "Akash",
  "ExpenseType": "Bike",
  "Amount": 190000,
  "Currency": "INR",
  "TravelCountry": "IND",
  "NumDays": 40
}
```

---

# Expected HTTP Status

| Status Code | Meaning |
|--------------|---------|
| 200 | Request processed successfully |
| 400 | Invalid request payload |
| 401 | Unauthorized |
| 500 | Internal server error |

---

# Sample Business Rules

| Amount | Approval Level | Status | Risk |
|---------|----------------|--------|------|
| ≤ 10,000 | Manager | APPROVED | LOW |
| 10,001 – 100,000 | Senior Manager | APPROVED | MEDIUM |
| > 100,000 | Director | PENDING | HIGH |

---

# Success Criteria

- ✔ Request payload is validated.
- ✔ RAP Action is executed successfully.
- ✔ Business rules are processed.
- ✔ Correct approval details are returned.
- ✔ Response is generated as OData V4 JSON.
