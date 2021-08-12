*&---------------------------------------------------------------------*
*& Report z_dd_cluster_setups
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_dd_cluster_setups.



DATA: l_matrix_id_str      LIKE /sapapo/set_mid,
      lt_lc_setup_matrix   TYPE /sapapo/om_setup_matrix_tab,
      lt_lc_setup_diagonal TYPE /sapapo/om_setup_diagonal_tab,
      lt_lc_setup_except   TYPE /sapapo/om_setup_except_tab.

" Data-Fields for K-Means
DATA: lt_PAL_KMEANS_DATA_TAB TYPE zdd_kmeans_cluster=>tt_PAL_KMEANS_DATA_TAB,
      lt_PAL_PARAMETER_TBL   TYPE zdd_kmeans_cluster=>tt_PAL_PARAMETER_TBL.


" Set K-Means Parameters
APPEND VALUE #( param_name = 'THREAD_RATIO' int_value = 0 double_value = '0.2' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'GROUP_NUMBER' int_value = 2 double_value = 0 string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'INIT_TYPE' int_value = 1 double_value = '0' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'DISTANCE_LEVEL' int_value = 2 double_value = '0' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'MAX_ITERATION' int_value = 100 double_value = '0' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'EXIT_THRESHOLD' int_value = 0 double_value = '0.000001' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'CATEGORY_WEIGHTS' int_value = 0 double_value = '0.5' string_value = '' ) TO lt_pal_parameter_tbl.

" Set Matrix ID
l_matrix_id_str-matrix_id = '{XO{DPFP7kkdXVsb9F30pW'.


CALL FUNCTION '/SAPAPO/OM_SETUPMATRIX_GET_DAT'
      EXPORTING
        iv_setup_matrix_id  = l_matrix_id_str-matrix_id
      IMPORTING
        et_setup_matrix     = lt_lc_setup_matrix
        et_setup_diagonals  = lt_lc_setup_diagonal
        et_setup_exceptions = lt_lc_setup_except
      EXCEPTIONS
        lc_connect_failed   = 1
        lc_com_error        = 2
        lc_appl_error       = 3
        OTHERS              = 4.


"Example
"APPEND VALUE #( id = 5  v000 = '0.5' v001 = 'B' v002 = '15.5' ) TO lt_PAL_KMEANS_DATA_TAB.

data i type Integer.

loop at lt_lc_setup_matrix into DATA(lv_lc_setup_matrix).

data(duration) = lv_lc_setup_matrix-data-duration .
APPEND VALUE #( id = i  v000 = duration  ) TO lt_PAL_KMEANS_DATA_TAB.
i = i + 1.

endloop.

zdd_kmeans_cluster=>kmeans_proc_call(
  EXPORTING
    it_kmeans_data_tab      = lt_PAL_KMEANS_DATA_TAB
    it_pal_parameter_tbl = lt_pal_parameter_tbl
  IMPORTING
    et_result            = data(lt_result)
    et_centers           = data(lt_centers)
    et_model             = data(lt_model)
    et_statistics        = data(lt_statistics)
    et_placeholder       = data(lt_placeholder)
).


BREAK-POINT.
