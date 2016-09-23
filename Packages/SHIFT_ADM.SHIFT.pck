CREATE OR REPLACE PACKAGE shift_adm.SHIFT IS

  -- Author  : BISHOP
  -- Created : 03.11.2006 13:10:29
  -- Purpose : Пакет для программы ведения графиков работы работников ОПЗ

  /*
    -- Public type declarations
    type <TypeName> is <Datatype>;
    
    -- Public constant declarations
    <ConstantName> constant <Datatype> := <Value>;
  
    -- Public variable declarations
    <VariableName> <Datatype>;
  
    -- Public function and procedure declarations
    function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  */

  /*
     Пакет содержит подпрограммы для системы учета графиков работы смен ОПЗ
     Составитель: Владимир Дуда, ОАСУ
  */

  PROCEDURE NEW_CALENDAR(current_date_n VARCHAR2
                        ,hol            NUMBER);
  /* Составление нового календаря
     current_date: текущая дата в формате dd.mm.yyyy;
     hol         : =0, праздник, попадающий на выходной не переносится на рабочий день;
                   =1, праздник, попадающий на выходной переносится на рабочий день.
  */

  PROCEDURE ADD_SHIFT(current_date_n VARCHAR2
                     ,smena_id       VARCHAR2
                     ,smena_type     NUMBER
                     ,pos            NUMBER);
  /*Расчет графика новой смены с известной позиции в цикле смены
    current_date: текущая дата, в формате dd.mm.yyyy;
    smena_id    : идентификатор смены;
    smena_type  : тип смены;
    pos         : номер позиции в цикле смены
  */

  PROCEDURE ADD_SHIFT_H(current_date_n VARCHAR2
                       ,smena_id       VARCHAR2
                       ,smena_type     NUMBER
                       ,pos            NUMBER);
  /*Расчет графика новой смены (праздник = выходной), с известной позиции в цикле смены
    current_date: текущая дата, в формате dd.mm.yyyy;
    smena_id    : идентификатор смены;
    smena_type  : тип смены;
    pos         : номер позиции в цикле смены
  
    Примечание: Предварительно должен быть расчитан календарь на текущий год
  */

  PROCEDURE ADD_SHIFT_H2(current_date_n VARCHAR2
                        ,smena_id       VARCHAR2
                        ,smena_type     NUMBER
                        ,pos            NUMBER);
  /*Расчет графика новой смены (выходные и праздники сдвигают цикл), с известной позиции
    в цикле смены
    current_date_n: текущая дата, в формате dd.mm.yyyy;
    smena_id    : идентификатор смены;
    smena_type  : тип смены;
    pos         : номер позиции в цикле смены
  
    Примечание: Предварительно должен быть расчитан календарь на текущий год
  */

  PROCEDURE ADD_SHIFT_H3(current_date_n VARCHAR2
                        ,smena_id       VARCHAR2
                        ,smena_type     NUMBER
                        ,pos            NUMBER);
  /*Расчет графика новой смены (выходные и праздники сдвигают цикл), с известной позиции
    в цикле смены
    current_date_n: текущая дата, в формате dd.mm.yyyy;
    smena_id    : идентификатор смены;
    smena_type  : тип смены;
    pos         : номер позиции в цикле смены
  
    Примечание: Предварительно должен быть расчитан календарь на текущий год
  */

  PROCEDURE ADD_SHIFT_H4(current_date_n VARCHAR2
                        ,smena_id       VARCHAR2
                        ,smena_type     NUMBER
                        ,pos            NUMBER);
  /*Расчет графика новой смены 
   (), с известной позиции
    в цикле смены
    current_date_n: текущая дата, в формате dd.mm.yyyy;
    smena_id    : идентификатор смены;
    smena_type  : тип смены;
    pos         : номер позиции в цикле смены
  
    Примечание: Предварительно должен быть расчитан календарь на текущий год
  */

  PROCEDURE NEW_SHIFT(current_date_n VARCHAR2
                     ,smena_id       VARCHAR2
                     ,smena_type     NUMBER);
  /*Расчет графика смены на год
    current_date: текущая дата, в формате dd.mm.yyyy;
    smena_id    : идентификатор смены;
    smena_type  : тип смены.
  */

  PROCEDURE WORKTIME_COUNTING(d1       VARCHAR2
                             ,d2       VARCHAR2
                             ,d3       VARCHAR2
                             ,d4       VARCHAR2
                             ,d5       VARCHAR2
                             ,d6       VARCHAR2
                             ,d7       VARCHAR2
                             ,d8       VARCHAR2
                             ,d9       VARCHAR2
                             ,d10      VARCHAR2
                             ,d11      VARCHAR2
                             ,d12      VARCHAR2
                             ,d13      VARCHAR2
                             ,d14      VARCHAR2
                             ,d15      VARCHAR2
                             ,d16      VARCHAR2
                             ,d17      VARCHAR2
                             ,d18      VARCHAR2
                             ,d19      VARCHAR2
                             ,d20      VARCHAR2
                             ,d21      VARCHAR2
                             ,d22      VARCHAR2
                             ,d23      VARCHAR2
                             ,d24      VARCHAR2
                             ,d25      VARCHAR2
                             ,d26      VARCHAR2
                             ,d27      VARCHAR2
                             ,d28      VARCHAR2
                             ,d29      VARCHAR2
                             ,d30      VARCHAR2
                             ,d31      VARCHAR2
                             ,smena_id VARCHAR2
                             ,TIME     OUT NUMBER
                             ,days     OUT NUMBER);
  /*Процедура подсчета времени работы и рабочих дней за расчетный месяц
    d1-d31      : отметки за расчетный месяц;
    smena_id    : идентификатор смены;
    Возвращаемые значения:
    time        : количество отработанных часов;
    days        : количество отработанных дней.
  */

  PROCEDURE WORKTIME_CALENDAR(current_year IN VARCHAR2);
  /*Подсчет времение работы и количества рабочих дней по календарю
  */

  PROCEDURE WORKTIME_GRAF(current_year IN VARCHAR2);
  /*Подсчет количества рабочего времени, переработки и рабочих дней для всех смен на указанный год
    current_year: строка, содержащий расчетный год в формате 'yyyy'.
  */

  PROCEDURE OVERTIME(d1        VARCHAR2
                    ,d2        VARCHAR2
                    ,d3        VARCHAR2
                    ,d4        VARCHAR2
                    ,d5        VARCHAR2
                    ,d6        VARCHAR2
                    ,d7        VARCHAR2
                    ,d8        VARCHAR2
                    ,d9        VARCHAR2
                    ,d10       VARCHAR2
                    ,d11       VARCHAR2
                    ,d12       VARCHAR2
                    ,d13       VARCHAR2
                    ,d14       VARCHAR2
                    ,d15       VARCHAR2
                    ,d16       VARCHAR2
                    ,d17       VARCHAR2
                    ,d18       VARCHAR2
                    ,d19       VARCHAR2
                    ,d20       VARCHAR2
                    ,d21       VARCHAR2
                    ,d22       VARCHAR2
                    ,d23       VARCHAR2
                    ,d24       VARCHAR2
                    ,d25       VARCHAR2
                    ,d26       VARCHAR2
                    ,d27       VARCHAR2
                    ,d28       VARCHAR2
                    ,d29       VARCHAR2
                    ,d30       VARCHAR2
                    ,d31       VARCHAR2
                    ,smena_id  VARCHAR2
                    ,d         DATE
                    ,graf_time NUMBER
                    ,per       OUT NUMBER
                    ,pra       OUT NUMBER
                    ,pra1      OUT NUMBER
                    ,pra2      OUT NUMBER);
  /*Подсчет переработки для смены на заданный месяц
    d1-d31      : отметки за расчетный месяц;
    smena_id    : идентификатор смены;
    d           : дата месяца расчета;
    graf_time   : количество рабочих часов по графику;
    Возвращаемые значения:
    per         : количество часов переработки;
    pra         : количество праздничных часов;
    pra1        : количество праздничных часов (вид 023);
    pra2        : количество праздничных часов (вид 033).
  */

  PROCEDURE WORKTIME_SHIFT(current_year IN VARCHAR2
                          ,smena        IN VARCHAR2);
  /*Подсчет количества часов работы и рабочих дней для заданной смены на заданный год
    current_year: строка, содержащая расчетный год в формате 'yyyy';
    smena       : идентификатор смены.
  */

  PROCEDURE NEW_YEAR(current_date_n VARCHAR2
                    ,hol            NUMBER);
  /*Процедура автоматического составление графика на заданный год
    current_date: текущая дата, в формате dd.mm.yyyy;
  */

