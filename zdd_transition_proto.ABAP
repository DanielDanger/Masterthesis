*&---------------------------------------------------------------------*
*& Report zdd_transition_proto
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdd_transition_proto.


DATA: ls_time TYPE isdd.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (10) l_plant FOR FIELD plant. " Label
  PARAMETERS: plant TYPE werks_d DEFAULT '0001'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (10) l_date FOR FIELD p_date. " Label
  PARAMETERS: p_date TYPE isdd DEFAULT '20200101'.

*    workc type CRHD-arbpl,
*    SELECT-OPTIONS:
*      time_sel      FOR ls_time.
SELECTION-SCREEN END OF LINE.
**
INITIALIZATION.
  l_plant = 'Plant:'.
  l_date = 'Date:'.

START-OF-SELECTION.

  SELECT * FROM zdd_full_join_with_ausp( p_werk = @plant, p_date = @p_date ) INTO TABLE @DATA(lt_full_join_with_ausp).
  SORT lt_full_join_with_ausp BY WorkCenter ASCENDING isdd ASCENDING isdz ASCENDING.

  DATA(out) = cl_demo_output=>new(
      )->write_data( lt_full_join_with_ausp ).

  DATA: BEGIN OF ty_transition,
          workcenter     TYPE string,
          transition_key TYPE string,
          predecessor    TYPE string,
          successor      TYPE string,
        END OF ty_transition.

  DATA: lt_transition    LIKE STANDARD TABLE OF ty_transition
            WITH NON-UNIQUE KEY transition_key,
        work_center_temp TYPE string.

  LOOP AT lt_full_join_with_ausp ASSIGNING FIELD-SYMBOL(<ls_mat>).
    DATA(lv_index) = sy-tabix.
    IF lv_index + 1 <= lines( lt_full_join_with_ausp ).
      READ TABLE lt_full_join_with_ausp INDEX lv_index + 1 INTO DATA(ls_mat_next).
      IF <ls_mat>-WorkCenter = ls_mat_next-WorkCenter.
        APPEND VALUE #( workcenter = <ls_mat>-WorkCenter transition_key = <ls_mat>-Material && '->' && ls_mat_next-Material predecessor = <ls_mat>-Material successor = ls_mat_next-Material ) TO lt_transition.
      ELSE.
        APPEND VALUE #(  workcenter = <ls_mat>-WorkCenter transition_key = <ls_mat>-Material && '->' && '' predecessor = <ls_mat>-Material successor = '' ) TO lt_transition.
      ENDIF.
    ELSE.
      APPEND VALUE #(  workcenter = <ls_mat>-WorkCenter transition_key = <ls_mat>-Material && '->' && '' predecessor = <ls_mat>-Material successor = '' ) TO lt_transition.
    ENDIF.
  ENDLOOP.

  out->write_data( lt_transition ).

  DATA: BEGIN OF ty_transition_count,
          transition_key TYPE string,
          predecessor    TYPE string,
          successor      TYPE string,
          count          TYPE i,
        END OF ty_transition_count,
        lt_transition_count LIKE STANDARD TABLE OF ty_transition_count
            WITH NON-UNIQUE KEY transition_key.

  LOOP AT lt_transition INTO DATA(ls_mat_order)
   GROUP BY  ( transition = ls_mat_order-transition_key
               predecessor = ls_mat_order-predecessor
               successor =  ls_mat_order-successor
               size  = GROUP SIZE
               index = GROUP INDEX )
    DESCENDING
    REFERENCE INTO DATA(transition_group).

    APPEND VALUE #( transition_key = transition_group->transition predecessor = transition_group->predecessor successor = transition_group->successor count = transition_group->size ) TO lt_transition_count.

  ENDLOOP.

  SORT lt_transition_count BY count DESCENDING.
  out->write_data( lt_transition_count )->display( ).
