CREATE OR REPLACE PACKAGE QWERTY.OASU IS

  -- Author  : BISHOP
  -- Created : 17.02.2016 13:11:43
  -- Purpose : ��������� �������� � ������ ���������� �������

  -- Public type declarations
  --type <TypeName> is <Datatype>;
  /**��� ������������ ������ ������� find_person
  %param ID_TAB ��������� �����
  %param FIO_RUS �.�.�. �� ������� �����
  %param FIO_UKR �.�.�. ���������� �����
  %param KOEFF ����������� ����������
  %param EXACT_FIT ���������� ������ ����������*/
  TYPE recFIND_PERSON_RESULT IS RECORD(
     ID_TAB    NUMBER(7) -- ���. �
    ,FIO_RUS   VARCHAR2(200) -- �.�.�. �� ������� �����
    ,FIO_UKR   VARCHAR2(200) -- �.�.�. �� ���������� �����
    ,KOEFF     NUMBER -- ����������� ����������
    ,EXACT_FIT NUMBER -- ���������� ������ ����������
    );
  /**��������� ���������� ������� find_person*/
  TYPE tFIND_PERSON_RESULT IS TABLE OF recFIND_PERSON_RESULT;

  /**��� ������������ ������ ������� find_person2
  %param ID_TAB ��������� �����
  %param FIO_RUS �.�.�. �� ������� �����
  %param FIO_UKR �.�.�. ���������� �����
  %param TOTAL_PERCENT c�������� ������� ����������
  %param WORK_STATUS ������ ���������*/
  TYPE recFIND_PERSON_RESULT2 IS RECORD(
     ID_TAB          NUMBER(7)
    ,FIO_RUS         VARCHAR2(200)
    ,FIO_UKR         VARCHAR2(200)
    ,TOTAL_PERCENT   NUMBER
    ,WORK_STATUS     NUMBER
    ,WORK_STATUS_TXT VARCHAR2(20));
  /**��������� ���������� ������� find_person2*/
  TYPE tFIND_PERSON_RESULT2 IS TABLE OF recFIND_PERSON_RESULT2;

  /**������� �� ��������*/
  TYPE OASU_OdciVarchar2List IS VARRAY(32767) OF VARCHAR2(4000);
  -- TYPE OASU_OdciNumberList IS varray(32767) of number;

  /**������� � ������*/
  TYPE OASU_OdciDateList IS VARRAY(32767) OF DATE;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

  /**�������� ������ �� ���������, ����������� �������� ������������*/
  FUNCTION split(i_str       IN VARCHAR2
                ,i_delimiter IN VARCHAR2 DEFAULT ',') RETURN OASU_OdciVarchar2List
    PIPELINED;
  FUNCTION split_by_char(i_str IN VARCHAR2) RETURN OASU_OdciVarchar2List
    PIPELINED;

  /**���������� �������� ���������� ������� �����, ������� � ������������� ��������
  %param i_num_of_rows ���������� �����, ������� ���������� ��������
  %param i_start_from  �������� � ������ ������, �� ��������� 1*/
  FUNCTION get_numbers(i_num_of_rows IN NUMBER
                      ,i_start_from  IN NUMBER DEFAULT 1) RETURN sys.odcinumberlist
    PIPELINED;

  /**���������� ������ ����� � �������� ��������� 
  %param i_from ����� ������ ������
  %param i_to   ����� ��������� ������*/
  FUNCTION get_numbers_from_to(i_from IN NUMBER
                              ,i_to   IN NUMBER) RETURN sys.odcinumberlist
    PIPELINED;

  /**���������� i_num_of_rows ���, ������� � i_start_from
  %param i_num_of_rows ���������� ����� � ������, ������� ���������� ��������
  %param i_start_from  �������� � ������ ������, �� ��������� sysdate*/
  FUNCTION get_dates(i_num_of_rows IN NUMBER
                    ,i_start_from  IN DATE DEFAULT SYSDATE) RETURN OASU_odcidatelist
    PIPELINED;

  /**���������� <b><i>i_num_of_rows</i></b> ���, ������� � <b><i>i_start_from</i></b> � ����� <b><i>i_step</i></b>
    %param i_num_of_rows ���������� ����� � ������, ������� ���������� ��������
    %param i_start_from  �������� � ������ ������, �� ��������� sysdate
    %param i_step        ��� ��������� ���� (��������� ��������: ��. Values)
    %value i_step ��� ��������� �������� ���� (<i>������� ��������� �������� �� �����!</i>):
                  {*}'����' 
                  {*}'DAY' <b>���� ����</b> (�� ���������)
                  {*}'������'
                  {*}'WEEK' ������
                  {*}'������'
                  {*}'DECADE' ������ (10 ����)
                  {*}'�����'
                  {*}'MONTH' �����
                  {*}'�������'
                  {*}'QUARTER' ������� (3 ������)
                  {*}'���'
                  {*}'YEAR' ���
    %return              OASU_odcidatelist (������� � ������)
    %usage SELECT * FROM TABLE(qwerty.oasu.get_dates2(15, SYSDATE, 'wEeK'))
  */
  FUNCTION get_dates2(i_num_of_rows IN NUMBER
                     ,i_start_from  IN DATE DEFAULT SYSDATE
                     ,i_step        IN VARCHAR2 DEFAULT '����') RETURN OASU_odcidatelist
    PIPELINED;
  /**���������� ����, ������� � <b><i>i_start</i></b> �� <b><i>i_finish</i></b> � ����� <b><i>i_step</i></b>
    %param i_FROM �������� � ������ ������
    %param i_TO   ���������� �������� ����
    %param i_STEP ��� ��������� ���� (��������� ��������: ��. Values)
    %value i_STEP ��� ��������� �������� ���� (<i>������� ��������� �������� �� �����!</i>):
                  {*}'����' 
                  {*}'DAY' <b>���� ����</b> (�� ���������)
                  {*}'������'
                  {*}'WEEK' ������
                  {*}'������'
                  {*}'DECADE' ������ (10 ����)
                  {*}'�����'
                  {*}'MONTH' �����
                  {*}'�������'
                  {*}'QUARTER' ������� (3 ������)
                  {*}'���'
                  {*}'YEAR' ���
    %return              OASU_odcidatelist (������� � ������)
    %usage SELECT * FROM TABLE(qwerty.oasu.get_dates_from_to(to_date('07.12.1998', SYSDATE, 'yEAr'))
  */
  FUNCTION get_dates_from_to(i_FROM IN DATE DEFAULT SYSDATE
                            ,i_TO   IN DATE DEFAULT SYSDATE
                            ,i_STEP IN VARCHAR2 DEFAULT '����') RETURN OASU_OdciDateList
    PIPELINED;

  /**���������� ����������� �������� ����������� �� �������� �����
  1 - ������� (�������� (������� �� �����): 1, �, ��, ���, �������, R, RU, RUS, RUSSIAN)
  2 - ���������� (2, �, ��, ���, ����������, U, UA, UKR, UKRAINIAN)
  3 - ���������� (3, �, ��, ���, ����������, E, EN, ENG, ENGLISH)
  %param i_language ������, e.g. '1', '2', '3', '�', '���', 'eng' etc.*/
  FUNCTION get_plant_name(i_language IN VARCHAR2) RETURN VARCHAR2;
  -- �������� ��������������� �������:
  /** %param i_language - �����, e.g. 1, 2, 3*/
  FUNCTION get_plant_name(i_language IN NUMBER) RETURN VARCHAR2;
  /** - �������� ����������� �� ������� �����*/
  FUNCTION get_plant_name_rus RETURN VARCHAR2;
  /** - �������� ����������� �� ���������� �����*/
  FUNCTION get_plant_name_ukr RETURN VARCHAR2;
  /** - �������� ����������� �� ���������� �����*/
  FUNCTION get_plant_name_eng RETURN VARCHAR2;

  /**����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ ��������
  update: �������� �������� find_person*/
  FUNCTION get_tab_by_fio(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED;
  /**����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ ��������
  %param i_fio ������ � ��������, ������, ��������� � ��������� ������� (� ����� �������), ������������ ���������*/
  FUNCTION find_person(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED;
  /**����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ �������� (������ �������)
  %param i_fio ������ � ��������, ������, ��������� � ��������� ������� (� ����� �������), ������������ ���������*/
  FUNCTION find_person2(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT2
    PIPELINED;

  /**���������� ��������� ����� ��������� �� �������� ���������� ������*/
  FUNCTION get_tab_by_passport(i_passport IN VARCHAR2) RETURN NUMBER;

  /**�������� ������� ������*/
  FUNCTION package_info RETURN OASU_OdciVarchar2List
    PIPELINED;

  /**������� ������������� �������� ������� ������
  %param i_FUNCTION_NAME - ��� �������, ��� ������� ���������� ������� �������������, e.g. 'package_info'*/
  FUNCTION package_examples(i_FUNCTION_NAME IN VARCHAR2) RETURN OASU_OdciVarchar2List
    PIPELINED;
END OASU;
/
CREATE OR REPLACE PACKAGE BODY QWERTY.OASU IS

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  /*
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;
  */

  FUNCTION split(i_str       IN VARCHAR2
                ,i_delimiter IN VARCHAR2 DEFAULT ',') RETURN OASU_OdciVarchar2List
    PIPELINED AS
    l_current_string VARCHAR2(4000) := i_str;
    l_current_value  VARCHAR2(4000) := '';
    l_pos            BINARY_INTEGER;
  BEGIN
    IF i_str IS NULL THEN
      RETURN;
    END IF;
    LOOP
      l_pos           := nullif(instr(l_current_string
                                     ,i_delimiter)
                               ,0);
      l_current_value := substr(l_current_string
                               ,1
                               ,nvl(l_pos - 1
                                   ,length(l_current_string)));
      IF NOT (l_current_value IS NULL) THEN
        PIPE ROW(l_current_value);
      END IF;
      EXIT WHEN l_pos IS NULL;
      l_current_string := substr(l_current_string
                                ,l_pos + length(i_delimiter));
    END LOOP;
  
    RETURN;
  END split;

  FUNCTION split_by_char(i_str IN VARCHAR2) RETURN OASU_OdciVarchar2List
    PIPELINED AS
    l_current_string VARCHAR2(4000) := i_str;
    l_current_value  VARCHAR2(4000) := '';
    l_pos            BINARY_INTEGER;
  BEGIN
    IF i_str IS NULL THEN
      RETURN;
    END IF;
    l_pos := 1;
    LOOP
      l_current_value := substr(l_current_string
                               ,l_pos
                               ,1);
      IF NOT (l_current_value IS NULL) THEN
        PIPE ROW(l_current_value);
      END IF;
      l_pos := l_pos + 1;
      EXIT WHEN l_pos > length(i_str);
    END LOOP;
  
    RETURN;
  END split_by_char;

  /**���������� �������� ���������� ������� �����, ������� � ������������� ��������
  %param i_num_of_rows - ���������� �����, ������� ���������� ��������
  %param i_start_from  - �������� � ������ ������, �� ��������� 1*/
  FUNCTION get_numbers(i_num_of_rows IN NUMBER
                      ,i_start_from  IN NUMBER DEFAULT 1) RETURN sys.odcinumberlist
    PIPELINED AS
  BEGIN
    FOR i IN (SELECT rownum + i_start_from - 1 cur_row
                FROM (SELECT NULL
                        FROM dual
                      CONNECT BY 1 = 1
                             AND PRIOR dbms_random.value IS NOT NULL)
               WHERE rownum <= i_num_of_rows)
    LOOP
      PIPE ROW(i.cur_row);
    END LOOP;
  
    RETURN;
  END get_numbers;

  /**���������� ������ ����� � �������� ��������� 
  %param i_from - ����� ������ ������
  %param i_to   - ����� ��������� ������*/
  FUNCTION get_numbers_from_to(i_from IN NUMBER
                              ,i_to   IN NUMBER) RETURN sys.odcinumberlist
    PIPELINED AS
  BEGIN
    IF i_to < i_from THEN
      RETURN;
    END IF;
  
    FOR i IN (SELECT rownum + i_from - 1 cur_row
                FROM (SELECT NULL
                        FROM dual
                      CONNECT BY 1 = 1
                             AND PRIOR dbms_random.value IS NOT NULL)
               WHERE rownum <= (i_to - i_from + 1))
    LOOP
      PIPE ROW(i.cur_row);
    END LOOP;
  
    RETURN;
  END get_numbers_from_to;

  FUNCTION get_dates(i_num_of_rows IN NUMBER
                    ,i_start_from  IN DATE DEFAULT SYSDATE) RETURN OASU_odcidatelist
    PIPELINED AS
  BEGIN
    /*SELECT add_months(sysdate + 24, -1 * rownum * 12) cur_date
     FROM (SELECT NULL
             FROM dual
           CONNECT BY 1 = 1
                  AND PRIOR dbms_random.value IS NOT NULL)
    WHERE rownum <= &i_to*/
  
    FOR i IN (SELECT i_start_from + (rownum - 1) cur_date
                FROM (SELECT NULL
                        FROM dual
                      CONNECT BY 1 = 1
                             AND PRIOR dbms_random.value IS NOT NULL)
               WHERE rownum <= i_num_of_rows)
    LOOP
      PIPE ROW(i.cur_date);
    END LOOP;
  
    RETURN;
  END get_dates;

  FUNCTION get_dates2(i_num_of_rows IN NUMBER
                     ,i_start_from  IN DATE DEFAULT SYSDATE
                     ,i_step        IN VARCHAR2 DEFAULT '����') RETURN OASU_odcidatelist
    PIPELINED AS
    vSTEP_NAME VARCHAR2(20);
    vSTEP      NUMBER;
  BEGIN
    vSTEP_NAME := UPPER(i_step);
  
    IF vSTEP_NAME IN ('�����'
                     ,'�������'
                     ,'���'
                     ,'MONTH'
                     ,'QUARTER'
                     ,'YEAR') THEN
      IF vSTEP_NAME = '�����' OR
         vSTEP_NAME = 'MONTH' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = '�������' OR
            vSTEP_NAME = 'QUARTER' THEN
        vSTEP := 3;
      ELSIF vSTEP_NAME = '���' OR
            vSTEP_NAME = 'YEAR' THEN
        vSTEP := 12;
      END IF;
    
      FOR i IN (SELECT add_months(i_start_from
                                 ,(rownum - 1) * vSTEP) cur_date
                  FROM (SELECT NULL
                          FROM dual
                        CONNECT BY 1 = 1
                               AND PRIOR dbms_random.value IS NOT NULL)
                 WHERE rownum <= i_num_of_rows)
      LOOP
        PIPE ROW(i.cur_date);
      END LOOP;
    ELSIF vSTEP_NAME IN ('����'
                        ,'DAY'
                        ,'������'
                        ,'WEEK'
                        ,'������'
                        ,'DECADE') THEN
      IF vSTEP_NAME = '����' OR
         vSTEP_NAME = 'DAY' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = '������' OR
            vSTEP_NAME = 'WEEK' THEN
        vSTEP := 7;
      ELSIF vSTEP_NAME = '������' OR
            vSTEP_NAME = 'DECADE' THEN
        vSTEP := 10;
      END IF;
    
      FOR i IN (SELECT i_start_from + (rownum - 1) * vSTEP cur_date
                  FROM (SELECT NULL
                          FROM dual
                        CONNECT BY 1 = 1
                               AND PRIOR dbms_random.value IS NOT NULL)
                 WHERE rownum <= i_num_of_rows)
      LOOP
        PIPE ROW(i.cur_date);
      END LOOP;
    ELSE
      PIPE ROW(i_start_from);
    END IF;
  
    RETURN;
  END get_dates2;

  FUNCTION get_dates_from_to(i_FROM IN DATE DEFAULT SYSDATE
                            ,i_TO   IN DATE DEFAULT SYSDATE
                            ,i_STEP IN VARCHAR2 DEFAULT '����') RETURN OASU_OdciDateList
    PIPELINED AS
    vSTEP_NAME VARCHAR2(20);
    vSTEP      NUMBER;
  BEGIN
    IF i_TO < i_FROM THEN
      RAISE_APPLICATION_ERROR(-20101
                             ,'���� ��������� ������� ������ ���� ������');
    END IF;
  
    vSTEP_NAME := UPPER(i_STEP);
  
    IF vSTEP_NAME IN ('�����'
                     ,'�������'
                     ,'���'
                     ,'MONTH'
                     ,'QUARTER'
                     ,'YEAR') THEN
      IF vSTEP_NAME = '�����' OR
         vSTEP_NAME = 'MONTH' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = '�������' OR
            vSTEP_NAME = 'QUARTER' THEN
        vSTEP := 3;
      ELSIF vSTEP_NAME = '���' OR
            vSTEP_NAME = 'YEAR' THEN
        vSTEP := 12;
      END IF;
    
      FOR i IN (SELECT add_months(i_FROM
                                 ,(rownum - 1) * vSTEP) cur_date
                  FROM (SELECT NULL
                          FROM dual
                        CONNECT BY 1 = 1
                               AND PRIOR dbms_random.value IS NOT NULL)
                 WHERE rownum <= TRUNC(months_between(i_TO
                                                     ,i_FROM) / vSTEP) + 1)
      LOOP
        PIPE ROW(i.cur_date);
      END LOOP;
    ELSIF vSTEP_NAME IN ('����'
                        ,'DAY'
                        ,'������'
                        ,'WEEK'
                        ,'������'
                        ,'DECADE') THEN
      IF vSTEP_NAME = '����' OR
         vSTEP_NAME = 'DAY' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = '������' OR
            vSTEP_NAME = 'WEEK' THEN
        vSTEP := 7;
      ELSIF vSTEP_NAME = '������' OR
            vSTEP_NAME = 'DECADE' THEN
        vSTEP := 10;
      END IF;
    
      FOR i IN (SELECT i_FROM + (rownum - 1) * vSTEP cur_date
                  FROM (SELECT NULL
                          FROM dual
                        CONNECT BY 1 = 1
                               AND PRIOR dbms_random.value IS NOT NULL)
                 WHERE rownum <= TRUNC((i_TO - i_FROM) / vSTEP) + 1)
      LOOP
        PIPE ROW(i.cur_date);
      END LOOP;
    ELSE
      PIPE ROW(i_FROM);
    END IF;
  
    RETURN;
  END get_dates_from_to;

  /**����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ ��������*/
  FUNCTION get_tab_by_fio(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED AS
    vROW recFIND_PERSON_RESULT;
  BEGIN
    vROW.ID_TAB    := -1;
    vROW.FIO_RUS   := '������ �������� ��������� FIND_PERSON � FIND_PERSON2';
    --NoFormat Start
    vROW.FIO_UKR   := '���������, ����������, ����� ������� �� e.g. ' || chr(13) ||
                      'select * from table(qwerty.oasu.find_person(''' || i_fio || '''))' || chr(13) || 
                      ' ��� ' || chr(13) || 
                      'select * from table(qwerty.oasu.find_person(''' || i_fio || '''))';
    --NoFormat End
    vROW.KOEFF     := 0;
    vROW.EXACT_FIT := 0;
    PIPE ROW(vROW);
  
    RETURN;
  END;

  FUNCTION find_person(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED AS
    vROW recFIND_PERSON_RESULT;
  BEGIN
    FOR i IN (SELECT DISTINCT id_tab
                             ,(COUNT(id_tab) over(PARTITION BY id_tab) + 10 * SUM(decode(lower(f.name_str)
                                                                                        ,lower(s.column_value)
                                                                                        ,1
                                                                                        ,0)) over(PARTITION BY id_tab)) * SUM(DISTINCT coefficient) over(PARTITION BY id_tab, value_type) koeff
                             ,SUM(decode(lower(f.name_str)
                                        ,lower(s.column_value)
                                        ,1
                                        ,0)) over(PARTITION BY id_tab) exact_fit
                             ,FIO
                             ,PIB
                FROM (SELECT id_tab
                            ,to_char(id_tab) name_str -- ��������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1 coefficient
                            ,1 value_type -- ��������� �����
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT id_tab
                            ,fam_u -- ������� �� ������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,2 -- �������
                        FROM qwerty.sp_rb_fio
                      UNION
                      SELECT id_tab
                            ,fam_r -- ������� �� ���������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,2 -- �������
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT id_tab
                            ,f_name_u -- ��� �� ������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,4 -- ���
                        FROM qwerty.sp_rb_fio
                      UNION
                      SELECT id_tab
                            ,f_name_r -- ��� �� ���������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,4 -- ���
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT id_tab
                            ,s_name_u -- �������� �� ������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,6 -- ��������
                        FROM qwerty.sp_rb_fio
                      UNION
                      SELECT id_tab
                            ,s_name_r -- �������� �� ���������� �����
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,6 -- ��������
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT DISTINCT o.id_tab
                                     ,o.fam_u -- ������ �������
                                     ,rbf.fam_u || ' (' || o.fam_u || ') ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                                     ,rbf.fam_r || ' (' || o.fam_u || ') ' || rbf.f_name_r || ' ' || rbf.s_name_r PIB
                                     ,0.5
                                     ,8 -- ������ �������
                        FROM qwerty.sp_ka_oldfio o
                            ,qwerty.sp_rb_fio    rbf
                       WHERE o.id_tab = rbf.id_tab) f
                    ,TABLE(qwerty.oasu.split(i_fio
                                            ,' ')) s
               WHERE translate(lower(f.name_str)
                              ,'�'''
                              ,'�') LIKE '%' || translate(lower(s.column_value)
                                                          ,'�'''
                                                          ,'�') || '%'
               ORDER BY 2 DESC
                       ,3 DESC
                       ,1)
    LOOP
      vROW.ID_TAB    := i.id_tab;
      vROW.FIO_RUS   := i.FIO;
      vROW.FIO_UKR   := i.PIB;
      vROW.KOEFF     := i.koeff;
      vROW.EXACT_FIT := i.exact_fit;
      PIPE ROW(vROW);
    END LOOP;
  
    RETURN;
  END find_person;

  /**����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ �������� (������ �������)
  %param i_fio ������ � ��������, ������, ��������� � ��������� ������� (� ����� �������), ������������ ���������*/
  FUNCTION find_person2(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT2
    PIPELINED AS
    vROW recFIND_PERSON_RESULT2;
  BEGIN
    FOR i IN (SELECT DISTINCT qry.id_tab
                             ,decode(max_value_type
                                    ,8
                                    ,rbf.fam_u || ' (' || oldfio.fam_u || ') ' || rbf.f_name_u || ' ' || rbf.s_name_u
                                    ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) fio
                             ,decode(max_value_type
                                    ,8
                                    ,rbf.fam_r || nvl2(oldfio.fam_r
                                                      ,' (' || oldfio.fam_r || ') '
                                                      ,'') || rbf.f_name_r || ' ' || rbf.s_name_u
                                    ,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r) pib
                             ,num_of_entries
                             ,num_of_values
                             ,total_percent
                             ,max_value_type
                              --������ (1-��������,2-������,3-�����������,4-����������,5-�����������,6-��������� �������,7-��������� ����,8-�������[�� ������������])
                             ,status
                             ,decode(status
                                    ,1
                                    ,'��������'
                                    ,2
                                    ,'������(-�)'
                                    ,3
                                    ,'�����������'
                                    ,4
                                    ,'����������'
                                    ,5
                                    ,'�����������(-��)'
                                    ,6
                                    ,'������� (�����)'
                                    ,7
                                    ,'��������� ����'
                                    ,8
                                    ,'������� (�� ���������)'
                                    ,'�� ��������') work_status
                FROM (SELECT DISTINCT id_tab
                                     ,COUNT(DISTINCT column_value) over(PARTITION BY id_tab) num_of_entries /*, sum(length(column_value)/length(name_str)) over (partition by id_tab)*/
                                     ,MAX(value_type) over(PARTITION BY id_tab) max_value_type
                                     ,COUNT(DISTINCT column_value) over() num_of_values
                                     ,SUM(procent) over(PARTITION BY id_tab) total_percent
                        FROM (SELECT DISTINCT id_tab
                                             ,koeff
                                             ,value_type
                                             ,column_value
                                             ,MAX(trunc(length(column_value) / length(name_str) * 100)) over(PARTITION BY id_tab, value_type) procent
                                FROM (SELECT id_tab
                                            ,to_char(id_tab) name_str -- ��������� �����
                                            ,1 koeff
                                            ,1 value_type -- ��������� �����
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,fam_u -- ������� �� ������� �����
                                            ,1.5
                                            ,2 -- �������
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,fam_r -- ������� �� ���������� �����
                                            ,1.5
                                            ,2 -- �������
                                        FROM qwerty.sp_rb_fio
                                      UNION ALL
                                      SELECT id_tab
                                            ,f_name_u -- ��� �� ������� �����
                                            ,1.5
                                            ,4 -- ���
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,f_name_r -- ��� �� ���������� �����
                                            ,1.5
                                            ,4 -- ���
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,s_name_u -- �������� �� ������� �����
                                            ,1.5
                                            ,6 -- ��������
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,s_name_r -- �������� �� ���������� �����
                                            ,1.5
                                            ,6 -- ��������
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT DISTINCT o.id_tab
                                                     ,o.fam_u -- ������ �������
                                                     ,0.5
                                                     ,8 -- ������ �������
                                        FROM qwerty.sp_ka_oldfio o
                                            ,qwerty.sp_rb_fio    rbf
                                       WHERE o.id_tab = rbf.id_tab) f
                                    ,TABLE(qwerty.oasu.split(i_fio
                                                            ,' ')) s
                               WHERE translate(lower(f.name_str)
                                              ,'�'''
                                              ,'�') LIKE '%' || translate(lower(s.column_value)
                                                                          ,'�'''
                                                                          ,'�') || '%')) qry
                    ,qwerty.sp_rb_fio rbf
                    ,qwerty.sp_ka_oldfio oldfio
               WHERE num_of_entries = num_of_values
                 AND qry.id_tab = rbf.id_tab
                 AND qry.id_tab = oldfio.id_tab(+)
               ORDER BY num_of_entries DESC
                        -- ������ (1-��������,2-������,3-�����������,4-����������,5-�����������,6-��������� �������,7-��������� ����,8-�������[�� ������������])
                       ,decode(status
                              ,1
                              ,1
                              ,2
                              ,4
                              ,3
                              ,3
                              ,4
                              ,4
                              ,5
                              ,7
                              ,6
                              ,8
                              ,7
                              ,5
                              ,8)
                       ,total_percent DESC
                       ,max_value_type)
    LOOP
      vROW.ID_TAB          := i.id_tab;
      vROW.FIO_RUS         := i.FIO;
      vROW.FIO_UKR         := i.PIB;
      vROW.TOTAL_PERCENT   := i.total_percent;
      vROW.WORK_STATUS     := i.status;
      vROW.WORK_STATUS_TXT := i.work_status;
      PIPE ROW(vROW);
    END LOOP;
  
    RETURN;
  END find_person2;

  /**
  ���������� ��� ����� �� ���������� ����������� �����
   %param i_language - ��������� ����������� �����, e.g. '1' - �������, '2' - ����������, '3' - ����������
  */
  FUNCTION get_language_id(i_language IN VARCHAR2) RETURN NUMBER AS
    vLANG_ID NUMBER;
  BEGIN
    CASE
      WHEN lower(i_language) IN ('1'
                                ,'�'
                                ,'��'
                                ,'���'
                                ,'�������'
                                ,'r'
                                ,'ru'
                                ,'rus'
                                ,'russian') THEN
        vLANG_ID := 1;
      WHEN lower(i_language) IN ('2'
                                ,'�'
                                ,'��'
                                ,'��'
                                ,'���'
                                ,'����������'
                                ,'u'
                                ,'ua'
                                ,'uk'
                                ,'ukr'
                                ,'ukrainian') THEN
        vLANG_ID := 2;
      WHEN lower(i_language) IN ('3'
                                ,'�'
                                ,'��'
                                ,'���'
                                ,'����������'
                                ,'e'
                                ,'en'
                                ,'eng'
                                ,'english') THEN
        vLANG_ID := 3;
      ELSE
        vLANG_ID := -1;
    END CASE;
  
    RETURN vLANG_ID;
  END get_language_id;

  /**
  ���������� �������� ��������� �� ��� ���� (i_requisite_id) �� �������� ����� (i_language)
   %param i_requisite_id - ��� ���������
   %param i_language     - ��� �����
  */
  FUNCTION get_requisite(i_requisite_id IN NUMBER
                        ,i_language     IN NUMBER) RETURN VARCHAR2 AS
    vCURSOR SYS_REFCURSOR;
    vSQL    VARCHAR2(500);
    vVALUE  VARCHAR2(1000);
  BEGIN
    vSQL := 'select value from qwerty.sp_requisites where id = ' || i_requisite_id || ' and id_lang = ' || i_language;
  
    OPEN vCURSOR FOR vSQL;
    FETCH vCURSOR
      INTO vVALUE;
    IF vVALUE IS NULL THEN
      vVALUE := '�������� � ����� ' || i_requisite_id || ' �� ����� ' || i_language || ' � ����������� �� ������';
    END IF;
    CLOSE vCURSOR;
  
    RETURN vVALUE;
  END get_requisite;

  FUNCTION get_plant_name(i_language IN VARCHAR2) RETURN VARCHAR2 AS
    vPLANT_NAME VARCHAR2(1000);
  BEGIN
    vPLANT_NAME := get_plant_name(get_language_id(i_language));
  
    RETURN vPLANT_NAME;
  END get_plant_name;

  FUNCTION get_plant_name(i_language IN NUMBER) RETURN VARCHAR2 AS
  BEGIN
    RETURN get_requisite(1
                        ,i_language);
  END get_plant_name;

  FUNCTION get_plant_name_rus RETURN VARCHAR2 AS
    vPLANT_NAME VARCHAR2(1000);
  BEGIN
    vPLANT_NAME := get_plant_name('1');
  
    RETURN vPLANT_NAME;
  END get_plant_name_rus;

  FUNCTION get_plant_name_ukr RETURN VARCHAR2 AS
    vPLANT_NAME VARCHAR2(1000);
  BEGIN
    vPLANT_NAME := get_plant_name('2');
  
    RETURN vPLANT_NAME;
  END get_plant_name_ukr;

  FUNCTION get_plant_name_eng RETURN VARCHAR2 AS
    vPLANT_NAME VARCHAR2(1000);
  BEGIN
    vPLANT_NAME := get_plant_name('3');
  
    RETURN vPLANT_NAME;
  END get_plant_name_eng;

  FUNCTION get_tab_by_passport(i_passport IN VARCHAR2) RETURN NUMBER AS
    CURSOR get_tab(p_passport VARCHAR2) IS
      SELECT id_tab
        FROM qwerty.sp_ka_pasport p
       WHERE translate(TRIM(upper(p.ser))
                      ,'ABCEHIKMOPTX'
                      ,'����Ͳ������') || p.numb LIKE
             upper((SELECT translate(p_seria
                                   ,'ABCEHIKMOPTX'
                                   ,'����Ͳ������') || TRIM(REPLACE(to_char(p_passport)
                                                                   ,p_seria
                                                                   ,''))
                   
                     FROM (SELECT to_char(p_passport)
                                 ,TRIM(substr(to_char(p_passport)
                                             ,1
                                             ,length(to_char(p_passport)) -
                                              (length(translate(REVERSE(REPLACE(to_char(p_passport)
                                                                               ,' '
                                                                               ,''))
                                                               ,'0123456789'
                                                               ,'          ')) - length(ltrim(translate(REVERSE(REPLACE(to_char(p_passport)
                                                                                                                       ,' '
                                                                                                                       ,''))
                                                                                                       ,'0123456789'
                                                                                                       ,'          ')))))) p_seria
                             FROM dual)));
    vTAB_ID NUMBER;
  BEGIN
    FOR i IN get_tab(i_passport)
    LOOP
      vTAB_ID := i.id_tab;
    END LOOP;
  
    RETURN vTAB_ID;
  END;

  FUNCTION package_info RETURN OASU_OdciVarchar2List
    PIPELINED AS
  BEGIN
    PIPE ROW('FIND_PERSON: ����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ �������� [pipelined]');
    PIPE ROW('FIND_PERSON2: ����� ����� �� ���������� ������, �.�.�., �.�.�. � ������ �������� (���������� �� FIND_PERSON �������� � ����� ����������) [pipelined]');
    PIPE ROW('GET_DATES: ���������� �������� ����� ����� � ������, ������� � ����������� ����');
    PIPE ROW('GET_DATES2: ���������� �������� ����� ����� � ������, ������� � ����������� ���� � �������� ����������� ����� ����');
    PIPE ROW('GET_NUMBERS: ���������� i_num_of_rows ����� � �������, ������� � i_start_from (�� ���������� - 1) [pipelined]');
    PIPE ROW('GET_NUMBERS_FROM_TO: ���������� ������� � ������� �� i_from �� i_to (� ����� 1) [pipelined]');
    -- NoFormat Start
    PIPE ROW('GET_PLANT_NAME: ���������� �������� ����������� �� �������� (�������� i_language) �����.' || CHR(13) || CHR(13) ||
             '�������� ��� ��������� i_language (������� ���� �� �����):' || CHR(13) || 
             ' ������� ����    - 1 (����� ��� ������), �, ��, ���, �������, R, RU, RUS, RUSSIAN' || CHR(13) ||
             ' ���������� ���� - 2 (����� ��� ������), �, ��, ��, ���, ����������, U, UA, UK, UKR, UKRAINIAN' || CHR(13) || 
             ' ���������� ���� - 3 (����� ��� ������), �, ��, ���, ����������, E, EN, ENG, ENGLISH');
    -- NoFormat End
    PIPE ROW('GET_PLANT_NAME_ENG: ���������� �������� ����������� �� ���������� �����');
    PIPE ROW('GET_PLANT_NAME_RUS: ���������� �������� ����������� �� ������� �����');
    PIPE ROW('GET_PLANT_NAME_UKR: ���������� �������� ����������� �� ���������� �����');
    PIPE ROW('GET_TAB_BY_FIO: �� ������������! ����� �����. �������� ��������� FIND_PERSON � FIND_PERSON2');
    PIPE ROW('GET_TAB_BY_PASSPORT: ���������� ��������� ����� ��������� �� �������� ���������� ������ (����� � �����)');
    PIPE ROW('SPLIT: ���������� ������� �� �������� �������� ������ (�������� - i_str), ����������� �������� ������������ (i_delimeter) [pipelined]');
    PIPE ROW('PACKAGE_INFO: �������� ������� ������ [pipelined]');
    PIPE ROW('PACKAGE_EXAMPLES: ������� ������ ��� �������� ���������� i_FUNCTION_NAME ������� ������ [pipelined]');
  
    RETURN;
  END package_info;

  FUNCTION package_examples(i_FUNCTION_NAME IN VARCHAR2) RETURN OASU_OdciVarchar2List
    PIPELINED AS
  BEGIN
    CASE LOWER(i_FUNCTION_NAME)
      WHEN 'split' THEN
      -- NoFormat Start
        PIPE ROW('SELECT INITCAP(column_value) as name, ' || chr(13) || 
                 '       LENGTH(column_value) as name_length' || chr(13) || 
                 '  FROM TABLE(qwerty.oasu.split(''paris,london,rome,madrid''))' || chr(13) || 
                 ' ORDER BY column_value');
      -- NoFormat End
      WHEN 'package_examples' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.package_examples(''split''))');
      WHEN 'package_info' THEN
        PIPE ROW('SELECT column_value FROM TABLE(qwerty.oasu.package_info)');
      WHEN 'get_plant_name' THEN
        PIPE ROW('SELECT qwerty.oasu.get_plant_name(''2'') FROM dual');
        PIPE ROW('SELECT qwerty.oasu.get_plant_name(3) FROM dual');
        PIPE ROW('SELECT qwerty.oasu.get_plant_name(''���'') FROM dual');
      WHEN 'get_plant_name_rus' THEN
        PIPE ROW('SELECT qwerty.oasu.get_plant_name_rus FROM dual');
      WHEN 'get_plant_name_ukr' THEN
        PIPE ROW('SELECT qwerty.oasu.get_plant_name_ukr FROM dual');
      WHEN 'get_plant_name_eng' THEN
        PIPE ROW('SELECT qwerty.oasu.get_plant_name_eng FROM dual');
      WHEN 'get_numbers' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.get_numbers(11));' || CHR(13) || 'SELECT * FROM TABLE(qwerty.oasu.get_numbers(11, 5))');
      WHEN 'get_numbers_from_to' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.get_numbers_from_to(11,36))');
      WHEN 'find_person' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.find_person(''75 ����''))');
      WHEN 'find_person2' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.find_person2(''75 ����''))');
      WHEN 'get_tab_by_fio' THEN
        PIPE ROW('�������������� ��������� FIND_PERSON ��� FIND_PERSON2 ������ ������� GET_TAB_BY_FIO');
      WHEN 'get_tab_by_passport' THEN
        PIPE ROW('SELECT qwerty.oasu.get_tab_by_passport(''�K 123456'') FROM dual');
      WHEN 'get_dates' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.get_dates(15, trunc(SYSDATE, ''YEAR'')))');
      WHEN 'get_dates2' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.get_dates2(15, trunc(SYSDATE, ''YEAR'', ''�������'')))');
      ELSE
        PIPE ROW('������� "' || UPPER(i_FUNCTION_NAME) || '" � ������ QWERTY.OASU �� ����������');
    END CASE;
  
    RETURN;
  END package_examples;

BEGIN
  -- Initialization
  --<Statement>;
  NULL;
END OASU;
/
