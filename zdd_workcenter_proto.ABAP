*&---------------------------------------------------------------------*
*& Report zdd_workcenter_proto
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdd_workcenter_proto.

DATA: ls_time TYPE isdd.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (15) l_plant FOR FIELD plant. " Label
  PARAMETERS: plant TYPE werks_d DEFAULT '0001'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (15) l_date FOR FIELD p_date. " Label
  PARAMETERS: p_date TYPE isdd DEFAULT '20200101'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT (15) l_workc FOR FIELD workc. " Label
  PARAMETERS: workc TYPE CRHD-arbpl OBLIGATORY.
SELECTION-SCREEN END OF LINE.


*    SELECT-OPTIONS:
*      time_sel      FOR ls_time.

INITIALIZATION.
  l_plant = 'Plant:'.
  l_date = 'Date:'.
  l_workc = 'Work Center:'.

START-OF-SELECTION.

  SELECT * FROM zdd_count_with_ausp( p_werk = @plant, p_date = @p_date ) INTO TABLE @DATA(lt_material_count).

  TYPES: ty_t_spopli TYPE STANDARD TABLE OF spopli WITH KEY varoption.
  DATA: lt_selection TYPE ty_t_spopli.

  LOOP AT lt_material_count ASSIGNING FIELD-SYMBOL(<ls_wc>).
    APPEND VALUE #( inactive = '' selflag = abap_true varoption = <ls_wc>-WorkCenter ) TO lt_selection.

  ENDLOOP.

""""""""""""""""""""""""""""""""""""""""
"" Show Pop up to select work centers ""
""""""""""""""""""""""""""""""""""""""""

  SORT lt_selection BY varoption.

" Show itab duplicates
  Data: lt_duplicates TYPE ty_t_spopli.
  LOOP AT lt_selection ASSIGNING FIELD-SYMBOL(<ls_line>).
    AT NEW varoption. " whenever drawing or any field left of it changes...
      FREE lt_duplicates.
    ENDAT.
    APPEND <ls_line> TO lt_duplicates.
    AT END OF varoption.
      IF lines( lt_duplicates ) > 1.
*       congrats, here are your duplicates...
      ENDIF.
    ENDAT.
  ENDLOOP.

* DELETE ADJACENT DUPLICATES FROM lt_selection comparing varoption.


*
*  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
*    EXPORTING
*      i_title               = 'Select Work Center'
*      i_selection           = abap_true
*      i_allow_no_selection  = abap_false
*      i_zebra               = abap_false
*      i_screen_start_column = 1
*      i_screen_start_line   = 1
*      i_screen_end_column   = 80
*      i_screen_end_line     = 10
*      i_checkbox_fieldname  = 'SELFLAG'
*      i_tabname             = 'IT_SEL'
*      i_structure_name      = 'SPOPLI'
*    TABLES
*      t_outtab              = lt_selection
*    EXCEPTIONS
*      program_error         = 1
*      OTHERS                = 2.
*  IF sy-subrc <> 0.
*    MESSAGE 'Error' TYPE 'E'.
*  ENDIF.
*
*  LOOP AT lt_selection INTO DATA(ls_selection) WHERE selflag <> abap_true.
*    DELETE lt_material_count WHERE WorkCenter = ls_selection-varoption.
*  ENDLOOP.

""""""""""""""""""""""""""""""""""""""""""""
"" END Show Pop up to select work centers ""
""""""""""""""""""""""""""""""""""""""""""""


"" show input work center only
 DELETE lt_material_count WHERE WorkCenter <> workc.


*  SORT lt_material_count BY Count_WC DESCENDING.
  cl_demo_output=>write_data( lt_material_count ).
  cl_demo_output=>display( ).
