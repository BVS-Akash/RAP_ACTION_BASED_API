# Travel Expense Approval Simulation API

This is an unmanaged, stateless RAP action API. `ZI_EXPENSE_API` is a RAP custom root entity so there is no CDS source table or persistence dependency. Its only role is to host the static OData action.

## ADT build order

1. Create and activate the two abstract entities, then the custom root entity.
2. Create and activate behavior definition `ZI_EXPENSE_API`.
3. Create behavior pool `ZBP_I_EXPENSE_API` and add the supplied local handler code.
4. Create and activate global class `ZCL_EXPENSE_RULE_ENGINE`.
5. Create and activate the service definition.
6. Create, activate, and publish `ZUI_EXPENSE_SERVICE_BINDING` as **OData V4 - Web API**.

## Sample request

## Generated endpoint

After activating and publishing `ZUI_EXPENSE_SERVICE_BINDING`, open the service binding in ADT. The **Service URL** field displays the generated root endpoint for your SAP system, for example:

```text
https://<host>:<port>/sap/opu/odata4/sap/zui_expense_service_o4/srvd/sap/zui_expense_service/0001/
```

Do not hard-code this example: copy the actual URL shown by your published binding. Open `<service-root>$metadata` to confirm the entity set and fully-qualified action name for your release.

The static action is invoked with `POST` below the exposed entity set. A typical action endpoint is:

```text
POST <service-root>/ExpenseApi/<namespace>.SimulateApproval
```

For example, if `$metadata` exposes `ZUI_EXPENSE_SERVICE.SimulateApproval`, use:

```text
POST <service-root>/ExpenseApi/ZUI_EXPENSE_SERVICE.SimulateApproval
```

The exact namespace is authoritative in `$metadata`.

Headers:

```http
Content-Type: application/json
Accept: application/json
```

Body:

```json
{
  "EmployeeID": "E1001",
  "ExpenseType": "Flight",
  "Amount": 1200.00,
  "Currency": "USD",
  "TravelCountry": "USA",
  "Days": 5
}
```

## Sample response

```json
{
  "ApprovalStatus": "APPROVED",
  "ApprovalLevel": "MANAGER",
  "ApprovedAmount": 1200.00,
  "RiskCategory": "MEDIUM",
  "Message": "Expense is within policy limit"
}
```

Depending on your SAP release and OData client, the action return can be wrapped in a `value` property. Confirm the precise URL and response shape in the published `$metadata` document.

## Test with ADT preview

1. In ADT, open `ZUI_EXPENSE_SERVICE_BINDING` and choose **Publish**.
2. Choose **Preview** (or open the copied Service URL in a browser). This opens the OData V4 service document.
3. Use the service document to navigate to `ExpenseApi`, then open `$metadata`.
4. Locate `SimulateApproval` in the metadata and copy its full action name.
5. Preview is useful for validating the binding, metadata, and entity exposure. Use Postman for the `POST` action call with a JSON body.

## Test with Postman

1. Create a new **POST** request using the action URL copied from `$metadata`.
2. If your SAP system requires authentication, configure the same authentication method used for the service binding (commonly Basic Authentication for a development system).
3. Add headers `Accept: application/json` and `Content-Type: application/json`.
4. On the **Body** tab, choose **raw** and **JSON**, then paste the sample request above.
5. Click **Send**. A successful `1200.00 USD` request returns `APPROVED`, `MANAGER`, and `MEDIUM` risk.

For this stateless action, no create/update operation occurs. If your SAP landscape enforces CSRF protection for POST requests, first send a `GET <service-root>` with header `x-csrf-token: Fetch`, then include the returned `x-csrf-token` and session cookies in the POST request.

## Request flow

```text
JSON request
  -> OData V4 runtime
  -> SimulateApproval action parameter (%param)
  -> lhc_ExpenseApi behavior handler
  -> ZCL_EXPENSE_RULE_ENGINE=>check_expense
  -> RAP result table (%param)
  -> JSON response
```

The behavior handler only adapts RAP request/response structures. Policy logic is isolated in `ZCL_EXPENSE_RULE_ENGINE`, which makes it testable and clean-core friendly.
