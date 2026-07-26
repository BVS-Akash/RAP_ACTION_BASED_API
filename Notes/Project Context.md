# RAP Action-Based API with Different Input and Output Structures

## 📖 Overview

This project demonstrates how to build a **standalone SAP RAP API** where the API accepts **one structure as input** and returns a **completely different structure as output**.

Instead of performing CRUD operations, the API executes business logic and returns a calculated result.

### Flow

```text
Input JSON
     │
     ▼
RAP Action
     │
     ▼
Business Logic
     │
     ▼
Output JSON
```

This design is commonly used for:

- ✅ Availability Checks
- ✅ Pricing Simulations
- ✅ Tax Calculations
- ✅ Approval Simulations
- ✅ Validations
- ✅ Eligibility Checks

---

# 🎯 Problem Statement

Traditional CRUD APIs operate on the same business entity.

```text
Create Customer
Read Customer
Update Customer
Delete Customer
```

However, many SAP business processes are **operations**, not CRUD.

Example:

> **Check whether an employee expense can be approved**

### Input

- Employee Details
- Expense Details
- Amount
- Country

### Output

- Approval Status
- Approval Level
- Approved Amount
- Reason

Notice that the request and response structures are completely different.

This is exactly what **RAP Actions** are designed for.

---

# 🏗 Architecture

```text
External Consumer
(Fiori / Postman / External System)
            │
            ▼
        OData V4 API
            │
            ▼
      Service Binding
            │
            ▼
     Service Definition
            │
            ▼
        RAP Action
            │
            ▼
 Behavior Implementation
            │
            ▼
 Business Logic Class
```

---

# 📦 RAP Components

## 1. CDS View Entities

CDS View Entities define the data model exposed through RAP.

In transactional applications they represent persisted business data.

For operation-based APIs they represent:

- API Input
- API Output
- Business Objects

---

## 2. Abstract Entities

Abstract entities define structures **without database persistence**.

### Input Entity

```text
ZI_EXPENSE_INPUT
```

| Field |
|-------|
| EmployeeID |
| ExpenseType |
| Amount |
| Currency |
| Country |
| Days |

Example Request

```json
{
  "EmployeeID": "E1001",
  "ExpenseType": "Flight",
  "Amount": 1200,
  "Currency": "USD"
}
```

---

### Output Entity

```text
ZI_EXPENSE_RESULT
```

| Field |
|-------|
| ApprovalStatus |
| ApprovalLevel |
| ApprovedAmount |
| RiskCategory |
| Message |

Example Response

```json
{
  "ApprovalStatus": "APPROVED",
  "ApprovalLevel": "MANAGER",
  "ApprovedAmount": 1200,
  "Message": "Within policy limit"
}
```

---

# ⚙ RAP Action

A RAP Action represents a business operation.

Example:

```text
SimulateApproval
```

Flow

```text
ZI_EXPENSE_INPUT
        │
        ▼
 SimulateApproval
        │
        ▼
ZI_EXPENSE_RESULT
```

---

# 📄 Behavior Definition

The action is defined inside the Behavior Definition.

```abap
define behavior for ZI_EXPENSE_API
{
  static action SimulateApproval
      parameter ZI_EXPENSE_INPUT
      result [1] ZI_EXPENSE_RESULT;
}
```

### Meaning

- Create an action named **SimulateApproval**
- Accept **ZI_EXPENSE_INPUT**
- Return **ZI_EXPENSE_RESULT**

---

# 💻 Behavior Implementation

Business logic is triggered from the handler class.

```abap
METHOD SimulateApproval.

  DATA(ls_input) = keys[ 1 ]-%param.

  DATA(ls_result) =
      zcl_expense_rule_engine=>check(
          ls_input ).

  result = VALUE #(
    (
      %param = ls_result
    )
  ).

ENDMETHOD.
```

Responsibilities

- Read input
- Execute business logic
- Prepare response
- Return output

---

# 🧠 Business Logic Layer

Business rules should remain independent from RAP.

```text
Behavior Handler
       │
       ▼
Expense Rule Engine
       │
       ▼
Business Rules
```

Benefits

- Reusable logic
- Better unit testing
- Clean RAP implementation
- Easier maintenance

---

# 🌐 Service Definition

The Service Definition exposes RAP artifacts.

```abap
define service ZUI_EXPENSE_SERVICE
{
    expose ZI_EXPENSE_API;
}
```

This creates the API contract.

---

# 🚀 Service Binding

Service Binding publishes the RAP service as an **OData V4 API**.

```text
Service Definition
        │
        ▼
Service Binding
        │
        ▼
OData V4 Endpoint
```

After publishing, the API can be tested using:

- Swagger / OpenAPI
- Postman
- SAP Fiori
- External Applications

---

# 🔄 API Execution Flow

## Request

```http
POST /SimulateApproval
```

```json
{
  "EmployeeID": "E1001",
  "Amount": 1200,
  "Currency": "USD"
}
```

---

## Processing

```text
JSON Request
      │
      ▼
RAP Framework
      │
      ▼
Action Parameter
      │
      ▼
Behavior Handler
      │
      ▼
Business Logic
```

---

## Response

```json
{
  "ApprovalStatus": "APPROVED",
  "ApprovalLevel": "MANAGER",
  "ApprovedAmount": 1200
}
```

---

# ⚖ SEGW vs RAP

| SEGW (OData V2) | RAP (OData V4) |
|-----------------|----------------|
| Function Import | Action |
| DPC_EXT Method | Behavior Implementation |
| Manual JSON Mapping | Automatic Framework Mapping |
| MPC Model | CDS Model |
| Service Registration | Service Binding |
| ER_ENTITY Handling | Action Result |

---

# 📚 Learning Outcomes

This project demonstrates:

- RAP Programming Model
- CDS View Entities
- Abstract Entities
- RAP Actions
- Different Request & Response Structures
- OData V4 Services
- Business Logic Separation
- API-First Development

---

# 💡 Real-World Use Cases

The same architecture can be applied to:

- Sales Order Availability Check API
- Pricing Simulation API
- Tax Determination API
- Credit Check API
- Purchase Approval Simulation API
- Invoice Validation API
- Delivery Cost Estimation API
- Shipping Eligibility API

---

# 🏁 Conclusion

RAP Actions provide a clean and modern approach for implementing **operation-based APIs** where the request and response structures are independent.

Instead of forcing every business requirement into CRUD operations, RAP enables APIs that execute business logic and return meaningful results, making it an excellent fit for modern SAP enterprise applications.
