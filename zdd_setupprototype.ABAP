*&---------------------------------------------------------------------*
*& Report zdd_setupprototype
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdd_setupprototype.


TABLES sscrfields.

SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.

  DATA: lv_arbpl    TYPE rc68a-arbpl,
        lv_plant    TYPE werks_d,
        lv_hierachy TYPE rc68h-hname.
  SELECT-OPTIONS s_werk  FOR lv_plant.
  SELECT-OPTIONS s_hier  FOR lv_hierachy.
  SELECT-OPTIONS s_arbpl FOR lv_arbpl.



  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: r1 RADIOBUTTON GROUP rad1. "
    SELECTION-SCREEN COMMENT (50) radtext1 FOR FIELD r1.
  SELECTION-SCREEN END OF LINE.


  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: r2 RADIOBUTTON GROUP rad1 DEFAULT 'X'. "newest
    SELECTION-SCREEN COMMENT (50) radtext2 FOR FIELD r2.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF SCREEN 100.








SELECTION-SCREEN BEGIN OF SCREEN 200 AS SUBSCREEN.
  PARAMETERS: classt TYPE ausp-klart,
              class  TYPE rmclm-class,
              char   TYPE atnam MATCHCODE OBJECT merk.




SELECTION-SCREEN END OF SCREEN 200.

SELECTION-SCREEN BEGIN OF SCREEN 300 AS SUBSCREEN.
  PARAMETERS: t1 TYPE c LENGTH 10,
              t2 TYPE c LENGTH 10,
              t3 TYPE c LENGTH 10.
SELECTION-SCREEN END OF SCREEN 300.

SELECTION-SCREEN BEGIN OF SCREEN 400 AS SUBSCREEN.
  PARAMETERS: s1 TYPE c LENGTH 10,
              s2 TYPE c LENGTH 10,
              s3 TYPE c LENGTH 10.
SELECTION-SCREEN END OF SCREEN 400.

SELECTION-SCREEN: BEGIN OF TABBED BLOCK mytab FOR 10 LINES,
TAB (20) button1 USER-COMMAND push1,
TAB (20) button2 USER-COMMAND push2,
TAB (20) button3 USER-COMMAND push3,
TAB (20) button4 USER-COMMAND push4,
END OF BLOCK mytab.

INITIALIZATION.

  button1 = 'SELECT Resources'.
  button2 = 'SELECT Characteristic'.
  button3 = 'DEFINE Generation Rules'.
  button4 = 'GENERATE Setup-Matrix'.


  radtext1 = 'Apply to workplace group'.
  radtext2 = 'Apply only to selected workplaces'.






  mytab-prog = sy-repid.
  mytab-dynnr = 100.
  mytab-activetab = 'PUSH1'.

AT SELECTION-SCREEN.
  CASE sy-dynnr.
    WHEN 1000.
      CASE sscrfields-ucomm.
        WHEN 'PUSH1'.
          mytab-dynnr = 100.
        WHEN 'PUSH2'.
          mytab-dynnr = 200.
        WHEN 'PUSH3'.
          mytab-dynnr = 300.
        WHEN OTHERS.
          ...
      ENDCASE.
      ...
  ENDCASE.
