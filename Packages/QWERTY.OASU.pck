CREATE OR REPLACE PACKAGE QWERTY.OASU IS

  -- Author  : BISHOP
  -- Created : 17.02.2016 13:11:43
  -- Purpose : Различные полезные и просто интересные функции

  -- Public type declarations
  --type <TypeName> is <Datatype>;
  /**Тип возвращаемой записи функции find_person
  %param ID_TAB табельный номер
  %param FIO_RUS Ф.И.О. на русском языке
  %param FIO_UKR П.І.Б. українскьою мовою
  %param KOEFF коэффициент совпадения
  %param EXACT_FIT количество точных совпадений*/
  TYPE recFIND_PERSON_RESULT IS RECORD(
     ID_TAB    NUMBER(7) -- Таб. №
    ,FIO_RUS   VARCHAR2(200) -- Ф.И.О. на русском языке
    ,FIO_UKR   VARCHAR2(200) -- Ф.И.О. на украинском языке
    ,KOEFF     NUMBER -- Коэффициент совпадения
    ,EXACT_FIT NUMBER -- Количество точных совпадений
    );
  /**Результат выполнения функции find_person*/
  TYPE tFIND_PERSON_RESULT IS TABLE OF recFIND_PERSON_RESULT;

  /**Тип возвращаемой записи функции find_person2
  %param ID_TAB табельный номер
  %param FIO_RUS Ф.И.О. на русском языке
  %param FIO_UKR П.І.Б. українскьою мовою
  %param TOTAL_PERCENT cуммарный процент совпадений
  %param WORK_STATUS статус работника*/
  TYPE recFIND_PERSON_RESULT2 IS RECORD(
     ID_TAB          NUMBER(7)
    ,FIO_RUS         VARCHAR2(200)
    ,FIO_UKR         VARCHAR2(200)
    ,TOTAL_PERCENT   NUMBER
    ,WORK_STATUS     NUMBER
    ,WORK_STATUS_TXT VARCHAR2(20));
  /**Результат выполнения функции find_person2*/
  TYPE tFIND_PERSON_RESULT2 IS TABLE OF recFIND_PERSON_RESULT2;

  /**Таблица со строками*/
  TYPE OASU_OdciVarchar2List IS VARRAY(32767) OF VARCHAR2(4000);
  -- TYPE OASU_OdciNumberList IS varray(32767) of number;

  /**Таблица с датами*/
  TYPE OASU_OdciDateList IS VARRAY(32767) OF DATE;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

  /**Разбивка строки на подстроки, разделенные заданным разделителем*/
  FUNCTION split(i_str       IN VARCHAR2
                ,i_delimiter IN VARCHAR2 DEFAULT ',') RETURN OASU_OdciVarchar2List
    PIPELINED;
  FUNCTION split_by_char(i_str IN VARCHAR2) RETURN OASU_OdciVarchar2List
    PIPELINED;

  /**Возвращает заданное количество номеров строк, начиная с определенного значения
  %param i_num_of_rows количество строк, которое необходимо получить
  %param i_start_from  значение в первой строке, по умолчанию 1*/
  FUNCTION get_numbers(i_num_of_rows IN NUMBER
                      ,i_start_from  IN NUMBER DEFAULT 1) RETURN sys.odcinumberlist
    PIPELINED;

  /**Возвращает номера строк в заданном диапазоне 
  %param i_from номер первой строки
  %param i_to   номер последней строки*/
  FUNCTION get_numbers_from_to(i_from IN NUMBER
                              ,i_to   IN NUMBER) RETURN sys.odcinumberlist
    PIPELINED;

  /**Возвращает i_num_of_rows дат, начиная с i_start_from
  %param i_num_of_rows количество строк с датами, которое необходимо получить
  %param i_start_from  значение в первой строке, по умолчанию sysdate*/
  FUNCTION get_dates(i_num_of_rows IN NUMBER
                    ,i_start_from  IN DATE DEFAULT SYSDATE) RETURN OASU_odcidatelist
    PIPELINED;

  /**Возвращает <b><i>i_num_of_rows</i></b> дат, начиная с <b><i>i_start_from</i></b> с шагом <b><i>i_step</i></b>
    %param i_num_of_rows количество строк с датами, которое необходимо получить
    %param i_start_from  значение в первой строке, по умолчанию sysdate
    %param i_step        шаг изменения даты (возможные значения: см. Values)
    %value i_step шаг изменения значений даты (<i>регистр написания значения НЕ ВАЖЕН!</i>):
                  {*}'ДЕНЬ' 
                  {*}'DAY' <b>один день</b> (по умолчанию)
                  {*}'НЕДЕЛЯ'
                  {*}'WEEK' неделя
                  {*}'ДЕКАДА'
                  {*}'DECADE' декада (10 дней)
                  {*}'МЕСЯЦ'
                  {*}'MONTH' месяц
                  {*}'КВАРТАЛ'
                  {*}'QUARTER' квартал (3 месяца)
                  {*}'ГОД'
                  {*}'YEAR' год
    %return              OASU_odcidatelist (таблица с датами)
    %usage SELECT * FROM TABLE(qwerty.oasu.get_dates2(15, SYSDATE, 'wEeK'))
  */
  FUNCTION get_dates2(i_num_of_rows IN NUMBER
                     ,i_start_from  IN DATE DEFAULT SYSDATE
                     ,i_step        IN VARCHAR2 DEFAULT 'ДЕНЬ') RETURN OASU_odcidatelist
    PIPELINED;
  /**Возвращает даты, начиная с <b><i>i_start</i></b> по <b><i>i_finish</i></b> с шагом <b><i>i_step</i></b>
    %param i_FROM значение в первой строке
    %param i_TO   предельное значение даты
    %param i_STEP шаг изменения даты (возможные значения: см. Values)
    %value i_STEP шаг изменения значений даты (<i>регистр написания значения НЕ ВАЖЕН!</i>):
                  {*}'ДЕНЬ' 
                  {*}'DAY' <b>один день</b> (по умолчанию)
                  {*}'НЕДЕЛЯ'
                  {*}'WEEK' неделя
                  {*}'ДЕКАДА'
                  {*}'DECADE' декада (10 дней)
                  {*}'МЕСЯЦ'
                  {*}'MONTH' месяц
                  {*}'КВАРТАЛ'
                  {*}'QUARTER' квартал (3 месяца)
                  {*}'ГОД'
                  {*}'YEAR' год
    %return              OASU_odcidatelist (таблица с датами)
    %usage SELECT * FROM TABLE(qwerty.oasu.get_dates_from_to(to_date('07.12.1998', SYSDATE, 'yEAr'))
  */
  FUNCTION get_dates_from_to(i_FROM IN DATE DEFAULT SYSDATE
                            ,i_TO   IN DATE DEFAULT SYSDATE
                            ,i_STEP IN VARCHAR2 DEFAULT 'ДЕНЬ') RETURN OASU_OdciDateList
    PIPELINED;

  /**Возвращает официальное название предприятия на заданном языке
  1 - русский (варианты (регистр НЕ важен): 1, Р, РУ, РУС, РУССКИЙ, R, RU, RUS, RUSSIAN)
  2 - украинский (2, У, УА, УКР, УКРАИНСКИЙ, U, UA, UKR, UKRAINIAN)
  3 - английский (3, А, АН, АНГ, АНГЛИЙСКИЙ, E, EN, ENG, ENGLISH)
  %param i_language строка, e.g. '1', '2', '3', 'р', 'укр', 'eng' etc.*/
  FUNCTION get_plant_name(i_language IN VARCHAR2) RETURN VARCHAR2;
  -- Варианты вышеприведенной функции:
  /** %param i_language - число, e.g. 1, 2, 3*/
  FUNCTION get_plant_name(i_language IN NUMBER) RETURN VARCHAR2;
  /** - название предприятия на русском языке*/
  FUNCTION get_plant_name_rus RETURN VARCHAR2;
  /** - название предприятия на украинском языке*/
  FUNCTION get_plant_name_ukr RETURN VARCHAR2;
  /** - название предприятия на английском языке*/
  FUNCTION get_plant_name_eng RETURN VARCHAR2;

  /**Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям
  update: заменена функцией find_person*/
  FUNCTION get_tab_by_fio(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED;
  /**Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям
  %param i_fio строка с фамилией, именем, отчеством и табельным номером (в любом порядке), разделенными пробелами*/
  FUNCTION find_person(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED;
  /**Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям (второй вариант)
  %param i_fio строка с фамилией, именем, отчеством и табельным номером (в любом порядке), разделенными пробелами*/
  FUNCTION find_person2(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT2
    PIPELINED;

  /**Возвращает табельный номер работника по заданным паспортным данным*/
  FUNCTION get_tab_by_passport(i_passport IN VARCHAR2) RETURN NUMBER;

  /**Перечень функций пакета*/
  FUNCTION package_info RETURN OASU_OdciVarchar2List
    PIPELINED;

  /**Примеры использования заданной функции пакета
  %param i_FUNCTION_NAME - имя функции, для которой выбираются примеры использования, e.g. 'package_info'*/
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

  /**Возвращает заданное количество номеров строк, начиная с определенного значения
  %param i_num_of_rows - количество строк, которое необходимо получить
  %param i_start_from  - значение в первой строке, по умолчанию 1*/
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

  /**Возвращает номера строк в заданном диапазоне 
  %param i_from - номер первой строки
  %param i_to   - номер последней строки*/
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
                     ,i_step        IN VARCHAR2 DEFAULT 'ДЕНЬ') RETURN OASU_odcidatelist
    PIPELINED AS
    vSTEP_NAME VARCHAR2(20);
    vSTEP      NUMBER;
  BEGIN
    vSTEP_NAME := UPPER(i_step);
  
    IF vSTEP_NAME IN ('МЕСЯЦ'
                     ,'КВАРТАЛ'
                     ,'ГОД'
                     ,'MONTH'
                     ,'QUARTER'
                     ,'YEAR') THEN
      IF vSTEP_NAME = 'МЕСЯЦ' OR
         vSTEP_NAME = 'MONTH' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = 'КВАРТАЛ' OR
            vSTEP_NAME = 'QUARTER' THEN
        vSTEP := 3;
      ELSIF vSTEP_NAME = 'ГОД' OR
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
    ELSIF vSTEP_NAME IN ('ДЕНЬ'
                        ,'DAY'
                        ,'НЕДЕЛЯ'
                        ,'WEEK'
                        ,'ДЕКАДА'
                        ,'DECADE') THEN
      IF vSTEP_NAME = 'ДЕНЬ' OR
         vSTEP_NAME = 'DAY' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = 'НЕДЕЛЯ' OR
            vSTEP_NAME = 'WEEK' THEN
        vSTEP := 7;
      ELSIF vSTEP_NAME = 'ДЕКАДА' OR
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
                            ,i_STEP IN VARCHAR2 DEFAULT 'ДЕНЬ') RETURN OASU_OdciDateList
    PIPELINED AS
    vSTEP_NAME VARCHAR2(20);
    vSTEP      NUMBER;
  BEGIN
    IF i_TO < i_FROM THEN
      RAISE_APPLICATION_ERROR(-20101
                             ,'Дата окончания периода меньше даты начала');
    END IF;
  
    vSTEP_NAME := UPPER(i_STEP);
  
    IF vSTEP_NAME IN ('МЕСЯЦ'
                     ,'КВАРТАЛ'
                     ,'ГОД'
                     ,'MONTH'
                     ,'QUARTER'
                     ,'YEAR') THEN
      IF vSTEP_NAME = 'МЕСЯЦ' OR
         vSTEP_NAME = 'MONTH' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = 'КВАРТАЛ' OR
            vSTEP_NAME = 'QUARTER' THEN
        vSTEP := 3;
      ELSIF vSTEP_NAME = 'ГОД' OR
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
    ELSIF vSTEP_NAME IN ('ДЕНЬ'
                        ,'DAY'
                        ,'НЕДЕЛЯ'
                        ,'WEEK'
                        ,'ДЕКАДА'
                        ,'DECADE') THEN
      IF vSTEP_NAME = 'ДЕНЬ' OR
         vSTEP_NAME = 'DAY' THEN
        vSTEP := 1;
      ELSIF vSTEP_NAME = 'НЕДЕЛЯ' OR
            vSTEP_NAME = 'WEEK' THEN
        vSTEP := 7;
      ELSIF vSTEP_NAME = 'ДЕКАДА' OR
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

  /**Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям*/
  FUNCTION get_tab_by_fio(i_fio IN VARCHAR2) RETURN tFIND_PERSON_RESULT
    PIPELINED AS
    vROW recFIND_PERSON_RESULT;
  BEGIN
    vROW.ID_TAB    := -1;
    vROW.FIO_RUS   := 'Данная заменена функциями FIND_PERSON и FIND_PERSON2';
    --NoFormat Start
    vROW.FIO_UKR   := 'Исправьте, пожалуйста, вызов функции на e.g. ' || chr(13) ||
                      'select * from table(qwerty.oasu.find_person(''' || i_fio || '''))' || chr(13) || 
                      ' или ' || chr(13) || 
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
                            ,to_char(id_tab) name_str -- Табельный номер
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1 coefficient
                            ,1 value_type -- Табельный номер
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT id_tab
                            ,fam_u -- Фамилия на русской языке
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,2 -- Фамилия
                        FROM qwerty.sp_rb_fio
                      UNION
                      SELECT id_tab
                            ,fam_r -- Фамилия на украинском языке
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,2 -- Фамилия
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT id_tab
                            ,f_name_u -- Имя на русском языке
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,4 -- Имя
                        FROM qwerty.sp_rb_fio
                      UNION
                      SELECT id_tab
                            ,f_name_r -- Имя на украинском языке
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,4 -- Имя
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT id_tab
                            ,s_name_u -- Отчество на русском языке
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,6 -- Отчество
                        FROM qwerty.sp_rb_fio
                      UNION
                      SELECT id_tab
                            ,s_name_r -- Отчество на украинском языке
                            ,fam_u || ' ' || f_name_u || ' ' || s_name_u FIO
                            ,fam_r || ' ' || f_name_r || ' ' || s_name_r PIB
                            ,1.5
                            ,6 -- Отчество
                        FROM qwerty.sp_rb_fio
                      UNION ALL
                      SELECT DISTINCT o.id_tab
                                     ,o.fam_u -- Старая фамилия
                                     ,rbf.fam_u || ' (' || o.fam_u || ') ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                                     ,rbf.fam_r || ' (' || o.fam_u || ') ' || rbf.f_name_r || ' ' || rbf.s_name_r PIB
                                     ,0.5
                                     ,8 -- Старая фамилия
                        FROM qwerty.sp_ka_oldfio o
                            ,qwerty.sp_rb_fio    rbf
                       WHERE o.id_tab = rbf.id_tab) f
                    ,TABLE(qwerty.oasu.split(i_fio
                                            ,' ')) s
               WHERE translate(lower(f.name_str)
                              ,'ё'''
                              ,'е’') LIKE '%' || translate(lower(s.column_value)
                                                          ,'ё'''
                                                          ,'е’') || '%'
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

  /**Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям (второй вариант)
  %param i_fio строка с фамилией, именем, отчеством и табельным номером (в любом порядке), разделенными пробелами*/
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
                              --Статус (1-работает,2-уволен,3-принимается,4-договорник,5-незаводской,6-удаленный двойник,7-пенсионер ВОХР,8-двойник[не исправленный])
                             ,status
                             ,decode(status
                                    ,1
                                    ,'работает'
                                    ,2
                                    ,'уволен(-а)'
                                    ,3
                                    ,'принимается'
                                    ,4
                                    ,'договорник'
                                    ,5
                                    ,'незаводской(-ая)'
                                    ,6
                                    ,'двойник (удалён)'
                                    ,7
                                    ,'пенсионер ВОХР'
                                    ,8
                                    ,'двойник (не исправлен)'
                                    ,'не известно') work_status
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
                                            ,to_char(id_tab) name_str -- Табельный номер
                                            ,1 koeff
                                            ,1 value_type -- Табельный номер
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,fam_u -- Фамилия на русской языке
                                            ,1.5
                                            ,2 -- Фамилия
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,fam_r -- Фамилия на украинском языке
                                            ,1.5
                                            ,2 -- Фамилия
                                        FROM qwerty.sp_rb_fio
                                      UNION ALL
                                      SELECT id_tab
                                            ,f_name_u -- Имя на русском языке
                                            ,1.5
                                            ,4 -- Имя
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,f_name_r -- Имя на украинском языке
                                            ,1.5
                                            ,4 -- Имя
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,s_name_u -- Отчество на русском языке
                                            ,1.5
                                            ,6 -- Отчество
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT id_tab
                                            ,s_name_r -- Отчество на украинском языке
                                            ,1.5
                                            ,6 -- Отчество
                                        FROM qwerty.sp_rb_fio
                                      UNION
                                      SELECT DISTINCT o.id_tab
                                                     ,o.fam_u -- Старая фамилия
                                                     ,0.5
                                                     ,8 -- Старая фамилия
                                        FROM qwerty.sp_ka_oldfio o
                                            ,qwerty.sp_rb_fio    rbf
                                       WHERE o.id_tab = rbf.id_tab) f
                                    ,TABLE(qwerty.oasu.split(i_fio
                                                            ,' ')) s
                               WHERE translate(lower(f.name_str)
                                              ,'ё'''
                                              ,'е’') LIKE '%' || translate(lower(s.column_value)
                                                                          ,'ё'''
                                                                          ,'е’') || '%')) qry
                    ,qwerty.sp_rb_fio rbf
                    ,qwerty.sp_ka_oldfio oldfio
               WHERE num_of_entries = num_of_values
                 AND qry.id_tab = rbf.id_tab
                 AND qry.id_tab = oldfio.id_tab(+)
               ORDER BY num_of_entries DESC
                        -- Статус (1-работает,2-уволен,3-принимается,4-договорник,5-незаводской,6-удаленный двойник,7-пенсионер ВОХР,8-двойник[не исправленный])
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
  Возвращает код языка по текстовому обозначению языка
   %param i_language - текстовое обозначение языка, e.g. '1' - русский, '2' - украинский, '3' - английский
  */
  FUNCTION get_language_id(i_language IN VARCHAR2) RETURN NUMBER AS
    vLANG_ID NUMBER;
  BEGIN
    CASE
      WHEN lower(i_language) IN ('1'
                                ,'р'
                                ,'ру'
                                ,'рус'
                                ,'русский'
                                ,'r'
                                ,'ru'
                                ,'rus'
                                ,'russian') THEN
        vLANG_ID := 1;
      WHEN lower(i_language) IN ('2'
                                ,'у'
                                ,'уа'
                                ,'ук'
                                ,'укр'
                                ,'украинский'
                                ,'u'
                                ,'ua'
                                ,'uk'
                                ,'ukr'
                                ,'ukrainian') THEN
        vLANG_ID := 2;
      WHEN lower(i_language) IN ('3'
                                ,'а'
                                ,'ан'
                                ,'анг'
                                ,'английский'
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
  Возвращает значение реквизита по его коду (i_requisite_id) на заданном языке (i_language)
   %param i_requisite_id - код реквизита
   %param i_language     - код языка
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
      vVALUE := 'реквизит с кодом ' || i_requisite_id || ' на языке ' || i_language || ' в справочнике не найден';
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
                      ,'АВСЕНІКМОРТХ') || p.numb LIKE
             upper((SELECT translate(p_seria
                                   ,'ABCEHIKMOPTX'
                                   ,'АВСЕНІКМОРТХ') || TRIM(REPLACE(to_char(p_passport)
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
    PIPE ROW('FIND_PERSON: Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям [pipelined]');
    PIPE ROW('FIND_PERSON2: Поиск людей по табельному номеру, Ф.И.О., П.І.Б. и старым фамилиям (отличается от FIND_PERSON запросом и видом результата) [pipelined]');
    PIPE ROW('GET_DATES: Возвращает заданное число строк с датами, начиная с определённой даты');
    PIPE ROW('GET_DATES2: Возвращает заданное число строк с датами, начиная с определённой даты и заданным промежутком между ними');
    PIPE ROW('GET_NUMBERS: Возвращает i_num_of_rows строк с числами, начиная с i_start_from (по умолачанию - 1) [pipelined]');
    PIPE ROW('GET_NUMBERS_FROM_TO: Возвращает колонку с числами от i_from до i_to (с шагом 1) [pipelined]');
    -- NoFormat Start
    PIPE ROW('GET_PLANT_NAME: Возвращает название предприятия на заданном (параметр i_language) языке.' || CHR(13) || CHR(13) ||
             'Варианты для параметра i_language (регистр букв не важен):' || CHR(13) || 
             ' русский язык    - 1 (число или символ), Р, РУ, РУС, РУССКИЙ, R, RU, RUS, RUSSIAN' || CHR(13) ||
             ' украинский язык - 2 (число или символ), У, УА, УК, УКР, УКРАИНСКИЙ, U, UA, UK, UKR, UKRAINIAN' || CHR(13) || 
             ' английский язык - 3 (число или символ), А, АН, АНГ, АНГЛИЙСКИЙ, E, EN, ENG, ENGLISH');
    -- NoFormat End
    PIPE ROW('GET_PLANT_NAME_ENG: Возвращает название предприятия на английском языке');
    PIPE ROW('GET_PLANT_NAME_RUS: Возвращает название предприятия на русском языке');
    PIPE ROW('GET_PLANT_NAME_UKR: Возвращает название предприятия на украинском языке');
    PIPE ROW('GET_TAB_BY_FIO: НЕ ИСПОЛЬЗУЕТСЯ! Поиск людей. ЗАМЕНЕНА функциями FIND_PERSON и FIND_PERSON2');
    PIPE ROW('GET_TAB_BY_PASSPORT: Возвращает табельный номер работника по заданным паспортным данным (серия и номер)');
    PIPE ROW('SPLIT: Возвращает колонку из подстрок заданной строки (параметр - i_str), разделенных заданным разделителем (i_delimeter) [pipelined]');
    PIPE ROW('PACKAGE_INFO: Описание функций пакета [pipelined]');
    PIPE ROW('PACKAGE_EXAMPLES: Примеры вызова для заданной параметром i_FUNCTION_NAME функции пакета [pipelined]');
  
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
        PIPE ROW('SELECT qwerty.oasu.get_plant_name(''укр'') FROM dual');
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
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.find_person(''75 ната''))');
      WHEN 'find_person2' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.find_person2(''75 ната''))');
      WHEN 'get_tab_by_fio' THEN
        PIPE ROW('Воспользуйтесь функциями FIND_PERSON или FIND_PERSON2 вместо функции GET_TAB_BY_FIO');
      WHEN 'get_tab_by_passport' THEN
        PIPE ROW('SELECT qwerty.oasu.get_tab_by_passport(''КK 123456'') FROM dual');
      WHEN 'get_dates' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.get_dates(15, trunc(SYSDATE, ''YEAR'')))');
      WHEN 'get_dates2' THEN
        PIPE ROW('SELECT * FROM TABLE(qwerty.oasu.get_dates2(15, trunc(SYSDATE, ''YEAR'', ''КВАРТАЛ'')))');
      ELSE
        PIPE ROW('Функция "' || UPPER(i_FUNCTION_NAME) || '" в пакете QWERTY.OASU не определена');
    END CASE;
  
    RETURN;
  END package_examples;

BEGIN
  -- Initialization
  --<Statement>;
  NULL;
END OASU;
/
