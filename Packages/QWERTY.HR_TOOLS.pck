CREATE OR REPLACE PACKAGE QWERTY.HR_TOOLS IS

  -- Author  : BISHOP
  -- Created : 03.06.2015 14:39:20
  -- Purpose : Вспомогательные утилиты для работы с кадровскими данными

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

  -- Информация о пакете
  FUNCTION PACKAGE_INFO RETURN VARCHAR2;

  TYPE recEMPLOYEE_PROPERTIES IS RECORD(
     ID_TAB          QWERTY.SP_RB_FIO.ID_TAB%TYPE
    , -- Табельный номер работника
    PROPERTY_NAME   QWERTY.SP_PROPERTIES.NAME%TYPE
    , -- Наименование свойства
    PROPERTY_STRING VARCHAR2(500) -- Строка для отображения (объединяем наименование свойства со значениями)
    );
  TYPE tEMPLOYEE_PROPERTIES IS TABLE OF recEMPLOYEE_PROPERTIES;

  -- Дополнительные свойства работника, заданного табельным номером
  FUNCTION GET_EMPLOYEE_PROPERTIES(pTAB_ID NUMBER) RETURN tEMPLOYEE_PROPERTIES
    PIPELINED;

  -- Дополнительные свойства всех работников
  FUNCTION GET_ALL_EMPLOYEE_PROPERTIES RETURN tEMPLOYEE_PROPERTIES
    PIPELINED;

  -- Возвращает дату первого рабочего дня выбранного работника
  FUNCTION GET_EMPLOYEE_FIRST_WORKDAY(i_TAB_ID NUMBER) RETURN DATE;

  /**Возвращает количество праздничных дней за период с <b><i>i_FROM</i></b> по <b><i>i_TO</i></b>
    %param i_FROM дата начала периода
    %param i_TO   дата окончания периода
    %return       NUMBER
    %usage SELECT qwerty.hr_tools.NUM_OF_HOLIDAYS_BETWEEN(trunc(SYSDATE, 'YEAR'), SYSDATE) FROM dual
  */
  FUNCTION NUM_OF_HOLIDAYS_BETWEEN(i_FROM DATE
                                  ,i_TO   DATE) RETURN NUMBER;

  /**Возращает начало текущего периода очередного отпуска для работника с заданным табельным номером <b><i>i_TAB_ID</i></b>
    %param i_TAB_ID табельный номер работника
    %return DATE
    %usage SELECT qwerty.hr_tools.GET_EMPLOYEE_CURRENT_LEAVE_PERIOD(4875) FROM dual
  */
  FUNCTION GET_EMPLOYEE_LEAVE_PERIOD(i_TAB_ID NUMBER) RETURN DATE;

  /**Тип с данными о декретном отпуске и предыдущем периоде очередного отпуска
  */
  TYPE recMATERNITY_LEAVE IS RECORD(
     ID_TAB             QWERTY.SP_RB_FIO.ID_TAB%TYPE
    ,OTPUSK_NAME        QWERTY.SP_OTPUSK.NAME_U%TYPE
    ,N_DEKR             DATE
    ,K_DEKR             DATE
    ,DATE_VID           DATE
    ,DATE_WORK          DATE
    ,PREV_PERIOD_START  DATE
    ,PREV_PERIOD_FINISH DATE
    ,PERIOD_IS_OVER     NUMBER);
  TYPE tMATERNITY_LEAVES IS TABLE OF recMATERNITY_LEAVE;

  /**Возвращает данные о декретных отпусках работников и крайними пердшествующими им периодами очередного отпуска
    %usage SELECT * from TABLE(qwerty.hr_tools.GET_MATERNITY_LEAVES)
  */
  FUNCTION GET_MATERNITY_LEAVES RETURN tMATERNITY_LEAVES
    PIPELINED;

  FUNCTION GET_NEW_PERIOD(i_PREV_PERIOD_FINISH DATE
                         ,i_DEKRET_START       DATE
                         ,i_BACK_2_WORK        DATE) RETURN DATE;