END SHIFT;
/
CREATE OR REPLACE PACKAGE BODY shift_adm.SHIFT IS

  /*
    -- Private type declarations
    type <TypeName> is <Datatype>;
    
    -- Private constant declarations
    <ConstantName> constant <Datatype> := <Value>;
  
    -- Private variable declarations
    <VariableName> <Datatype>;
  
    -- Function and procedure implementations
    function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
      <LocalVariable> <Datatype>;
    begin
      <Statement>;
      return(<Result>);
    end;
  */

  PROCEDURE CALENDAR(current_date_n VARCHAR2) AS
    /* Составление нового календаря
       current_date_n: текущая дата в формате dd.mm.yyyy
       если праздник попадает на выходной день, выходной НЕ(!) переносится на рабочий день
    */
    TYPE TDayColumns IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
  
    CURSOR hol_cursor(cur_mon DATE) IS
      SELECT dat_prazdn
        FROM qwerty.sp_zar_prazdn
       WHERE TO_CHAR(dat_prazdn
                    ,'mm.yyyy') = TO_CHAR(cur_mon
                                         ,'mm.yyyy');
  
    i         NUMBER(2);
    j         NUMBER(2);
    y         NUMBER(4);
    m         NUMBER(2);
    feb_days  NUMBER(2);
    days      NUMBER(2);
    prev_days NUMBER(2);
    weekday   NUMBER(1);
    flag      NUMBER(1);
    flag_mon  NUMBER(1);
    d         DATE;
    hol_date  DATE;
    day_col   TDayColumns;
    index_    BINARY_INTEGER := 0;
  BEGIN
    -- Урезаем дату до начала года
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'YEAR');
  
    -- Количество дней в предыдущем месяце
    prev_days := 31;
  
    -- y - числовое представление текущего года
    SELECT (TO_CHAR(d
                   ,'yyyy'))
      INTO y
      FROM dual;
  
    -- проверяем не високосный ли год
    IF (MOD(y
           ,400) = 0) OR
       ((MOD(y
            ,4) = 0) AND NOT (MOD(y
                                  ,100) = 0)) THEN
      feb_days := 29;
    ELSE
      feb_days := 28;
    END IF;
  
    flag_mon := 0;
  
    <<month_cycle>>
    FOR i IN 0 .. 11
    LOOP
      flag := 0;
    
      -- Определяем количество дней в месяце
      SELECT TO_NUMBER(TO_CHAR(d
                              ,'mm'))
        INTO m
        FROM dual;
      IF ((MOD(m
              ,2) = 1) AND (m <= 7)) OR
         ((MOD(m
              ,2) = 0) AND (m > 7)) THEN
        days := 31;
      ELSIF m = 2 THEN
        days := feb_days;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        days := 30;
      END IF;
    
      <<days_cycle>>
      FOR j IN 0 .. days - 1
      LOOP
        --  Вычисляем порядковый номер дня в неделе
        SELECT TO_NUMBER(TO_CHAR(d + j
                                ,'d'))
          INTO weekday
          FROM dual;
        index_ := j + 1;
      
        -- Выходной день?
        IF (weekday = 6) OR
           (weekday = 7) THEN
          day_col(index_) := ' В';
        
          -- Будни?
        ELSIF (weekday = 1) OR
              (weekday = 2) OR
              (weekday = 3) OR
              (weekday = 4) OR
              (weekday = 5) THEN
          day_col(index_) := 'Рд';
        END IF;
      
        -- Получаем список праздников на текущий месяц
        OPEN hol_cursor(d);
      
        <<cursor_cycle>>
        LOOP
          FETCH hol_cursor
            INTO hol_date;
          EXIT WHEN hol_cursor%NOTFOUND;
          IF TO_CHAR(d + j
                    ,'dd.mm') = TO_CHAR(hol_date
                                       ,'dd.mm') THEN
            IF (weekday = 2) OR
               (weekday = 3) OR
               (weekday = 4) OR
               (weekday = 5) OR
               (weekday = 6) THEN
              BEGIN
                day_col(index_) := ' П';
                IF index_ <> 1 THEN
                  IF (day_col(index_ - 1) <> ' П') AND
                     (day_col(index_ - 1) <> ' В') THEN
                    day_col(index_ - 1) := 'Кд'; --короткий?
                  END IF;
                END IF;
                EXIT;
              END;
            ELSIF weekday = 1 THEN
              BEGIN
                day_col(index_) := ' П';
                EXIT;
              END;
              /*ELSIF weekday=6 THEN BEGIN
                day_col(index_):=' П';
                flag:=1;
                IF TO_NUMBER(TO_CHAR(d+j,'dd'))=days
                 THEN flag_mon:=1;
                END IF;
                IF index_<>1 THEN
                IF (day_col(index_-1)<>' П') AND
                   (day_col(index_-1)<>' В') THEN
                    day_col(index_-1):=' ?';--короткий?
                END IF;
                END IF; 
                EXIT;
              END;*/
            ELSIF weekday = 7 THEN
              BEGIN
                day_col(index_) := ' П';
                /*flag:=1;
                IF TO_NUMBER(TO_CHAR(d+j,'dd'))=days
                 THEN flag_mon:=1;
                END IF;*/
                EXIT;
              END;
            END IF;
          END IF;
        END LOOP cursor_cycle;
      
        CLOSE hol_cursor;
      END LOOP days_cycle;
    
      IF m = 2 THEN
        BEGIN
          IF feb_days = 28 THEN
            day_col(29) := ' ';
          END IF;
          day_col(30) := ' ';
          day_col(31) := ' ';
        END;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        day_col(31) := ' ';
      END IF;
    
      IF day_col(1) = ' П' THEN
        BEGIN
          SELECT TO_NUMBER(TO_CHAR(d - 1
                                  ,'d'))
            INTO weekday
            FROM dual;
          IF (weekday <> 6) AND
             (weekday <> 7) THEN
            IF prev_days = 31 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d31 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            ELSIF prev_days = 30 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d30 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            ELSIF prev_days = 28 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d28 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            ELSIF prev_days = 29 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d29 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            END IF;
          END IF;
        END;
      END IF;
    
      -- предновогодний короткий день
      IF TO_CHAR(d
                ,'mm') = '12' THEN
        --  если конечно он не помечен как выходной или праздник 
        IF (day_col(31) <> ' В') AND
           (day_col(31) <> ' П') THEN
          day_col(31) := 'Кд';
        END IF;
      END IF;
    
      INSERT INTO qwerty.sp_zar_grafik
      VALUES
        (d,
         0,
         ' О',
         0,
         0,
         0,
         0,
         0,
         0,
         day_col(1),
         day_col(2),
         day_col(3),
         day_col(4),
         day_col(5),
         day_col(6),
         day_col(7),
         day_col(8),
         day_col(9),
         day_col(10),
         day_col(11),
         day_col(12),
         day_col(13),
         day_col(14),
         day_col(15),
         day_col(16),
         day_col(17),
         day_col(18),
         day_col(19),
         day_col(20),
         day_col(21),
         day_col(22),
         day_col(23),
         day_col(24),
         day_col(25),
         day_col(26),
         day_col(27),
         day_col(28),
         day_col(29),
         day_col(30),
         day_col(31));
    
      prev_days := days;
      d         := ADD_MONTHS(d
                             ,1);
    
    END LOOP month_cycle;
  END CALENDAR;

  PROCEDURE CALENDAR_HOLYDAY(current_date_n VARCHAR2) AS
    /* Составление нового календаря
       current_date_n: текущая дата в формате dd.mm.yyyy
       если праздник попадает на выходной день, выходной переносится на рабочий день
    */
    TYPE TDayColumns IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
  
    CURSOR hol_cursor(cur_mon DATE) IS
      SELECT dat_prazdn
        FROM qwerty.sp_zar_prazdn
       WHERE TO_CHAR(dat_prazdn
                    ,'mm.yyyy') = TO_CHAR(cur_mon
                                         ,'mm.yyyy');
  
    i         NUMBER(2);
    j         NUMBER(2);
    y         NUMBER(4);
    m         NUMBER(2);
    feb_days  NUMBER(2);
    days      NUMBER(2);
    prev_days NUMBER(2);
    weekday   NUMBER(1);
    flag      NUMBER(1);
    flag_mon  NUMBER(1);
    d         DATE;
    hol_date  DATE;
    day_col   TDayColumns;
    index_    BINARY_INTEGER := 0;
  BEGIN
    -- Урезаем дату до начала года
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'YEAR');
  
    -- Количество дней в предыдущем месяце
    prev_days := 31;
  
    -- y - числовое представление текущего года
    SELECT TO_NUMBER(TO_CHAR(d
                            ,'yyyy'))
      INTO y
      FROM dual;
  
    -- проверяем не високосный ли год
    IF (MOD(y
           ,400) = 0) OR
       ((MOD(y
            ,4) = 0) AND NOT (MOD(y
                                  ,100) = 0)) THEN
      feb_days := 29;
    ELSE
      feb_days := 28;
    END IF;
  
    flag_mon := 0; -- Праздник выпал на выходной день в конце предыдущего месяца 
  
    <<month_cycle>>
    FOR i IN 0 .. 11
    LOOP
      flag := 0; -- Праздник выпал на выходной день
    
      -- Определяем количество дней в месяце
      SELECT TO_NUMBER(TO_CHAR(d
                              ,'mm'))
        INTO m
        FROM dual;
      IF ((MOD(m
              ,2) = 1) AND (m <= 7)) OR
         ((MOD(m
              ,2) = 0) AND (m > 7)) THEN
        days := 31;
      ELSIF m = 2 THEN
        days := feb_days;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        days := 30;
      END IF;
    
      <<days_cycle>>
      FOR j IN 0 .. days - 1
      LOOP
        --  Вычисляем порядковый номер дня в неделе
        SELECT TO_NUMBER(TO_CHAR(d + j
                                ,'d'))
          INTO weekday
          FROM dual;
        index_ := j + 1;
      
        IF (flag_mon = 1) AND
           (index_ = 1) THEN
          BEGIN
            -- Если это первый день месяца и праздник выпал на выходной
            day_col(index_) := ' В';
            flag_mon := 0;
          END;
        ELSE
          BEGIN
            -- Выходной день?
            IF (weekday = 6) OR
               (weekday = 7) THEN
              day_col(index_) := ' В';
            
              -- Будни?
            ELSIF (weekday = 1) OR
                  (weekday = 2) OR
                  (weekday = 3) OR
                  (weekday = 4) OR
                  (weekday = 5) THEN
              IF flag = 1 THEN
                BEGIN
                  -- Если праздник попал на выходной
                  day_col(index_) := ' В'; -- Переносим выходной на будний день
                  flag := 0;
                END;
              ELSE
                day_col(index_) := 'Рд'; -- Иначе, оставляем день рабочим
              END IF;
            END IF;
          END;
        END IF;
      
        -- Получаем список праздников на текущий месяц
        OPEN hol_cursor(d);
      
        <<cursor_cycle>>
        LOOP
          FETCH hol_cursor
            INTO hol_date;
          EXIT WHEN hol_cursor%NOTFOUND;
          IF TO_CHAR(d + j
                    ,'dd.mm') = TO_CHAR(hol_date
                                       ,'dd.mm') THEN
            IF (weekday = 2) OR
               (weekday = 3) OR
               (weekday = 4) OR
               (weekday = 5) OR
               (weekday = 6) THEN
              BEGIN
                day_col(index_) := ' П';
                IF index_ <> 1 THEN
                  IF (day_col(index_ - 1) <> ' П') AND
                     (day_col(index_ - 1) <> ' В') THEN
                    day_col(index_ - 1) := 'Кд'; --короткий?
                  END IF;
                END IF;
                EXIT;
              END;
            ELSIF weekday = 1 THEN
              BEGIN
                day_col(index_) := ' П';
                EXIT;
              END;
            ELSIF weekday = 6 THEN
              BEGIN
                day_col(index_) := ' П';
                IF index_ = days THEN
                  flag_mon := 1;
                ELSE
                  flag := 1;
                END IF;
                IF index_ <> 1 THEN
                  IF (day_col(index_ - 1) <> ' П') AND
                     (day_col(index_ - 1) <> ' В') THEN
                    day_col(index_ - 1) := 'Кд'; --короткий?
                  END IF;
                END IF;
                EXIT;
              END;
            ELSIF weekday = 7 THEN
              BEGIN
                day_col(index_) := ' П';
                flag := 1;
                IF TO_NUMBER(TO_CHAR(d + j
                                    ,'dd')) = days THEN
                  flag_mon := 1;
                END IF;
                EXIT;
              END;
            END IF;
          END IF;
        END LOOP cursor_cycle;
      
        CLOSE hol_cursor;
      END LOOP days_cycle;
    
      IF m = 2 THEN
        BEGIN
          IF feb_days = 28 THEN
            day_col(29) := ' ';
          END IF;
          day_col(30) := ' ';
          day_col(31) := ' ';
        END;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        day_col(31) := ' ';
      END IF;
    
      IF day_col(1) = ' П' THEN
        BEGIN
          SELECT TO_NUMBER(TO_CHAR(d - 1
                                  ,'d'))
            INTO weekday
            FROM dual;
          IF (weekday <> 6) AND
             (weekday <> 7) THEN
            IF prev_days = 31 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d31 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            ELSIF prev_days = 30 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d30 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            ELSIF prev_days = 28 THEN
              UPDATE qwerty.sp_zar_grafik
                 SET d28 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            ELSIF prev_days = 29 THEN
              UPDATE QWERTY.sp_zar_grafik
                 SET d29 = 'Кд' -- было ' ?' (29.10.1999)
               WHERE (TO_CHAR(data_graf
                             ,'dd.mm') = TO_CHAR(TRUNC(d - 1
                                                       ,'MONTH')
                                                 ,'dd.mm'))
                 AND (tip_smen = 0);
            END IF;
          END IF;
        END;
      END IF;
    
      -- предновогодний короткий день
      IF TO_CHAR(d
                ,'mm') = '12' THEN
        --  если конечно он не помечен как выходной или праздник 
        IF (day_col(31) <> ' В') AND
           (day_col(31) <> ' П') THEN
          day_col(31) := 'Кд';
        END IF;
      END IF;
    
      INSERT INTO QWERTY.sp_zar_grafik
      VALUES
        (d,
         0,
         ' О',
         0,
         0,
         0,
         0,
         0,
         0,
         day_col(1),
         day_col(2),
         day_col(3),
         day_col(4),
         day_col(5),
         day_col(6),
         day_col(7),
         day_col(8),
         day_col(9),
         day_col(10),
         day_col(11),
         day_col(12),
         day_col(13),
         day_col(14),
         day_col(15),
         day_col(16),
         day_col(17),
         day_col(18),
         day_col(19),
         day_col(20),
         day_col(21),
         day_col(22),
         day_col(23),
         day_col(24),
         day_col(25),
         day_col(26),
         day_col(27),
         day_col(28),
         day_col(29),
         day_col(30),
         day_col(31));
    
      prev_days := days;
      d         := ADD_MONTHS(d
                             ,1);
    
    END LOOP month_cycle;
  END CALENDAR_HOLYDAY;

  PROCEDURE NEW_CALENDAR(current_date_n VARCHAR2
                        ,hol            NUMBER) AS
    /* Составление нового календаря
       current_date_n: текущая дата в формате dd.mm.yyyy
       hol         : параметр, 
         при hol=0 - если праздник попадает на выходной день, выходной 
                     НЕ(!) переносится на рабочий день
         при hol=1 - если праздник попадает на выходной день, выходной 
                     переносится на рабочий день
    */
  BEGIN
    IF hol = 0 THEN
      CALENDAR(current_date_n);
    ELSE
      IF hol = 1 THEN
        CALENDAR_HOLYDAY(current_date_n);
      END IF;
    END IF;
  END NEW_CALENDAR;

  PROCEDURE ADD_SHIFT(current_date_n VARCHAR2
                     ,smena_id       VARCHAR2
                     ,smena_type     NUMBER
                     ,pos            NUMBER) AS
    /*Расчет графика новой смены с известной позиции в цикле смены
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      smena_id    : идентификатор смены;
      smena_type  : тип смены;
      pos         : номер позиции в цикле смены
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    d           DATE;
    i           NUMBER(2);
    j           NUMBER(2);
    k           NUMBER(2);
    l           NUMBER(2);
    days        NUMBER(2);
    feb_days    NUMBER(2);
    m           NUMBER(2);
    y           NUMBER(4);
    position    NUMBER(2);
    ld_amount   NUMBER(1);
    smena       VARCHAR2(14);
    smena_cycle VARCHAR2(160);
    last_days   TDayColumns;
    day_col     TDayColumns;
    index_      BINARY_INTEGER := 0;
  BEGIN
    -- Вычисляем порядковый номер месяца и дня текущей даты
    SELECT TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'mm'))
          ,TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'dd'))
      INTO k
          ,l
      FROM dual;
    -- k - порядковый номер месяца
    -- l - порядковый номер дня в месяце
  
    -- "Урезаем" дату до начала месяца
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'MONTH');
  
    -- Вычисляем високосный год или нет для определения количества дней в феврале
    SELECT TO_NUMBER(TO_CHAR(d
                            ,'yyyy'))
      INTO y
      FROM dual;
    IF (MOD(y
           ,400) = 0) OR
       ((MOD(y
            ,4) = 0) AND NOT (MOD(y
                                  ,100) = 0)) THEN
      feb_days := 29;
    ELSE
      feb_days := 28;
    END IF;
  
    -- Выбираем цикл и количество определяющих дней для смены
    SELECT cycle
          ,days
      INTO smena_cycle
          ,ld_amount
      FROM QWERTY.sp_zar_t_smen
     WHERE tip_smen = smena_type;
  
    smena_cycle := smena_cycle || smena_cycle;
  
    -- Позиция текущего дня в цикле смены
    position := pos;
  
    <<month_cycle>>
    FOR i IN k .. 12
    LOOP
      SELECT TO_NUMBER(TO_CHAR(d
                              ,'mm'))
        INTO m
        FROM dual;
      -- вычисляем количество дней в месяце
      IF ((MOD(m
              ,2) = 1) AND (m <= 7)) OR
         ((MOD(m
              ,2) = 0) AND (m > 7)) THEN
        days := 31;
      ELSIF m = 2 THEN
        days := feb_days;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        days := 30;
      END IF;
    
      <<day_cycle>>
    -- обнуляем дни, предшествующие текущему
      FOR j IN 1 .. l
      LOOP
        index_ := j;
        day_col(index_) := '  ';
      END LOOP;
      -- определяем дни, после текущего включительно
      FOR j IN l .. days
      LOOP
        index_ := j;
        IF position > LENGTH(smena_cycle) THEN
          position := 1;
        END IF;
        day_col(index_) := SUBSTR(smena_cycle
                                 ,position
                                 ,2);
        position := position + 2;
      END LOOP day_cycle;
    
      -- подготавливаем порядковый номер текущего дня для следующего месяца
      l := 1;
    
      -- дописывыем пустые значения в конец месяца для февраля и месяцев с 30ю днями
      IF m = 2 THEN
        BEGIN
          IF feb_days = 28 THEN
            day_col(29) := '  ';
          END IF;
          day_col(30) := '  ';
          day_col(31) := '  ';
        END;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        day_col(31) := '  ';
      END IF;
    
      -- записываем полученную строку в таблицу графика
      INSERT INTO QWERTY.sp_zar_grafik
      VALUES
        (d,
         smena_type,
         smena_id,
         0,
         0,
         0,
         0,
         0,
         0,
         day_col(1),
         day_col(2),
         day_col(3),
         day_col(4),
         day_col(5),
         day_col(6),
         day_col(7),
         day_col(8),
         day_col(9),
         day_col(10),
         day_col(11),
         day_col(12),
         day_col(13),
         day_col(14),
         day_col(15),
         day_col(16),
         day_col(17),
         day_col(18),
         day_col(19),
         day_col(20),
         day_col(21),
         day_col(22),
         day_col(23),
         day_col(24),
         day_col(25),
         day_col(26),
         day_col(27),
         day_col(28),
         day_col(29),
         day_col(30),
         day_col(31));
    
      -- переходим к следующему месяцу
      d := ADD_MONTHS(d
                     ,1);
    
    END LOOP month_cycle;
  END ADD_SHIFT;

  PROCEDURE ADD_SHIFT_H(current_date_n VARCHAR2
                       ,smena_id       VARCHAR2
                       ,smena_type     NUMBER
                       ,pos            NUMBER) AS
    /*Расчет графика новой смены (праздник = выходной), с известной позиции в цикле смены
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      smena_id    : идентификатор смены;
      smena_type  : тип смены;
      pos         : номер позиции в цикле смены
    
      Примечание: Предварительно должен быть расчитан календарь на текущий год
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    d           DATE;
    i           NUMBER(2);
    j           NUMBER(2);
    k           NUMBER(2);
    l           NUMBER(2);
    days        NUMBER(2);
    feb_days    NUMBER(2);
    m           NUMBER(2);
    y           NUMBER(4);
    position    NUMBER(2);
    ld_amount   NUMBER(1);
    smena       VARCHAR2(14);
    smena_cycle VARCHAR2(160);
    last_days   TDayColumns;
    day_col     TDayColumns;
    cal_col     TDayColumns;
    index_      BINARY_INTEGER := 0;
  BEGIN
    -- Вычисляем порядковый номер месяца и дня текущей даты
    SELECT TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'mm'))
          ,TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'dd'))
      INTO k
          ,l
      FROM dual;
    -- k - порядковый номер месяца
    -- l - порядковый номер дня в месяце
  
    -- "Урезаем" дату до начала месяца
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'MONTH');
  
    -- Вычисляем високосный год или нет для определения количества дней в феврале
    SELECT TO_NUMBER(TO_CHAR(d
                            ,'yyyy'))
      INTO y
      FROM dual;
    IF (MOD(y
           ,400) = 0) OR
       ((MOD(y
            ,4) = 0) AND NOT (MOD(y
                                  ,100) = 0)) THEN
      feb_days := 29;
    ELSE
      feb_days := 28;
    END IF;
  
    -- Выбираем цикл и количество определяющих дней для смены
    SELECT cycle
          ,days
      INTO smena_cycle
          ,ld_amount
      FROM QWERTY.sp_zar_t_smen
     WHERE tip_smen = smena_type;
  
    smena_cycle := smena_cycle || smena_cycle;
  
    -- Позиция текущего дня в цикле смены
    position := pos;
  
    <<month_cycle>>
    FOR i IN k .. 12
    LOOP
      SELECT TO_NUMBER(TO_CHAR(d
                              ,'mm'))
        INTO m
        FROM dual;
      -- вычисляем количество дней в месяце
      IF ((MOD(m
              ,2) = 1) AND (m <= 7)) OR
         ((MOD(m
              ,2) = 0) AND (m > 7)) THEN
        days := 31;
      ELSIF m = 2 THEN
        days := feb_days;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        days := 30;
      END IF;
    
      -- Выбираем календарь на текущий месяц
      SELECT d1
            ,d2
            ,d3
            ,d4
            ,d5
            ,d6
            ,d7
            ,d8
            ,d9
            ,d10
            ,d11
            ,d12
            ,d13
            ,d14
            ,d15
            ,d16
            ,d17
            ,d18
            ,d19
            ,d20
            ,d21
            ,d22
            ,d23
            ,d24
            ,d25
            ,d26
            ,d27
            ,d28
            ,d29
            ,d30
            ,d31
        INTO cal_col(1)
            ,cal_col(2)
            ,cal_col(3)
            ,cal_col(4)
            ,cal_col(5)
            ,cal_col(6)
            ,cal_col(7)
            ,cal_col(8)
            ,cal_col(9)
            ,cal_col(10)
            ,cal_col(11)
            ,cal_col(12)
            ,cal_col(13)
            ,cal_col(14)
            ,cal_col(15)
            ,cal_col(16)
            ,cal_col(17)
            ,cal_col(18)
            ,cal_col(19)
            ,cal_col(20)
            ,cal_col(21)
            ,cal_col(22)
            ,cal_col(23)
            ,cal_col(24)
            ,cal_col(25)
            ,cal_col(26)
            ,cal_col(27)
            ,cal_col(28)
            ,cal_col(29)
            ,cal_col(30)
            ,cal_col(31)
        FROM QWERTY.sp_zar_grafik
       WHERE (data_graf = d)
         AND (tip_smen = 0);
    
      <<day_cycle>>
    -- обнуляем дни, предшествующие текущему
      FOR j IN 1 .. l
      LOOP
        index_ := j;
        day_col(index_) := '  ';
      END LOOP;
    
      -- определяем дни, после текущего включительно
      FOR j IN l .. days
      LOOP
        index_ := j;
        IF position > LENGTH(smena_cycle) THEN
          position := 1;
        END IF;
      
        IF cal_col(index_) = ' П' THEN
          day_col(index_) := ' П';
        ELSE
          IF cal_col(index_) = ' В' THEN
            day_col(index_) := ' В';
          ELSE
            IF (smena_type = 1) AND
               (cal_col(index_) = 'Кд') THEN
              day_col(index_) := ' 7';
            ELSE
              day_col(index_) := SUBSTR(smena_cycle
                                       ,position
                                       ,2);
            END IF;
          END IF;
        END IF;
      
        position := position + 2;
      END LOOP day_cycle;
    
      -- подготавливаем порядковый номер текущего дня для следующего месяца
      l := 1;
    
      -- дописывыем пустые значения в конец месяца для февраля и месяцев с 30ю днями
      IF m = 2 THEN
        BEGIN
          IF feb_days = 28 THEN
            day_col(29) := '  ';
          END IF;
          day_col(30) := '  ';
          day_col(31) := '  ';
        END;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        day_col(31) := '  ';
      END IF;
    
      -- записываем полученную строку в таблицу графика
      INSERT INTO QWERTY.sp_zar_grafik
      VALUES
        (d,
         smena_type,
         smena_id,
         0,
         0,
         0,
         0,
         0,
         0,
         day_col(1),
         day_col(2),
         day_col(3),
         day_col(4),
         day_col(5),
         day_col(6),
         day_col(7),
         day_col(8),
         day_col(9),
         day_col(10),
         day_col(11),
         day_col(12),
         day_col(13),
         day_col(14),
         day_col(15),
         day_col(16),
         day_col(17),
         day_col(18),
         day_col(19),
         day_col(20),
         day_col(21),
         day_col(22),
         day_col(23),
         day_col(24),
         day_col(25),
         day_col(26),
         day_col(27),
         day_col(28),
         day_col(29),
         day_col(30),
         day_col(31));
    
      -- переходим к следующему месяцу
      d := ADD_MONTHS(d
                     ,1);
    
    END LOOP month_cycle;
  END ADD_SHIFT_H;

  PROCEDURE ADD_SHIFT_H2(current_date_n VARCHAR2
                        ,smena_id       VARCHAR2
                        ,smena_type     NUMBER
                        ,pos            NUMBER) AS
    /*Расчет графика новой смены (выходные и праздники сдвигают цикл), с известной позиции
      в цикле смены
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      smena_id    : идентификатор смены;
      smena_type  : тип смены;
      pos         : номер позиции в цикле смены
    
      Примечание: Предварительно должен быть расчитан календарь на текущий год
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    d           DATE;
    i           NUMBER(2);
    j           NUMBER(2);
    k           NUMBER(2);
    l           NUMBER(2);
    days        NUMBER(2);
    feb_days    NUMBER(2);
    m           NUMBER(2);
    y           NUMBER(4);
    position    NUMBER(2);
    ld_amount   NUMBER(1);
    smena       VARCHAR2(14);
    smena_cycle VARCHAR2(160);
    last_days   TDayColumns;
    day_col     TDayColumns;
    cal_col     TDayColumns;
    index_      BINARY_INTEGER := 0;
  BEGIN
    -- Вычисляем порядковый номер месяца и дня текущей даты
    SELECT TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'mm'))
          ,TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'dd'))
      INTO k
          ,l
      FROM dual;
    -- k - порядковый номер месяца
    -- l - порядковый номер дня в месяце
  
    -- "Урезаем" дату до начала месяца
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'MONTH');
  
    -- Вычисляем високосный год или нет для определения количества дней в феврале
    SELECT TO_NUMBER(TO_CHAR(d
                            ,'yyyy'))
      INTO y
      FROM dual;
    IF (MOD(y
           ,400) = 0) OR
       ((MOD(y
            ,4) = 0) AND NOT (MOD(y
                                  ,100) = 0)) THEN
      feb_days := 29;
    ELSE
      feb_days := 28;
    END IF;
  
    -- Выбираем цикл и количество определяющих дней для смены
    SELECT cycle
          ,days
      INTO smena_cycle
          ,ld_amount
      FROM QWERTY.sp_zar_t_smen
     WHERE tip_smen = smena_type;
  
    smena_cycle := smena_cycle || smena_cycle;
  
    -- Позиция текущего дня в цикле смены
    position := pos;
  
    <<month_cycle>>
    FOR i IN k .. 12
    LOOP
      SELECT TO_NUMBER(TO_CHAR(d
                              ,'mm'))
        INTO m
        FROM dual;
      -- вычисляем количество дней в месяце
      IF ((MOD(m
              ,2) = 1) AND (m <= 7)) OR
         ((MOD(m
              ,2) = 0) AND (m > 7)) THEN
        days := 31;
      ELSIF m = 2 THEN
        days := feb_days;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        days := 30;
      END IF;
    
      -- Выбираем календарь на текущий месяц
      SELECT d1
            ,d2
            ,d3
            ,d4
            ,d5
            ,d6
            ,d7
            ,d8
            ,d9
            ,d10
            ,d11
            ,d12
            ,d13
            ,d14
            ,d15
            ,d16
            ,d17
            ,d18
            ,d19
            ,d20
            ,d21
            ,d22
            ,d23
            ,d24
            ,d25
            ,d26
            ,d27
            ,d28
            ,d29
            ,d30
            ,d31
        INTO cal_col(1)
            ,cal_col(2)
            ,cal_col(3)
            ,cal_col(4)
            ,cal_col(5)
            ,cal_col(6)
            ,cal_col(7)
            ,cal_col(8)
            ,cal_col(9)
            ,cal_col(10)
            ,cal_col(11)
            ,cal_col(12)
            ,cal_col(13)
            ,cal_col(14)
            ,cal_col(15)
            ,cal_col(16)
            ,cal_col(17)
            ,cal_col(18)
            ,cal_col(19)
            ,cal_col(20)
            ,cal_col(21)
            ,cal_col(22)
            ,cal_col(23)
            ,cal_col(24)
            ,cal_col(25)
            ,cal_col(26)
            ,cal_col(27)
            ,cal_col(28)
            ,cal_col(29)
            ,cal_col(30)
            ,cal_col(31)
        FROM QWERTY.sp_zar_grafik
       WHERE (data_graf = d)
         AND (tip_smen = 0);
    
      <<day_cycle>>
    -- обнуляем дни, предшествующие текущему
      FOR j IN 1 .. l
      LOOP
        index_ := j;
        day_col(index_) := '  ';
      END LOOP;
    
      -- определяем дни, после текущего включительно
      FOR j IN l .. days
      LOOP
        index_ := j;
        IF position > LENGTH(smena_cycle) THEN
          position := 1;
        END IF;
      
        IF cal_col(index_) = ' П' THEN
          day_col(index_) := ' П';
        ELSE
          IF cal_col(index_) = ' В' THEN
            day_col(index_) := ' В';
          ELSE
            IF (smena_type = 1) AND
               (cal_col(index_) = 'Кд') THEN
              BEGIN
                day_col(index_) := ' 7';
                position := position + 2;
              END;
            ELSE
              BEGIN
                day_col(index_) := SUBSTR(smena_cycle
                                         ,position
                                         ,2);
                position := position + 2;
              END;
            END IF;
          END IF;
        END IF;
      
      -- Позиция сдвигается только в случае рабочего дня (см. выше)
      -- position:=position+2;
      END LOOP day_cycle;
    
      -- подготавливаем порядковый номер текущего дня для следующего месяца
      l := 1;
    
      -- дописывыем пустые значения в конец месяца для февраля и месяцев с 30ю днями
      IF m = 2 THEN
        BEGIN
          IF feb_days = 28 THEN
            day_col(29) := '  ';
          END IF;
          day_col(30) := '  ';
          day_col(31) := '  ';
        END;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        day_col(31) := '  ';
      END IF;
    
      -- записываем полученную строку в таблицу графика
      INSERT INTO QWERTY.sp_zar_grafik
      VALUES
        (d,
         smena_type,
         smena_id,
         0,
         0,
         0,
         0,
         0,
         0,
         day_col(1),
         day_col(2),
         day_col(3),
         day_col(4),
         day_col(5),
         day_col(6),
         day_col(7),
         day_col(8),
         day_col(9),
         day_col(10),
         day_col(11),
         day_col(12),
         day_col(13),
         day_col(14),
         day_col(15),
         day_col(16),
         day_col(17),
         day_col(18),
         day_col(19),
         day_col(20),
         day_col(21),
         day_col(22),
         day_col(23),
         day_col(24),
         day_col(25),
         day_col(26),
         day_col(27),
         day_col(28),
         day_col(29),
         day_col(30),
         day_col(31));
    
      -- переходим к следующему месяцу
      d := ADD_MONTHS(d
                     ,1);
    
    END LOOP month_cycle;
  END ADD_SHIFT_H2;

  PROCEDURE ADD_SHIFT_H3(current_date_n VARCHAR2
                        ,smena_id       VARCHAR2
                        ,smena_type     NUMBER
                        ,pos            NUMBER) AS
    /*Расчет графика новой смены (выходные и праздники сдвигают цикл), с известной позиции
      в цикле смены
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      smena_id    : идентификатор смены;
      smena_type  : тип смены;
      pos         : номер позиции в цикле смены
    
      Примечание: Предварительно должен быть расчитан календарь на текущий год
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    d           DATE;
    i           NUMBER(2);
    j           NUMBER(2);
    k           NUMBER(2);
    l           NUMBER(2);
    days        NUMBER(2);
    feb_days    NUMBER(2);
    m           NUMBER(2);
    y           NUMBER(4);
    position    NUMBER(2);
    ld_amount   NUMBER(1);
    smena       VARCHAR2(14);
    smena_cycle VARCHAR2(160);
    last_days   TDayColumns;
    day_col     TDayColumns;
    cal_col     TDayColumns;
    index_      BINARY_INTEGER := 0;
  BEGIN
    -- Вычисляем порядковый номер месяца и дня текущей даты
    SELECT TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'mm'))
          ,TO_NUMBER(TO_CHAR(TO_DATE(current_date_n
                                    ,'dd.mm.yyyy')
                            ,'dd'))
      INTO k
          ,l
      FROM dual;
    -- k - порядковый номер месяца
    -- l - порядковый номер дня в месяце
  
    -- "Урезаем" дату до начала месяца
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'MONTH');
  
    -- Вычисляем високосный год или нет для определения количества дней в феврале
    SELECT TO_NUMBER(TO_CHAR(d
                            ,'yyyy'))
      INTO y
      FROM dual;
    IF (MOD(y
           ,400) = 0) OR
       ((MOD(y
            ,4) = 0) AND NOT (MOD(y
                                  ,100) = 0)) THEN
      feb_days := 29;
    ELSE
      feb_days := 28;
    END IF;
  
    -- Выбираем цикл и количество определяющих дней для смены
    SELECT cycle
          ,days
      INTO smena_cycle
          ,ld_amount
      FROM QWERTY.sp_zar_t_smen
     WHERE tip_smen = smena_type;
  
    smena_cycle := smena_cycle || smena_cycle;
  
    -- Позиция текущего дня в цикле смены
    position := pos;
  
    <<month_cycle>>
    FOR i IN k .. 12
    LOOP
      SELECT TO_NUMBER(TO_CHAR(d
                              ,'mm'))
        INTO m
        FROM dual;
      -- вычисляем количество дней в месяце
      IF ((MOD(m
              ,2) = 1) AND (m <= 7)) OR
         ((MOD(m
              ,2) = 0) AND (m > 7)) THEN
        days := 31;
      ELSIF m = 2 THEN
        days := feb_days;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        days := 30;
      END IF;
    
      -- Выбираем календарь на текущий месяц
      SELECT d1
            ,d2
            ,d3
            ,d4
            ,d5
            ,d6
            ,d7
            ,d8
            ,d9
            ,d10
            ,d11
            ,d12
            ,d13
            ,d14
            ,d15
            ,d16
            ,d17
            ,d18
            ,d19
            ,d20
            ,d21
            ,d22
            ,d23
            ,d24
            ,d25
            ,d26
            ,d27
            ,d28
            ,d29
            ,d30
            ,d31
        INTO cal_col(1)
            ,cal_col(2)
            ,cal_col(3)
            ,cal_col(4)
            ,cal_col(5)
            ,cal_col(6)
            ,cal_col(7)
            ,cal_col(8)
            ,cal_col(9)
            ,cal_col(10)
            ,cal_col(11)
            ,cal_col(12)
            ,cal_col(13)
            ,cal_col(14)
            ,cal_col(15)
            ,cal_col(16)
            ,cal_col(17)
            ,cal_col(18)
            ,cal_col(19)
            ,cal_col(20)
            ,cal_col(21)
            ,cal_col(22)
            ,cal_col(23)
            ,cal_col(24)
            ,cal_col(25)
            ,cal_col(26)
            ,cal_col(27)
            ,cal_col(28)
            ,cal_col(29)
            ,cal_col(30)
            ,cal_col(31)
        FROM QWERTY.sp_zar_grafik
       WHERE (data_graf = d)
         AND (tip_smen = 0);
    
      <<day_cycle>>
    -- обнуляем дни, предшествующие текущему
      FOR j IN 1 .. l
      LOOP
        index_ := j;
        day_col(index_) := '  ';
      END LOOP;
    
      -- определяем дни, после текущего включительно
      FOR j IN l .. days
      LOOP
        index_ := j;
        IF position > LENGTH(smena_cycle) THEN
          position := 1;
        END IF;
      
        IF cal_col(index_) = ' П' THEN
          BEGIN
            day_col(index_) := ' П';
            position := position + 2;
          END;
          /*            
                        ELSE IF cal_col(index_)=' В' THEN day_col(index_):=' В';
                        ELSE IF (smena_type=1) AND (cal_col(index_)='Кд') THEN BEGIN 
                              day_col(index_):=' 7';
                              position:=position+2;
                            END;
                        ELSE BEGIN
                              day_col(index_):=SUBSTR(smena_cycle,position,2);
                              position:=position+2;
                            END;
                          END IF;
                        END IF;
          */
        END IF;
      
      -- Позиция сдвигается только в случае рабочего дня (см. выше)
      -- position:=position+2;
      END LOOP day_cycle;
    
      -- подготавливаем порядковый номер текущего дня для следующего месяца
      l := 1;
    
      -- дописывыем пустые значения в конец месяца для февраля и месяцев с 30ю днями
      IF m = 2 THEN
        BEGIN
          IF feb_days = 28 THEN
            day_col(29) := '  ';
          END IF;
          day_col(30) := '  ';
          day_col(31) := '  ';
        END;
      ELSIF ((MOD(m
                 ,2) = 0) AND (m <= 7)) OR
            ((MOD(m
                 ,2) = 1) AND (m > 7)) THEN
        day_col(31) := '  ';
      END IF;
    
      -- записываем полученную строку в таблицу графика
      INSERT INTO QWERTY.sp_zar_grafik
      VALUES
        (d,
         smena_type,
         smena_id,
         0,
         0,
         0,
         0,
         0,
         0,
         day_col(1),
         day_col(2),
         day_col(3),
         day_col(4),
         day_col(5),
         day_col(6),
         day_col(7),
         day_col(8),
         day_col(9),
         day_col(10),
         day_col(11),
         day_col(12),
         day_col(13),
         day_col(14),
         day_col(15),
         day_col(16),
         day_col(17),
         day_col(18),
         day_col(19),
         day_col(20),
         day_col(21),
         day_col(22),
         day_col(23),
         day_col(24),
         day_col(25),
         day_col(26),
         day_col(27),
         day_col(28),
         day_col(29),
         day_col(30),
         day_col(31));
    
      -- переходим к следующему месяцу
      d := ADD_MONTHS(d
                     ,1);
    
    END LOOP month_cycle;
  END ADD_SHIFT_H3;

  PROCEDURE ADD_SHIFT_H4(current_date_n VARCHAR2
                        ,smena_id       VARCHAR2
                        ,smena_type     NUMBER
                        ,pos            NUMBER) AS
    /*Расчет графика новой смены 
      (), с известной позиции
      в цикле смены
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      smena_id    : идентификатор смены;
      smena_type  : тип смены;
      pos         : номер позиции в цикле смены
    
      Примечание: Предварительно должен быть расчитан календарь на текущий год
    */
  BEGIN
    SHIFT_ADM.SHIFT4.SCHEDULE_CALCULATE(current_date_n
                                       ,smena_id
                                       ,pos);
  END ADD_SHIFT_H4;

  PROCEDURE NEW_SHIFT(current_date_n VARCHAR2
                     ,smena_id       VARCHAR2
                     ,smena_type     NUMBER) AS
    /*Расчет графика смены на год
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      smena_id    : идентификатор смены;
      smena_type  : тип смены.
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    d           DATE;
    i           NUMBER(2);
    j           NUMBER(2);
    days        NUMBER(2);
    feb_days    NUMBER(2);
    m           NUMBER(2);
    y           NUMBER(4);
    position    NUMBER(2);
    ld_amount   NUMBER(1);
    last_day1   CHAR(2);
    last_day2   CHAR(2);
    last_day3   CHAR(2);
    last_day4   CHAR(2);
    smena       VARCHAR2(8);
    smena_cycle VARCHAR2(64);
    day_col     TDayColumns;
    index_      BINARY_INTEGER := 0;
  BEGIN
    -- "Урезаем" дату до начала года
    d := TRUNC(TO_DATE(current_date_n
                      ,'dd.mm.yyyy')
              ,'YEAR');
  
    -- Вычисляем позицию в цикле смены
    SELECT cycle
          ,days
      INTO smena_cycle
          ,ld_amount
      FROM QWERTY.sp_zar_t_smen
     WHERE tip_smen = smena_type;
    smena_cycle := smena_cycle || smena_cycle;
  
    SELECT d28
          ,d29
          ,d30
          ,d31
      INTO last_day1
          ,last_day2
          ,last_day3
          ,last_day4
      FROM QWERTY.sp_zar_grafik
     WHERE (data_graf = ADD_MONTHS(d
                                  ,-1))
       AND (id_smen = smena_id)
       AND (tip_smen = smena_type);
  
    smena := CONCAT(last_day1
                   ,CONCAT(last_day2
                          ,CONCAT(last_day3
                                 ,last_day4)));
    IF ld_amount = 1 THEN
      smena := SUBSTR(smena
                     ,7
                     ,2);
    ELSIF ld_amount = 2 THEN
      smena := SUBSTR(smena
                     ,5
                     ,4);
    END IF;
    position := INSTR(smena_cycle
                     ,smena) + LENGTH(smena);
  
    -- Вызываем процедуру расчета графика смены с известной позиции в цикле
    SHIFT_ADM.SHIFT.ADD_SHIFT(current_date_n
                             ,smena_id
                             ,smena_type
                             ,position);
  END NEW_SHIFT;

  PROCEDURE WORKTIME_COUNTING(d1       VARCHAR2
                             ,d2       VARCHAR2
                             ,d3       VARCHAR2
                             ,d4       VARCHAR2
                             ,d5       VARCHAR2
                             ,d6       VARCHAR2
                             ,d7       VARCHAR2
                             ,d8       VARCHAR2
                             ,d9       VARCHAR2
                             ,d10      VARCHAR2
                             ,d11      VARCHAR2
                             ,d12      VARCHAR2
                             ,d13      VARCHAR2
                             ,d14      VARCHAR2
                             ,d15      VARCHAR2
                             ,d16      VARCHAR2
                             ,d17      VARCHAR2
                             ,d18      VARCHAR2
                             ,d19      VARCHAR2
                             ,d20      VARCHAR2
                             ,d21      VARCHAR2
                             ,d22      VARCHAR2
                             ,d23      VARCHAR2
                             ,d24      VARCHAR2
                             ,d25      VARCHAR2
                             ,d26      VARCHAR2
                             ,d27      VARCHAR2
                             ,d28      VARCHAR2
                             ,d29      VARCHAR2
                             ,d30      VARCHAR2
                             ,d31      VARCHAR2
                             ,smena_id VARCHAR2
                             ,TIME     OUT NUMBER
                             ,days     OUT NUMBER) AS
    /*Процедура подсчета времени работы и рабочих дней за расчетный месяц
      d1-d31      : отметки за расчетный месяц;
      smena_id    : идентификатор смены;
      Возвращаемые значения:
      time        : количество отработанных часов;
      days        : количество отработанных дней.
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    TYPE TTimeWork IS TABLE OF NUMBER(5, 2) INDEX BY BINARY_INTEGER;
    TYPE TDayWork IS TABLE OF NUMBER(1) INDEX BY BINARY_INTEGER;
    CURSOR otm_cursor IS
      SELECT id_otmetka FROM QWERTY.sp_zar_tabl_smen WHERE id_smen = smena_id;
    amount    NUMBER(2);
    i         NUMBER(2);
    j         NUMBER(2);
    day_col   TDayColumns;
    otmetka   TDayColumns;
    otm_time  TTimeWork;
    otm_days  TDayWork;
    index1    BINARY_INTEGER := 0;
    index2    BINARY_INTEGER := 0;
    work_time NUMBER(5
                    ,2);
    work_days NUMBER(2);
    otm       VARCHAR2(2);
  BEGIN
    day_col(1) := d1;
    day_col(2) := d2;
    day_col(3) := d3;
    day_col(4) := d4;
    day_col(5) := d5;
    day_col(6) := d6;
    day_col(7) := d7;
    day_col(8) := d8;
    day_col(9) := d9;
    day_col(10) := d10;
    day_col(11) := d11;
    day_col(12) := d12;
    day_col(13) := d13;
    day_col(14) := d14;
    day_col(15) := d15;
    day_col(16) := d16;
    day_col(17) := d17;
    day_col(18) := d18;
    day_col(19) := d19;
    day_col(20) := d20;
    day_col(21) := d21;
    day_col(22) := d22;
    day_col(23) := d23;
    day_col(24) := d24;
    day_col(25) := d25;
    day_col(26) := d26;
    day_col(27) := d27;
    day_col(28) := d28;
    day_col(29) := d29;
    day_col(30) := d30;
    day_col(31) := d31;
    work_time := 0; -- Количество рабочих часов
    work_days := 0; -- Количество рабочих дней
    amount := 0; -- Количество отметок для данной смены
  
    -- Выбираем информацию об отметках для данной смены
    OPEN otm_cursor;
    LOOP
      index1 := index1 + 1;
      FETCH otm_cursor
        INTO otmetka(index1);
      EXIT WHEN otm_cursor%NOTFOUND;
      amount := amount + 1;
      SELECT time_work
            ,day_work
        INTO otm_time(index1)
            ,otm_days(index1)
        FROM QWERTY.sp_zar_ot_prop
       WHERE id_otmetka = otmetka(index1);
    END LOOP;
    CLOSE otm_cursor;
  
    FOR i IN 1 .. 31
    LOOP
      index2 := i;
      FOR j IN 1 .. amount
      LOOP
        index1 := j;
        IF day_col(index2) = otmetka(index1) THEN
          BEGIN
            work_time := work_time + otm_time(index1);
            work_days := work_days + otm_days(index1);
            EXIT;
          END;
        END IF;
      END LOOP;
    END LOOP;
  
    TIME := work_time;
    days := work_days;
  END WORKTIME_COUNTING;

  PROCEDURE WORKTIME_CALENDAR(current_year IN VARCHAR2) AS
    /*Подсчет времение работы и количества рабочих дней по календарю
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    CURSOR grafik_row_cursor(cur_year VARCHAR2) IS
      SELECT data_graf
            ,id_smen
            ,time_graf
            ,d1
            ,d2
            ,d3
            ,d4
            ,d5
            ,d6
            ,d7
            ,d8
            ,d9
            ,d10
            ,d11
            ,d12
            ,d13
            ,d14
            ,d15
            ,d16
            ,d17
            ,d18
            ,d19
            ,d20
            ,d21
            ,d22
            ,d23
            ,d24
            ,d25
            ,d26
            ,d27
            ,d28
            ,d29
            ,d30
            ,d31
        FROM QWERTY.sp_zar_GRAFIK
       WHERE (TO_CHAR(data_graf
                     ,'yyyy') = cur_year)
         AND (tip_smen = 0)
         FOR UPDATE OF time_graf, day_graf, time_per, time_pra, time_pra1, time_pra2;
    day_col  TDayColumns;
    index_   BINARY_INTEGER := 0;
    d        DATE;
    smena_id VARCHAR2(2);
    old_time NUMBER(5
                   ,2);
    new_time NUMBER(5
                   ,2);
    new_days NUMBER(5
                   ,2);
  BEGIN
    new_time := 0;
    new_days := 0;
  
    OPEN grafik_row_cursor(current_year);
    LOOP
      FETCH grafik_row_cursor
        INTO d
            ,smena_id
            ,old_time
            ,day_col(1)
            ,day_col(2)
            ,day_col(3)
            ,day_col(4)
            ,day_col(5)
            ,day_col(6)
            ,day_col(7)
            ,day_col(8)
            ,day_col(9)
            ,day_col(10)
            ,day_col(11)
            ,day_col(12)
            ,day_col(13)
            ,day_col(14)
            ,day_col(15)
            ,day_col(16)
            ,day_col(17)
            ,day_col(18)
            ,day_col(19)
            ,day_col(20)
            ,day_col(21)
            ,day_col(22)
            ,day_col(23)
            ,day_col(24)
            ,day_col(25)
            ,day_col(26)
            ,day_col(27)
            ,day_col(28)
            ,day_col(29)
            ,day_col(30)
            ,day_col(31);
      EXIT WHEN grafik_row_cursor%NOTFOUND;
      WORKTIME_COUNTING(day_col(1)
                       ,day_col(2)
                       ,day_col(3)
                       ,day_col(4)
                       ,day_col(5)
                       ,day_col(6)
                       ,day_col(7)
                       ,day_col(8)
                       ,day_col(9)
                       ,day_col(10)
                       ,day_col(11)
                       ,day_col(12)
                       ,day_col(13)
                       ,day_col(14)
                       ,day_col(15)
                       ,day_col(16)
                       ,day_col(17)
                       ,day_col(18)
                       ,day_col(19)
                       ,day_col(20)
                       ,day_col(21)
                       ,day_col(22)
                       ,day_col(23)
                       ,day_col(24)
                       ,day_col(25)
                       ,day_col(26)
                       ,day_col(27)
                       ,day_col(28)
                       ,day_col(29)
                       ,day_col(30)
                       ,day_col(31)
                       ,' О'
                       ,new_time
                       ,new_days);
      UPDATE QWERTY.sp_zar_grafik
         SET time_graf = new_time
            ,day_graf  = new_days
       WHERE CURRENT OF grafik_row_cursor;
    END LOOP;
  
    CLOSE grafik_row_cursor;
  END WORKTIME_CALENDAR;

  PROCEDURE WORKTIME_GRAF(current_year IN VARCHAR2) AS
    /*Подсчет количества рабочего времени, переработки и рабочих дней для всех смен на указанный год
      current_year: строка, содержащий расчетный год в формате 'yyyy'.
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    CURSOR grafik_row_cursor(YEAR VARCHAR2) IS
      SELECT data_graf
            ,id_smen
            ,time_graf
            ,d1
            ,d2
            ,d3
            ,d4
            ,d5
            ,d6
            ,d7
            ,d8
            ,d9
            ,d10
            ,d11
            ,d12
            ,d13
            ,d14
            ,d15
            ,d16
            ,d17
            ,d18
            ,d19
            ,d20
            ,d21
            ,d22
            ,d23
            ,d24
            ,d25
            ,d26
            ,d27
            ,d28
            ,d29
            ,d30
            ,d31
        FROM QWERTY.sp_zar_grafik
       WHERE TO_CHAR(data_graf
                    ,'yyyy') = YEAR
         FOR UPDATE OF time_graf, day_graf, time_per, time_pra, time_pra1, time_pra2;
    day_col       TDayColumns;
    index_        BINARY_INTEGER := 0;
    d             DATE;
    smena_id      VARCHAR2(2);
    old_time      NUMBER(5
                        ,2);
    new_time      NUMBER(5
                        ,2);
    new_days      NUMBER(5
                        ,2);
    new_time_per  NUMBER(5
                        ,2);
    new_time_pra  NUMBER(5
                        ,2);
    new_time_pra1 NUMBER(5
                        ,2);
    new_time_pra2 NUMBER(5
                        ,2);
  BEGIN
    new_time      := 0;
    new_days      := 0;
    new_time_per  := 0;
    new_time_pra  := 0;
    new_time_pra1 := 0;
    new_time_pra2 := 0;
    OPEN grafik_row_cursor(current_year);
    LOOP
      FETCH grafik_row_cursor
        INTO d
            ,smena_id
            ,old_time
            ,day_col(1)
            ,day_col(2)
            ,day_col(3)
            ,day_col(4)
            ,day_col(5)
            ,day_col(6)
            ,day_col(7)
            ,day_col(8)
            ,day_col(9)
            ,day_col(10)
            ,day_col(11)
            ,day_col(12)
            ,day_col(13)
            ,day_col(14)
            ,day_col(15)
            ,day_col(16)
            ,day_col(17)
            ,day_col(18)
            ,day_col(19)
            ,day_col(20)
            ,day_col(21)
            ,day_col(22)
            ,day_col(23)
            ,day_col(24)
            ,day_col(25)
            ,day_col(26)
            ,day_col(27)
            ,day_col(28)
            ,day_col(29)
            ,day_col(30)
            ,day_col(31);
      EXIT WHEN grafik_row_cursor%NOTFOUND;
      IF to_char(d
                ,'yyyy') = current_year THEN
        BEGIN
          IF (smena_id = ' Д') THEN
            BEGIN
              WORKTIME_COUNTING(day_col(1)
                               ,day_col(2)
                               ,day_col(3)
                               ,day_col(4)
                               ,day_col(5)
                               ,day_col(6)
                               ,day_col(7)
                               ,day_col(8)
                               ,day_col(9)
                               ,day_col(10)
                               ,day_col(11)
                               ,day_col(12)
                               ,day_col(13)
                               ,day_col(14)
                               ,day_col(15)
                               ,day_col(16)
                               ,day_col(17)
                               ,day_col(18)
                               ,day_col(19)
                               ,day_col(20)
                               ,day_col(21)
                               ,day_col(22)
                               ,day_col(23)
                               ,day_col(24)
                               ,day_col(25)
                               ,day_col(26)
                               ,day_col(27)
                               ,day_col(28)
                               ,day_col(29)
                               ,day_col(30)
                               ,day_col(31)
                               ,' Д'
                               ,new_time
                               ,new_days);
              OVERTIME(day_col(1)
                      ,day_col(2)
                      ,day_col(3)
                      ,day_col(4)
                      ,day_col(5)
                      ,day_col(6)
                      ,day_col(7)
                      ,day_col(8)
                      ,day_col(9)
                      ,day_col(10)
                      ,day_col(11)
                      ,day_col(12)
                      ,day_col(13)
                      ,day_col(14)
                      ,day_col(15)
                      ,day_col(16)
                      ,day_col(17)
                      ,day_col(18)
                      ,day_col(19)
                      ,day_col(20)
                      ,day_col(21)
                      ,day_col(22)
                      ,day_col(23)
                      ,day_col(24)
                      ,day_col(25)
                      ,day_col(26)
                      ,day_col(27)
                      ,day_col(28)
                      ,day_col(29)
                      ,day_col(30)
                      ,day_col(31)
                      ,' Д'
                      ,d
                      ,new_time
                      ,new_time_per
                      ,new_time_pra
                      ,new_time_pra1
                      ,new_time_pra2);
              UPDATE QWERTY.sp_zar_grafik
                 SET time_graf = new_time
                    ,day_graf  = new_days
                    ,time_per  = new_time_per
                    ,time_pra  = new_time_pra
                    ,time_pra1 = new_time_pra1
                    ,time_pra2 = new_time_pra2
               WHERE CURRENT OF grafik_row_cursor;
              UPDATE QWERTY.sp_zar_grafik
                 SET time_graf = new_time
                    ,day_graf  = 0
               WHERE (data_graf = d)
                 AND (id_smen = ' М');
            END;
          ELSIF smena_id <> ' О' THEN
            BEGIN
              WORKTIME_COUNTING(day_col(1)
                               ,day_col(2)
                               ,day_col(3)
                               ,day_col(4)
                               ,day_col(5)
                               ,day_col(6)
                               ,day_col(7)
                               ,day_col(8)
                               ,day_col(9)
                               ,day_col(10)
                               ,day_col(11)
                               ,day_col(12)
                               ,day_col(13)
                               ,day_col(14)
                               ,day_col(15)
                               ,day_col(16)
                               ,day_col(17)
                               ,day_col(18)
                               ,day_col(19)
                               ,day_col(20)
                               ,day_col(21)
                               ,day_col(22)
                               ,day_col(23)
                               ,day_col(24)
                               ,day_col(25)
                               ,day_col(26)
                               ,day_col(27)
                               ,day_col(28)
                               ,day_col(29)
                               ,day_col(30)
                               ,day_col(31)
                               ,smena_id
                               ,new_time
                               ,new_days);
              OVERTIME(day_col(1)
                      ,day_col(2)
                      ,day_col(3)
                      ,day_col(4)
                      ,day_col(5)
                      ,day_col(6)
                      ,day_col(7)
                      ,day_col(8)
                      ,day_col(9)
                      ,day_col(10)
                      ,day_col(11)
                      ,day_col(12)
                      ,day_col(13)
                      ,day_col(14)
                      ,day_col(15)
                      ,day_col(16)
                      ,day_col(17)
                      ,day_col(18)
                      ,day_col(19)
                      ,day_col(20)
                      ,day_col(21)
                      ,day_col(22)
                      ,day_col(23)
                      ,day_col(24)
                      ,day_col(25)
                      ,day_col(26)
                      ,day_col(27)
                      ,day_col(28)
                      ,day_col(29)
                      ,day_col(30)
                      ,day_col(31)
                      ,smena_id
                      ,d
                      ,new_time
                      ,new_time_per
                      ,new_time_pra
                      ,new_time_pra1
                      ,new_time_pra2);
              UPDATE QWERTY.sp_zar_grafik
                 SET time_graf = new_time
                    ,day_graf  = new_days
                    ,time_per  = new_time_per
                    ,time_pra  = new_time_pra
                    ,time_pra1 = new_time_pra1
                    ,time_pra2 = new_time_pra2
               WHERE CURRENT OF grafik_row_cursor;
            END;
          END IF;
        END;
      END IF;
    END LOOP;
    CLOSE grafik_row_cursor;
  END WORKTIME_GRAF;

  PROCEDURE OVERTIME(d1        VARCHAR2
                    ,d2        VARCHAR2
                    ,d3        VARCHAR2
                    ,d4        VARCHAR2
                    ,d5        VARCHAR2
                    ,d6        VARCHAR2
                    ,d7        VARCHAR2
                    ,d8        VARCHAR2
                    ,d9        VARCHAR2
                    ,d10       VARCHAR2
                    ,d11       VARCHAR2
                    ,d12       VARCHAR2
                    ,d13       VARCHAR2
                    ,d14       VARCHAR2
                    ,d15       VARCHAR2
                    ,d16       VARCHAR2
                    ,d17       VARCHAR2
                    ,d18       VARCHAR2
                    ,d19       VARCHAR2
                    ,d20       VARCHAR2
                    ,d21       VARCHAR2
                    ,d22       VARCHAR2
                    ,d23       VARCHAR2
                    ,d24       VARCHAR2
                    ,d25       VARCHAR2
                    ,d26       VARCHAR2
                    ,d27       VARCHAR2
                    ,d28       VARCHAR2
                    ,d29       VARCHAR2
                    ,d30       VARCHAR2
                    ,d31       VARCHAR2
                    ,smena_id  VARCHAR2
                    ,d         DATE
                    ,graf_time NUMBER
                    ,per       OUT NUMBER
                    ,pra       OUT NUMBER
                    ,pra1      OUT NUMBER
                    ,pra2      OUT NUMBER) AS
    /*Подсчет переработки для смены на заданный месяц
      d1-d31      : отметки за расчетный месяц;
      smena_id    : идентификатор смены;
      d           : дата месяца расчета;
      graf_time   : количество рабочих часов по графику;
      Возвращаемые значения:
      per         : количество часов переработки;
      pra         : количество праздничных часов;
      pra1        : количество праздничных часов (вид 023);
      pra2        : количество праздничных часов (вид 033).
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    TYPE TTimeWork IS TABLE OF NUMBER(5, 2) INDEX BY BINARY_INTEGER;
    --   TYPE TDayWork IS TABLE OF NUMBER(1)
    -- INDEX BY BINARY_INTEGER;
    CURSOR otm_cursor IS
      SELECT id_otmetka FROM QWERTY.sp_zar_tabl_smen WHERE id_smen = smena_id;
    amount   NUMBER(2);
    i        NUMBER(2);
    j        NUMBER(2);
    cal_col  TDayColumns;
    day_col  TDayColumns;
    otmetka  TDayColumns;
    otm_time TTimeWork;
    --  otm_days  TDayWork;
    index1    BINARY_INTEGER := 0;
    index2    BINARY_INTEGER := 0;
    cal_time  NUMBER(5
                    ,2);
    per_time  NUMBER(5
                    ,2);
    pra_time  NUMBER(5
                    ,2);
    pra1_time NUMBER(5
                    ,2);
    pra2_time NUMBER(5
                    ,2);
  BEGIN
    day_col(1) := d1;
    day_col(2) := d2;
    day_col(3) := d3;
    day_col(4) := d4;
    day_col(5) := d5;
    day_col(6) := d6;
    day_col(7) := d7;
    day_col(8) := d8;
    day_col(9) := d9;
    day_col(10) := d10;
    day_col(11) := d11;
    day_col(12) := d12;
    day_col(13) := d13;
    day_col(14) := d14;
    day_col(15) := d15;
    day_col(16) := d16;
    day_col(17) := d17;
    day_col(18) := d18;
    day_col(19) := d19;
    day_col(20) := d20;
    day_col(21) := d21;
    day_col(22) := d22;
    day_col(23) := d23;
    day_col(24) := d24;
    day_col(25) := d25;
    day_col(26) := d26;
    day_col(27) := d27;
    day_col(28) := d28;
    day_col(29) := d29;
    day_col(30) := d30;
    day_col(31) := d31;
    SELECT d1
          ,d2
          ,d3
          ,d4
          ,d5
          ,d6
          ,d7
          ,d8
          ,d9
          ,d10
          ,d11
          ,d12
          ,d13
          ,d14
          ,d15
          ,d16
          ,d17
          ,d18
          ,d19
          ,d20
          ,d21
          ,d22
          ,d23
          ,d24
          ,d25
          ,d26
          ,d27
          ,d28
          ,d29
          ,d30
          ,d31
          ,time_graf
      INTO cal_col(1)
          ,cal_col(2)
          ,cal_col(3)
          ,cal_col(4)
          ,cal_col(5)
          ,cal_col(6)
          ,cal_col(7)
          ,cal_col(8)
          ,cal_col(9)
          ,cal_col(10)
          ,cal_col(11)
          ,cal_col(12)
          ,cal_col(13)
          ,cal_col(14)
          ,cal_col(15)
          ,cal_col(16)
          ,cal_col(17)
          ,cal_col(18)
          ,cal_col(19)
          ,cal_col(20)
          ,cal_col(21)
          ,cal_col(22)
          ,cal_col(23)
          ,cal_col(24)
          ,cal_col(25)
          ,cal_col(26)
          ,cal_col(27)
          ,cal_col(28)
          ,cal_col(29)
          ,cal_col(30)
          ,cal_col(31)
          ,cal_time
      FROM QWERTY.sp_zar_grafik
     WHERE (data_graf = d)
       AND (tip_smen = 0);
    per_time  := 0;
    pra_time  := 0;
    pra1_time := 0;
    pra2_time := 0;
    amount    := 0;
  
    OPEN otm_cursor;
    LOOP
      index1 := index1 + 1;
      FETCH otm_cursor
        INTO otmetka(index1);
      EXIT WHEN otm_cursor%NOTFOUND;
      amount := amount + 1;
      SELECT time_work INTO otm_time(index1) FROM QWERTY.sp_zar_ot_prop WHERE id_otmetka = otmetka(index1);
    END LOOP;
    CLOSE otm_cursor;
  
    FOR i IN 1 .. 31
    LOOP
      index2 := i;
      IF cal_col(index2) = ' П' THEN
        FOR j IN 1 .. amount
        LOOP
          index1 := j;
          IF day_col(index2) = otmetka(index1) THEN
            BEGIN
              pra_time := pra_time + otm_time(index1);
              EXIT;
            END;
          END IF;
        END LOOP;
      END IF;
    END LOOP;
    per_time := graf_time - cal_time;
  
    IF (per_time <= 0) AND
       (smena_id <> ' Д') THEN
      BEGIN
        pra2_time := 0;
        pra1_time := pra_time;
        per_time  := 0;
      END;
    ELSIF pra_time <> 0 THEN
      /*IF per_time<=0 THEN BEGIN
        pra2_time:=pra_time;
        per_time:=0;
        pra1_time:=0;
      END;
        ELSIF pra_time<=per_time THEN BEGIN
        pra2_time:=pra_time;
        per_time:=per_time-pra_time;
        pra1_time:=0;
      END;
      ELSIF pra_time>per_time THEN BEGIN
        pra2_time:=per_time;
        pra1_time:=pra_time-per_time;
        per_time:=0;
      END;
      END IF;*/
      IF (pra_time - per_time) < 0 THEN
        BEGIN
          pra2_time := pra_time;
          per_time  := per_time - pra_time;
          pra1_time := 0;
        END;
      ELSIF (pra_time - per_time) = 0 THEN
        BEGIN
          pra2_time := pra_time;
          per_time  := 0;
          pra1_time := 0;
        END;
      ELSIF (pra_time - per_time) > 0 THEN
        BEGIN
          pra2_time := per_time;
          pra1_time := pra_time - per_time;
          per_time  := 0;
        END;
      END IF;
    END IF;
  
    -- IF (per_time<0) AND (smena_id<>' Д') THEN per_time:=0;
    -- END IF;
  
    per  := per_time;
    pra  := pra_time;
    pra1 := pra1_time;
    pra2 := pra2_time;
  END OVERTIME;

  PROCEDURE WORKTIME_SHIFT(current_year IN VARCHAR2
                          ,smena        IN VARCHAR2) IS
    /*Подсчет количества часов работы и рабочих дней для заданной смены на заданный год
      current_year: строка, содержащая расчетный год в формате 'yyyy';
      smena       : идентификатор смены.
    */
    TYPE TDayColumns IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
    CURSOR grafik_row_cursor(cur_year VARCHAR2) IS
      SELECT data_graf
            ,id_smen
            ,time_graf
            ,d1
            ,d2
            ,d3
            ,d4
            ,d5
            ,d6
            ,d7
            ,d8
            ,d9
            ,d10
            ,d11
            ,d12
            ,d13
            ,d14
            ,d15
            ,d16
            ,d17
            ,d18
            ,d19
            ,d20
            ,d21
            ,d22
            ,d23
            ,d24
            ,d25
            ,d26
            ,d27
            ,d28
            ,d29
            ,d30
            ,d31
        FROM QWERTY.sp_zar_grafik
       WHERE TO_CHAR(data_graf
                    ,'yyyy') = cur_year
         FOR UPDATE OF time_graf, day_graf, time_per, time_pra, time_pra1, time_pra2;
    day_col       TDayColumns;
    index_        BINARY_INTEGER := 0;
    d             DATE;
    smena_id      VARCHAR2(2);
    old_time      NUMBER(5
                        ,2);
    new_time      NUMBER(5
                        ,2);
    new_days      NUMBER(5
                        ,2);
    new_time_per  NUMBER(5
                        ,2);
    new_time_pra  NUMBER(5
                        ,2);
    new_time_pra1 NUMBER(5
                        ,2);
    new_time_pra2 NUMBER(5
                        ,2);
    vchDate       VARCHAR(10);
  BEGIN
    vchDate := '01.01.' || current_year;
    SHIFT_ADM.SHIFT4.SCHEDULE_CALCULATE_WORKTIME(vchDate
                                                ,smena
                                                ,TRUE
                                                ,TRUE);
    /*
      new_time:=0;
      new_days:=0;
      new_time_per:=0;
      new_time_pra:=0;
      new_time_pra1:=0;
      new_time_pra2:=0;
      OPEN grafik_row_cursor(current_year);
      LOOP
     FETCH grafik_row_cursor INTO d,smena_id,old_time,day_col(1),day_col(2),day_col(3),
       day_col(4),day_col(5),day_col(6),day_col(7),day_col(8),day_col(9),day_col(10),
       day_col(11),day_col(12),day_col(13),day_col(14),day_col(15),day_col(16),
       day_col(17),day_col(18),day_col(19),day_col(20),day_col(21),day_col(22),
       day_col(23),day_col(24),day_col(25),day_col(26),day_col(27),day_col(28),
       day_col(29),day_col(30),day_col(31);
     EXIT WHEN grafik_row_cursor%NOTFOUND;
    
     IF smena_id=smena THEN BEGIN 
           WORKTIME_COUNTING(day_col(1),day_col(2),day_col(3),
           day_col(4),day_col(5),day_col(6),day_col(7),
           day_col(8),day_col(9),day_col(10),day_col(11),
           day_col(12),day_col(13),day_col(14),day_col(15),
           day_col(16),day_col(17),day_col(18),day_col(19),
           day_col(20),day_col(21),day_col(22),day_col(23),
           day_col(24),day_col(25),day_col(26),day_col(27),
           day_col(28),day_col(29),day_col(30),day_col(31), 
           smena,new_time,new_days);
           OVERTIME(day_col(1),day_col(2),day_col(3),
           day_col(4),day_col(5),day_col(6),day_col(7),
           day_col(8),day_col(9),day_col(10),day_col(11),
           day_col(12),day_col(13),day_col(14),day_col(15),
           day_col(16),day_col(17),day_col(18),day_col(19),
           day_col(20),day_col(21),day_col(22),day_col(23),
           day_col(24),day_col(25),day_col(26),day_col(27),
           day_col(28),day_col(29),day_col(30),day_col(31),
           smena,d,new_time,new_time_per,new_time_pra,new_time_pra1,new_time_pra2);
           UPDATE QWERTY.sp_zar_grafik SET time_graf=new_time,
             day_graf=new_days,time_per=new_time_per,
             time_pra=new_time_pra,time_pra1=new_time_pra1,
             time_pra2=new_time_pra2
             WHERE CURRENT OF grafik_row_cursor;
           IF smena=' Д' THEN
           UPDATE QWERTY.sp_zar_grafik SET time_graf=new_time,
             day_graf=0
             WHERE (data_graf=d) AND (id_smen=' М');
           END IF;
         END;
     END IF;
    
      END LOOP;
      CLOSE grafik_row_cursor;
    */
  END WORKTIME_SHIFT;

  PROCEDURE NEW_YEAR(current_date_n VARCHAR2
                    ,hol            NUMBER) AS
    /*Процедура автоматического составление графика на заданный год
      current_date_n: текущая дата, в формате dd.mm.yyyy;
      hol         : =0, праздник, попадающий на выходной не переносится на рабочий день;
                    =1, праздник, попадающий на выходной переносится на рабочий день.
    */
    CURSOR shift_list IS
      SELECT tip_smen
            ,hol_type
        FROM QWERTY.sp_zar_T_SMEN;
    CURSOR shift_id_list(shift_type NUMBER) IS
      SELECT id_smen FROM QWERTY.sp_zar_S_SMEN WHERE tip_smen = shift_type;
    cur_date_d     DATE;
    cur_date_vch   VARCHAR2(10);
    cur_weekday    NUMBER;
    cur_shift_type NUMBER;
    cur_hol_type   NUMBER;
    cur_shift_id   VARCHAR2(2);
    error_counter  NUMBER;
  BEGIN
    cur_date_d    := TRUNC(TO_DATE(current_date_n
                                  ,'dd.mm.yyyy')
                          ,'YEAR');
    cur_date_vch  := TO_CHAR(cur_date_d
                            ,'dd.mm.yyyy');
    error_counter := 0;
  
    -- Удаляем из таблицы графика информацию по данному году
    DELETE FROM QWERTY.sp_zar_GRAFIK
     WHERE TO_CHAR(data_graf
                  ,'yyyy') = TO_CHAR(cur_date_d
                                    ,'yyyy');
    -- Расчитываем календарь на данный год
    SHIFT_ADM.SHIFT.NEW_CALENDAR(cur_date_vch
                                ,hol);
  
    OPEN shift_list;
    <<shift_list_cycle>>
    LOOP
      FETCH shift_list
        INTO cur_shift_type
            ,cur_hol_type;
      EXIT WHEN shift_list%NOTFOUND;
    
      IF cur_hol_type = 0 THEN
        BEGIN
          -- По календарю, однонедельный цикл
        
          IF cur_shift_type <> 0 THEN
            BEGIN
              SELECT TO_NUMBER(TO_CHAR(cur_date_d
                                      ,'d'))
                INTO cur_weekday
                FROM DUAL;
            
              OPEN shift_id_list(cur_shift_type);
              <<shift_id_list_cycle>>
              LOOP
                FETCH shift_id_list
                  INTO cur_shift_id;
                EXIT WHEN shift_id_list%NOTFOUND;
                SHIFT_ADM.SHIFT.ADD_SHIFT_H(cur_date_vch
                                           ,cur_shift_id
                                           ,cur_shift_type
                                           ,cur_weekday * 2 - 1);
              END LOOP shift_id_list_cycle;
              CLOSE shift_id_list;
            END;
          END IF;
        
        END;
      ELSIF cur_hol_type = 1 THEN
        BEGIN
          -- Циклические смены
          OPEN shift_id_list(cur_shift_type);
          <<shift_id_list_cycle>>
          LOOP
            FETCH shift_id_list
              INTO cur_shift_id;
            EXIT WHEN shift_id_list%NOTFOUND;
            SHIFT_ADM.SHIFT.NEW_SHIFT(cur_date_vch
                                     ,cur_shift_id
                                     ,cur_shift_type);
          END LOOP shift_id_list_cycle;
          CLOSE shift_id_list;
        
        END;
      ELSIF cur_hol_type = 2 THEN
        BEGIN
          -- По календарю, многонедельный цикл
          cur_weekday := cur_weekday;
        END;
      END IF;
    
    END LOOP shift_list_cycle;
    CLOSE shift_list;
  
    WORKTIME_CALENDAR(TO_CHAR(cur_date_d
                             ,'yyyy'));
    WORKTIME_GRAF(TO_CHAR(cur_date_d
                         ,'yyyy'));
  END NEW_YEAR;

  PROCEDURE NEW_MARK(smena_type   IN NUMBER
                    ,mark_id      IN CHAR
                    ,work_time    IN NUMBER
                    ,id_vid       IN NUMBER
                    ,day_work     IN NUMBER
                    ,night_time   IN NUMBER
                    ,evening_time IN NUMBER
                    ,description  IN VARCHAR2
                    ,begin_time   IN VARCHAR2
                    ,end_time     IN VARCHAR2
                    ,obed         IN NUMBER) AS
    /*Процедура добавления новой отметки в базу данных
      smena_type  : тип смены;
      mark_id     : идентификатор новой отметки;
      work_time   : количество рабочих часов;
      id_vid      : вид;
      day_work    : количество рабочих дней;
      night_time  : количество ночных часов;
      evening_time: количество вечерних часов;
      description : описание;
      begin_tiem  : время начала работы;
      end_time    : время окончания работы.
    */
    CURSOR shift_id_list(shift_type NUMBER) IS
      SELECT id_smen FROM QWERTY.sp_zar_S_SMEN WHERE tip_smen = shift_type;
    cur_shift_id CHAR(2);
  BEGIN
    INSERT INTO QWERTY.sp_zar_OT_PROP VALUES (mark_id, work_time, id_vid, day_work, night_time, evening_time, description, begin_time, end_time, obed);
    OPEN shift_id_list(smena_type);
    <<shift_id_list_cycle>>
    LOOP
      FETCH shift_id_list
        INTO cur_shift_id;
      EXIT WHEN shift_id_list%NOTFOUND;
      INSERT INTO QWERTY.sp_zar_TABL_SMEN VALUES (cur_shift_id, mark_id);
    END LOOP shift_id_list_cycle;
  END NEW_MARK;

--begin
-- Initialization
--  <Statement>;
END SHIFT;
/
