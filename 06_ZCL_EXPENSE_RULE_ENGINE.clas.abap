CLASS zcl_expense_rule_engine DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS check_expense
      IMPORTING is_input         TYPE zi_expense_input
      RETURNING VALUE(rs_result) TYPE zi_expense_result.
ENDCLASS.

CLASS zcl_expense_rule_engine IMPLEMENTATION.
  METHOD check_expense.
    rs_result-approvedamount = is_input-amount.

    IF is_input-amount <= 1000.
      rs_result-approvalstatus = 'APPROVED'.
      rs_result-approvallevel  = 'AUTO'.
      rs_result-riskcategory   = 'LOW'.
      rs_result-message        = 'Expense is within automatic approval limit'.
    ELSEIF is_input-amount <= 5000.
      rs_result-approvalstatus = 'APPROVED'.
      rs_result-approvallevel  = 'MANAGER'.
      rs_result-riskcategory   = 'MEDIUM'.
      rs_result-message        = 'Expense is within policy limit'.
    ELSE.
      rs_result-approvalstatus = 'PENDING'.
      rs_result-approvallevel  = 'DIRECTOR'.
      rs_result-riskcategory   = 'HIGH'.
      rs_result-message        = 'Expense exceeds manager approval limit'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
