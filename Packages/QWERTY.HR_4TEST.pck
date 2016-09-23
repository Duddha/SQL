CREATE OR REPLACE PACKAGE QWERTY.HR_4TEST IS

  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  --  Необходимость создания данного пакета возникла, когда было обнаружено, что из-за моих экспериментов с пакетом QWERTY.HR
  --  приостановилась работа проходной: Олег Кундиев обращается к пакету каждый раз, когда работник прикладывает пропуск к считывателю,
  --  я, изменяя пакет, могу на время сделать его неvalidным, тем самым внося сбой в работу программы, обслуживающей проходную.
  --  Принял решение сделать копию пакета QWERTY.HR, в которой буду тестировать новые функции, а после успешного завершения
  --  тестирования буду внедрять их в основной пакет QWERTY.HR
  --   Владимир Дуда, 04.07.2014
  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  -- Author : BISHOP
  -- Created : 25.02.2010 8:25:20
  -- Purpose : Пакет для работы с данными по кадрам

  -- Public type declarations
  --type is ;

  -- Public constant declarations
  -- constant := ;

  -- Public variable declarations
  -- ;

  -- Public function and procedure declarations
  --function ( ) return ;

  FUNCTION GET_CITY_NAME(pCITY_ID    NUMBER
                        ,pLANG       NUMBER
                        ,pSHORT_LONG NUMBER) RETURN VARCHAR2;
  -- pLANG:
  --   1               - русский язык,
  --   другое значение - украинский язык
  -- pSHORT_LONG:
  --   1 - урезанный вариант названия города

  FUNCTION GET_CITY_NAME_NOCOUNTRY(pCITY_ID    NUMBER
                                  ,pLANG       NUMBER
                                  ,pSHORT_LONG NUMBER) RETURN VARCHAR2;
  -- pLANG:
  --   1               - русский язык,
  --   другое значение - украинский язык
  -- pSHORT_LONG:
  --   1 - урезанный вариант названия города

  FUNCTION GET_EMPLOYEE_PASSPORT(pTAB_ID     NUMBER
                                ,pLANG       NUMBER
                                ,pSHORT_LONG NUMBER) RETURN VARCHAR2;
  -- pLANG:
  --   1               - русский язык,
  --   другое значение - украинский язык
  -- pSHORT_LONG:
  --   1 - урезанный вариант названия города

  FUNCTION GET_EMPLOYEE_ADDRESS(pTAB_ID     NUMBER
                               ,pLANG       NUMBER
                               ,pSHORT_LONG NUMBER) RETURN VARCHAR2;
  -- pLANG:
  --   1               - русский язык,
  --   другое значение - украинский язык
  -- pSHORT_LONG:
  --   1 - урезанный вариант, для Южного и Одессы

  FUNCTION GET_EMPLOYEE_ADDRESS_BY_FL(pTAB_ID     NUMBER
                                     ,pLANG       NUMBER DEFAULT 1
                                     ,pSHORT_LONG NUMBER DEFAULT 1
                                     ,pFL         NUMBER DEFAULT -1
                                     ,pINDEX      NUMBER DEFAULT -1) RETURN VARCHAR2;
  -- pLANG:
  --   1               - русский язык,
  --   другое значение - украинский язык
  --
  -- SHORT_LONG:
  --   1 - урезанный вариант, для Южного и Одессы
  -- pFL - флаг из SP_KA_ADRES:
  --  pFL=-1 выбираются все адреса
  --  pFL=12 выбирается фактическое место проживания, если такового нет, то берется адрес из паспорта
  -- pINDEX - порядковый номер адреса

  FUNCTION KADR_UVOL_STAT(pTAB_ID    NUMBER
                         ,pUVOL_ID   NUMBER
                         ,pUVOL_DATE DATE
                         ,pZAP_DATE  DATE
                         ,pPRIKAZ_ID VARCHAR2) RETURN BOOLEAN;
  -- НЕ ДОДЕЛАНО!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!                          
  -- pTAB_ID - табельный номер увольняемого работника,
  -- pUVOL_ID - код вида увольнения,
  -- pUVOL_DATE - дата увольнения,
  -- pZAP_DATE - дата записи
  -- pPRIKAZ_ID - приказ об увольнении работника(-ов)
  --
  -- Возвращаемое значение:
  --  TRUE  - успешное завершение увольнения
  --  FALSE - ошибка при увольнении работника

  FUNCTION GET_SURNAME_CASE(pSURNAME VARCHAR2
                           ,pGENDER  NUMBER
                           ,pCASE    NUMBER
                           ,pUSE_DB  NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Функция возвращает фамилию в заданном падеже
  -- pSURNAME - фамилия
  -- pGENDER  - род
  -- pCASE    - падеж (из справочника QWERTY.SP_CASE)
  -- pUSE_DB  - использовать таблицу исключений или только автоматический расчет:
  --   pUSE_DB = 1 используется таблица исключений

  FUNCTION GET_NAME_CASE(pNAME   VARCHAR2
                        ,pGENDER NUMBER
                        ,pCASE   NUMBER
                        ,pUSE_DB NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Функция возвращает имя в заданном падеже
  -- pNAME   - имя
  -- pGENDER - род
  -- pCASE   - падеж (из справочника QWERTY.SP_CASE)                            
  -- pUSE_DB  - использовать таблицу исключений или только автоматический расчет:
  --   pUSE_DB = 1 используется таблица исключений  

  FUNCTION GET_PATRONYMIC_CASE(pPATRONYMIC VARCHAR2
                              ,pGENDER     NUMBER
                              ,pCASE       NUMBER
                              ,pUSE_DB     NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Функция возвращает отчество в заданном падеже
  -- pPATRONYMIC - очество
  -- pGENDER     - род
  -- pCASE       - падеж (из справочника QWERTY.SP_CASE)                            
  -- pUSE_DB  - использовать таблицу исключений или только автоматический расчет:
  --   pUSE_DB = 1 используется таблица исключений  

  FUNCTION GET_FIO_CASE(pSURNAME    VARCHAR2
                       ,pNAME       VARCHAR2
                       ,pPATRONYMIC VARCHAR2
                       ,pCASE       NUMBER
                       ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Функция возвращает Ф.И.О., заданное фамилией, именем и отчеством, в заданном падеже
  -- pSURNAME - фамилия
  -- pNAME - имя
  -- pPATRONYMIC - отчество
  -- pCASE - падеж (из справочника QWERTY.SP_CASE)
  -- pSHORT_LONG:
  --   1               - ответ в виде "Фамилия И.О."
  --   другое значение - ответ в виде "Фамилия Имя Отчество"

  FUNCTION GET_FIO_CASE(pTAB_ID     NUMBER
                       ,pCASE       NUMBER
                       ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Функция возвращает Ф.И.О. работника в заданном падеже
  -- pTAB_ID - табельный номер работника
  -- pCASE - падеж (из справочника QWERTY.SP_CASE)
  -- pSHORT_LONG:
  --   1               - ответ в виде "Фамилия И.О."
  --   другое значение - ответ в виде "Фамилия Имя Отчество"

  FUNCTION GET_FIO_CASE1(pTAB_ID     NUMBER
                        ,pCASE       NUMBER
                        ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Тест для автоматического спряжения Ф.И.О.                                                

  FUNCTION GET_WORKPLACE_CASE(pWORKPLACE VARCHAR2
                             ,pCASE      NUMBER) RETURN VARCHAR2;
  --Функция возвращает должность в заданном падеже
  -- pWORKPLACE - наименование должности
  -- pCASE - падеж (из справочника QWERTY.SP_CASE)

  FUNCTION STAG_TO_CHAR(pSTAG_MONTHS    NUMBER
                       ,pSHORT_LONG     NUMBER DEFAULT 1
                       ,pROUND_OR_TRUNC NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Преобразует стаж в числе месяцев в строку стажа в годах и месяцах
  -- pSHORT_LONG - формат возвращаемой строки:
  -- при pSHORT_LONG=1: "Xл. Xм."
  --     pSHORT_LONG=2: "X лет X мес."
  --   другое значение: "X лет X месяцев"
  -- pROUND_OR_TRUNC - округлять или обрезать:
  --   1               - значение месяцев округляется по правилам округления
  --   другое значение - значение обрезается до целого числа, меньшего или равного числу
  -- e.g. STAG_TO_CHAR(75, 2) = '6 лет 3 мес.'

  FUNCTION GET_STAG_MONTHS(pTAB_ID    NUMBER
                          ,pSTAG_DATE DATE DEFAULT SYSDATE) RETURN NUMBER;
  --Возвращает стаж работника в месяцах
  -- pTAB_ID - табельный номер работника

  FUNCTION GET_EMPLOYEE_STAG_MONTHS(pTAB_ID NUMBER) RETURN NUMBER;
  --Возвращает стаж работника в месяцах (на замену GET_STAG_MONTHS для унификации названий функций)
  -- pTAB_ID - табельный номер работника

  FUNCTION GET_STAG_CHAR(pTAB_ID     NUMBER
                        ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Возвращает стаж работника 
  -- pTAB_ID - табельный номер работника
  -- pSHORT_LONG - формат возвращаемой строки:
  -- при pSHORT_LONG=1: "Xл. Xм."     
  --     pSHORT_LONG=2: "X лет X мес."
  --  другое значение : "X лет X месяцев"

  FUNCTION GET_EMPLOYEE_STAG(pTAB_ID     NUMBER
                            ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Возвращает стаж работника (на замену GET_STAG_CHAR для унификации названий функций)
  -- pTAB_ID - табельный номер работника
  -- pSHORT_LONG - формат возвращаемой строки:
  -- при pSHORT_LONG=1: "Xл. Xм."     
  --     pSHORT_LONG=2: "X лет X мес."
  --  другое значение : "X лет X месяцев"                                              

  FUNCTION GET_EMPLOYEE_STAG_MONTHS_2DATE(pTAB_ID    NUMBER
                                         ,pSTAG_DATE DATE) RETURN NUMBER;
  --Возвращает стаж работника в месяцах на определенную дату
  --  (e.g. для увольняющихся на пенсию на дату увольнения)
  -- pTAB_ID - табельный номер работника
  -- pSTAG_DATE - дата, на которую необходимо расчитать стаж

  FUNCTION GET_EMPLOYEE_STAG_2DATE(pTAB_ID     NUMBER
                                  ,pSTAG_DATE  DATE
                                  ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Возвращает стаж работника в месяцах на определенную дату
  --  (e.g. для увольняющихся на пенсию на дату увольнения)
  -- pTAB_ID - табельный номер работника
  -- pSTAG_DATE - дата, на которую необходимо расчитать стаж
  -- при pSHORT_LONG=1: "Xл. Xм."
  --     pSHORT_LONG=2: "X лет X мес."
  --   другое значение: "X лет X месяцев"

  FUNCTION GET_EMPLOYEE_AGE_MONTHS(pTAB_ID NUMBER) RETURN NUMBER;
  --Возвращает возраст работника в месяцах
  -- pTAB_ID - табельный номер работника

  FUNCTION GET_EMPLOYEE_AGE(pTAB_ID     NUMBER
                           ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Возвращает возраст работника
  -- pTAB_ID - табельный номер работника
  -- pSHORT_LONG - формат возвращаемой строки:
  -- при pSHORT_LONG=1: "Xл. Xм."     
  --     pSHORT_LONG=2: "X лет X мес."
  --  другое значение : "X лет X месяцев"

  FUNCTION GET_EMPLOYEE_PHONE(pTAB_ID     NUMBER
                             ,pPHONE_TYPE NUMBER DEFAULT 0
                             ,pFORMAT     NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Возвращает телефон (телефоны) работника
  -- pTAB_ID - табельный номер работника
  -- pPHONE_TYPE:
  --         1      - рабочий телефон
  --        -1      - все, кроме рабочего телефона
  --         2      - домашний телефон
  --        -2      - все, кроме домашнего телефона
  --         3      - мобильный телефон, рабочий
  --        -3      - все, кроме рабочего мобильного телефона 
  --         4      - мобильный телефон, домашний
  --        -4      - все, кроме домашнего мобильного телефона     
  --   другое число - все доступные телефоны
  -- pFORMAT:
  --         0      - не форматировать телефонные номера
  --   другое число - отформатировать (по возможности) телефонные номера                            

  TYPE recEMPLOYEE_INFO IS RECORD(
     ID_TAB        NUMBER(7)
    , -- Таб. №
    FIO_RUS       VARCHAR2(100)
    , -- Ф.И.О. на русском языке
    FIO_UKR       VARCHAR2(100)
    , -- Ф.И.О. на украинском языке
    INN           VARCHAR2(10)
    , -- Налоговый код
    DATE_OF_BIRTH DATE
    , -- Дата рождения
    PASSPORT_INFO VARCHAR2(200)); -- Паспортные данные
  TYPE tEMPLOYEE_INFO IS TABLE OF recEMPLOYEE_INFO;

  FUNCTION GET_INFO_BY_INN(pINN VARCHAR2) RETURN tEMPLOYEE_INFO
    PIPELINED;
  --Возвращает информацию о пользователе по заданному налоговому коду 
  -- в виде таблицы со следующими полями:
  --  - Таб. №
  --  - Ф.И.О. на русском языке
  --  - Ф.И.О. на украинском языке
  --  - Налоговый код
  --  - Дата рождения
  --  - Паспортные данные

  FUNCTION GET_FIO_BY_TAB(pTAB_ID     NUMBER
                         ,pLANG       NUMBER DEFAULT 1
                         ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2;
  --Возвращает Ф.И.О. работника с заданным табельным номером
  -- pTAB_ID - табельный номер работника 
  -- pLANG:
  --   1               - русский язык,
  --   другое значение - украинский язык
  -- pSHORT_LONG:
  --   1               - Фамилия Имя Отчество
  --   2               - Фамилия И.О.
  --   3               - И.О. Фамилия   

  TYPE recEMPLOYEE_INFO_SHORT IS RECORD(
     ID_TAB  NUMBER(7)
    , -- Таб. №
    FIO_RUS VARCHAR2(100)
    , -- Ф.И.О. на русском языке
    FIO_UKR VARCHAR2(100)); -- Ф.И.О. на украинском языке
  TYPE tEMPLOYEE_INFO_SHORT IS TABLE OF recEMPLOYEE_INFO_SHORT;

  FUNCTION GET_TAB_BY_FIO(pFIO VARCHAR2) RETURN tEMPLOYEE_INFO_SHORT
    PIPELINED;
  --Возвращает Таб. № по Ф.И.О. работника (вне зависимости от регистра)
  -- pFIO - Ф.И.О. работника в виде:
  --   - Фамилия Имя Отчество
  --   - Фамилия И.О.
  --   - И.О. Фамилия
  -- pFIO может быть как на русском так и на украинском языках
  -- обрабатываемые варианты Ф.И.О.:
  --   - Фамилия 
  --   - Имя
  --   - Отчество
  --   - Фамилия Имя
  --   - Имя Отчество
  --   - Фамилия И.
  --   - И. Фамилия
  --   - Фамилия И.О.
  --   - И.О. Фамилия
  --   - Фамилия Имя Отчество
  --   - Имя Отчество Фамилия
  --   - Фамилия И. О.
  --   - И. О. Фамилия

  FUNCTION GET_OTPUSK_SETTLEMENT_DATE(pTAB_ID   NUMBER
                                     ,pOTP_ID   NUMBER
                                     ,pOTP_DATE DATE) RETURN DATE;
  --Возвращает дату расчета для отпуска работника по виду отпуска и дате его оформления
  -- pTAB_ID - табельный номер работника
  -- pOTP_ID - вид отпуска
  -- pOTP_DATE - дата отпуска (для остатка с компенсацией обрезанная дата редактирования)

  TYPE recDEPARTMENT_INFO IS RECORD(
     ID_CEX     NUMBER(7)
    ,FULL_NAME  VARCHAR2(64)
    ,SHORT_NAME VARCHAR2(10)
    ,PARENT_ID  NUMBER(7)
    ,TYPE_MASK  VARCHAR2(20)
    ,OLD_IDC    NUMBER(3)
    ,OLD_IDP    NUMBER(3)
    ,FL         CHAR(1));
  TYPE tDEPARTMENT_INFO IS TABLE OF recDEPARTMENT_INFO;

  FUNCTION GET_DEPARTMENTS(pLANG            NUMBER DEFAULT 1
                          ,pWHERE_CLAUSE    VARCHAR2 DEFAULT ''
                          ,pORDER_BY_CLAUSE VARCHAR2 DEFAULT '') RETURN tDEPARTMENT_INFO
    PIPELINED;
  --Возвращает список цехов (подразделений) на необходимом языке по заданному условию и в определенном порядке
  -- pLANG:
  --   1 - русский язык,
  --   другое значение - украинский язык
  -- pWHERE_CLAUSE    - фраза WHERE для запроса
  -- pORDER_BY_CLAUSE - фраза ORDER BY для запроса

  TYPE tARRAY_OF_STRING IS TABLE OF VARCHAR2(100);

  FUNCTION TRANSLATE_TEXT(pTEXT VARCHAR2) RETURN VARCHAR2;
  --Возвращает перевод предложения pTEXT (по словам) с русского языка на украинский

  TYPE recWORD_INFO IS RECORD(
     WORD     VARCHAR2(500)
    ,ID_MEST  NUMBER(7)
    ,WORD_POS NUMBER(3));
  TYPE tWORD_INFO IS TABLE OF recWORD_INFO;

  FUNCTION GET_WORD_STATISTICS(pTABLE_NAME      VARCHAR2
                              ,pWORD_FIELD_NAME VARCHAR2
                              ,pID_FIELD_NAME   VARCHAR2
                              ,pID_FIELD_VALUE  NUMBER DEFAULT -999) RETURN tWORD_INFO
    PIPELINED;
  --Слово в должности с указанием его позиции в наименовании должности

  --Данные для получения из SAP адреса компании
  TYPE recSAP_LFA1 IS RECORD(
     NAME     VARCHAR2(35)
    , -- Наименование компании
    COUNTRY  VARCHAR2(50)
    , -- Страна (UA, RU etc)
    CITY     VARCHAR2(35)
    , -- Город
    STREET   VARCHAR2(35)
    , -- Улица и номер дома
    ZIP_CODE VARCHAR2(10)); -- Почтовый индекс
  TYPE tLFA1 IS TABLE OF recSAP_LFA1;

  FUNCTION GET_COMPANY_ADDRESS(pCOMPANY_NAME VARCHAR2 DEFAULT '*') RETURN tLFA1
    PIPELINED;
  --Возвращает адрес компании с именем pCOMPANY_NAME из SAP
  -- для поиска по части имени можно в переменной pCOMPANY_NAME использовать символы % и _

  FUNCTION PACKAGE_INFO RETURN VARCHAR2;
  --Возвращает информацию о пакете

  FUNCTION FUNCTION_INFO(pFUNCTION_NAME VARCHAR2) RETURN VARCHAR2;
  --Возвращает описание функции

  /*
  function FUNCTION_INFO(pFUNCTION_NAME varchar2) return varchar2;
  --Возвращает информацию о функции
  */

  /*  
  function [NAME_OF_FUNCTION](p[PARAM_NAME1] {PARAM_TYPE}
                             ,p[PARAM_NAME2] {PARAM_TYPE}) return {RETURN_TYPE};
  --Возвращает ...
  -- p[PARAM_NAME1] - 
  -- p[PARAM_NAME2] -
  */

  -- НОВЫЕ ФУНКЦИИ, проходящие тестирование
  -- Данные о работнике
  TYPE recEMPLOYEE_INFO_WORK IS RECORD(
     ID_TAB        QWERTY.SP_RB_FIO.ID_TAB%TYPE
    ,ID_DEPT       QWERTY.SP_PODR.ID_CEX%TYPE
    ,DEPT_NAME_RUS QWERTY.SP_PODR.NAME_U%TYPE
    ,DEPT_NAME_UKR QWERTY.SP_PODR.NAME_R%TYPE
    ,ID_STAT       QWERTY.SP_STAT.ID_STAT%TYPE
    ,ID_MEST       QWERTY.SP_MEST.ID_MEST%TYPE
    ,WORKPLACE_RUS QWERTY.SP_MEST.FULL_NAME_U%TYPE
    ,WORKPLACE_UKR QWERTY.SP_MEST.FULL_NAME_R%TYPE
    ,WORKPLACE_SHORT_RUS QWERTY.SP_MEST.NAME_U%TYPE
    ,WORKPLACE_SHORT_UKR QWERTY.SP_MEST.NAME_R%TYPE
    ,ID_KAT        QWERTY.SP_KAT.ID_KAT%TYPE
    ,CATEGORY_NAME QWERTY.SP_KAT.NAME_U%TYPE);

  TYPE tEMPLOYEE_INFO_WORK IS TABLE OF recEMPLOYEE_INFO_WORK;

  FUNCTION GET_EMPLOYEE_INFO(pTAB_ID NUMBER) RETURN tEMPLOYEE_INFO_WORK
    PIPELINED;

END HR_4TEST;
/
CREATE OR REPLACE PACKAGE BODY QWERTY.HR_4TEST IS

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

  --Константы с описанием функций:
  -- - что выполняет функция
  -- - какие параметры за что отвечают
  -- - какой результат возвращается
  --константа именуется по названию функции в формате "cNAME_OF_FUNCTION"
  cGET_OTPUSK_SETTLEMENT_DATE CONSTANT VARCHAR2(500) := 'Описание функции, ее назначение, перечень параметров';
  cGET_TAB_BY_FIO             CONSTANT VARCHAR2(500) := 'Возвращает данные о работнике в виде таблицы с полями: ID_TAB, FIO_RUS, FIO_UKR.' || chr(13) || 'Входящий параметр pFIO принимает Ф.И.О. искомого работника в различных вариациях';

  FUNCTION GET_PUNKT_FULL_NAME(pPUNKT_NAME VARCHAR2
                              ,pPUNKT_TYPE NUMBER
                              ,pLANG       NUMBER) RETURN VARCHAR2 IS
    --pPUNKT_TYPE:
    --  тип населенного пункта
    --pLANG:
    --  1 - русский язык
    --  другое значение - украинский язык
    RESULT    VARCHAR2(250);
    vPunktRec qwerty.sp_punkt%ROWTYPE;
  BEGIN
    IF pPUNKT_TYPE = 21 THEN
      RESULT := '';
    ELSE
      SELECT * INTO vPunktRec FROM QWERTY.SP_PUNKT WHERE ID = pPUNKT_TYPE;
      IF pLANG = 1 THEN
        RESULT := vPunktRec.snam_u;
      ELSE
        RESULT := vPunktRec.snam_r;
      END IF;
    END IF;
    RESULT := LOWER(RESULT);
    IF RESULT = 'обл.' OR RESULT = 'р-н' THEN
      RESULT := pPUNKT_NAME || ' ' || RESULT;
    ELSE
      RESULT := RESULT || ' ' || pPUNKT_NAME;
    END IF;
    RETURN(RESULT);
  END GET_PUNKT_FULL_NAME;

  FUNCTION CORRECTING_ADDRESS(pADDRESS VARCHAR2) RETURN VARCHAR2 IS
    RESULT VARCHAR2(500);
  BEGIN
    RESULT := pADDRESS;
  
    RESULT := REPLACE(RESULT
                     ,'г. г.'
                     ,'г.');
    RESULT := REPLACE(RESULT
                     ,'г. Г.'
                     ,'г.');
    RESULT := REPLACE(RESULT
                     ,'м. м.'
                     ,'м.');
    RESULT := REPLACE(RESULT
                     ,'м. М.'
                     ,'м.');
    RESULT := REPLACE(RESULT
                     ,'а.р.'
                     ,'А.Р.');
    RESULT := REPLACE(RESULT
                     ,'А.Р. Республика'
                     ,'А.Р.');
    RESULT := REPLACE(RESULT
                     ,'  '
                     ,' ');
  
    RETURN(TRIM(RESULT));
  END CORRECTING_ADDRESS;

  FUNCTION GET_CITY_NAME(pCITY_ID    NUMBER
                        ,pLANG       NUMBER
                        ,pSHORT_LONG NUMBER) RETURN VARCHAR2 IS
    -- pLANG:
    --   1 - русский язык,
    --   другое значение - украинский язык
    -- pSHORT_LONG:
    --   1 - урезанный вариант названия города
    RESULT   VARCHAR2(250);
    vCityRec qwerty.sp_sity%ROWTYPE;
  
  BEGIN
    SELECT * INTO vCityRec FROM QWERTY.SP_SITY WHERE id = pCITY_ID;
  
    IF pSHORT_LONG = 1 THEN
      IF pLANG = 1 THEN
        RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_u)
                                     ,vCityRec.id_punkt
                                     ,pLANG);
      ELSE
        RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_r)
                                     ,vCityRec.id_punkt
                                     ,pLANG);
      END IF;
    ELSE
      IF vCityRec.parent_id <> 0 THEN
        RESULT := get_city_name(vCityRec.parent_id
                               ,pLANG
                               ,pSHORT_LONG);
      END IF;
      IF pLANG = 1 THEN
        IF NOT (RESULT IS NULL) THEN
          RESULT := RESULT || ', ' || GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_u)
                                                         ,vCityRec.id_punkt
                                                         ,pLANG);
        ELSE
          RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_u)
                                       ,vCityRec.id_punkt
                                       ,pLANG);
        END IF;
      ELSE
        IF NOT (RESULT IS NULL) THEN
          RESULT := RESULT || ', ' || GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_r)
                                                         ,vCityRec.id_punkt
                                                         ,pLANG);
        ELSE
          RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_r)
                                       ,vCityRec.id_punkt
                                       ,pLANG);
        END IF;
      END IF;
    END IF;
    --Корректировки
    RESULT := CORRECTING_ADDRESS(RESULT);
  
    RETURN(RESULT);
  END GET_CITY_NAME;

  FUNCTION GET_CITY_NAME_NOCOUNTRY(pCITY_ID    NUMBER
                                  ,pLANG       NUMBER
                                  ,pSHORT_LONG NUMBER) RETURN VARCHAR2 IS
    -- pLANG:
    --   1 - русский язык,
    --   другое значение - украинский язык
    -- pSHORT_LONG:
    --   1 - урезанный вариант названия города
    RESULT   VARCHAR2(250);
    vCityRec qwerty.sp_sity%ROWTYPE;
  
  BEGIN
    SELECT * INTO vCityRec FROM QWERTY.SP_SITY WHERE id = pCITY_ID;
  
    --Если доходим до государства, то прекращаем выполнение
    IF vCityRec.id_punkt = 21 THEN
      RETURN(RESULT);
    END IF;
  
    IF pSHORT_LONG = 1 THEN
      IF pLANG = 1 THEN
        RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_u)
                                     ,vCityRec.id_punkt
                                     ,pLANG);
      ELSE
        RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_r)
                                     ,vCityRec.id_punkt
                                     ,pLANG);
      END IF;
    ELSE
      IF vCityRec.parent_id <> 0 THEN
        RESULT := GET_CITY_NAME_NOCOUNTRY(vCityRec.parent_id
                                         ,pLANG
                                         ,pSHORT_LONG);
      END IF;
      IF pLANG = 1 THEN
        IF NOT (RESULT IS NULL) THEN
          RESULT := RESULT || ', ' || GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_u)
                                                         ,vCityRec.id_punkt
                                                         ,pLANG);
        ELSE
          RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_u)
                                       ,vCityRec.id_punkt
                                       ,pLANG);
        END IF;
      ELSE
        IF NOT (RESULT IS NULL) THEN
          RESULT := RESULT || ', ' || GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_r)
                                                         ,vCityRec.id_punkt
                                                         ,pLANG);
        ELSE
          RESULT := GET_PUNKT_FULL_NAME(INITCAP(vCityRec.name_r)
                                       ,vCityRec.id_punkt
                                       ,pLANG);
        END IF;
      END IF;
    END IF;
  
    RESULT := CORRECTING_ADDRESS(RESULT);
  
    RETURN(RESULT);
  END GET_CITY_NAME_NOCOUNTRY;

  FUNCTION GET_EMPLOYEE_PASSPORT(pTAB_ID     NUMBER
                                ,pLANG       NUMBER
                                ,pSHORT_LONG NUMBER) RETURN VARCHAR2 IS
    -- pLANG:
    --   1 - русский язык,
    --   другое значение - украинский язык
    -- pSHORT_LONG:
    --   1 - урезанный вариант названия города
    RESULT    VARCHAR2(250);
    vCityID   INTEGER;
    vCityName VARCHAR2(500);
  BEGIN
    --  select pas.ser||' '||trim(pas.numb)||', '||translate(pas.kem, chr(10), ' ')||', '||pas.nam_sity_p||', '||pas.data_p PASPORT
    --  into Result
    --  from qwerty.sp_kav_pasport pas
    --  where pas.id_tab=ID_TAB_;
  
    RESULT := '-';
    SELECT NVL(PA.SER
              ,'-') || ' ' || TRIM(NVL(TO_CHAR(PA.NUMB
                                              ,'999999999')
                                      ,'-')) || ', ' || TRANSLATE(RTRIM(NVL(PA.KEM
                                                                           ,'-'))
                                                                 ,CHR(10)
                                                                 ,' ') || ', ' || NVL(TO_CHAR(PA.DATA_P
                                                                                             ,'dd.mm.yyyy "zz"')
                                                                                     ,'-')
          ,pa.id_sity
      INTO RESULT
          ,vCityID
      FROM qwerty.sp_ka_pasport pa
     WHERE pa.id_tab = pTAB_ID;
    IF pLANG = 1 THEN
      RESULT := REPLACE(RESULT
                       ,'zz'
                       ,'г.');
    ELSE
      RESULT := REPLACE(RESULT
                       ,'zz'
                       ,'р.');
    END IF;
  
    vCityName := GET_CITY_NAME(vCityID
                              ,pLANG
                              ,pSHORT_LONG);
    RESULT    := RESULT || ', ' || RTRIM(vCityName);
  
    RETURN(RESULT);
  END GET_EMPLOYEE_PASSPORT;

  FUNCTION GET_ADDRESS_FROM_ADDRESS_REC(pADDRESS_REC qwerty.sp_ka_adres%ROWTYPE
                                       ,pLANG        NUMBER
                                       ,pSHORT_LONG  NUMBER) RETURN VARCHAR2 IS
    -- ADDRESS_REC - строка из таблицы QWERTY.SP_KA_ADRES
    -- LANG=1 - русский язык,
    -- другое значение - украинский язык
    --
    -- SHORT_LONG=1 - урезанный вариант, для Южного и Одессы
    RESULT VARCHAR2(200);
  
    line_rec     qwerty.sp_line%ROWTYPE;
    dom_str      VARCHAR2(20);
    korpus_str   VARCHAR2(20);
    kvartira_str VARCHAR2(20);
  
  BEGIN
    RESULT := NULL;
  
    IF NOT (pADDRESS_REC.id_line IS NULL) THEN
      SELECT * INTO line_rec FROM QWERTY.SP_LINE WHERE ID = pADDRESS_REC.id_line;
    END IF;
  
    --Получаем строку вида
    -- Приморская/Приморська д./б. AA, корп. BB, кв. СС
  
    IF (pADDRESS_REC.korp IS NULL) OR (TRIM(pADDRESS_REC.korp) = '0') OR (TRIM(pADDRESS_REC.korp) = '-') THEN
      korpus_str := '';
    ELSE
      korpus_str := ', корп. ' || pADDRESS_REC.korp;
    END IF;
    IF (TRIM(pADDRESS_REC.dom) = '0') OR (TRIM(pADDRESS_REC.dom) = '-') THEN
      dom_str := '';
    ELSE
      IF pLANG = 1 THEN
        dom_str := ', д. ' || pADDRESS_REC.dom;
      ELSE
        dom_str := ', б. ' || pADDRESS_REC.dom;
      END IF;
    END IF;
    IF (TRIM(pADDRESS_REC.kvart) = '0') OR (TRIM(pADDRESS_REC.kvart) = '00') OR (TRIM(pADDRESS_REC.kvart) = '-') THEN
      kvartira_str := '';
    ELSE
      kvartira_str := ', кв. ' || pADDRESS_REC.kvart;
    END IF;
    IF pLANG = 1 THEN
      RESULT := LOWER(line_rec.snam_u) || ' ' || pADDRESS_REC.name_line_u || dom_str || korpus_str || kvartira_str;
    ELSE
      RESULT := LOWER(line_rec.snam_r) || ' ' || pADDRESS_REC.name_line_r || dom_str || korpus_str || kvartira_str;
    END IF;
  
    IF NOT (pADDRESS_REC.post_ind IS NULL) THEN
      RESULT := GET_CITY_NAME(pADDRESS_REC.id_sity
                             ,pLANG
                             ,pSHORT_LONG) || ', ' || pADDRESS_REC.post_ind || ', ' || RESULT;
    ELSE
      RESULT := GET_CITY_NAME(pADDRESS_REC.id_sity
                             ,pLANG
                             ,pSHORT_LONG) || ', ' || RESULT;
    END IF;
    RESULT := LTRIM(RESULT
                   ,', ');
  
    RETURN(RESULT);
  END GET_ADDRESS_FROM_ADDRESS_REC;

  FUNCTION GET_EMPLOYEE_ADDRESS(pTAB_ID     NUMBER
                               ,pLANG       NUMBER
                               ,pSHORT_LONG NUMBER) RETURN VARCHAR2 IS
    -- pLANG:
    --   1 - русский язык,
    --   другое значение - украинский язык
    -- pSHORT_LONG:
    --   1 - урезанный вариант, для Южного и Одессы
  
    address_rec      qwerty.sp_ka_adres%ROWTYPE;
    line_rec         qwerty.sp_line%ROWTYPE;
    num_of_addresses NUMBER;
    line_info_count  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO num_of_addresses FROM QWERTY.SP_KA_ADRES WHERE ID_TAB = pTAB_ID;
    IF num_of_addresses > 1 THEN
      SELECT *
        INTO address_rec
        FROM QWERTY.SP_KA_ADRES
       WHERE ID_TAB = pTAB_ID
         AND FL = 1;
    ELSE
      SELECT * INTO address_rec FROM QWERTY.SP_KA_ADRES WHERE ID_TAB = pTAB_ID;
    END IF;
  
    --Проверяем есть ли данные в таблице QWERTY.SP_LINE
    SELECT COUNT(*) INTO line_info_count FROM QWERTY.SP_LINE WHERE ID = address_rec.id_line;
    IF line_info_count <> 0 THEN
      SELECT * INTO line_rec FROM QWERTY.SP_LINE WHERE ID = address_rec.id_line;
    ELSE
      NULL;
    END IF;
  
    RETURN(GET_ADDRESS_FROM_ADDRESS_REC(address_rec
                                       ,pLANG
                                       ,pSHORT_LONG));
  END GET_EMPLOYEE_ADDRESS;

  FUNCTION GET_EMPLOYEE_ADDRESS_BY_FL(pTAB_ID     NUMBER
                                     ,pLANG       NUMBER DEFAULT 1
                                     ,pSHORT_LONG NUMBER DEFAULT 1
                                     ,pFL         NUMBER DEFAULT -1
                                     ,pINDEX      NUMBER DEFAULT -1) RETURN VARCHAR2 IS
    -- LANG=1 - русский язык,
    -- другое значение - украинский язык
    --
    -- SHORT_LONG=1 - урезанный вариант, для Южного и Одессы
    -- pFL - флаг из SP_KA_ADRES
    --   при pFL=-1 выбираются все адреса
    --   при pFL=12 выбирается фактическое место проживания, если такового нет, то берется адрес из паспорта
    -- pINDEX - порядковый номер адреса
    RESULT VARCHAR2(500);
  
    TYPE ADDRESS_CURSOR IS REF CURSOR RETURN QWERTY.SP_KA_ADRES%ROWTYPE;
  
    address_rec qwerty.sp_ka_adres%ROWTYPE;
    I           NUMBER;
    curCURSOR   ADDRESS_CURSOR;
  
  BEGIN
    RESULT := NULL;
  
    IF pFL = -1 THEN
      OPEN curCURSOR FOR
        SELECT * FROM QWERTY.SP_KA_ADRES WHERE ID_TAB = pTAB_ID ORDER BY FL;
    ELSE
      IF pFL = 12 THEN
        --выбираем фактическое место проживания
        SELECT COUNT(*)
          INTO I
          FROM QWERTY.SP_KA_ADRES
         WHERE ID_TAB = pTAB_ID
           AND FL = pFL - 10;
        IF I = 0 THEN
          --если его нет, то пытаемся взять адрес из паспорта
          OPEN curCURSOR FOR
            SELECT *
              FROM QWERTY.SP_KA_ADRES
             WHERE ID_TAB = pTAB_ID
               AND FL = 1;
        ELSE
          OPEN curCURSOR FOR
            SELECT *
              FROM QWERTY.SP_KA_ADRES
             WHERE ID_TAB = pTAB_ID
               AND FL = pFL - 10;
        END IF;
      ELSE
        OPEN curCURSOR FOR
          SELECT *
            FROM QWERTY.SP_KA_ADRES
           WHERE ID_TAB = pTAB_ID
             AND FL = pFL;
      END IF;
    END IF;
    I := 1;
    LOOP
      FETCH curCURSOR
        INTO address_rec;
      EXIT WHEN curCURSOR%NOTFOUND;
      IF (pINDEX = -1) OR (I = pINDEX) THEN
        RESULT := RESULT || '; ' || GET_ADDRESS_FROM_ADDRESS_REC(address_rec
                                                                ,pLANG
                                                                ,pSHORT_LONG);
      END IF;
      I := I + 1;
    END LOOP;
  
    CLOSE curCURSOR;
  
    RESULT := LTRIM(RESULT
                   ,'; ');
    RETURN(RESULT);
  END GET_EMPLOYEE_ADDRESS_BY_FL;

  FUNCTION GET_WORD_CASE(pWORD VARCHAR2
                        ,pCASE NUMBER) RETURN VARCHAR2 IS
    vWORD_IN_CASE VARCHAR2(50);
  BEGIN
    SELECT nvl(WORD_CASE
              ,pWORD)
      INTO vWORD_IN_CASE
      FROM SP_WORD_CASE
     WHERE WORD = pWORD
       AND ID_CASE = pCASE;
    RETURN vWORD_IN_CASE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN pWORD;
  END GET_WORD_CASE;

  FUNCTION GET_FIO_CASE(pSURNAME    VARCHAR2
                       ,pNAME       VARCHAR2
                       ,pPATRONYMIC VARCHAR2
                       ,pCASE       NUMBER
                       ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    vSURNAME    VARCHAR2(50);
    vNAME       VARCHAR2(50);
    vPATRONYMIC VARCHAR2(50);
    vDIVIDER    VARCHAR2(1);
  BEGIN
    vSURNAME := GET_WORD_CASE(pSURNAME
                             ,pCASE);
    IF pSHORT_LONG = 1 THEN
      vNAME       := substr(pNAME
                           ,1
                           ,1) || '.';
      vPATRONYMIC := substr(pPATRONYMIC
                           ,1
                           ,1) || '.';
      vDIVIDER    := '';
    ELSE
      vNAME       := GET_WORD_CASE(pNAME
                                  ,pCASE);
      vPATRONYMIC := GET_WORD_CASE(pPATRONYMIC
                                  ,pCASE);
      vDIVIDER    := ' ';
    END IF;
  
    RETURN vSURNAME || ' ' || vNAME || vDIVIDER || vPATRONYMIC;
  END GET_FIO_CASE;

  FUNCTION GET_FIO_CASE(pTAB_ID     NUMBER
                       ,pCASE       NUMBER
                       ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    vSURNAME    VARCHAR2(50);
    vNAME       VARCHAR2(50);
    vPATRONYMIC VARCHAR2(50);
  BEGIN
    IF pCASE < 10 THEN
      SELECT FAM_U
            ,F_NAME_U
            ,S_NAME_U
        INTO vSURNAME
            ,vNAME
            ,vPATRONYMIC
        FROM QWERTY.SP_RB_FIO
       WHERE ID_TAB = pTAB_ID;
    ELSE
      SELECT FAM_R
            ,F_NAME_R
            ,S_NAME_R
        INTO vSURNAME
            ,vNAME
            ,vPATRONYMIC
        FROM QWERTY.SP_RB_FIO
       WHERE ID_TAB = pTAB_ID;
    END IF;
  
    RETURN GET_FIO_CASE(vSURNAME
                       ,vNAME
                       ,vPATRONYMIC
                       ,pCASE
                       ,pSHORT_LONG);
  END GET_FIO_CASE;

  FUNCTION GET_SURNAME_CASE(pSURNAME VARCHAR2
                           ,pGENDER  NUMBER
                           ,pCASE    NUMBER
                           ,pUSE_DB  NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    vREVERSED VARCHAR2(50);
    vSURNAME  VARCHAR2(50);
    vENDING   VARCHAR2(10);
    vLENGTH   NUMBER(3);
  BEGIN
    IF pUSE_DB = 1 THEN
      SELECT WORD_CASE
        INTO vSURNAME
        FROM SP_WORD_CASE
       WHERE WORD = pSURNAME
         AND ID_CASE = pCASE
         AND ID_GENDER IN (0
                          ,pGENDER);
      RETURN vSURNAME;
    ELSE
      RAISE NO_DATA_FOUND;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      vSURNAME := pSURNAME;
      vLENGTH  := length(vSURNAME);
      SELECT translate(REVERSE(vSURNAME)
                      ,'бвгджзклмнпрстфхцчшщ'
                      ,'99999999999999999999')
        INTO vREVERSED
        FROM dual;
      SELECT nvl(REVERSE(substr(vREVERSED
                               ,1
                               ,instr(vREVERSED
                                     ,'9') - 1))
                ,'-')
        INTO vENDING
        FROM dual;
      CASE vENDING
        WHEN '-' THEN
          --Нет окончания
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := vSURNAME || 'а';
                WHEN 13 THEN
                  vSURNAME := vSURNAME || 'у';
                WHEN 14 THEN
                  vSURNAME := vSURNAME || 'а';
                WHEN 15 THEN
                  IF substr(vSURNAME
                           ,vLENGTH
                           ,1) IN ('в'
                                  ,'н') THEN
                    vSURNAME := vSURNAME || 'им';
                  ELSE
                    vSURNAME := vSURNAME || 'ом';
                  END IF;
                WHEN 16 THEN
                  IF substr(vSURNAME
                           ,vLENGTH
                           ,1) IN ('в'
                                  ,'н') THEN
                    vSURNAME := vSURNAME || 'і';
                  ELSE
                    vSURNAME := vSURNAME || 'у';
                  END IF;
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'о' THEN
          -- Заканчивается на "-о"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'а';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'у';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'а';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ом';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'у';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ь' THEN
          --Заканчивается на "ь"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'я';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ю';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'я';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ем';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'еві';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ий' THEN
          --Заканчивается на "ий"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ого';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ому';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ого';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'им';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ому';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ій' THEN
          --Заканчивается на "ій"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ього';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ьому';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ього';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ім';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ьому';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ой' THEN
          --Заканчивается на "ий"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ого';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ому';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ого';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'им';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ому';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ей' THEN
          --Заканчивается на "ей"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'я';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ю';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'я';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'єм';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ї';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ай' THEN
          --Заканчивается на "ай"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'я';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ю';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'я';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'єм';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ї';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'ая' THEN
          --Заканчивается на "ая"
          CASE pGENDER
            WHEN 2 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ої';
                WHEN 13 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ої';
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'у';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ою';
                WHEN 16 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 2) || 'ої';
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            ELSE
              NULL;
          END CASE;
        WHEN 'а' THEN
          --Заканчивается на "а"
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'и';
                WHEN 13 THEN
                  IF substr(vSURNAME
                           ,vLENGTH - 1
                           ,1) IN ('г') THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 2) || 'зі';
                  ELSE
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'і';
                  END IF;
                WHEN 14 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'у';
                WHEN 15 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'ою';
                WHEN 16 THEN
                  IF substr(vSURNAME
                           ,vLENGTH - 1
                           ,1) IN ('г') THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 2) || 'зі';
                  ELSE
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'і';
                  END IF;
                WHEN 17 THEN
                  vSURNAME := vSURNAME;
                ELSE
                  NULL;
              END CASE;
            WHEN 2 THEN
              IF substr(vSURNAME
                       ,vLENGTH - 1
                       ,1) IN ('в'
                              ,'н') OR substr(vSURNAME
                                             ,vLENGTH - 2
                                             ,2) = 'ьк' THEN
                CASE pCASE
                  WHEN 12 THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'ої';
                  WHEN 13 THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'ій';
                  WHEN 14 THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'у';
                  WHEN 15 THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'ою';
                  WHEN 16 THEN
                    vSURNAME := substr(vSURNAME
                                      ,1
                                      ,vLENGTH - 1) || 'ій';
                  WHEN 17 THEN
                    vSURNAME := vSURNAME;
                  ELSE
                    NULL;
                END CASE;
              ELSE
                vSURNAME := GET_SURNAME_CASE(pSURNAME
                                            ,1
                                            ,pCASE
                                            ,pUSE_DB);
              END IF;
            ELSE
              NULL;
          END CASE;
        WHEN 'я' THEN
          --Заканчивается на "я"
          --case pGENDER
          --when 1 then
          CASE pCASE
            WHEN 12 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'і';
            WHEN 13 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'і';
            WHEN 14 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'ею';
            WHEN 16 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'і';
            WHEN 17 THEN
              vSURNAME := vSURNAME;
            ELSE
              NULL;
          END CASE;
          /*when 2 then
          case pCASE
            when 12 then vSURNAME := substr(vSURNAME, 1, vLENGTH - 1) || 'і';
            when 13 then vSURNAME := substr(vSURNAME, 1, vLENGTH - 1) || 'і';
            when 14 then vSURNAME := substr(vSURNAME, 1, vLENGTH - 1) || 'ю';
            when 15 then vSURNAME := substr(vSURNAME, 1, vLENGTH - 1) || 'ею';
            when 16 then vSURNAME := substr(vSURNAME, 1, vLENGTH - 1) || 'і';
            when 17 then vSURNAME := vSURNAME;
            else null;
          end case;*/
      --else null;
      --end case;
        WHEN 'ья' THEN
          --Заканчивается на "ья"
          CASE pCASE
            WHEN 12 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'ї';
            WHEN 13 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'ї';
            WHEN 14 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              CASE pGENDER
                WHEN 1 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'йом';
                WHEN 2 THEN
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'єю';
                ELSE
                  vSURNAME := substr(vSURNAME
                                    ,1
                                    ,vLENGTH - 1) || 'єю';
              END CASE;
            WHEN 16 THEN
              vSURNAME := substr(vSURNAME
                                ,1
                                ,vLENGTH - 1) || 'ї';
            WHEN 17 THEN
              vSURNAME := vSURNAME;
            ELSE
              NULL;
          END CASE;
        WHEN 'у' THEN
          --Заканчивается на "у"
          vSURNAME := vSURNAME;
        WHEN 'і' THEN
          --Заканчивается на "і"
          vSURNAME := vSURNAME;
        
      --- Непонятки
      
        WHEN 'ьо' THEN
          --Заканчивается на "ьо"
          vSURNAME := vSURNAME;
        WHEN 'еу' THEN
          --Заканчивается на "еу"
          vSURNAME := vSURNAME;
        WHEN 'іє' THEN
          --Заканчивается на "іє"
          vSURNAME := vSURNAME;
        ELSE
          vSURNAME := 'ELSE'; --null;
      END CASE;
    
      RETURN vSURNAME;
  END GET_SURNAME_CASE;

  FUNCTION GET_NAME_CASE(pNAME   VARCHAR2
                        ,pGENDER NUMBER
                        ,pCASE   NUMBER
                        ,pUSE_DB NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    vNAME   VARCHAR2(50);
    vENDING VARCHAR2(10);
    vLENGTH NUMBER(3);
  BEGIN
    IF pUSE_DB = 1 THEN
      SELECT WORD_CASE
        INTO vNAME
        FROM SP_WORD_CASE
       WHERE WORD = pNAME
         AND ID_CASE = pCASE
         AND ID_GENDER IN (0
                          ,pGENDER);
      RETURN vNAME;
    ELSE
      RAISE NO_DATA_FOUND;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      vNAME   := pNAME;
      vLENGTH := length(vNAME);
      --select nvl(substr(vNAME, vLENGTH, 1), '-') into vENDING from dual;
    
      /*select translate(reverse(vSURNAME), 'бвгджзклмнпрстфхцчшщ', '99999999999999999999') into vREVERSED from dual;
      select nvl(reverse(substr(vREVERSED, 1, instr(vREVERSED, '9') - 1)), '-') into vENDING from dual;*/
    
      SELECT nvl(substr(vNAME
                       ,vLENGTH - instr(REVERSE(translate(vNAME
                                                         ,'бвгджзклмнпрстфхцчшщ'
                                                         ,'99999999999999999999'))
                                       ,9) + 2
                       ,vLENGTH)
                ,'-')
        INTO vENDING
        FROM dual;
    
      CASE vENDING
        WHEN '-' THEN
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := vNAME || 'а';
                WHEN 13 THEN
                  vNAME := vNAME || 'у';
                WHEN 14 THEN
                  vNAME := vNAME || 'а';
                WHEN 15 THEN
                  vNAME := vNAME || 'ом';
                WHEN 16 THEN
                  vNAME := vNAME || 'ові';
                WHEN 17 THEN
                  vNAME := vNAME || 'е';
              END CASE;
            WHEN 2 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := vNAME || 'і';
                WHEN 13 THEN
                  vNAME := vNAME || 'і';
                WHEN 14 THEN
                  vNAME := vNAME;
                WHEN 15 THEN
                  vNAME := vNAME || '''ю';
                WHEN 16 THEN
                  vNAME := vNAME || 'і';
                WHEN 17 THEN
                  vNAME := vNAME || 'е';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'ь' THEN
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'я';
                WHEN 13 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ю';
                WHEN 14 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'я';
                WHEN 15 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ем';
                WHEN 16 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'еві';
                WHEN 17 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ю';
              END CASE;
            WHEN 2 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'і';
                WHEN 13 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'і';
                WHEN 14 THEN
                  vNAME := vNAME;
                WHEN 15 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || '''ю';
                WHEN 16 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'і';
                WHEN 17 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'е';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'о' THEN
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'а';
                WHEN 13 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'у';
                WHEN 14 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'а';
                WHEN 15 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ом';
                WHEN 16 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ові';
                WHEN 17 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'е';
              END CASE;
            WHEN 2 THEN
              NULL;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'а' THEN
          CASE pGENDER
            WHEN 1 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'и';
                WHEN 13 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'і';
                WHEN 14 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'у';
                WHEN 15 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ою';
                WHEN 16 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'і';
                WHEN 17 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'о';
              END CASE;
            WHEN 2 THEN
              CASE pCASE
                WHEN 12 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'и';
                WHEN 13 THEN
                  CASE substr(vNAME
                         ,vLENGTH - 1
                         ,1)
                    WHEN 'г' THEN
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 2) || 'зі';
                    WHEN 'к' THEN
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 2) || 'ці';
                    WHEN 'х' THEN
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 2) || 'cі';
                    ELSE
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 1) || 'і';
                  END CASE;
                WHEN 14 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'у';
                WHEN 15 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ою';
                WHEN 16 THEN
                  CASE substr(vNAME
                         ,vLENGTH - 1
                         ,1)
                    WHEN 'г' THEN
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 2) || 'зі';
                    WHEN 'к' THEN
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 2) || 'ці';
                    WHEN 'х' THEN
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 2) || 'cі';
                    ELSE
                      vNAME := substr(vNAME
                                     ,1
                                     ,vLENGTH - 1) || 'і';
                  END CASE;
                WHEN 17 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'о';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'я' THEN
          CASE pCASE
            WHEN 12 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'і';
            WHEN 13 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'і';
            WHEN 14 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ею';
            WHEN 16 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'і';
            WHEN 17 THEN
              CASE pGENDER
                WHEN 2 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ю';
                ELSE
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'е';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'ья' THEN
          CASE pCASE
            WHEN 12 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'і';
            WHEN 13 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'і';
            WHEN 14 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'єю';
            WHEN 16 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'і';
            WHEN 17 THEN
              CASE pGENDER
                WHEN 2 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ю';
                ELSE
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'е';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN '''я' THEN
          CASE pCASE
            WHEN 12 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 13 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 14 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'єю';
            WHEN 16 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 17 THEN
              CASE pGENDER
                WHEN 2 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ю';
                ELSE
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'е';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'ій' THEN
          CASE pCASE
            WHEN 12 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'я';
            WHEN 13 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ю';
            WHEN 14 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'я';
            WHEN 15 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'єм';
            WHEN 16 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'єві';
            WHEN 17 THEN
              CASE pGENDER
                WHEN 2 THEN
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'ю';
                ELSE
                  vNAME := substr(vNAME
                                 ,1
                                 ,vLENGTH - 1) || 'е';
              END CASE;
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'ія' THEN
          CASE pCASE
            WHEN 12 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 13 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 14 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'єю';
            WHEN 16 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 17 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'є';
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        WHEN 'ея' THEN
          CASE pCASE
            WHEN 12 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 13 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 14 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ю';
            WHEN 15 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'єю';
            WHEN 16 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'ї';
            WHEN 17 THEN
              vNAME := substr(vNAME
                             ,1
                             ,vLENGTH - 1) || 'є';
            ELSE
              vNAME := '[род не определён]';
          END CASE;
        ELSE
          vNAME := '[не обрабатываемое окончание]';
      END CASE;
    
      RETURN vNAME;
  END GET_NAME_CASE;

  FUNCTION GET_PATRONYMIC_CASE(pPATRONYMIC VARCHAR2
                              ,pGENDER     NUMBER
                              ,pCASE       NUMBER
                              ,pUSE_DB     NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    vPATRONYMIC VARCHAR2(50);
    vENDING     VARCHAR2(10);
    vLENGTH     NUMBER(3);
  BEGIN
    IF pUSE_DB = 1 THEN
      SELECT WORD_CASE
        INTO vPATRONYMIC
        FROM SP_WORD_CASE
       WHERE WORD = pPATRONYMIC
         AND ID_CASE = pCASE
         AND ID_GENDER IN (0
                          ,pGENDER);
      RETURN vPATRONYMIC;
    ELSE
      RAISE NO_DATA_FOUND;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      vPATRONYMIC := pPATRONYMIC;
      vLENGTH     := length(vPATRONYMIC);
      SELECT nvl(substr(vPATRONYMIC
                       ,vLENGTH
                       ,1)
                ,'-')
        INTO vENDING
        FROM dual;
    
      CASE vENDING
        WHEN '-' THEN
          NULL;
        WHEN 'ч' THEN
          CASE pCASE
            WHEN 12 THEN
              vPATRONYMIC := vPATRONYMIC || 'а';
            WHEN 13 THEN
              vPATRONYMIC := vPATRONYMIC || 'у';
            WHEN 14 THEN
              vPATRONYMIC := vPATRONYMIC || 'а';
            WHEN 15 THEN
              vPATRONYMIC := vPATRONYMIC || 'ем';
            WHEN 16 THEN
              vPATRONYMIC := vPATRONYMIC || 'у';
            WHEN 17 THEN
              vPATRONYMIC := vPATRONYMIC || 'у';
          END CASE;
        WHEN 'а' THEN
          CASE pCASE
            WHEN 12 THEN
              vPATRONYMIC := substr(vPATRONYMIC
                                   ,1
                                   ,vLENGTH - 1) || 'и';
            WHEN 13 THEN
              vPATRONYMIC := substr(vPATRONYMIC
                                   ,1
                                   ,vLENGTH - 1) || 'і';
            WHEN 14 THEN
              vPATRONYMIC := substr(vPATRONYMIC
                                   ,1
                                   ,vLENGTH - 1) || 'у';
            WHEN 15 THEN
              vPATRONYMIC := substr(vPATRONYMIC
                                   ,1
                                   ,vLENGTH - 1) || 'ою';
            WHEN 16 THEN
              vPATRONYMIC := substr(vPATRONYMIC
                                   ,1
                                   ,vLENGTH - 1) || 'і';
            WHEN 17 THEN
              vPATRONYMIC := substr(vPATRONYMIC
                                   ,1
                                   ,vLENGTH - 1) || 'о';
          END CASE;
        ELSE
          vPATRONYMIC := '???';
      END CASE;
    
      RETURN vPATRONYMIC;
  END GET_PATRONYMIC_CASE;

  FUNCTION GET_FIO_CASE1(pTAB_ID     NUMBER
                        ,pCASE       NUMBER
                        ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    vSURNAME    VARCHAR2(50);
    vNAME       VARCHAR2(50);
    vPATRONYMIC VARCHAR2(50);
    vGENDER     NUMBER(1);
    vHYPHEN     NUMBER(2);
  BEGIN
    IF pCASE < 10 THEN
      SELECT FAM_U
            ,F_NAME_U
            ,S_NAME_U
            ,ID_POL
        INTO vSURNAME
            ,vNAME
            ,vPATRONYMIC
            ,vGENDER
        FROM QWERTY.SP_RB_FIO rbf
            ,QWERTY.SP_KA_OSN osn
       WHERE rbf.ID_TAB = pTAB_ID
         AND rbf.ID_TAB = osn.ID_TAB;
    ELSE
      SELECT FAM_R
            ,F_NAME_R
            ,S_NAME_R
            ,ID_POL
        INTO vSURNAME
            ,vNAME
            ,vPATRONYMIC
            ,vGENDER
        FROM QWERTY.SP_RB_FIO rbf
            ,QWERTY.SP_KA_OSN osn
       WHERE rbf.ID_TAB = pTAB_ID
         AND rbf.ID_TAB = osn.ID_TAB;
    
      vHYPHEN := instr(vSURNAME
                      ,'-');
      IF vHYPHEN > 0 THEN
        vSURNAME := GET_SURNAME_CASE(substr(vSURNAME
                                           ,1
                                           ,vHYPHEN - 1)
                                    ,vGENDER
                                    ,pCASE) || '-' || GET_SURNAME_CASE(substr(vSURNAME
                                                                             ,vHYPHEN + 1
                                                                             ,100)
                                                                      ,vGENDER
                                                                      ,pCASE);
      ELSE
        vSURNAME := GET_SURNAME_CASE(vSURNAME
                                    ,vGENDER
                                    ,pCASE);
      END IF;
    END IF;
  
    --return GET_FIO_CASE(vSURNAME, vNAME, vPATRONYMIC, pCASE, pSHORT_LONG);
    IF pSHORT_LONG = 1 THEN
      RETURN vSURNAME || ' ' || substr(vNAME
                                      ,1
                                      ,1) || '.' || substr(vPATRONYMIC
                                                          ,1
                                                          ,1) || '.';
    ELSE
      vNAME       := GET_NAME_CASE(vNAME
                                  ,vGENDER
                                  ,pCASE);
      vPATRONYMIC := GET_PATRONYMIC_CASE(vPATRONYMIC
                                        ,vGENDER
                                        ,pCASE);
      RETURN vSURNAME || ' ' || vNAME || ' ' || vPATRONYMIC;
    END IF;
  END GET_FIO_CASE1;

  FUNCTION GET_WORKPLACE_CASE(pWORKPLACE VARCHAR2
                             ,pCASE      NUMBER) RETURN VARCHAR2 IS
    vFIRST_WORD  VARCHAR2(100);
    vREST_OF_STR VARCHAR2(255);
    vSPACE_POS   NUMBER(3);
  BEGIN
    vSPACE_POS := instr(pWORKPLACE
                       ,' ');
    IF vSPACE_POS <> 0 THEN
      vFIRST_WORD  := substr(pWORKPLACE
                            ,1
                            ,vSPACE_POS - 1);
      vREST_OF_STR := substr(pWORKPLACE
                            ,vSPACE_POS
                            ,length(pWORKPLACE));
    ELSE
      vFIRST_WORD  := pWORKPLACE;
      vREST_OF_STR := '';
    END IF;
    vFIRST_WORD := GET_WORD_CASE(vFIRST_WORD
                                ,pCASE);
    RETURN vFIRST_WORD || vREST_OF_STR;
  END GET_WORKPLACE_CASE;

  FUNCTION STAG_TO_CHAR(pSTAG_MONTHS    NUMBER
                       ,pSHORT_LONG     NUMBER DEFAULT 1
                       ,pROUND_OR_TRUNC NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Преобразует стаж в числе месяцев в строку стажа в годах  работника строкой вида и месяцах
    -- при pSHORT_LONG=1: "Xл. Xм."
    --     pSHORT_LONG=2: "X лет X мес."
    --   другое значение: "X лет X месяцев"
    -- pROUND_OR_TRUNC - округлять или обрезать:
    --   1               - значение месяцев округляется по правилам округления
    --   другое значение - значение обрезается до целого числа, меньшего или равного числу
    vYEARS_TEXT1  VARCHAR2(10); --год
    vYEARS_TEXT2  VARCHAR2(10); --года
    vYEARS_TEXT3  VARCHAR2(10); --лет
    vMONTHS_TEXT1 VARCHAR2(10); --месяцев
    vMONTHS_TEXT2 VARCHAR2(10); --месяца
    vMONTHS_TEXT3 VARCHAR2(10); --месяц
  
    vSTA_YEARS       NUMBER;
    vSTA_YEARS_BY_10 NUMBER;
    vSTA_MONTHS      NUMBER;
    vMONTHS          VARCHAR2(50);
  
    vRESULT VARCHAR2(50);
  BEGIN
    CASE pSHORT_LONG
      WHEN 1 THEN
        vYEARS_TEXT1  := 'г. ';
        vYEARS_TEXT2  := 'г. ';
        vYEARS_TEXT3  := 'л. ';
        vMONTHS_TEXT1 := 'м.';
        vMONTHS_TEXT2 := vMONTHS_TEXT1;
        vMONTHS_TEXT3 := vMONTHS_TEXT1;
      WHEN 2 THEN
        vYEARS_TEXT1  := ' год ';
        vYEARS_TEXT2  := ' года ';
        vYEARS_TEXT3  := ' лет ';
        vMONTHS_TEXT1 := ' мес.';
        vMONTHS_TEXT2 := vMONTHS_TEXT1;
        vMONTHS_TEXT3 := vMONTHS_TEXT1;
      ELSE
        vYEARS_TEXT1  := ' год ';
        vYEARS_TEXT2  := ' года ';
        vYEARS_TEXT3  := ' лет ';
        vMONTHS_TEXT1 := ' месяцев';
        vMONTHS_TEXT2 := ' месяца';
        vMONTHS_TEXT3 := ' месяц';
    END CASE;
  
    vSTA_YEARS       := TRUNC(NVL(pSTAG_MONTHS
                                 ,0) / 12);
    vSTA_YEARS_BY_10 := MOD(vSTA_YEARS
                           ,10);
    IF pROUND_OR_TRUNC = 1 THEN
      vSTA_MONTHS := ROUND(MOD(NVL(pSTAG_MONTHS
                                  ,0)
                              ,12));
    ELSE
      vSTA_MONTHS := TRUNC(MOD(NVL(pSTAG_MONTHS
                                  ,0)
                              ,12));
    END IF;
  
    CASE --vSTA_MONTHS
      WHEN vSTA_MONTHS = 0 THEN
        vMONTHS := '';
      WHEN vSTA_MONTHS = 1 THEN
        vMONTHS := TO_CHAR(vSTA_MONTHS) || vMONTHS_TEXT3;
      WHEN vSTA_MONTHS IN (2
                          ,3
                          ,4) THEN
        vMONTHS := TO_CHAR(vSTA_MONTHS) || vMONTHS_TEXT2;
      WHEN vSTA_MONTHS IN (5
                          ,6
                          ,7
                          ,8
                          ,9
                          ,10
                          ,11
                          ,12) THEN
        vMONTHS := TO_CHAR(vSTA_MONTHS) || vMONTHS_TEXT1;
      ELSE
        vMONTHS := TO_CHAR(vSTA_MONTHS) || vMONTHS_TEXT1;
    END CASE; --vSTA_MONTHS
  
    CASE --vSTA_YEARS
      WHEN vSTA_YEARS = 0 THEN
        vRESULT := TRIM('' || vMONTHS);
      WHEN vSTA_YEARS IN (11
                         ,12
                         ,13
                         ,14) THEN
        vRESULT := TRIM(TO_CHAR(vSTA_YEARS) || vYEARS_TEXT3 || vMONTHS);
      ELSE
        CASE vSTA_YEARS_BY_10
          WHEN 1 THEN
            vRESULT := TRIM(TO_CHAR(vSTA_YEARS) || vYEARS_TEXT1 || vMONTHS);
          WHEN 2 THEN
            vRESULT := TRIM(TO_CHAR(vSTA_YEARS) || vYEARS_TEXT2 || vMONTHS);
          WHEN 3 THEN
            vRESULT := TRIM(TO_CHAR(vSTA_YEARS) || vYEARS_TEXT2 || vMONTHS);
          WHEN 4 THEN
            vRESULT := TRIM(TO_CHAR(vSTA_YEARS) || vYEARS_TEXT2 || vMONTHS);
          ELSE
            vRESULT := TRIM(TO_CHAR(vSTA_YEARS) || vYEARS_TEXT3 || vMONTHS);
        END CASE;
    END CASE; --vSTA_YEARS
  
    IF vRESULT IS NULL THEN
      vRESULT := TRIM('0' || vYEARS_TEXT3);
    END IF;
  
    RETURN vRESULT;
  END STAG_TO_CHAR;

  FUNCTION GET_STAG_MONTHS(pTAB_ID    NUMBER
                          ,pSTAG_DATE DATE DEFAULT SYSDATE) RETURN NUMBER IS
    --Возвращает стаж работника в месяцах
    vRESULT NUMBER;
  BEGIN
    SELECT sta_m
      INTO vRESULT
      FROM (SELECT nvl(round(sum_sta_day - months_between(sta.data
                                                         ,pSTAG_DATE) * decode(rbf.status
                                                                                            ,1
                                                                                            ,1
                                                                                            ,0))
                      ,0) sta_m
            --from QWERTY.SP_KAV_STA_OPZ_ITOG_ALL it,
              FROM QWERTY.SP_KAV_STA_OPZ_ITOG it
                  ,QWERTY.SP_ZAR_DATA_STAG    sta
                  ,QWERTY.SP_RB_FIO           rbf
             WHERE it.id_tab = pTAB_ID
               AND it.id_tab = rbf.id_tab
             ORDER BY nvl(it.data_w
                         ,to_date('01.01.1900'
                                 ,'dd.mm.yyyy')) DESC)
     WHERE rownum = 1;
  
    RETURN vRESULT;
  END GET_STAG_MONTHS;

  FUNCTION GET_EMPLOYEE_STAG_MONTHS(pTAB_ID NUMBER) RETURN NUMBER IS
    --Возвращает стаж работника в месяцах (на замену GET_STAG_MONTHS для унификации названий функций)
    -- pTAB_ID - табельный номер работника
  BEGIN
    RETURN GET_STAG_MONTHS(pTAB_ID);
  END GET_EMPLOYEE_STAG_MONTHS;

  FUNCTION GET_STAG_CHAR(pTAB_ID     NUMBER
                        ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Возвращает стаж работника строкой вида 
    -- при pSHORT_LONG=1: "Xл. Xм."
    --     pSHORT_LONG=2: "X лет X мес."
    --   другое значение: "X лет X месяцев"
  BEGIN
    RETURN STAG_TO_CHAR(GET_STAG_MONTHS(pTAB_ID)
                       ,pSHORT_LONG);
  END GET_STAG_CHAR;

  FUNCTION GET_EMPLOYEE_STAG(pTAB_ID     NUMBER
                            ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Возвращает стаж работника (на замену GET_STAG_CHAR для унификации названий функций)
    -- pTAB_ID - табельный номер работника
    -- pSHORT_LONG - формат возвращаемой строки:
    -- при pSHORT_LONG=1: "Xл. Xм."     
    --     pSHORT_LONG=2: "X лет X мес."
    --  другое значение : "X лет X месяцев"                                              
  BEGIN
    RETURN GET_STAG_CHAR(pTAB_ID
                        ,pSHORT_LONG);
  END;

  FUNCTION GET_EMPLOYEE_STAG_MONTHS_2DATE(pTAB_ID    NUMBER
                                         ,pSTAG_DATE DATE) RETURN NUMBER IS
    --Возвращает стаж работника в месяцах на определенную дату
    --  (e.g. для увольняющихся на пенсию на дату увольнения)
    -- pTAB_ID - табельный номер работника
    -- pSTAG_DATE - дата, на которую необходимо расчитать стаж (строка в формате DD.MM.YYYY)
  BEGIN
    RETURN GET_STAG_MONTHS(pTAB_ID
                          ,pSTAG_DATE);
  END;

  FUNCTION GET_EMPLOYEE_STAG_2DATE(pTAB_ID     NUMBER
                                  ,pSTAG_DATE  DATE
                                  ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Возвращает стаж работника в месяцах на определенную дату
    --  (e.g. для увольняющихся на пенсию на дату увольнения)
    -- pTAB_ID - табельный номер работника
    -- pSTAG_DATE - дата, на которую необходимо расчитать стаж
    -- при pSHORT_LONG=1: "Xл. Xм."
    --     pSHORT_LONG=2: "X лет X мес."
    --   другое значение: "X лет X месяцев"
  BEGIN
    RETURN STAG_TO_CHAR(GET_STAG_MONTHS(pTAB_ID
                                       ,pSTAG_DATE)
                       ,pSHORT_LONG);
  END;

  FUNCTION GET_EMPLOYEE_AGE_MONTHS(pTAB_ID NUMBER) RETURN NUMBER IS
    --Возвращает возраст работника в месяцах
    -- pTAB_ID - табельный номер работника
    vRESULT NUMBER;
  BEGIN
    SELECT months_between(nvl(date_lost
                             ,nvl2(guess_year || guess_month || guess_day
                                  ,to_date(to_char(nvl(guess_year
                                                      ,to_char(SYSDATE
                                                              ,'yyyy'))) || lpad(nvl(guess_month
                                                                                    ,1)
                                                                                ,2
                                                                                ,'0') || lpad(nvl(guess_day
                                                                                                 ,1)
                                                                                             ,2
                                                                                             ,'0')
                                          ,'yyyymmdd')
                                  ,SYSDATE))
                         ,osn.data_r) age
      INTO vRESULT
      FROM qwerty.sp_ka_lost l
          ,qwerty.sp_ka_osn  osn
     WHERE osn.id_tab = pTAB_ID
       AND osn.id_tab = l.id_tab(+)
       AND l.lost_type(+) = 1;
  
    RETURN vRESULT;
  END;

  FUNCTION GET_EMPLOYEE_AGE(pTAB_ID     NUMBER
                           ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Возвращает возраст работника
    -- pTAB_ID - табельный номер работника
    -- pSHORT_LONG - формат возвращаемой строки:
    -- при pSHORT_LONG=1: "Xл. Xм."     
    --     pSHORT_LONG=2: "X лет X мес."
    --  другое значение : "X лет X месяцев"
  BEGIN
    RETURN STAG_TO_CHAR(GET_EMPLOYEE_AGE_MONTHS(pTAB_ID)
                       ,pSHORT_LONG);
  END;

  FUNCTION FORMAT_PHONE_NUMBER(pPHONE_NUMBER VARCHAR2
                              ,pCITY_CODE    NUMBER DEFAULT 0) RETURN VARCHAR2 IS
    --Возвращает номер телефона заданные параметром pPHONE_NUMBER в форматированном виде
    -- (XXX) XXX-XX-XX    
    -- pCITY_CODE - код города (пока что только 758-, 759- к заводскому номеру)
    --             0 - не добавлять код города
    --  другое число - добавить код города
    vPHONE_NUMBER VARCHAR2(500);
  BEGIN
    vPHONE_NUMBER := lpad(translate(pPHONE_NUMBER
                                   ,'0123456789- '
                                   ,'0123456789')
                         ,10
                         ,' ');
    vPHONE_NUMBER := ltrim(REPLACE('(' || substr(vPHONE_NUMBER
                                                ,1
                                                ,3) || ') ' || substr(vPHONE_NUMBER
                                                                     ,4
                                                                     ,3) || '-' || substr(vPHONE_NUMBER
                                                                                         ,7
                                                                                         ,2) || '-' || substr(vPHONE_NUMBER
                                                                                                             ,9
                                                                                                             ,2)
                                  ,'(   )'
                                  ,'*')
                          ,' *-');
  
    IF pCITY_CODE = 2 THEN
      IF LENGTH(vPHONE_NUMBER) = 5 THEN
        CASE SUBSTR(vPHONE_NUMBER
               ,1
               ,1)
          WHEN '3' THEN
            vPHONE_NUMBER := '759-' || vPHONE_NUMBER;
          WHEN '6' THEN
            vPHONE_NUMBER := '758-' || vPHONE_NUMBER;
          ELSE
            NULL;
        END CASE;
      END IF;
    END IF;
  
    RETURN vPHONE_NUMBER;
  END;

  FUNCTION GET_EMPLOYEE_PHONE(pTAB_ID     NUMBER
                             ,pPHONE_TYPE NUMBER DEFAULT 0
                             ,pFORMAT     NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Возвращает телефон (телефоны) работника
    -- pTAB_ID - табельный номер работника
    -- pPHONE_TYPE:
    --         1      - рабочий телефон
    --        -1      - все, кроме рабочего телефона
    --         2      - домашний телефон
    --        -2      - все, кроме домашнего телефона
    --         3      - мобильный телефон, рабочий
    --        -3      - все, кроме рабочего мобильного телефона 
    --         4      - мобильный телефон, домашний
    --        -4      - все, кроме домашнего мобильного телефона     
    --        13      - рабочий и мобильный рабочий телефоны
    --       -13      - все, кроме рабочего и мобильного рабочего телефонов
    --        24      - домашний и мобильный личный телефоны
    --       -24      - все, кроме домашнего и мобильного личного телефонов
    --   другое число - все доступные телефоны
    -- pFORMAT:
    --         0      - не форматировать телефонные номера
    --         2      - отформатировать (по возможности) телефонные номера, ДОБАВЛЯЯ код города
    --   другое число - отформатировать (по возможности) телефонные номера    
    vCURSOR SYS_REFCURSOR;
    vROW    QWERTY.SP_KA_TELEF%ROWTYPE;
  
    vPHONE_NUMBER VARCHAR2(500);
  BEGIN
    CASE pPHONE_TYPE
    -- только...
      WHEN 1 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'рабочий' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor = 1
           ORDER BY num_tel;
      WHEN 2 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'домашний' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor = 2
           ORDER BY num_tel;
      WHEN 3 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'мобильный, рабочий' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor = 3
           ORDER BY num_tel;
      WHEN 4 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'мобильный, домашний' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor = 4
           ORDER BY num_tel;
      WHEN 13 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'рабочий и мобильный рабочий' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor IN (1
                            ,3)
           ORDER BY hom_wor
                   ,num_tel;
      WHEN 24 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'домашний и мобильный личные' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor IN (2
                            ,4)
           ORDER BY hom_wor
                   ,num_tel;
        -- все телефоны, кроме...
      WHEN -1 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'рабочий' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor <> 1
           ORDER BY hom_wor
                   ,num_tel;
      WHEN -2 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'домашний' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor <> 2
           ORDER BY hom_wor
                   ,num_tel;
      WHEN -3 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'мобильный, рабочий' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor <> 3
           ORDER BY hom_wor
                   ,num_tel;
      WHEN -4 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'мобильный, домашний' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor <> 4
           ORDER BY hom_wor
                   ,num_tel;
      WHEN -13 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'рабочий и мобильный рабочий' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor NOT IN (1
                                ,3)
           ORDER BY hom_wor
                   ,num_tel;
      WHEN -24 THEN
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, 'домашний и мобильный личные' phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
             AND hom_wor NOT IN (2
                                ,4)
           ORDER BY hom_wor
                   ,num_tel;
      ELSE
        -- все номера телефонов
        OPEN vCURSOR FOR
          SELECT id_tab
                ,num_tel phone_number
                ,hom_wor phone_type /*, decode(hom_wor, 1, 'рабочий', 2, 'домашний', 3, 'мобильный', 'не определен') phone_type_text*/
            FROM qwerty.sp_ka_telef
           WHERE id_tab = pTAB_ID
           ORDER BY hom_wor
                   ,num_tel;
    END CASE;
  
    vPHONE_NUMBER := '';
  
    LOOP
      FETCH vCURSOR
        INTO vROW;
      EXIT WHEN vCURSOR%NOTFOUND;
    
      -- здесь будет форматирование телефонного номера
      IF pFORMAT <> 0 THEN
        vPHONE_NUMBER := vPHONE_NUMBER || ', ' || FORMAT_PHONE_NUMBER(vROW.NUM_TEL
                                                                     ,pFORMAT);
      ELSE
        vPHONE_NUMBER := vPHONE_NUMBER || ', ' || vROW.NUM_TEL;
      END IF;
    END LOOP;
  
    vPHONE_NUMBER := LTRIM(vPHONE_NUMBER
                          ,', ');
  
    RETURN vPHONE_NUMBER;
  END;

  FUNCTION GET_INFO_BY_INN(pINN VARCHAR2) RETURN tEMPLOYEE_INFO
    PIPELINED IS
    --Возвращает информацию о пользователе по заданному налоговому коду 
    -- в виде таблицы со следующими полями:
    --  - Таб. №
    --  - Ф.И.О. на русском языке
    --  - Ф.И.О. на украинском языке
    --  - Налоговый код
    --  - Дата рождения
    --  - Паспортные данные
  
    vCURSOR SYS_REFCURSOR;
  
    vROW recEMPLOYEE_INFO;
  
    vPASSPORT_SERIA VARCHAR2(2);
    vPASSPORT_NUM   NUMBER;
    vINN            VARCHAR2(10);
  BEGIN
    vINN := TRIM(TRANSLATE(pINN
                          ,'0123456789'
                          ,'          '));
    IF NVL(LENGTH(vINN)
          ,0) = 0 THEN
      -- Значит у нас в коде только числа
      OPEN vCURSOR FOR
        SELECT rbf.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio_rus
              ,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r fio_ukr
              ,to_char(osn.id_nalog) inn
              ,osn.data_r date_of_birth
              ,qwerty.hr.GET_EMPLOYEE_PASSPORT(rbf.id_tab
                                              ,1
                                              ,1) passport_info
          FROM qwerty.sp_rb_fio rbf
              ,qwerty.sp_ka_osn osn
         WHERE osn.id_nalog = to_number(pINN)
           AND osn.id_tab = rbf.id_tab;
    ELSE
      -- Отказник
      -- необходимо в предоставленном коде выделить серию и номер паспорта
      --  серия:
      vPASSPORT_SERIA := UPPER(TRIM(TRANSLATE(vINN
                                             ,'_'
                                             ,' ')));
      --  номер паспорта:
      vPASSPORT_NUM := TRIM(TRANSLATE(pINN
                                     ,vINN
                                     ,' '));
    
      OPEN vCURSOR FOR
        SELECT rbf.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio_rus
              ,rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r fio_ukr
              ,osnn.id_nalog inn
              ,osn.data_r date_of_birth
              ,qwerty.hr.GET_EMPLOYEE_PASSPORT(rbf.id_tab
                                              ,1
                                              ,1) passport_info
          FROM qwerty.sp_rb_fio       rbf
              ,qwerty.sp_ka_osn       osn
              ,qwerty.sp_ka_osn_nalog osnn
         WHERE UPPER(osnn.id_nalog) = vPASSPORT_SERIA || '  ' || vPASSPORT_NUM
           AND osnn.id_tab = osn.id_tab
           AND osnn.id_tab = rbf.id_tab;
    END IF;
  
    LOOP
      FETCH vCURSOR
        INTO vROW;
      EXIT WHEN vCURSOR%NOTFOUND;
    
      PIPE ROW(vROW);
    END LOOP;
    CLOSE vCURSOR;
  
    RETURN;
  END GET_INFO_BY_INN;

  FUNCTION GET_FIO_BY_TAB(pTAB_ID     NUMBER
                         ,pLANG       NUMBER DEFAULT 1
                         ,pSHORT_LONG NUMBER DEFAULT 1) RETURN VARCHAR2 IS
    --Возвращает Ф.И.О. работника с заданным табельным номером
    -- pTAB_ID - табельный номер работника 
    -- pLANG:
    --   1               - русский язык,
    --   другое значение - украинский язык
    -- pSHORT_LONG:
    --   1               - Фамилия Имя Отчество
    --   2               - Фамилия И.О.
    --   3               - И.О. Фамилия
    vSURNAME    VARCHAR2(30);
    vNAME       VARCHAR2(30);
    vPATRONYMIC VARCHAR2(30);
    vRESULT     VARCHAR2(100);
  BEGIN
    IF pLANG = 1 THEN
      SELECT FAM_U
            ,F_NAME_U
            ,S_NAME_U
        INTO vSURNAME
            ,vNAME
            ,vPATRONYMIC
        FROM QWERTY.SP_RB_FIO
       WHERE ID_TAB = pTAB_ID;
    ELSE
      SELECT FAM_R
            ,F_NAME_R
            ,S_NAME_R
        INTO vSURNAME
            ,vNAME
            ,vPATRONYMIC
        FROM QWERTY.SP_RB_FIO
       WHERE ID_TAB = pTAB_ID;
    END IF;
  
    CASE pSHORT_LONG
      WHEN 1 THEN
        vRESULT := TRIM(vSURNAME || ' ' || vNAME || ' ' || vPATRONYMIC);
      WHEN 2 THEN
        vRESULT := TRIM(vSURNAME || ' ' || SUBSTR(vNAME
                                                 ,1
                                                 ,1) || '.' || SUBSTR(vPATRONYMIC
                                                                     ,1
                                                                     ,1) || '.');
      WHEN 3 THEN
        vRESULT := TRIM(SUBSTR(vNAME
                              ,1
                              ,1) || '.' || SUBSTR(vPATRONYMIC
                                                  ,1
                                                  ,1) || '. ' || vSURNAME);
      ELSE
        vRESULT := TRIM(vSURNAME || ' ' || vNAME || ' ' || vPATRONYMIC);
    END CASE;
  
    RETURN vRESULT;
  END GET_FIO_BY_TAB;

  FUNCTION GET_TAB_BY_FIO(pFIO VARCHAR2) RETURN tEMPLOYEE_INFO_SHORT
    PIPELINED IS
    --Возвращает Таб. № по Ф.И.О. работника
    -- pFIO - Ф.И.О. работника в виде:
    --   - Фамилия Имя Отчество
    --   - Фамилия И.О.
    --   - И.О. Фамилия
    -- pFIO может быть как на русском так и на украинском языках
    vCURSOR        SYS_REFCURSOR; -- курсор, с которым будем работать
    vFIO           VARCHAR2(100); -- внутренняя переменая с pFIO для дальнейшей обработки
    vNUM_OF_SPACES NUMBER; -- количество пробелов в Ф.И.О.
    vNUM_OF_POINTS NUMBER; -- количество точек в Ф.И.О.
    vROW           recEMPLOYEE_INFO_SHORT; -- строка курсора
  BEGIN
    -- займемся анализом полученного параметра
    vFIO := pFIO;
    -- удаляю пробелы слева и справа
    vFIO := TRIM(vFIO);
    -- считаю количество пробелов
    vNUM_OF_SPACES := LENGTH(vFIO) - LENGTH(REPLACE(vFIO
                                                   ,' '
                                                   ,''));
    -- считаю количество точек
    vNUM_OF_POINTS := LENGTH(vFIO) - LENGTH(REPLACE(vFIO
                                                   ,'.'
                                                   ,''));
  
    -- избавляемся от регистра символов
    vFIO := LOWER(vFIO);
    CASE vNUM_OF_SPACES
      WHEN 0 THEN
        -- Ни одного пробела - значит это что-то одно: фамилия, имя или отчество ИЛИ ВСЁ СЛИТНО!!! (e.g. И.О.Фамилия)
        OPEN vCURSOR FOR
          SELECT id_tab
                ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio_rus
                ,fam_r || ' ' || f_name_r || ' ' || s_name_r fio_ukr
            FROM qwerty.sp_rb_fio
           WHERE (lower(fam_u) = vFIO OR lower(f_name_u) = vFIO OR lower(s_name_u) = vFIO OR lower(fam_r) = vFIO OR lower(f_name_r) = vFIO OR lower(s_name_r) = vFIO);
      WHEN 1 THEN
        -- Один пробел - значит это Фамилия И.О. (И.О. Фамилия) или комбинация двух из трёх параметров - фамилии, имени и отчества
        -- проверяю есть ли точки
        CASE vNUM_OF_POINTS
          WHEN 0 THEN
            -- один пробел и точек нет, значит это комбинация
            -- для двух параметров пока что рассмотрю ситуацию "Фамилия Имя" или "Имя Отчество"
            OPEN vCURSOR FOR
              SELECT id_tab
                    ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio_rus
                    ,fam_r || ' ' || f_name_r || ' ' || s_name_r fio_ukr
                FROM qwerty.sp_rb_fio
               WHERE (lower(fam_u || ' ' || f_name_u) = vFIO OR lower(f_name_u || ' ' || s_name_u) = vFIO OR lower(f_name_u || ' ' || fam_u) = vFIO OR lower(fam_r || ' ' || f_name_r) = vFIO OR lower(f_name_r || ' ' || s_name_r) = vFIO OR lower(f_name_r || ' ' || fam_r) = vFIO);
          WHEN 1 THEN
            -- один пробел и одна точка - "Фамилия И." или "И. Фамилия"
            OPEN vCURSOR FOR
              SELECT id_tab
                    ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio_rus
                    ,fam_r || ' ' || f_name_r || ' ' || s_name_r fio_ukr
                FROM qwerty.sp_rb_fio
               WHERE (lower(fam_u || ' ' || substr(f_name_u
                                                  ,1
                                                  ,1)) || '.' = vFIO OR lower(substr(f_name_u
                                                                                     ,1
                                                                                     ,1) || '. ' || fam_u) = vFIO OR lower(fam_r || ' ' || substr(f_name_r
                                                                                                                                                  ,1
                                                                                                                                                  ,1)) || '.' = vFIO OR
                     lower(substr(f_name_r
                                  ,1
                                  ,1) || '. ' || fam_r) = vFIO);
          WHEN 2 THEN
            -- один пробел и две точки - "Фамилия И.О." или "И.О. Фамилия"
            /*
            -- заменяю "И. О." на "И.О." (при этом "И.О. Фамилия" заменится на "И.О.Фамилия")
            vFIO := REPLACE(vFIO,
                            '. ',
                            '.');
            */
            OPEN vCURSOR FOR
              SELECT id_tab
                    ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio_rus
                    ,fam_r || ' ' || f_name_r || ' ' || s_name_r fio_ukr
                FROM qwerty.sp_rb_fio
               WHERE (lower(fam_u || ' ' || substr(f_name_u
                                                  ,1
                                                  ,1) || '.' || substr(s_name_u
                                                                      ,1
                                                                      ,1)) || '.' = vFIO OR lower(substr(f_name_u
                                                                                                         ,1
                                                                                                         ,1) || '.' || substr(s_name_u
                                                                                                                             ,1
                                                                                                                             ,1) || '. ' || fam_u) = vFIO OR
                     lower(fam_r || ' ' || substr(f_name_r
                                                  ,1
                                                  ,1) || '.' || substr(s_name_r
                                                                      ,1
                                                                      ,1)) || '.' = vFIO OR lower(substr(f_name_r
                                                                                                         ,1
                                                                                                         ,1) || '.' || substr(s_name_r
                                                                                                                             ,1
                                                                                                                             ,1) || '. ' || fam_r) = vFIO);
          ELSE
            -- один пробел и точек больше двух - такого быть не должно!!!
            NULL;
        END CASE;
      WHEN 2 THEN
        -- Два пробела - значит у нас все три составлющих Ф.И.О.
        CASE vNUM_OF_POINTS
          WHEN 0 THEN
            -- два пробела и точек нет - у нас "Фамилия Имя Отчество"
            OPEN vCURSOR FOR
              SELECT id_tab
                    ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio_rus
                    ,fam_r || ' ' || f_name_r || ' ' || s_name_r fio_ukr
                FROM qwerty.sp_rb_fio
               WHERE (lower(fam_u || ' ' || f_name_u || ' ' || s_name_u) = vFIO OR lower(f_name_u || ' ' || s_name_u || ' ' || fam_u) = vFIO OR lower(fam_r || ' ' || f_name_r || ' ' || s_name_r) = vFIO OR lower(f_name_r || ' ' || s_name_r || ' ' || fam_r) = vFIO);
          WHEN 1 THEN
            -- два пробела и одна точка - странная ситуация: имя или отчество даны одной буквой с точкой
            NULL;
          WHEN 2 THEN
            -- два пробела и две точки - у нас "Фамилия И. О." или "И. О. Фамилия"
            OPEN vCURSOR FOR
              SELECT id_tab
                    ,fam_u || ' ' || f_name_u || ' ' || s_name_u fio_rus
                    ,fam_r || ' ' || f_name_r || ' ' || s_name_r fio_ukr
                FROM qwerty.sp_rb_fio
               WHERE (lower(fam_u || ' ' || substr(f_name_u
                                                  ,1
                                                  ,1) || '. ' || substr(s_name_u
                                                                       ,1
                                                                       ,1)) || '.' = vFIO OR lower(fam_r || ' ' || substr(f_name_r
                                                                                                                          ,1
                                                                                                                          ,1) || '. ' || substr(s_name_r
                                                                                                                                               ,1
                                                                                                                                               ,1)) || '.' = vFIO OR
                     lower(substr(f_name_u
                                  ,1
                                  ,1) || '. ' || substr(s_name_u
                                                       ,1
                                                       ,1) || '. ' || fam_u) = vFIO OR lower(substr(f_name_r
                                                                                                    ,1
                                                                                                    ,1) || '. ' || substr(s_name_r
                                                                                                                         ,1
                                                                                                                         ,1) || '. ' || fam_r) = vFIO);
          ELSE
            -- всех ситуаций не учесть :(
            NULL;
        END CASE;
      ELSE
        -- всех ситуаций не учесть :(
        NULL;
    END CASE;
  
    -- проверяю открыт ли курсор
    IF vCURSOR%ISOPEN THEN
      -- если открыт, то обрабатываю записи
      LOOP
        FETCH vCURSOR
          INTO vROW;
        EXIT WHEN vCURSOR%NOTFOUND;
      
        PIPE ROW(vROW);
      END LOOP;
      CLOSE vCURSOR;
    END IF; -- открыт ли курсор
  
    RETURN;
  END GET_TAB_BY_FIO;

  FUNCTION GET_OTPUSK_SETTLEMENT_DATE(pTAB_ID   NUMBER
                                     ,pOTP_ID   NUMBER
                                     ,pOTP_DATE DATE) RETURN DATE IS
    --Возвращает дату расчета для отпуска работника по виду отпуска и дате его оформления
    -- pTAB_ID - табельный номер работника
    -- pOTP_ID - вид отпуска
    -- pOTP_DATE - дата отпуска (для остатка с компенсацией обрезанная дата редактирования)
    vSETTLEMENT_DATE DATE;
  BEGIN
    SELECT DISTINCT DATA_SC
      INTO vSETTLEMENT_DATE
      FROM COUNT.SP_ZAR_OTP_VID
     WHERE ID_TAB = pTAB_ID
       AND ID_OTP = pOTP_ID
          --and ID_VID = 66 -- это актуально только для компенсации! Добавлено для ускорения работы, т.к. ID_VID часть PRIMARY KEY
       AND DATA_NK = pOTP_DATE;
  
    RETURN vSETTLEMENT_DATE;
  END GET_OTPUSK_SETTLEMENT_DATE;

  FUNCTION GET_DEPARTMENTS(pLANG            NUMBER DEFAULT 1
                          ,pWHERE_CLAUSE    VARCHAR2
                          ,pORDER_BY_CLAUSE VARCHAR2) RETURN tDEPARTMENT_INFO
    PIPELINED IS
    --Возвращает список цехов (подразделений) на необходимом языке по заданному условию и в определенном порядке
    -- pLANG:
    --   1 - русский язык,
    --   другое значение - украинский язык
    -- pWHERE_CLAUSE    - фраза WHERE для запроса
    -- pORDER_BY_CLAUSE - фраза ORDER BY для запроса
    vCURSOR     SYS_REFCURSOR; -- курсор, с которым будем работать
    vROW        recDEPARTMENT_INFO;
    vQUERY_TEXT VARCHAR2(1000);
  BEGIN
    vQUERY_TEXT := 'select ID_CEX, ';
    IF pLANG = 1 THEN
      vQUERY_TEXT := vQUERY_TEXT || 'NAME_U, NAM, ';
    ELSE
      vQUERY_TEXT := vQUERY_TEXT || 'NAME_R, NAM_R, ';
    END IF;
    vQUERY_TEXT := vQUERY_TEXT || 'PARENT_ID, TYPE_MASK, OLD_IDC, OLD_IDP, FL from SP_PODR ';
  
    IF LENGTH(pWHERE_CLAUSE) <> 0 THEN
      vQUERY_TEXT := vQUERY_TEXT || 'where ' || pWHERE_CLAUSE;
    END IF;
  
    IF LENGTH(pORDER_BY_CLAUSE) <> 0 THEN
      vQUERY_TEXT := vQUERY_TEXT || 'order by ' || pORDER_BY_CLAUSE;
    END IF;
  
    OPEN vCURSOR FOR vQUERY_TEXT;
  
    -- проверяю открыт ли курсор
    IF vCURSOR%ISOPEN THEN
      -- если открыт, то обрабатываю записи
      LOOP
        FETCH vCURSOR
          INTO vROW;
        EXIT WHEN vCURSOR%NOTFOUND;
      
        PIPE ROW(vROW);
      END LOOP;
      CLOSE vCURSOR;
    END IF; -- открыт ли курсор
  
    RETURN;
  END;

  FUNCTION GET_WORD_STATISTICS(pTABLE_NAME      VARCHAR2
                              ,pWORD_FIELD_NAME VARCHAR2
                              ,pID_FIELD_NAME   VARCHAR2
                              ,pID_FIELD_VALUE  NUMBER DEFAULT -999) RETURN tWORD_INFO
    PIPELINED IS
    vCURSOR     SYS_REFCURSOR;
    vROW        recWORD_INFO;
    vCUR_ROW    recWORD_INFO;
    vQUERY_TEXT VARCHAR2(1000);
    i           NUMBER;
    j           NUMBER;
  BEGIN
    vQUERY_TEXT := 'select distinct TRIM(' || pWORD_FIELD_NAME || '), ' || pID_FIELD_NAME || ', 1 from ' || pTABLE_NAME; -- || ' order by ' || pID_FIELD_NAME;
    -- выборка по определённому ID
    IF pID_FIELD_VALUE <> -999 THEN
      vQUERY_TEXT := vQUERY_TEXT || ' where ' || pID_FIELD_NAME || ' = ' || pID_FIELD_VALUE;
    END IF;
  
    OPEN vCURSOR FOR vQUERY_TEXT;
  
    IF vCURSOR%ISOPEN THEN
      LOOP
        FETCH vCURSOR
          INTO vROW;
        EXIT WHEN vCURSOR%NOTFOUND;
      
        -- выберем слова и словосочетания от конца к началу
        j := -1;
        i := 1;
        WHILE (INSTR(vROW.WORD
                    ,' '
                    ,j
                    ,i) <> 0)
        LOOP
          vCUR_ROW.WORD     := SUBSTR(vROW.WORD
                                     ,INSTR(vROW.WORD
                                           ,' '
                                           ,j
                                           ,i) + 1
                                     ,LENGTH(vROW.WORD));
          vCUR_ROW.ID_MEST  := vROW.ID_MEST;
          vCUR_ROW.WORD_POS := sign(j) * i;
        
          IF NOT (TRIM(vCUR_ROW.WORD) IS NULL) THEN
            PIPE ROW(vCUR_ROW);
          END IF;
        
          i := i + 1;
        END LOOP;
      
        -- выберем слова и словосочетания с начала к концу
        j := 1;
        i := 1;
        WHILE (INSTR(vROW.WORD
                    ,' '
                    ,j
                    ,i) <> 0)
        LOOP
          vCUR_ROW.WORD     := SUBSTR(vROW.WORD
                                     ,1
                                     ,INSTR(vROW.WORD
                                           ,' '
                                           ,j
                                           ,i) - 1);
          vCUR_ROW.ID_MEST  := vROW.ID_MEST;
          vCUR_ROW.WORD_POS := i;
        
          IF NOT (TRIM(vCUR_ROW.WORD) IS NULL) THEN
            PIPE ROW(vCUR_ROW);
          END IF;
        
          i := i + 1;
        END LOOP;
      
        vCUR_ROW.WORD     := vROW.WORD;
        vCUR_ROW.ID_MEST  := vROW.ID_MEST;
        vCUR_ROW.WORD_POS := i;
        PIPE ROW(vCUR_ROW);
      END LOOP;
    END IF; -- открыт ли курсор
  
    RETURN;
  END GET_WORD_STATISTICS;

  FUNCTION GET_COMPANY_ADDRESS(pCOMPANY_NAME VARCHAR2 DEFAULT '*') RETURN tLFA1
    PIPELINED IS
    --Возвращает информацию о компании с именем pCOMPANY_NAME из SAP
    vCURSOR     SYS_REFCURSOR;
    vROW        recSAP_LFA1;
    vQUERY_TEXT VARCHAR2(1000);
  BEGIN
    IF pCOMPANY_NAME = '*' THEN
      vQUERY_TEXT := 'select lfa.NAME1, t005.LANDX50, lfa.ORT01, lfa.STRAS, lfa.PSTLZ 
                        from LFA1@qwertysap.oasu lfa, T005T@qwertysap.oasu t005 
                       where SUBSTR(lfa.LIFNR, 1, 1) <> ''Z'' and lfa.MANDT = t005.MANDT and lfa.LAND1 = t005.LAND1 and t005.SPRAS = ''8''
                      union
                      select kna.NAME1, t005.LANDX50, kna.ORT01, kna.STRAS, kna.PSTLZ 
                        from KNA1@qwertysap.oasu kna, T005T@qwertysap.oasu t005
                       where SUBSTR(kna.KUNNR, 1, 1) <> ''Z'' and kna.MANDT = t005.MANDT and kna.LAND1 = t005.LAND1 and t005.SPRAS = ''8''';
    ELSIF (INSTR(pCOMPANY_NAME
                ,'%') <> 0) OR (INSTR(pCOMPANY_NAME
                                     ,'_') <> 0) THEN
      vQUERY_TEXT := 'select lfa.NAME1, t005.LANDX50, lfa.ORT01, lfa.STRAS, lfa.PSTLZ 
                        from LFA1@qwertysap.oasu lfa, T005T@qwertysap.oasu t005 
                       where SUBSTR(lfa.LIFNR, 1, 1) <> ''Z'' and lfa.MANDT = t005.MANDT and lfa.LAND1 = t005.LAND1 and t005.SPRAS = ''8'' and UPPER(NAME1) like ''' || UPPER(pCOMPANY_NAME) || '''
                      union
                      select kna.NAME1, t005.LANDX50, kna.ORT01, kna.STRAS, kna.PSTLZ 
                        from KNA1@qwertysap.oasu kna, T005T@qwertysap.oasu t005
                       where SUBSTR(kna.KUNNR, 1, 1) <> ''Z'' and kna.MANDT = t005.MANDT and kna.LAND1 = t005.LAND1 and t005.SPRAS = ''8'' and UPPER(NAME1) like ''' || UPPER(pCOMPANY_NAME) || '''';
    ELSE
      vQUERY_TEXT := 'select lfa.NAME1, t005.LANDX50, lfa.ORT01, lfa.STRAS, lfa.PSTLZ 
                        from LFA1@qwertysap.oasu lfa, T005T@qwertysap.oasu t005 
                       where SUBSTR(lfa.LIFNR, 1, 1) <> ''Z'' and lfa.MANDT = t005.MANDT and lfa.LAND1 = t005.LAND1 and t005.SPRAS = ''8'' and UPPER(NAME1) = ''' || UPPER(pCOMPANY_NAME) || '''
                      union
                      select kna.NAME1, t005.LANDX50, kna.ORT01, kna.STRAS, kna.PSTLZ 
                        from KNA1@qwertysap.oasu kna, T005T@qwertysap.oasu t005
                       where SUBSTR(kna.KUNNR, 1, 1) <> ''Z'' and kna.MANDT = t005.MANDT and kna.LAND1 = t005.LAND1 and t005.SPRAS = ''8'' and UPPER(NAME1) = ''' || UPPER(pCOMPANY_NAME) || '''';
    END IF;
  
    OPEN vCURSOR FOR vQUERY_TEXT;
  
    IF vCURSOR%ISOPEN THEN
      LOOP
        FETCH vCURSOR
          INTO vROW;
        EXIT WHEN vCURSOR%NOTFOUND;
      
        PIPE ROW(vROW);
      END LOOP;
    END IF; -- открыт ли курсор
  
    RETURN;
  END GET_COMPANY_ADDRESS;

  --**************************************************************************************************************************************************************************
  --
  --!!!!!UNFINISHED!!!!!
  --НЕЗАВЕРШЁННОЕ!!! В СТАДИИ РАЗРАБОТКИ
  --
  --**************************************************************************************************************************************************************************

  FUNCTION TRANSLATE_TEXT(pTEXT VARCHAR2) RETURN VARCHAR2 IS
    --Возвращает перевод предложения pTEXT (по словам) с русского языка на украинский
    vRESULT VARCHAR2(1000);
    --vWORDS     tARRAY_OF_STRING;
    vSPACE_POS NUMBER;
  BEGIN
    vRESULT := pTEXT;
  
    vSPACE_POS := -1;
    WHILE 1 = 1
    LOOP
      SELECT INSTR(pTEXT
                  ,' '
                  ,vSPACE_POS + 1)
        INTO vSPACE_POS
        FROM DUAL;
    
    END LOOP;
  
    RETURN vRESULT;
  END TRANSLATE_TEXT;

  --
  --!!!!!UNFINISHED!!!!!
  --НЕЗАВЕРШЁННОЕ!!! В СТАДИИ РАЗРАБОТКИ
  --

  FUNCTION PACKAGE_INFO RETURN VARCHAR2 IS
    vRESULT VARCHAR2(200);
  BEGIN
    vRESULT := 'Пакет с набором функций для работы с данными отдела кадров';
  
    RETURN vRESULT;
  END;

  FUNCTION FUNCTION_INFO(pFUNCTION_NAME VARCHAR2) RETURN VARCHAR2 IS
    vRESULT VARCHAR2(500);
  BEGIN
    CASE pFUNCTION_NAME
      WHEN 'GET_OTPUSK_SETTLEMENT_DATE' THEN
        vRESULT := cGET_OTPUSK_SETTLEMENT_DATE;
      WHEN 'GET_TAB_BY_FIO' THEN
        vRESULT := cGET_TAB_BY_FIO;
      ELSE
        vRESULT := 'Описание не найдено';
    END CASE;
  
    RETURN vRESULT;
  END;

  --В стадии разработки!!!!!!!!!
  FUNCTION KADR_UVOL_STAT(pTAB_ID    NUMBER
                         ,pUVOL_ID   NUMBER
                         ,pUVOL_DATE DATE
                         ,pZAP_DATE  DATE
                         ,pPRIKAZ_ID VARCHAR2) RETURN BOOLEAN IS
    vWORK_STAG NUMBER; --стаж работника, для пенсионеров
    vFLAG      NUMBER; --флаг для сигнала есть/нет записи в таблице
    vARX_CEX   NUMBER; --код названия цеха из архива
    vARX_KAT   NUMBER; --код названия категории из архива
    vARX_MEST  NUMBER; --код названия рабочего места из архива
    vTMPZAM    NUMBER; --флаг для сигнала заменял/не заменял
  BEGIN
    --устанавливаем статус работника в 2 - уволен
    UPDATE QWERTY.SP_RB_FIO SET status = 2 WHERE id_tab = pTAB_ID;
  
    --***************** ДЛЯ ПЕНСИОНЕРОВ *****************
    --если работник увольняется на пенсию, заносим данные о нем таблицу пенсионеров QWERTY.SP_KA_PENS_ALL
    IF pUVOL_ID IN (30
                   ,36
                   ,69
                   ,70
                   ,71
                   ,79) THEN
      --Вычисляем стаж
      SELECT NVL(ROUND(sum_sta_day - MONTHS_BETWEEN(sta.data
                                                   ,pUVOL_DATE))
                ,0)
        INTO vWORK_STAG
        FROM QWERTY.SP_KAV_STA_OPZ_ITOG_ALL it
            ,QWERTY.SP_ZAR_DATA_STAG        sta
       WHERE id_tab = pTAB_ID;
      --Записывем данные в таблицу пенсионеров
      INSERT INTO QWERTY.SP_KA_PENS_ALL (ID_TAB, DAT_UVOL, ID_UVOL, KTO, STAG) VALUES (pTAB_ID, pUVOL_DATE, pUVOL_ID, 1, vWORK_STAG);
    
      --SP_ZAR_SPENS
      INSERT INTO QWERTY.SP_ZAR_SPENS (ID_CEX, ID_TAB, U_OKL, OKLAD, SUM_AVANS, ID_DOPL, SUM_DOPL, NALOG, U_PROEZD, U_MILK, U_15) VALUES (8600, pTAB_ID, 'O', 0, 0, 0, 0, 110, 0, 0, 1);
    END IF;
    --***************************************************
    --если работник увольняется в связи со смертью, заносим данные о нем в таблицу QWERTY.SP_KA_LOST
    IF pUVOL_ID = 31 THEN
      INSERT INTO QWERTY.SP_KA_LOST (ID_TAB, DATE_LOST, LOST_TYPE) VALUES (pTAB_ID, pUVOL_DATE, 1);
    END IF;
  
    --Проверка на название цеха.
    SELECT COUNT(*)
      INTO vFLAG
      FROM QWERTY.SP_ARX_CEX ac
          ,QWERTY.SP_PODR    p
          ,QWERTY.SP_STAT    s
          ,QWERTY.SP_RB_KEY  k
     WHERE ac.name_u = p.name_u
       AND p.id_cex = s.id_cex
       AND s.id_stat = k.id_stat
       AND k.id_tab = pTAB_ID;
    IF (vFLAG = 1) THEN
      --если в архиве названий цехов есть такое название
      SELECT ac.id
        INTO vARX_CEX
        FROM QWERTY.SP_ARX_CEX ac
            ,QWERTY.SP_PODR    p
            ,QWERTY.SP_STAT    s
            ,QWERTY.SP_RB_KEY  k
       WHERE ac.name_u = p.name_u
         AND p.id_cex = s.id_cex
         AND s.id_stat = k.id_stat
         AND k.id_tab = pTAB_ID;
    ELSE
      --если нет - добавляем
      SELECT MAX(ac.id) + 1 INTO vARX_CEX FROM QWERTY.SP_ARX_CEX ac;
    
      INSERT INTO QWERTY.SP_ARX_CEX
        (ID, NAME_U, NAME_R)
        SELECT vARX_CEX
              ,p.name_u
              ,p.name_r
          FROM QWERTY.SP_PODR   p
              ,QWERTY.SP_STAT   s
              ,QWERTY.SP_RB_KEY k
         WHERE p.id_cex = s.id_cex
           AND s.id_stat = k.id_stat
           AND k.id_tab = pTAB_ID;
    END IF;
  
    --Проверка на название категории.
    SELECT COUNT(*)
      INTO vFLAG
      FROM QWERTY.SP_ARX_KAT ak
          ,QWERTY.SP_KAT     kat
          ,QWERTY.SP_STAT    s
          ,QWERTY.SP_RB_KEY  k
     WHERE ak.name_u = kat.name_u
       AND kat.id_kat = s.id_kat
       AND s.id_stat = k.id_stat
       AND k.id_tab = pTAB_ID;
    IF (vFLAG = 1) THEN
      --если в архиве названий категорий есть категория с таким названием
      SELECT ak.id
        INTO vARX_KAT
        FROM QWERTY.SP_ARX_KAT ak
            ,QWERTY.SP_KAT     kat
            ,QWERTY.SP_STAT    s
            ,QWERTY.SP_RB_KEY  k
       WHERE ak.name_u = kat.name_u
         AND kat.id_kat = s.id_kat
         AND s.id_stat = k.id_stat
         AND k.id_tab = pTAB_ID;
    ELSE
      -- если нет - добавляем.
      SELECT MAX(ak.id) + 1 INTO vARX_KAT FROM QWERTY.SP_ARX_KAT ak;
    
      INSERT INTO QWERTY.SP_ARX_KAT
        (ID, NAME_U, NAME_R)
        SELECT vARX_KAT
              ,kat.name_u
              ,kat.name_r
          FROM QWERTY.SP_KAT    kat
              ,QWERTY.SP_STAT   s
              ,QWERTY.SP_RB_KEY k
         WHERE kat.id_kat = s.id_kat
           AND s.id_stat = k.id_stat
           AND k.id_tab = pTAB_ID;
    END IF;
  
    --Проверка на название должности
    SELECT COUNT(*)
      INTO vFLAG
      FROM QWERTY.SP_ARX_MEST am
          ,QWERTY.SP_MEST     m
          ,QWERTY.SP_STAT     s
          ,QWERTY.SP_RB_KEY   k
     WHERE am.full_name = m.full_name_u
       AND m.id_mest = s.id_mest
       AND s.id_stat = k.id_stat
       AND k.id_tab = pTAB_ID;
    IF (vFLAG = 1) THEN
      --если в архиве названий должностей есть должность с таким названием
      SELECT am.id
        INTO vARX_MEST
        FROM QWERTY.SP_ARX_MEST am
            ,QWERTY.SP_MEST     m
            ,QWERTY.SP_STAT     s
            ,QWERTY.SP_RB_KEY   k
       WHERE am.full_name = m.full_name_u
         AND m.id_mest = s.id_mest
         AND s.id_stat = k.id_stat
         AND k.id_tab = pTAB_ID;
    ELSE
      --если нет - добавляем
      SELECT MAX(am.id) + 1 INTO vARX_MEST FROM QWERTY.SP_ARX_MEST am;
    
      INSERT INTO QWERTY.SP_ARX_MEST
        (ID, NAME_U, NAME_R, FULL_NAME)
        SELECT vARX_MEST
              ,m.name_u
              ,m.name_r
              ,m.full_name_u
          FROM QWERTY.SP_MEST   m
              ,QWERTY.SP_STAT   s
              ,QWERTY.SP_RB_KEY k
         WHERE m.id_mest = s.id_mest
           AND s.id_stat = k.id_stat
           AND k.id_tab = pTAB_ID;
    END IF;
  
    --коммитим, чтобы с вновь вставленными названиями можно было уже работать.
    --:system.message_level := '10';
    COMMIT;
    --:system.message_level := '0';
  
    --SP_KA_PEREM
    --добавляем строку об увольнение человека.
    INSERT INTO QWERTY.SP_KA_PEREM
      (ID_TAB, ID_ZAP, DATA_ZAP, ID_WORK, DATA_WORK, DATA_KON, ID_PRIKAZ, ID_A_CEX, ID_A_KAT, ID_A_MEST, ID_A_KP, A_RAZR, ID_PEREM, ID_N_CEX, ID_N_KAT, ID_N_MEST)
      SELECT pTAB_ID
            ,w.id_zap
            , --:tools_uvol.data_zap, --Закомментировано по причине см. 3 строчки ниже
             w.data_zap
            ,w.id_work
            ,w.data_work
            ,pUVOL_DATE
            , --:tools_uvol.id_prikaz, --Закомментировано
             -- в связи с тем, что ранее терялся номер приказа,
             -- по которому работник был переведен на
             -- последнее место работы (затирался номером
             -- приказа на увольнение)
             w.id_prikaz
            ,s.id_cex
            ,s.id_kat
            ,s.id_mest
            ,s.id_kp
            ,w.razr
            ,64
            ,vARX_CEX
            ,vARX_KAT
            ,vARX_MEST
        FROM QWERTY.SP_KA_WORK w
            ,QWERTY.SP_STAT    s
            ,QWERTY.SP_RB_KEY  k
       WHERE w.id_tab = pTAB_ID
         AND w.id_tab = k.id_tab
         AND k.id_stat = s.id_stat;
  
    --определяем, заменял ли
    SELECT COUNT(*) INTO vTMPZAM FROM QWERTY.SP_KA_ZAM Z WHERE z.id_tab_w = pTAB_ID;
    --проверяем, был или нет
    IF (vTMPZAM >= 1) THEN
      --значит был
      --добавяем данные о заменах
      INSERT INTO QWERTY.SP_KA_ZPEREM
        (ID_TAB, ID_ZAP, ID_TAB_Z)
        SELECT z.id_tab_w
              ,w.id_zap
              ,z.id_tab_z
          FROM QWERTY.SP_KA_WORK w
              ,QWERTY.SP_KA_ZAM  z
         WHERE w.id_tab = z.id_tab_w
           AND z.id_tab_w = pTAB_ID;
      --удаляем устаревшие данные о заменах
      DELETE FROM QWERTY.SP_KA_ZAM WHERE id_tab_w = pTAB_ID;
    ELSE
      --значит не был
      NULL;
    END IF;
    --* ДОБАВЛЕНО 22.04.2010 (по просьбе Солоида/Дубовцевой)
    --ищем замены в другой таблице
    SELECT COUNT(*) INTO vTMPZAM FROM QWERTY.SP_KA_CEX_ZAM z WHERE z.id_tab = pTAB_ID;
    --если запись в таблице есть,..
    IF (vTMPZAM >= 1) THEN
      -- удаляем её
      DELETE FROM QWERTY.SP_KA_CEX_ZAM WHERE id_tab = pTAB_ID;
    END IF;
    --* end of ДОБАВЛЕНО 22.04.2010
  
    --SP_KA_UVOL
    --занесение записи об увольнении.
    --запись об увольнении должна быть на 1 больше соответствующем записи в sp_ka_perem
    INSERT INTO QWERTY.SP_KA_UVOL
      (ID_TAB, ID_ZAP, DATA_ZAP, ID_UVOL, DATA_UVOL, ID_PRIKAZ)
      SELECT pTAB_ID
            ,w.id_zap + 1
            ,pZAP_DATE
            ,pUVOL_ID
            ,pUVOL_DATE
            ,pPRIKAZ_ID
        FROM QWERTY.SP_KA_WORK w
       WHERE w.id_tab = pTAB_ID;
  
    --подтверждаем
    --:system.message_level := '10';
    COMMIT;
    --:system.message_level := '0';
  
    --SP_KA_WORK
    --удаляем запись от работе человека
    DELETE FROM QWERTY.SP_KA_WORK WHERE id_tab = pTAB_ID;
  
    --подтверждаем
    --:system.message_level := '10';
    COMMIT;
    --:system.message_level := '0';
  
    --SP_ZAR_SUWOL
    --добавляем данные о зарплате в sp_zar_suwol
    INSERT INTO QWERTY.SP_ZAR_SUWOL
      (ID_TAB, U_OKL, OKLAD, SUM_AVANS, ID_DOPL, SUM_DOPL, TIME_DAY, NALOG, U_VLKSM, SMENA, U_PROEZD, ID_STAT, DATA_UV, ID_BRI, UK_IO, U_MILK, U_PERE, U_15)
      SELECT sp.id_tab
            ,sp. u_okl
            ,sp.oklad
            ,sp.sum_avans
            ,sp.id_dopl
            ,sp.sum_dopl
            ,sp.time_day
            ,sp.nalog
            ,sp.u_vlksm
            ,sp.smena
            ,sp.u_proezd
            ,k.id_stat
            ,pUVOL_DATE
            ,sp.id_bri
            ,sp.uk_io
            ,sp.u_milk
            ,sp.u_pere
            ,sp.u_15
        FROM QWERTY.SP_ZAR_SWORK sp
            ,QWERTY.SP_RB_KEY    k
       WHERE sp.id_tab = k.id_tab
         AND sp.id_tab = pTAB_ID;
  
    --* 28.10.2010 Переносим выше в начало, где уже проверяется на пенсионера
    --SP_ZAR_SPENS
    --если увольняется пенсионер
    /*    if (pUVOL_ID in (30,36,69,70,71,79)) then
      insert into QWERTY.SP_ZAR_SPENS(
        ID_CEX, ID_TAB, U_OKL, OKLAD, SUM_AVANS, ID_DOPL, SUM_DOPL,
        NALOG, U_PROEZD, U_MILK, U_15)
      values (8600, pTAB_ID, 'O', 0, 0, 0, 0,
        110, 0, 0, 1);
    end if;*/
  
    --удаляем данные о зарплате из swork
    DELETE FROM QWERTY.SP_ZAR_SWORK WHERE id_tab = pTAB_ID;
    --удаляем связь человека со штатным расписанием
    DELETE FROM QWERTY.SP_RB_KEY WHERE id_tab = pTAB_ID;
  
    --* 06.02.2007
    --SP_KA_OSN
    --Инвертируем номер пропуска, чтобы не было двойственности в проходной, когда
    -- другому отдадут пропуск этого работника
    UPDATE QWERTY.SP_KA_OSN SET id_prop = -id_prop WHERE id_tab = pTAB_ID;
  
    --подтверждаем
    --:system.message_level := '10';
    COMMIT;
    /*
     TODO: owner="Bishop" category="Fix" priority="1 - High" created="28.10.2010"
     text="Разобраться с COMMIT-ами
           Если оставить так как есть, то ROLLBACK в случае неудачи откатит только до последнего COMMIT-а, а их в функции несколько.
                   
           Можно вполне оставить лишь те, которые после архива"
    */
    --:system.message_level := '0';
  
    RETURN(TRUE);
  
    /*    set_alert_property('alert', ALERT_MESSAGE_TEXT,
                       'Работник успешно уволен.');
    if(show_alert('alert')=ALERT_BUTTON1) then
      Hide_Window('w_uvol');
      Hide_view('c_uvol');
      go_block('sp_ka_work');
    end if;*/
  
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        ROLLBACK;
        RETURN(FALSE);
        /*set_alert_property('alert', ALERT_MESSAGE_TEXT,
                           'Произошла ошибка при увольнении. Обратитесь в отдел АСУ.'||sqlerrm);
        if(show_alert('alert')=ALERT_BUTTON1) then
          null;
        end if;
        raise form_trigger_failure;*/
      END;
  END KADR_UVOL_STAT;

  -- НОВЫЕ ФУНКЦИИ, проходящие тестирование
  -- Данные о работнике
  FUNCTION GET_EMPLOYEE_INFO(pTAB_ID NUMBER) RETURN tEMPLOYEE_INFO_WORK
    PIPELINED IS
  BEGIN
    NULL;
  END GET_EMPLOYEE_INFO;

BEGIN
  -- Initialization
  --<Statement>;
  NULL;
END HR_4TEST;
/
