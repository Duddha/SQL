CREATE OR REPLACE PACKAGE QWERTY.HR_FIX IS

  -- Author  : BISHOP
  -- Created : 09.09.2014 8:13:16
  -- Purpose : Пакет с набором процедур и функций для исправления ошибок в HR

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  TYPE recPRED_WORK IS RECORD(
    ID_TAB    NUMBER(7),
    PRED_WORK QWERTY.SP_KA_OSN.PRED_WORK%TYPE);

  FUNCTION FIX_KAOSN_PRED_WORK_MULTILINE(pTAB_ID NUMBER DEFAULT -1) RETURN NUMBER;
  
  FUNCTION TEST(pTAB_ID NUMBER DEFAULT -1) RETURN DATE;

END HR_FIX;
/
CREATE OR REPLACE PACKAGE BODY QWERTY.HR_FIX IS
  -- Пакет с набором функций для исправления ошибок в HR

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

  FUNCTION FIX_KAOSN_PRED_WORK_MULTILINE(pTAB_ID NUMBER DEFAULT -1) RETURN NUMBER IS
    vCURSOR     SYS_REFCURSOR;
    vROW        recPRED_WORK;
    vQUERY_TEXT VARCHAR2(1000);
    i           NUMBER;
  BEGIN
    IF (pTAB_ID = -1) OR (pTAB_ID is null) THEN
      vQUERY_TEXT := 'select ID_TAB, PRED_WORK from qwerty.sp_ka_osn where owa_pattern.amatch(pred_work, 0, ''\n'', ''i'') <> 0';
    ELSE
      vQUERY_TEXT := 'select ID_TAB, PRED_WORK from qwerty.sp_ka_osn where ID_TAB = ' || pTAB_ID;
    END IF;
  
    OPEN vCURSOR FOR vQUERY_TEXT;

    i := vCURSOR%ROWCOUNT; -- Количество выбранных записей

    IF vCURSOR%ISOPEN THEN
      LOOP
        FETCH vCURSOR
          INTO vROW;
        EXIT WHEN vCURSOR%NOTFOUND;
      
        OWA_PATTERN.change(vROW.PRED_WORK,
                           '\n',               -- перевод строки
                           ' ',                -- заменяем пробелом
                           'g');               -- все вхождения
        --DBMS_OUTPUT.put_line(vROW.ID_TAB || ': [' || TRIM(vROW.PRED_WORK) || ']');
        UPDATE qwerty.sp_ka_osn SET PRED_WORK = TRIM(vROW.PRED_WORK) WHERE ID_TAB = vROW.ID_TAB;
      END LOOP;
    END IF;
  
    COMMIT;
  
    RETURN i; -- Возвращаем количество обработанных записей
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1; -- Ошибка!
  END FIX_KAOSN_PRED_WORK_MULTILINE;
  
  FUNCTION TEST(pTAB_ID NUMBER DEFAULT -1) RETURN DATE IS
    
  BEGIN
    RETURN sysdate;
  END;

BEGIN
  -- Initialization
  --<Statement>;
  NULL;
END HR_FIX;
/
