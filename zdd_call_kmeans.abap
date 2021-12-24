*&---------------------------------------------------------------------*
*& Report zdd_call_kmeans
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdd_call_kmeans.

DATA: lt_PAL_KMEANS_DATA_TAB TYPE zdd_kmeans_cluster=>tt_PAL_KMEANS_DATA_TAB,
      lt_PAL_PARAMETER_TBL   TYPE zdd_kmeans_cluster=>tt_PAL_PARAMETER_TBL.

APPEND VALUE #( id = 0  v000 = '0.5' v001 = 'A' v002 = '0.5' ) TO lt_PAL_KMEANS_DATA_TAB.
APPEND VALUE #( id = 1  v000 = '1.5' v001 = 'A' v002 = '0.5' ) TO lt_PAL_KMEANS_DATA_TAB.
APPEND VALUE #( id = 2  v000 = '1.5' v001 = 'A' v002 = '1.5' ) TO lt_PAL_KMEANS_DATA_TAB.
APPEND VALUE #( id = 3  v000 = '0.5' v001 = 'A' v002 = '1.5' ) TO lt_PAL_KMEANS_DATA_TAB.
APPEND VALUE #( id = 4  v000 = '0.1' v001 = 'B' v002 = '1.2' ) TO lt_PAL_KMEANS_DATA_TAB.
APPEND VALUE #( id = 5  v000 = '0.5' v001 = 'B' v002 = '15.5' ) TO lt_PAL_KMEANS_DATA_TAB.


APPEND VALUE #( param_name = 'THREAD_RATIO' int_value = 0 double_value = '0.2' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'GROUP_NUMBER' int_value = 4 double_value = 0 string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'INIT_TYPE' int_value = 1 double_value = '0' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'DISTANCE_LEVEL' int_value = 2 double_value = '0' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'MAX_ITERATION' int_value = 100 double_value = '0' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'EXIT_THRESHOLD' int_value = 0 double_value = '0.000001' string_value = '' ) TO lt_pal_parameter_tbl.
APPEND VALUE #( param_name = 'CATEGORY_WEIGHTS' int_value = 0 double_value = '0.5' string_value = '' ) TO lt_pal_parameter_tbl.

*lt_PAL_KMEANS_DATA_TBL.insert((0, 0.5, 'A', 0.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((1, 1.5, 'A', 0.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((2, 1.5, 'A', 1.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((3, 0.5, 'A', 1.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((4, 1.1, 'B', 1.2));
*:lt_PAL_KMEANS_DATA_TBL.insert((5, 0.5, 'B', 15.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((6, 1.5, 'B', 15.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((7, 1.5, 'B', 16.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((8, 0.5, 'B', 16.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((9, 1.2, 'C', 16.1));
*:lt_PAL_KMEANS_DATA_TBL.insert((10, 15.5, 'C', 15.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((11, 16.5, 'C', 15.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((12, 16.5, 'C', 16.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((13, 15.5, 'C', 16.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((14, 15.6, 'D', 16.2));
*:lt_PAL_KMEANS_DATA_TBL.insert((15, 15.5, 'D', 0.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((16, 16.5, 'D', 0.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((17, 16.5, 'D', 1.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((18, 15.5, 'D', 1.5));
*:lt_PAL_KMEANS_DATA_TBL.insert((19, 15.7, 'A', 1.6));



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
