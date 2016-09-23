CREATE OR REPLACE PACKAGE shift_adm.SHIFT4 IS

  -- Author  : BISHOP
  -- Created : 13.11.2006 9:41:04
  -- Purpose : ����� ��� ��������� ������� �������� ������ ���� ���

  -- Public type declarations
  --  type <TypeName> is <Datatype>;
  TYPE DAY_COLUMNS IS TABLE OF CHAR(2) INDEX BY BINARY_INTEGER;
  --  type MARK_INFO is RECORD (miMARK CHAR(2), miTIME_WORK NUMBER(5, 2), miDAY_WORK NUMBER(1), miTIME_N NUMBER(5, 2), miTIME_V NUMBER(5, 2));
  --  type MARK_LIST is TABLE of MARK_INFO INDEX BY BINARY_INTEGER;

  -- Public constant declarations
  --  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --  <VariableName> <Datatype>;

  -- Public function and procedure declarations
  --  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

  PROCEDURE SCHEDULE_CALCULATE(v_schedule_date VARCHAR2
                              ,v_shift_id      VARCHAR2
                              ,v_cycle_pos     NUMBER);
  /*
  ������ ������� ������ �����.
    v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
    v_shift_id      - ID �����
    v_cycle_por     - ������� � �����, � ������� ���������� ������
  */

  PROCEDURE SCHEDULE_CALCULATE_WITH_PAST(v_schedule_date VARCHAR2
                                        ,v_shift_id      VARCHAR2);
  /*
  ������ ������� ������ �����, ��� ������� � ����� ������������ �� ���������� ����
    v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
    v_shift_id      - ID �����
  */

  PROCEDURE CALENDAR_NEW(v_schedule_date VARCHAR2
                        ,v_hol           BOOLEAN);
  /*
  ������ ������ ��������� �� ���
    v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy       
  */

  PROCEDURE SCHEDULE_CALCULATE_WORKTIME(v_schedule_date VARCHAR2
                                       ,v_shift_id      VARCHAR2
                                       ,v_whole_year    BOOLEAN
                                       ,v_holiday_time  BOOLEAN);
  /*
  ������� ������� ������ �����
    v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
    v_shift_id      - ID �����
    v_whole_year    - ����: ��������� ������ �� ���� ��� (TRUE)
                            ��� ������ ��������� ����� (FALSE)
    v_holiday_time  - ����: ������� ����������� (TRUE)
                            ��� ��� (FALSE)
  */

  PROCEDURE COPY_DAYS_TIME_FROM_DAYSTAFF(v_schedule_date VARCHAR2
                                        ,v_whole_year    BOOLEAN);
  /*
  ������� ������� ������ �����
    v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
    v_whole_year    - ����: ���������� ������ �� ���� ��� (TRUE)
                            ��� ������ �� ��������� ����� (FALSE)
  */