END HR_TOOLS;
/
CREATE OR REPLACE PACKAGE BODY QWERTY.HR_TOOLS IS

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

  /*
  LIST of EXCEPTIONs:
    -20202: Количество декретных отпусков меньше нуля!? (GET_EMPLOYEE_LEAVE_PERIOD function)
  */

  FUNCTION PACKAGE_INFO RETURN VARCHAR2 IS
    vMSG VARCHAR2(500);
  BEGIN
    vMSG := 'Пакет содержит набор утилит для работы с кадровскими данными';
  
    RETURN vMSG;
  END;

  FUNCTION GET_EMPLOYEE_PROPERTIES(pTAB_ID NUMBER) RETURN tEMPLOYEE_PROPERTIES
    PIPELINED IS
    vCURSOR     SYS_REFCURSOR;
    vROW        recEMPLOYEE_PROPERTIES;
    vQUERY_TEXT VARCHAR2(2000);
  BEGIN
    vQUERY_TEXT := 'SELECT id_tab
                          ,property_name
                          ,property_name || nvl2(value_text
                                                ,'' ('' || value_text || '')''
                                                ,'''') property_string
                      FROM (SELECT tp.id_tab
                                  ,tp.id_property
                                  ,p.name property_name
                                  ,tpv.value_text
                              FROM qwerty.sp_ka_tab_prop tp
                                  ,(SELECT DISTINCT id_tab_prop
                                          ,last_value(value_text) over(PARTITION BY id_tab_prop) value_text
                                      FROM (SELECT ktpv.id_tab_prop
                                                  ,ltrim(sys_connect_by_path(pv.short_name || '' '' || ktpv.value
                                                                            ,'', '')
                                                        ,'', '') value_text
                                              FROM QWERTY.SP_KA_TAB_PROP_VALUE ktpv
                                                  ,qwerty.sp_property_values   pv
                                             WHERE ktpv.id_value = pv.id
                                             CONNECT BY PRIOR ktpv.id_tab_prop = ktpv.id_tab_prop
                                                 AND PRIOR pv.value_index = pv.value_index - 1
                                               START WITH pv.value_index = 0)) tpv
                                  ,qwerty.sp_properties p
                     WHERE tp.id_tab = ' || pTAB_ID || '
                       AND tp.id = tpv.id_tab_prop(+)
                       AND tp.id_property = p.id)';
  
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
  
  END GET_EMPLOYEE_PROPERTIES;

  FUNCTION GET_ALL_EMPLOYEE_PROPERTIES RETURN tEMPLOYEE_PROPERTIES
    PIPELINED IS
    --vCURSOR     SYS_REFCURSOR;
    --vROW        recEMPLOYEE_PROPERTIES;
    --vQUERY_TEXT VARCHAR2(2000);
  BEGIN
    /*vQUERY_TEXT := 'SELECT id_tab
        ,property_name
        ,property_name || nvl2(value_text
                              ,'' ('' || value_text || '')''
                              ,'''') property_string
    FROM (SELECT tp.id_tab
                ,tp.id_property
                ,p.name property_name
                ,tpv.value_text
            FROM qwerty.sp_ka_tab_prop tp
                ,(SELECT DISTINCT id_tab_prop
                                 ,last_value(value_text) over(PARTITION BY id_tab_prop) value_text
                    FROM (SELECT ktpv.id_tab_prop
                                ,ltrim(sys_connect_by_path(pv.short_name || '' '' || ktpv.value
                                                          ,'', '')
                                      ,'', '') value_text
                            FROM QWERTY.SP_KA_TAB_PROP_VALUE ktpv
                                ,qwerty.sp_property_values   pv
                           WHERE ktpv.id_value = pv.id
                          CONNECT BY PRIOR ktpv.id_tab_prop = ktpv.id_tab_prop
                                 AND PRIOR pv.value_index = pv.value_index - 1
                           START WITH pv.value_index = 0)) tpv
                ,qwerty.sp_properties p
           WHERE tp.id = tpv.id_tab_prop(+)
             AND tp.id_property = p.id)';
    
      OPEN vCURSOR FOR vQUERY_TEXT;
    
      IF vCURSOR%ISOPEN THEN
        LOOP
          FETCH vCURSOR
            INTO vROW;
          EXIT WHEN vCURSOR%NOTFOUND;
        
          PIPE ROW(vROW);
        END LOOP;
      END IF; -- открыт ли курсор*/
  
    FOR r IN (SELECT id_tab
                    ,property_name
                    ,property_name || nvl2(value_text
                                          ,' (' || value_text || ')'
                                          ,'') property_string
                FROM (SELECT tp.id_tab
                            ,tp.id_property
                            ,p.name property_name
                            ,tpv.value_text
                        FROM qwerty.sp_ka_tab_prop tp
                            ,(SELECT DISTINCT id_tab_prop
                                             ,last_value(value_text) over(PARTITION BY id_tab_prop) value_text
                                FROM (SELECT ktpv.id_tab_prop
                                            ,ltrim(sys_connect_by_path(pv.short_name || ' ' || ktpv.value
                                                                      ,', ')
                                                  ,', ') value_text
                                        FROM QWERTY.SP_KA_TAB_PROP_VALUE ktpv
                                            ,qwerty.sp_property_values   pv
                                       WHERE ktpv.id_value = pv.id
                                      CONNECT BY PRIOR ktpv.id_tab_prop = ktpv.id_tab_prop
                                             AND PRIOR pv.value_index = pv.value_index - 1
                                       START WITH pv.value_index = 0)) tpv
                            ,qwerty.sp_properties p
                       WHERE tp.id = tpv.id_tab_prop(+)
                         AND tp.id_property = p.id(+)))
    LOOP
      PIPE ROW(r);
    END LOOP;
  
    RETURN;
  
  END GET_ALL_EMPLOYEE_PROPERTIES;

  FUNCTION GET_EMPLOYEE_FIRST_WORKDAY(i_TAB_ID NUMBER) RETURN DATE IS
    v_FIRST_DAY DATE;
  BEGIN
    SELECT MAX(data_work)
      INTO v_FIRST_DAY
      FROM (SELECT id_tab
                  ,data_work
                  ,id_zap
              FROM qwerty.sp_ka_perem
             WHERE id_tab = i_TAB_ID
               AND abs(id_zap) = 1
            UNION ALL
            SELECT id_tab
                  ,data_work
                  ,id_zap
              FROM qwerty.sp_ka_work
             WHERE id_tab = i_TAB_ID
               AND id_zap = 1);
  
    RETURN v_FIRST_DAY;
  END GET_EMPLOYEE_FIRST_WORKDAY;

  -- Количество праздничных дней между двумя датами
  FUNCTION NUM_OF_HOLIDAYS_BETWEEN(i_FROM DATE
                                  ,i_TO   DATE) RETURN NUMBER IS
    v_NUM  NUMBER;
    v_FROM DATE;
    v_TO   DATE;
  BEGIN
    IF i_FROM > i_TO THEN
      v_FROM := i_TO;
      v_TO   := i_FROM;
    ELSE
      v_FROM := i_FROM;
      v_TO   := i_TO;
    END IF;
  
    SELECT COUNT(*) INTO v_NUM FROM qwerty.sp_zar_prazdn p WHERE p.dat_prazdn BETWEEN v_FROM AND v_TO;
  
    RETURN v_NUM;
  END NUM_OF_HOLIDAYS_BETWEEN;

  -- Возращает начало текущего периода очередного отпуска для работника с заданным табельным номером i_TAB_ID
  FUNCTION GET_EMPLOYEE_LEAVE_PERIOD(i_TAB_ID NUMBER) RETURN DATE IS
    v_NUM_OF_MATERNITY_LEAVES NUMBER;
    v_CURRENT_LEAVE_PERIOD    DATE;
  BEGIN
    SELECT COUNT(*)
      INTO v_NUM_OF_MATERNITY_LEAVES
      FROM qwerty.sp_ka_dekr
     WHERE id_tab = i_TAB_ID
       AND id_otp IN (SELECT id_otp FROM qwerty.SP_OTPUSK WHERE pid = 2);
  
    v_CURRENT_LEAVE_PERIOD := NULL;
  
    IF v_NUM_OF_MATERNITY_LEAVES = 0 OR
       v_NUM_OF_MATERNITY_LEAVES IS NULL THEN
      -- не было декретных отпусков
      BEGIN
        -- Выбираем последний период по очередным (PID = 1) отпускам
        --  смотрим выбран ли период полностью (наличие в периоде отпусков с 
        --   ID_OTP =  4 (очередной)
        --           , 6 (остаток очередного)
        --           ,25 (остаток очередного отпуска [денежная компенсация])
        --        или 34 24 дня отпуска плюс компенсация)
        SELECT DISTINCT DECODE(SUM(DECODE(id_otp
                                         ,4
                                         ,1
                                         ,6
                                         ,1
                                         ,25
                                         ,1
                                         ,34
                                         ,1
                                         ,0)) OVER(PARTITION BY id_tab
                                   ,n_period)
                              ,0
                              ,leave_period_start
                              ,ADD_MONTHS(leave_period_start
                                         ,12)) leave_period_start
          INTO v_CURRENT_LEAVE_PERIOD
          FROM (SELECT DISTINCT NVL(MAX(n_period) OVER(PARTITION BY id_tab)
                                   ,qwerty.hr_tools.get_employee_first_workday(id_tab)) leave_period_start
                  FROM qwerty.sp_ka_otpusk
                 WHERE id_tab = i_TAB_ID
                   AND id_otp IN (SELECT id_otp FROM qwerty.SP_OTPUSK WHERE pid = 1)) t
              ,qwerty.sp_ka_otpusk o
         WHERE o.id_tab = i_TAB_ID
           AND o.n_period = t.leave_period_start;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- Если записей об отпусках ещё нет
          v_CURRENT_LEAVE_PERIOD := GET_EMPLOYEE_FIRST_WORKDAY(i_TAB_ID);
      END;
    ELSIF v_NUM_OF_MATERNITY_LEAVES = 1 THEN
      -- имеется один декретный отпуск
      -- Выбираем очередные отпуска после декретного
      --  смотрим выбран ли период полностью
      BEGIN
        SELECT DISTINCT DECODE(SUM(DECODE(id_otp
                                         ,4
                                         ,1
                                         ,6
                                         ,1
                                         ,25
                                         ,1
                                         ,34
                                         ,1
                                         ,0)) OVER(PARTITION BY id_tab
                                   ,n_period)
                              ,0
                              ,leave_period_start
                              ,ADD_MONTHS(leave_period_start
                                         ,12)) leave_period_start
          INTO v_CURRENT_LEAVE_PERIOD
          FROM (SELECT MAX(n_period) leave_period_start
                  FROM qwerty.sp_ka_otpusk o
                 WHERE id_tab = i_TAB_ID
                   AND id_otp IN (SELECT id FROM qwerty.sp_otpusk WHERE pid = 1)
                   AND dat_n > (SELECT MAX(nvl(date_vid
                                              ,k_dekr))
                                  FROM qwerty.sp_ka_dekr
                                 WHERE id_tab = o.id_tab)
                UNION ALL
                SELECT MAX(n_period) leave_period_start
                  FROM qwerty.sp_ka_otpusk o
                 WHERE id_tab = i_TAB_ID
                   AND id_otp IN (SELECT id FROM qwerty.sp_otpusk WHERE pid = 1)
                   AND dat_n < (SELECT MAX(n_dekr) FROM qwerty.sp_ka_dekr WHERE id_tab = o.id_tab)) t
              ,qwerty.sp_ka_otpusk o
         WHERE o.id_tab = i_TAB_ID
           AND o.n_period = t.leave_period_start
           AND rownum = 1
         ORDER BY 1 DESC;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- Если записей об отпусках ещё нет
          v_CURRENT_LEAVE_PERIOD := GET_EMPLOYEE_FIRST_WORKDAY(i_TAB_ID);
      END;
    ELSIF v_NUM_OF_MATERNITY_LEAVES >= 2 THEN
      -- имеются более одного декретного отпуска
      NULL;
    ELSE
      -- количество декретных отпусков меньше нуля
      RAISE_APPLICATION_ERROR(-20202
                             ,'Количество декретных отпусков меньше нуля!?');
    END IF;
  
    RETURN v_CURRENT_LEAVE_PERIOD;
  END GET_EMPLOYEE_LEAVE_PERIOD;

  FUNCTION GET_MATERNITY_LEAVES RETURN tMATERNITY_LEAVES
    PIPELINED IS
  BEGIN
    FOR rec IN (SELECT t.id_tab
                      ,otp.name_u
                      ,t.dat_n              n_dekr
                      ,t.dat_k              k_dekr
                      ,d.date_vid
                      ,d.date_work
                      ,t.prev_period_start
                      ,t.prev_period_finish
                      ,t.period_is_over
                  FROM (SELECT q.*
                              ,SUM(decode(id_otp
                                         ,4
                                         ,1
                                         ,6
                                         ,1
                                         ,25
                                         ,1
                                         ,34
                                         ,1
                                         ,0)) over(PARTITION BY id_tab, prev_period_finish ORDER BY dat_n) period_is_over
                          FROM (SELECT o.*
                                      ,MAX(n_period) over(PARTITION BY o.id_tab ORDER BY o.dat_n rows unbounded preceding) prev_period_start
                                      ,MAX(k_period) over(PARTITION BY o.id_tab ORDER BY o.dat_n rows unbounded preceding) prev_period_finish
                                  FROM qwerty.sp_ka_otpusk o
                                 WHERE id_otp IN (SELECT id
                                                    FROM qwerty.sp_otpusk
                                                   WHERE pid IN (1
                                                                ,2))) q) t
                      ,qwerty.sp_ka_dekr d
                      ,qwerty.sp_otpusk otp
                 WHERE t.id_tab = d.id_tab
                   AND t.id_otp = d.id_otp
                   AND t.dat_n = d.n_dekr
                   AND t.id_otp = otp.id)
    LOOP
      PIPE ROW(rec);
    END LOOP;
  
    RETURN;
  END GET_MATERNITY_LEAVES;

  FUNCTION GET_NEW_PERIOD(i_PREV_PERIOD_FINISH DATE
                         ,i_DEKRET_START       DATE
                         ,i_BACK_2_WORK        DATE) RETURN DATE IS
    vPPF_DAY   NUMBER;
    vPPF_MONTH NUMBER;
    vPPF_YEAR  NUMBER;
    vDS_DAY    NUMBER;
    vDS_MONTH  NUMBER;
    vDS_YEAR   NUMBER;
    vB2W_DAY   NUMBER;
    vB2W_MONTH NUMBER;
    vB2W_YEAR  NUMBER;
    vNP_DAY    NUMBER;
    vNP_MONTH  NUMBER;
    vNP_YEAR   NUMBER;
    m          NUMBER;
    y          NUMBER;
  BEGIN
    -- Дата окончания предыдущего периода
    vPPF_DAY   := TO_NUMBER(TO_CHAR(i_PREV_PERIOD_FINISH
                                   ,'dd'));
    vPPF_MONTH := TO_NUMBER(TO_CHAR(i_PREV_PERIOD_FINISH
                                   ,'mm'));
    vPPF_YEAR  := TO_NUMBER(TO_CHAR(i_PREV_PERIOD_FINISH
                                   ,'yyyy'));
    -- Дата начала декрета
    vDS_DAY   := TO_NUMBER(TO_CHAR(i_DEKRET_START
                                  ,'dd'));
    vDS_MONTH := TO_NUMBER(TO_CHAR(i_DEKRET_START
                                  ,'mm'));
    vDS_YEAR  := TO_NUMBER(TO_CHAR(i_DEKRET_START
                                  ,'yyyy'));
    -- Дата возвращения на работу
    vB2W_DAY   := TO_NUMBER(TO_CHAR(i_BACK_2_WORK
                                   ,'dd'));
    vB2W_MONTH := TO_NUMBER(TO_CHAR(i_BACK_2_WORK
                                   ,'mm'));
    vB2W_YEAR  := TO_NUMBER(TO_CHAR(i_BACK_2_WORK
                                   ,'yyyy'));
    -- Новая дата начала периода
    vNP_DAY   := 0;
    vNP_MONTH := 0;
    vNP_YEAR  := 0;
    m         := 0;
    y         := 0;
  
    IF i_PREV_PERIOD_FINISH > i_DEKRET_START THEN
      vNP_DAY := vPPF_DAY - vDS_DAY;
      IF vNP_DAY > 30 THEN
        vNP_DAY := vNP_DAY - 30;
        m       := 1;
      ELSIF vNP_DAY < 0 THEN
        vNP_DAY := 30 + vNP_DAY;
        m       := -1;
      END IF;
    
      vNP_MONTH := vPPF_MONTH - vDS_MONTH + m;
      IF vNP_MONTH > 12 THEN
        vNP_MONTH := vNP_MONTH - 12;
        y         := 1;
      ELSIF vNP_MONTH < 0 THEN
        vNP_MONTH := 12 + vNP_MONTH;
        y         := -1;
      END IF;
    
      vNP_YEAR := vPPF_YEAR - vDS_YEAR + y;
    
      --dbms_output.put_line('Day: ' || vNP_DAY || ' Month: ' || vNP_MONTH || ' Year: ' || vNP_YEAR);
    
      m       := 0;
      y       := 0;
      vNP_DAY := vB2W_DAY + vNP_DAY;
      IF vNP_DAY > 30 THEN
        vNP_DAY := vNP_DAY - 30;
        m       := 1;
      ELSIF vNP_DAY < 0 THEN
        vNP_DAY := 30 + vNP_DAY;
        m       := -1;
      END IF;
    
      vNP_MONTH := vB2W_MONTH + vNP_MONTH + m;
      IF vNP_MONTH > 12 THEN
        vNP_MONTH := vNP_MONTH - 12;
        y         := 1;
      ELSIF vNP_MONTH < 0 THEN
        vNP_MONTH := 12 + vNP_MONTH;
        y         := -1;
      END IF;
    
      vNP_YEAR := vB2W_YEAR + vNP_YEAR + y;
    
      --dbms_output.put_line('Day: ' || vNP_DAY || ' Month: ' || vNP_MONTH || ' Year: ' || vNP_YEAR);
    ELSE
      vNP_DAY := -vPPF_DAY + vDS_DAY;
      IF vNP_DAY > 30 THEN
        vNP_DAY := vNP_DAY - 30;
        m       := 1;
      ELSIF vNP_DAY < 0 THEN
        vNP_DAY := 30 + vNP_DAY;
        m       := -1;
      END IF;
    
      vNP_MONTH := -vPPF_MONTH + vDS_MONTH + m;
      IF vNP_MONTH > 12 THEN
        vNP_MONTH := vNP_MONTH - 12;
        y         := 1;
      ELSIF vNP_MONTH < 0 THEN
        vNP_MONTH := 12 + vNP_MONTH;
        y         := -1;
      END IF;
    
      vNP_YEAR := -vPPF_YEAR + vDS_YEAR + y;
    
      --dbms_output.put_line('Day: ' || vNP_DAY || ' Month: ' || vNP_MONTH || ' Year: ' || vNP_YEAR);
    
      m       := 0;
      y       := 0;
      vNP_DAY := vB2W_DAY - vNP_DAY;
      IF vNP_DAY > 30 THEN
        vNP_DAY := vNP_DAY - 30;
        m       := 1;
      ELSIF vNP_DAY < 0 THEN
        vNP_DAY := 30 + vNP_DAY;
        m       := -1;
      END IF;
    
      vNP_MONTH := vB2W_MONTH - vNP_MONTH + m;
      IF vNP_MONTH > 12 THEN
        vNP_MONTH := vNP_MONTH - 12;
        y         := 1;
      ELSIF vNP_MONTH < 0 THEN
        vNP_MONTH := 12 + vNP_MONTH;
        y         := -1;
      END IF;
    
      vNP_YEAR := vB2W_YEAR - vNP_YEAR + y;
    
      --dbms_output.put_line('Day: ' || vNP_DAY || ' Month: ' || vNP_MONTH || ' Year: ' || vNP_YEAR);
    END IF;
  
    RETURN TO_DATE(LPAD(vNP_DAY
                       ,2
                       ,'0') || LPAD(vNP_MONTH
                                    ,2
                                    ,'0') || LPAD(vNP_YEAR
                                                 ,4
                                                 ,'0')
                  ,'ddmmyyyy');
  END GET_NEW_PERIOD;

BEGIN
  -- Initialization
  --<Statement>;
  NULL;
END HR_TOOLS;
/
