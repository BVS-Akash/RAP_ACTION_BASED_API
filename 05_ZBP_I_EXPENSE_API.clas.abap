CLASS zbp_i_expense_api DEFINITION
  PUBLIC ABSTRACT FINAL
  FOR BEHAVIOR OF zi_expense_api.
ENDCLASS.

CLASS zbp_i_expense_api IMPLEMENTATION.
ENDCLASS.

CLASS lhc_ExpenseApi DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS SimulateApproval FOR MODIFY
      IMPORTING keys FOR ACTION ExpenseApi~SimulateApproval
      RESULT result.
ENDCLASS.

CLASS lhc_ExpenseApi IMPLEMENTATION.
  METHOD SimulateApproval.
    " %param contains the JSON object supplied as the RAP action parameter.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<action_request>).
      DATA(ls_input)  = CORRESPONDING zi_expense_input( <action_request>-%param ).
      DATA(ls_output) = zcl_expense_rule_engine=>check_expense( ls_input ).

      " %param becomes the action response payload in OData V4.
      APPEND VALUE #( %cid   = <action_request>-%cid
                      %param = ls_output ) TO result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