END shift4;
/
CREATE OR REPLACE PACKAGE BODY shift_adm.SHIFT4 IS

  -- Private type declarations
  --  type <TypeName> is <Datatype>;

  -- Private constant declarations
  --  <ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --  <VariableName> <Datatype>;

  -- Function and procedure implementations
  --  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
  --    <LocalVariable> <Datatype>;
  --  begin
  --    <Statement>;
  --    return(<Result>);
  --  end;

  --***************************************************************************************
  --***************************************************************************************
  FUNCTION LEAP_YEAR(v_year NUMBER) RETURN BOOLEAN IS
    /*
    ���������� ������������ ����
      v_year - �����, ������������ ���
    */
  BEGIN
    /*if (mod(v_year, 400)=0) or ((mod(v_year, 4)=0) and not(mod(v_year, 100)=0)) then
      return(TRUE);
    else
      return(FALSE);
    end if;*/
    IF MOD(v_year
          ,400) = 0 THEN
      RETURN(TRUE);
    ELSIF MOD(v_year
             ,100) = 0 THEN
      RETURN(FALSE);
    ELSIF MOD(v_year
             ,4) = 0 THEN
      RETURN(TRUE);
    ELSE
      RETURN(FALSE);
    END IF;
  END LEAP_YEAR;

  --***************************************************************************************
  --***************************************************************************************
  FUNCTION FEBRUARY_DAYS(v_year NUMBER) RETURN NUMBER IS
    /*
    ������ ���������� ���� � ������� ��������� ����
      v_year - �����, ������������ ���
    */
  BEGIN
    IF LEAP_YEAR(v_year) THEN
      RETURN(29);
    ELSE
      RETURN(28);
    END IF;
  END FEBRUARY_DAYS;

  --***************************************************************************************
  --***************************************************************************************
  FUNCTION MONTH_DAYS(v_date DATE) RETURN NUMBER IS
    /*
    ������ ���������� ���� � ������
      v_date - ����
    */
    m NUMBER(2);
  BEGIN
    SELECT to_number(to_char(v_date
                            ,'mm'))
      INTO m
      FROM DUAL;
    IF ((MOD(m
            ,2) = 1) AND (m <= 7)) OR
       ((MOD(m
            ,2) = 0) AND (m > 7)) THEN
      RETURN(31);
    ELSIF m = 2 THEN
      RETURN(FEBRUARY_DAYS(to_number(to_char(v_date
                                            ,'yyyy'))));
    ELSIF ((MOD(m
               ,2) = 0) AND (m <= 7)) OR
          ((MOD(m
               ,2) = 1) AND (m > 7)) THEN
      RETURN(30);
    END IF;
  END MONTH_DAYS;

  --***************************************************************************************
  --***************************************************************************************
  PROCEDURE SCHEDULE_CALCULATE(v_SCHEDULE_DATE VARCHAR2
                              ,v_SHIFT_ID      VARCHAR2
                              ,v_CYCLE_POS     NUMBER) IS
    /*
      v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
      v_shift_id      - ID �����
      v_cycle_pos     - ������� � �����, � ������� ���������� ������
    */
    dCUR_DATE DATE;
    nMONTH    NUMBER(2);
    nDAY      NUMBER(2);
  
    schTYPE    NUMBER(3);
    schCYCLE   VARCHAR2(160);
    schDAYS    NUMBER(2);
    schHOLIDAY NUMBER(2);
  
    nPOSITION   NUMBER(3);
    i           NUMBER(2);
    j           NUMBER(2);
    nMONTH_DAYS NUMBER(2);
    dcCALENDAR  DAY_COLUMNS;
    dcOLD_SCHED DAY_COLUMNS;
    biINDEX     BINARY_INTEGER := 0;
    dcSCHEDULE  DAY_COLUMNS;
  BEGIN
    --��������� ���������� ����� ������ � ��� ��������� ����
    SELECT to_number(to_char(to_date(v_SCHEDULE_DATE
                                    ,'dd.mm.yyyy')
                            ,'mm'))
          ,to_number(to_char(to_date(v_SCHEDULE_DATE
                                    ,'dd.mm.yyyy')
                            ,'dd'))
      INTO nMONTH
          ,nDAY
      FROM DUAL;
    -- nMONTH - ���������� ����� ������
    -- nDAY   - ���������� ����� ���
  
    --������� ���� �� ������ ������
    dCUR_DATE := TRUNC(to_date(v_schedule_date
                              ,'dd.mm.yyyy')
                      ,'MONTH');
  
    --�������� ���������� � �������
    SELECT tip_smen
          ,cycle
          ,days
          ,hol_type
      INTO schTYPE
          ,schCYCLE
          ,schDAYS
          ,schHOLIDAY
      FROM QWERTY.SP_ZAR_T_SMEN
     WHERE tip_smen = (SELECT tip_smen FROM QWERTY.SP_ZAR_S_SMEN WHERE id_smen = v_SHIFT_ID);
  
    --��������� ����
    schCYCLE := schCYCLE || schCYCLE;
  
    nPOSITION := v_cycle_pos;
  
    --����������� �������
    <<month_cycle>>
    FOR i IN nMONTH .. 12
    LOOP
      --��������� ���������� ���� � ������
      nMONTH_DAYS := MONTH_DAYS(dCUR_DATE);
    
      --�������� ��������� �� ������� �����
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
        INTO dcCALENDAR(1)
            ,dcCALENDAR(2)
            ,dcCALENDAR(3)
            ,dcCALENDAR(4)
            ,dcCALENDAR(5)
            ,dcCALENDAR(6)
            ,dcCALENDAR(7)
            ,dcCALENDAR(8)
            ,dcCALENDAR(9)
            ,dcCALENDAR(10)
            ,dcCALENDAR(11)
            ,dcCALENDAR(12)
            ,dcCALENDAR(13)
            ,dcCALENDAR(14)
            ,dcCALENDAR(15)
            ,dcCALENDAR(16)
            ,dcCALENDAR(17)
            ,dcCALENDAR(18)
            ,dcCALENDAR(19)
            ,dcCALENDAR(20)
            ,dcCALENDAR(21)
            ,dcCALENDAR(22)
            ,dcCALENDAR(23)
            ,dcCALENDAR(24)
            ,dcCALENDAR(25)
            ,dcCALENDAR(26)
            ,dcCALENDAR(27)
            ,dcCALENDAR(28)
            ,dcCALENDAR(29)
            ,dcCALENDAR(30)
            ,dcCALENDAR(31)
        FROM QWERTY.SP_ZAR_GRAFIK
       WHERE (data_graf = dCUR_DATE)
         AND (tip_smen = 0);
    
      <<day_cycle>>
    --�������� ������ �������� ����, ���������������� ��� ������ �������
      IF nDAY > 1 THEN
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
          INTO dcOLD_SCHED(1)
              ,dcOLD_SCHED(2)
              ,dcOLD_SCHED(3)
              ,dcOLD_SCHED(4)
              ,dcOLD_SCHED(5)
              ,dcOLD_SCHED(6)
              ,dcOLD_SCHED(7)
              ,dcOLD_SCHED(8)
              ,dcOLD_SCHED(9)
              ,dcOLD_SCHED(10)
              ,dcOLD_SCHED(11)
              ,dcOLD_SCHED(12)
              ,dcOLD_SCHED(13)
              ,dcOLD_SCHED(14)
              ,dcOLD_SCHED(15)
              ,dcOLD_SCHED(16)
              ,dcOLD_SCHED(17)
              ,dcOLD_SCHED(18)
              ,dcOLD_SCHED(19)
              ,dcOLD_SCHED(20)
              ,dcOLD_SCHED(21)
              ,dcOLD_SCHED(22)
              ,dcOLD_SCHED(23)
              ,dcOLD_SCHED(24)
              ,dcOLD_SCHED(25)
              ,dcOLD_SCHED(26)
              ,dcOLD_SCHED(27)
              ,dcOLD_SCHED(28)
              ,dcOLD_SCHED(29)
              ,dcOLD_SCHED(30)
              ,dcOLD_SCHED(31)
          FROM QWERTY.SP_ZAR_GRAFIK
         WHERE (data_graf = dCUR_DATE)
           AND (id_smen = v_shift_id);
      
        FOR j IN 1 .. nDAY
        LOOP
          biINDEX := j;
          dcSCHEDULE(biINDEX) := dcOLD_SCHED(biINDEX);
        END LOOP;
      END IF;
    
      --����������� ��� �������, ������� � ��� �������
      FOR j IN nDAY .. nMONTH_DAYS
      LOOP
        biINDEX := j;
        IF nPOSITION > LENGTH(schCYCLE) THEN
          nPOSITION := 1;
        END IF;
      
        /*
        ������������� ������� �� ���������, ������������ � ��������� �������� � �������� ���
          ��� ����� ����������
              0 - �������� �������� �������� ����, ����������� �������� �������� (�������� �� ���������),
              1 - �������� �� �������� ��������,
              2 - �������� �������� �������� � ��������� ����,
              3 - ����������� � �������� �������� ��������� � ��������� ����
              4 - �������� �������� ��������, �� �� ��������� ����
        */
        IF dcCALENDAR(biINDEX) = ' �' THEN
          IF (schHOLIDAY = 0) THEN
            BEGIN
              dcSCHEDULE(biINDEX) := ' �';
              nPOSITION := nPOSITION + 2;
            END;
          ELSIF schHOLIDAY = 1 THEN
            BEGIN
              dcSCHEDULE(biINDEX) := SUBSTR(schCYCLE
                                           ,nPOSITION
                                           ,2);
              nPOSITION := nPOSITION + 2;
              NULL;
            END;
          ELSIF schHOLIDAY = 2 OR
                schHOLIDAY = 3 THEN
            BEGIN
              dcSCHEDULE(biINDEX) := ' �';
              --nPOSITION := nPOSITION + 2;
            END;
          ELSIF (schHOLIDAY = 4) THEN
            BEGIN
              dcSCHEDULE(biINDEX) := ' �';
              nPOSITION := nPOSITION + 2;
            END;
          END IF;
        ELSIF dcCALENDAR(biINDEX) = ' �' AND
              (schHOLIDAY = 0 OR schHOLIDAY = 3) THEN
          BEGIN
            dcSCHEDULE(biINDEX) := ' �';
            IF schHOLIDAY = 0 THEN
              nPosition := nPOSITION + 2;
            END IF;
          END;
        ELSIF dcCALENDAR(biINDEX) = '��' AND
              schTYPE = 1 THEN
          BEGIN
            dcSCHEDULE(biINDEX) := ' 7';
            nPosition := nPOSITION + 2;
          END;
        ELSE
          BEGIN
            dcSCHEDULE(biINDEX) := SUBSTR(schCYCLE
                                         ,nPOSITION
                                         ,2);
            nPOSITION := nPOSITION + 2;
          END;
        END IF;
      END LOOP day_cycle;
      --���������� ����� ��� ��� ���������� ������
      nDAY := 1;
    
      --���������� ������ �������� � ����� ��� ������� � ������� � 30-� �����
      FOR j IN nMONTH_DAYS + 1 .. 31
      LOOP
        biINDEX := j;
        dcSCHEDULE(biINDEX) := '  ';
      END LOOP;
    
      --���������� ���������� ����� � ������� �������
      DELETE FROM QWERTY.SP_ZAR_GRAFIK
       WHERE data_graf = dCUR_DATE
         AND id_smen = v_shift_id;
      DELETE FROM QWERTY.SP_ZAR_GRAFIK_NV
       WHERE data_graf = dCUR_DATE
         AND id_smen = v_shift_id;
      INSERT INTO QWERTY.SP_ZAR_GRAFIK
      VALUES
        (dCUR_DATE,
         schTYPE,
         v_SHIFT_ID,
         0,
         0,
         0,
         0,
         0,
         0,
         dcSCHEDULE(1),
         dcSCHEDULE(2),
         dcSCHEDULE(3),
         dcSCHEDULE(4),
         dcSCHEDULE(5),
         dcSCHEDULE(6),
         dcSCHEDULE(7),
         dcSCHEDULE(8),
         dcSCHEDULE(9),
         dcSCHEDULE(10),
         dcSCHEDULE(11),
         dcSCHEDULE(12),
         dcSCHEDULE(13),
         dcSCHEDULE(14),
         dcSCHEDULE(15),
         dcSCHEDULE(16),
         dcSCHEDULE(17),
         dcSCHEDULE(18),
         dcSCHEDULE(19),
         dcSCHEDULE(20),
         dcSCHEDULE(21),
         dcSCHEDULE(22),
         dcSCHEDULE(23),
         dcSCHEDULE(24),
         dcSCHEDULE(25),
         dcSCHEDULE(26),
         dcSCHEDULE(27),
         dcSCHEDULE(28),
         dcSCHEDULE(29),
         dcSCHEDULE(30),
         dcSCHEDULE(31));
      --��������� ������ � ������� � ������� � ������ � �������� �����
      INSERT INTO QWERTY.SP_ZAR_GRAFIK_NV VALUES (dCUR_DATE, v_SHIFT_ID, 0, 0);
    
      --������������ ���� �� ������ ���������� ������
      dCUR_DATE := ADD_MONTHS(dCUR_DATE
                             ,1);
    END LOOP month_cycle;
  
  END SCHEDULE_CALCULATE;

  --***************************************************************************************
  --***************************************************************************************
  PROCEDURE SCHEDULE_CALCULATE_WITH_PAST(v_SCHEDULE_DATE VARCHAR2
                                        ,v_SHIFT_ID      VARCHAR2) IS
    /*
    ������ ������� ������ �����, ��� ������� � ����� ������������ �� ���������� ����
      v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
      v_shift_id      - ID �����
    */
    dCUR_DATE   DATE;
    dPREV_DATE  DATE; --���� ������, ����� ���������� �������� ���������� ���
    nSTART_DAY  NUMBER(2);
    nDAYS       NUMBER(1); --���������� ������������ ���� � �����
    dcPREV_DAYS DAY_COLUMNS;
    biINDEX     BINARY_INTEGER;
    vCYCLE      VARCHAR2(160); --���� �����
    vPREV_CYCLE VARCHAR2(160);
    nMONTH_DAYS NUMBER(2); --���������� ���� � ���������� ������
    i           NUMBER(2);
    nPOSITION   NUMBER(2);
    nCORRECTION NUMBER(2); --����� � ����� ��� ����� ������ ������������� 30 � 31 �������, � ���������� � �������������� ���� ������� ���
  BEGIN
    dCUR_DATE  := TO_DATE(v_schedule_date
                         ,'dd.mm.yyyy');
    dPREV_DATE := TRUNC(ADD_MONTHS(dCUR_DATE
                                  ,-1)
                       ,'MONTH');
    --�������� ���������� ������������ ���� ����� � ��� ���� ��� �������� �����
    SELECT days
          ,cycle || cycle
      INTO nDAYS
          ,vCYCLE
      FROM QWERTY.SP_ZAR_T_SMEN
     WHERE tip_smen = (SELECT tip_smen FROM QWERTY.SP_ZAR_S_SMEN WHERE id_smen = v_SHIFT_ID);
    --� ������ ���������� ���� �������� ������ �� �������������� �����
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
      INTO dcPREV_DAYS(1)
          ,dcPREV_DAYS(2)
          ,dcPREV_DAYS(3)
          ,dcPREV_DAYS(4)
          ,dcPREV_DAYS(5)
          ,dcPREV_DAYS(6)
          ,dcPREV_DAYS(7)
          ,dcPREV_DAYS(8)
          ,dcPREV_DAYS(9)
          ,dcPREV_DAYS(10)
          ,dcPREV_DAYS(11)
          ,dcPREV_DAYS(12)
          ,dcPREV_DAYS(13)
          ,dcPREV_DAYS(14)
          ,dcPREV_DAYS(15)
          ,dcPREV_DAYS(16)
          ,dcPREV_DAYS(17)
          ,dcPREV_DAYS(18)
          ,dcPREV_DAYS(19)
          ,dcPREV_DAYS(20)
          ,dcPREV_DAYS(21)
          ,dcPREV_DAYS(22)
          ,dcPREV_DAYS(23)
          ,dcPREV_DAYS(24)
          ,dcPREV_DAYS(25)
          ,dcPREV_DAYS(26)
          ,dcPREV_DAYS(27)
          ,dcPREV_DAYS(28)
          ,dcPREV_DAYS(29)
          ,dcPREV_DAYS(30)
          ,dcPREV_DAYS(31)
      FROM QWERTY.SP_ZAR_GRAFIK
     WHERE data_graf = dPREV_DATE
       AND id_smen = v_shift_id;
    --���������� � ������ ����� �� �������� ������ �������
    nSTART_DAY := TO_NUMBER(TO_CHAR(dCUR_DATE
                                   ,'dd'));
    --���� ������ ������� �� � 1�� ����� ������, �� ��� ���������� � ������ ���������� ����
    -- �������� �������������� ��� � ������� ������
    IF nSTART_DAY <> 1 THEN
      --��� �������� ������ ����� ��� ������ �� ������� �����, ���� ������ ������� ���� ����
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
        INTO dcPREV_DAYS(32)
            ,dcPREV_DAYS(33)
            ,dcPREV_DAYS(34)
            ,dcPREV_DAYS(35)
            ,dcPREV_DAYS(36)
            ,dcPREV_DAYS(37)
            ,dcPREV_DAYS(38)
            ,dcPREV_DAYS(39)
            ,dcPREV_DAYS(40)
            ,dcPREV_DAYS(41)
            ,dcPREV_DAYS(42)
            ,dcPREV_DAYS(43)
            ,dcPREV_DAYS(44)
            ,dcPREV_DAYS(45)
            ,dcPREV_DAYS(46)
            ,dcPREV_DAYS(47)
            ,dcPREV_DAYS(48)
            ,dcPREV_DAYS(49)
            ,dcPREV_DAYS(50)
            ,dcPREV_DAYS(51)
            ,dcPREV_DAYS(52)
            ,dcPREV_DAYS(53)
            ,dcPREV_DAYS(54)
            ,dcPREV_DAYS(55)
            ,dcPREV_DAYS(56)
            ,dcPREV_DAYS(57)
            ,dcPREV_DAYS(58)
            ,dcPREV_DAYS(59)
            ,dcPREV_DAYS(60)
            ,dcPREV_DAYS(61)
            ,dcPREV_DAYS(62)
        FROM QWERTY.SP_ZAR_GRAFIK
       WHERE data_graf = TRUNC(dCUR_DATE
                              ,'MONTH')
         AND id_smen = v_shift_id;
    END IF;
    --�������� ��������� ��� ����������� ������:
    -- ������ ������ � ����������� �����
    vPREV_CYCLE := '';
    nMONTH_DAYS := MONTH_DAYS(dPREV_DATE) + nSTART_DAY - 1; --"+nSTART_DAY-1" - ��������� ���� ������ �������
    nCORRECTION := 2; --���� ���� ������ ������ (�.�. � ��� ������ 31.12 ��������, � 30.12 �����������)
    --���� ��� ������ ��������� ������� � ����� �����
    LOOP
      --�������������� ���� ������� �������� nCORRECTION,
      -- �������� vPREV_CYCLE �� ������� � �� ������� ' �',
      -- �, � ������ �� �����������, ���������� ������ ����� �� ������
      LOOP
        FOR i IN 0 .. nDAYS - 1
        LOOP
          biINDEX     := nMONTH_DAYS - i - nCORRECTION; --�������� "-nCORRECTION" ��� ����� ������ (��. �������� nCORRECTION)
          vPREV_CYCLE := dcPREV_DAYS(biINDEX) || vPREV_CYCLE;
        END LOOP;
        EXIT WHEN(INSTR(vPREV_CYCLE
                       ,' �') = 0 AND INSTR(vPREV_CYCLE
                                           ,'  ') = 0);
        nCORRECTION := nCORRECTION + nDAYS;
        vPREV_CYCLE := '';
      END LOOP;
      --�������� � ������� � ����� �����
      nPOSITION := INSTR(vCYCLE
                        ,vPREV_CYCLE);
      EXIT WHEN nPOSITION <> 0;
      nCORRECTION := nCORRECTION + nDAYS;
      vPREV_CYCLE := '';
    END LOOP;
    nPOSITION := nPOSITION + nDAYS * 2 + nCORRECTION * 2; --������� "+nCORRECTION*2" ��� ����������� ������ (��. �������� nCORRECTION)
    --���� ����� �� ������� �����,
    IF nPOSITION > LENGTH(vCYCLE) THEN
      -- �� �������� ������� �� ����� �����
      nPOSITION := nPOSITION MOD LENGTH(vCYCLE);
    END IF;
    SCHEDULE_CALCULATE(v_schedule_date
                      ,v_shift_id
                      ,nPOSITION);
  END SCHEDULE_CALCULATE_WITH_PAST;

  --***************************************************************************************
  --***************************************************************************************
  PROCEDURE CALENDAR_NEW(v_schedule_date VARCHAR2
                        ,v_hol           BOOLEAN) IS
    /*
      ����������� ������ ���������
        v_schedule_date   - ���� � ���� ������ � ������� dd.mm.yyyy
        v_hol             - ��� ������� �� ��������� � �������� ���
          ��� v_hol=FALSE - ���� �������� �������� �� �������� ����,
                            �������� ��(!!!) ����������� �� ������ ����� ���� ������� ����
          ��� v_hol=TRUE  - ���� �������� �������� �� �������� ����,
                            �������� ����������� �� ������ ������� ���� ����� ����
    !!!��������� �� ���������� ������ �������� ��������� ���, ���� ����� 3 ���������� ��� ������!!!
    
      */
    CURSOR holiday_cursor(v_date DATE) IS
      SELECT dat_prazdn
        FROM QWERTY.SP_ZAR_PRAZDN
       WHERE to_char(dat_prazdn
                    ,'mm.yyyy') = to_char(v_date
                                         ,'mm.yyyy')
       ORDER BY 1 DESC;
    CURSOR next_month_first_day(v_date DATE) IS
      SELECT dat_prazdn FROM QWERTY.SP_ZAR_PRAZDN WHERE dat_prazdn = v_date;
  
    dCUR_DATE   DATE;
    i           NUMBER(2);
    nMONTH_DAYS NUMBER(2);
    j           NUMBER(2);
    nWEEKDAY    NUMBER(1);
    dcSCHEDULE  DAY_COLUMNS;
    biINDEX     BINARY_INTEGER := 0;
    dHOLIDAY    DATE;
    dNEXT_MONTH DATE;
  BEGIN
    --������� ���� �� ������ ����
    dCUR_DATE := TRUNC(to_date(v_schedule_date
                              ,'dd.mm.yyyy')
                      ,'YEAR');
  
    <<month_cycle>>
    FOR i IN 1 .. 12
    LOOP
      nMONTH_DAYS := MONTH_DAYS(dCUR_DATE);
    
      <<days_cycle>>
      FOR j IN 0 .. nMONTH_DAYS
      LOOP
        biINDEX := j + 1;
        --�������� ����� ��� ������
        SELECT to_number(to_char(dCUR_DATE + j
                                ,'d'))
          INTO nWEEKDAY
          FROM DUAL;
        --��������� �������� ��� �����
        IF (nWEEKDAY = 6) OR
           (nWEEKDAY = 7) THEN
          dcSCHEDULE(biINDEX) := ' �';
        ELSE
          dcSCHEDULE(biINDEX) := '��';
        END IF;
      END LOOP days_cycle;
    
      --����������� ���������
      --�������� ������ ���������� ��� �������� ������
      OPEN holiday_cursor(dCUR_DATE);
      <<cursor_cycle>>
      LOOP
        FETCH holiday_cursor
          INTO dHOLIDAY;
        EXIT WHEN holiday_cursor%NOTFOUND;
        --�������� ���������� ����� ��� ������ ��� ���������
        nWEEKDAY := to_number(to_char(dHOLIDAY
                                     ,'d'));
        j        := to_number(to_char(dHOLIDAY
                                     ,'dd'));
        biINDEX  := j;
        --���� �������� ���� �����������
        IF (v_hol) THEN
          IF (nWEEKDAY = 7) THEN
            IF NOT (dcSCHEDULE(biINDEX + 1) = ' �') THEN
              dcSCHEDULE(biINDEX + 1) := ' �';
            ELSE
              dcSCHEDULE(biINDEX + 2) := ' �';
            END IF;
          ELSIF (nWEEKDAY = 6) THEN
            IF NOT (dcSCHEDULE(biINDEX + 2) = ' �') THEN
              dcSCHEDULE(biINDEX + 2) := ' �';
            ELSE
              dcSCHEDULE(biINDEX + 3) := ' �';
            END IF;
          END IF;
        END IF;
        --��������� ��������� 1�� ����� ���������� ������
        OPEN next_month_first_day(ADD_MONTHS(dCUR_DATE
                                            ,1));
        <<next_month>>
        LOOP
          FETCH next_month_first_day
            INTO dNEXT_MONTH;
          EXIT WHEN next_month_first_day%NOTFOUND;
          IF dcSCHEDULE(nMONTH_DAYS) = '��' THEN
            dcSCHEDULE(nMONTH_DAYS) := '��';
          END IF;
        END LOOP next_month;
        CLOSE next_month_first_day;
      
        --����������� ������� ���������
        dcSCHEDULE(biINDEX) := ' �';
        --���������� ���� ������ �������� ����
        IF (nWEEKDAY <> 7) AND
           (nWEEKDAY <> 1) THEN
          dcSCHEDULE(biINDEX - 1) := '��';
        END IF;
      END LOOP cursor_cycle;
      CLOSE holiday_cursor;
    
      --31 ������� - �������� ����, ������ ���� ���� ���� ������� ��� �������
      IF i = 12 THEN
        IF dcSCHEDULE(31) = '��' THEN
          dcSCHEDULE(31) := '��';
        END IF;
      END IF;
    
      --���������� ������ �������� � ����� ��� ������� � ������� � 30-� �����
      FOR j IN nMONTH_DAYS + 1 .. 31
      LOOP
        biINDEX := j;
        dcSCHEDULE(biINDEX) := '  ';
      END LOOP;
    
      DELETE FROM QWERTY.SP_ZAR_GRAFIK
       WHERE data_graf = dCUR_DATE
         AND id_smen = ' �';
      INSERT INTO QWERTY.SP_ZAR_GRAFIK
      VALUES
        (dCUR_DATE,
         0,
         ' �',
         0,
         0,
         0,
         0,
         0,
         0,
         dcSCHEDULE(1),
         dcSCHEDULE(2),
         dcSCHEDULE(3),
         dcSCHEDULE(4),
         dcSCHEDULE(5),
         dcSCHEDULE(6),
         dcSCHEDULE(7),
         dcSCHEDULE(8),
         dcSCHEDULE(9),
         dcSCHEDULE(10),
         dcSCHEDULE(11),
         dcSCHEDULE(12),
         dcSCHEDULE(13),
         dcSCHEDULE(14),
         dcSCHEDULE(15),
         dcSCHEDULE(16),
         dcSCHEDULE(17),
         dcSCHEDULE(18),
         dcSCHEDULE(19),
         dcSCHEDULE(20),
         dcSCHEDULE(21),
         dcSCHEDULE(22),
         dcSCHEDULE(23),
         dcSCHEDULE(24),
         dcSCHEDULE(25),
         dcSCHEDULE(26),
         dcSCHEDULE(27),
         dcSCHEDULE(28),
         dcSCHEDULE(29),
         dcSCHEDULE(30),
         dcSCHEDULE(31));
    
      dCUR_DATE := ADD_MONTHS(dCUR_DATE
                             ,1);
    END LOOP month_cycle;
    NULL;
  END CALENDAR_NEW;

  --***************************************************************************************
  --***************************************************************************************
  PROCEDURE SCHEDULE_CALCULATE_WORKTIME(v_schedule_date VARCHAR2
                                       ,v_shift_id      VARCHAR2
                                       ,v_whole_year    BOOLEAN
                                       ,v_holiday_time  BOOLEAN) IS
    /*
    ������� ������� ������ �����
      v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
      v_shift_id      - ID �����
      v_whole_year    - ����: ��������� ������ �� ���� ��� (TRUE)
                              ��� ������ ��������� ����� (FALSE)
      v_holiday_time  - ����: ������� ����������� (TRUE)
                              ��� ��� (FALSE)
    */
    CURSOR mark_array(vi_schedule_date DATE
                     ,vi_shift_id      VARCHAR2) IS
      SELECT d1
            ,COUNT(*)
        FROM (SELECT d1
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d2
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d3
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d4
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d5
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d6
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d7
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d8
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d9
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d10
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d11
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d12
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d13
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d14
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d15
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d16
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d17
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d18
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d19
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d20
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d21
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d22
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d23
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d24
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d25
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d26
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d27
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d28
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d29
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d30
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT d31
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date)
       GROUP BY d1;
  
    CURSOR shift_marks_cursor(vi_shift_id VARCHAR2) IS
      SELECT id_otmetka
            ,time_work
            ,day_work
            ,time_n
            ,time_v
        FROM QWERTY.SP_ZAR_OT_PROP
       WHERE id_otmetka IN (SELECT id_otmetka FROM QWERTY.SP_ZAR_TABL_SMEN WHERE id_smen = vi_shift_id);
    TYPE SHIFT_MARKS IS TABLE OF shift_marks_cursor%ROWTYPE;
  
    CURSOR holiday_marks(vi_schedule_date DATE
                        ,vi_shift_id      VARCHAR2) IS
      SELECT mark
            ,COUNT(*)
        FROM (SELECT 1  MONTH_DAY
                    ,d1 MARK
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 2
                    ,d2
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 3
                    ,d3
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 4
                    ,d4
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 5
                    ,d5
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 6
                    ,d6
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 7
                    ,d7
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 8
                    ,d8
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 9
                    ,d9
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 10
                    ,d10
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 11
                    ,d11
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 12
                    ,d12
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 13
                    ,d13
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 14
                    ,d14
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 15
                    ,d15
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 16
                    ,d16
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 17
                    ,d17
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 18
                    ,d18
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 19
                    ,d19
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 20
                    ,d20
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 21
                    ,d21
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 22
                    ,d22
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 23
                    ,d23
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 24
                    ,d24
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 25
                    ,d25
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 26
                    ,d26
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 27
                    ,d27
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 28
                    ,d28
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 29
                    ,d29
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 30
                    ,d30
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date
              UNION ALL
              SELECT 31
                    ,d31
                FROM QWERTY.SP_ZAR_GRAFIK
               WHERE id_smen = vi_shift_id
                 AND data_graf = vi_schedule_date)
       WHERE month_day IN (SELECT to_number(to_char(dat_prazdn
                                                   ,'dd'))
                             FROM QWERTY.SP_ZAR_PRAZDN
                            WHERE to_char(dat_prazdn
                                         ,'mm.yyyy') = to_char(vi_schedule_date
                                                              ,'mm.yyyy'))
       GROUP BY mark;
  
    shmMARKS SHIFT_MARKS := SHIFT_MARKS();
  
    chMARK    CHAR(2);
    nAMOUNT   NUMBER(2);
    vCUR_DATE DATE;
  
    i           NUMBER(2);
    j           NUMBER(2);
    nSTART_MON  NUMBER(2); --����� ������ �����
    nFINISH_MON NUMBER(2); --����� ��������� �����
    biINDEX     BINARY_INTEGER := 0;
  
    nWORKTIME NUMBER(5
                    ,2);
    nWORKDAYS NUMBER(2);
    nTIME_N   NUMBER(5
                    ,2);
    nTIME_V   NUMBER(5
                    ,2);
    nHOLIDAY  NUMBER(5
                    ,2);
    nOVERTIME NUMBER(5
                    ,2);
    n023      NUMBER(5
                    ,2);
    n033      NUMBER(5
                    ,2);
  BEGIN
    --���� ��������� ���� ���, �� ������� ���� �� ������ ����
    --� ������ ���� � 1�� �� 12�� ������
    --����� - ������� ���� �� ������ ������ � ������ ���� �-�� ���� �����
    IF v_whole_year THEN
      vCUR_DATE   := TRUNC(TO_DATE(v_schedule_date
                                  ,'dd.mm.yyyy')
                          ,'YEAR');
      nSTART_MON  := 1;
      nFINISH_MON := 12;
    ELSE
      vCUR_DATE   := TRUNC(TO_DATE(v_schedule_date
                                  ,'dd.mm.yyyy')
                          ,'MONTH');
      nSTART_MON  := TO_NUMBER(TO_CHAR(TO_DATE(v_schedule_date
                                              ,'dd.mm.yyyy')
                                      ,'mm'));
      nFINISH_MON := nSTART_MON;
    END IF;
  
    j := 1;
    --�������� ������ �� �������� �����: �������, ������� ����, ���
    OPEN shift_marks_cursor(v_shift_id);
    <<cursor_cycle>>
    LOOP
      biINDEX := j;
      shmMARKS.extend(1);
      FETCH shift_marks_cursor
        INTO shmMARKS(biINDEX);
      EXIT WHEN shift_marks_cursor%NOTFOUND;
      j := j + 1;
    END LOOP cursor_cycle;
    CLOSE shift_marks_cursor;
  
    <<month_cycle>>
    FOR i IN nSTART_MON .. nFINISH_MON
    LOOP
      --�������� ��������
      nWORKTIME := 0;
      nWORKDAYS := 0;
      nTIME_N   := 0;
      nTIME_V   := 0;
      nOVERTIME := 0;
      nHOLIDAY  := 0;
      n023      := 0;
      n033      := 0;
    
      --�������� ������� � �� ���������� � ��������� ������
      OPEN mark_array(vCUR_DATE
                     ,v_shift_id);
      <<cursor_cycle>>
      LOOP
        FETCH mark_array
          INTO chMARK
              ,nAMOUNT;
        EXIT WHEN mark_array%NOTFOUND;
      
        --������� ����� ������
        j := 1;
        <<marks_cycle>>
        LOOP
          EXIT WHEN j = shmMARKS.count;
          IF shmMARKS(j).id_otmetka = chMARK THEN
            nWORKTIME := nWORKTIME + shmMARKS(j).time_work * nAMOUNT;
            nWORKDAYS := nWORKDAYS + shmMARKS(j).day_work * nAMOUNT;
            nTIME_N   := nTIME_N + shmMARKS(j).time_n * nAMOUNT;
            nTIME_V   := nTIME_V + shmMARKS(j).time_v * nAMOUNT;
            EXIT;
          END IF;
          j := j + 1;
        END LOOP marks_cycle;
      END LOOP cursor_cycle;
      CLOSE mark_array;
    
      SELECT nWORKTIME - time_graf
        INTO nOVERTIME
        FROM QWERTY.SP_ZAR_GRAFIK
       WHERE data_graf = vCUR_DATE
         AND ID_SMEN = ' �';
    
      IF v_holiday_time THEN
        --������� ����������� �����
        OPEN holiday_marks(vCUR_DATE
                          ,v_shift_id);
        <<holiday_cursor_cycle>>
        LOOP
          FETCH holiday_marks
            INTO chMARK
                ,nAMOUNT;
          EXIT WHEN holiday_marks%NOTFOUND;
        
          --������� ���������� ����������� �����
          j := 1;
          <<marks_cycle>>
          LOOP
            EXIT WHEN j = shmMARKS.count;
            IF shmMARKS(j).id_otmetka = chMARK THEN
              nHOLIDAY := nHOLIDAY + shmMARKS(j).time_work * nAMOUNT;
              EXIT;
            END IF;
            j := j + 1;
          END LOOP marks_cycle;
        END LOOP holiday_cursor_cycle;
        CLOSE holiday_marks;
      
        --��������� ���������� ����� ��� 023 � 033 ����� �����������
        IF nHOLIDAY <> 0 THEN
          --����������� ����
          CASE SIGN(nHOLIDAY - nOVERTIME)
            WHEN -1 THEN
              --����������� ������ �����������
              n023      := 0;
              n033      := nHOLIDAY;
              nOVERTIME := nOVERTIME - nHOLIDAY;
            WHEN 0 THEN
              --����������� � ����������� ���������
              n023      := 0;
              n033      := nHOLIDAY;
              nOVERTIME := 0;
            WHEN 1 THEN
              --����������� ������ �����������
              IF nOVERTIME > 0 THEN
                --����������� �������������
                n023      := nHOLIDAY - nOVERTIME;
                n033      := nOVERTIME;
                nOVERTIME := 0;
              ELSE
                --����������� �������������
                n023 := nHOLIDAY;
                n033 := 0;
                --nOVERTIME := nOVERTIME;
              END IF;
          END CASE;
        END IF;
      END IF;
    
      --���������� ���������� �������� � �������
      UPDATE QWERTY.SP_ZAR_GRAFIK
         SET DAY_GRAF  = nWORKDAYS
            ,TIME_GRAF = nWORKTIME
            ,TIME_PER  = nOVERTIME
            ,TIME_PRA  = nHOLIDAY
            ,TIME_PRA1 = n023
            ,TIME_PRA2 = n033
       WHERE DATA_GRAF = vCUR_DATE
         AND ID_SMEN = v_shift_id;
      DELETE FROM QWERTY.SP_ZAR_GRAFIK_NV
       WHERE data_graf = vCUR_DATE
         AND id_smen = v_shift_id;
      INSERT INTO QWERTY.SP_ZAR_GRAFIK_NV (DATA_GRAF, ID_SMEN, TIME_V, TIME_N) VALUES (vCUR_DATE, v_shift_id, nTIME_V, nTIME_N);
    
      --��������� � ���������� ������
      vCUR_DATE := ADD_MONTHS(vCUR_DATE
                             ,1);
    END LOOP month_cycle;
  END SCHEDULE_CALCULATE_WORKTIME;

  --***************************************************************************************
  --***************************************************************************************
  PROCEDURE COPY_DAYS_TIME_FROM_DAYSTAFF(v_schedule_date VARCHAR2
                                        ,v_whole_year    BOOLEAN) IS
    /*
    ������� ������� ������ �����
      v_schedule_date - ���� � ���� ������ � ������� dd.mm.yyyy
      v_whole_year    - ����: ���������� ������ �� ���� ��� (TRUE)
                              ��� ������ �� ��������� ����� (FALSE)
    */
    nTIME     NUMBER(5
                    ,2);
    nDAYS     NUMBER(2);
    dCUR_DATE DATE;
    i         NUMBER(2);
  BEGIN
    dCUR_DATE := TRUNC(TO_DATE(v_schedule_date
                              ,'dd.mm.yyyy')
                      ,'MONTH');
    IF v_whole_year THEN
      dCUR_DATE := TRUNC(dCUR_DATE
                        ,'YEAR');
      FOR i IN 1 .. 12
      LOOP
        SELECT DAY_GRAF
              ,TIME_GRAF
          INTO nDAYS
              ,nTIME
          FROM QWERTY.SP_ZAR_GRAFIK
         WHERE DATA_GRAF = dCUR_DATE
           AND TIP_SMEN = 1;
        UPDATE QWERTY.SP_ZAR_GRAFIK
           SET DAY_GRAF  = nDAYS
              ,TIME_GRAF = nTIME
              ,TIME_PER  = 0
              ,TIME_PRA  = 0
              ,TIME_PRA1 = 0
              ,TIME_PRA2 = 0
         WHERE DATA_GRAF = dCUR_DATE
           AND TIP_SMEN = 2;
        dCUR_DATE := ADD_MONTHS(dCUR_DATE
                               ,1);
      END LOOP;
    ELSE
      SELECT DAY_GRAF
            ,TIME_GRAF
        INTO nDAYS
            ,nTIME
        FROM QWERTY.SP_ZAR_GRAFIK
       WHERE DATA_GRAF = dCUR_DATE
         AND TIP_SMEN = 1;
      UPDATE QWERTY.SP_ZAR_GRAFIK
         SET DAY_GRAF  = nDAYS
            ,TIME_GRAF = nTIME
            ,TIME_PER  = 0
            ,TIME_PRA  = 0
            ,TIME_PRA1 = 0
            ,TIME_PRA2 = 0
       WHERE DATA_GRAF = dCUR_DATE
         AND TIP_SMEN = 2;
    END IF;
  END;

--begin
-- Initialization
--  <Statement>;
END SHIFT4;
/
