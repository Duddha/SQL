-- �������� ����������� ���������� ����� �� DUAL

-- ����������:
--  1. � ������ ������� SQL Plus ���������� ��������� ������ ������������ WITH. � ����� ������� ����� ������������� ���
--  2. ��� ������� ������� ����� ������� ���������� �����, e.g. 10 000 000, ����� �������� ������ ����������� ������ � PGA (Programm Global Area)
--     ��� �������� ����� ������ ��� ������ JOIN (��. ������� 2.1)

-- TAB = ������� 1
WITH get_rows1 AS
 (SELECT rownum row_number
    FROM dual
  CONNECT BY 1 = 1
         AND rownum <= &< NAME = "���������� ����� ��� �������" HINT = "������� ����� �����, ������� �� ������ ��������" TYPE = "integer"
   DEFAULT = "100" >)
SELECT row_number "� �/�" FROM get_rows1;

-- TAB = ������� 2
WITH get_rows2 AS
 (SELECT LEVEL row_number FROM dual CONNECT BY LEVEL <= &< NAME = "���������� ����� ��� �������" >)
SELECT row_number "� �/�" FROM get_rows2;

-- TAB = ������� 2.1 (10 ���. �����)
WITH get_rows3 AS
 (SELECT LEVEL row_number FROM dual CONNECT BY LEVEL <= 10000),
get_rows4 AS
 (SELECT LEVEL row_number FROM dual CONNECT BY LEVEL <= 1000)

SELECT rownum "� �/�"
  FROM (SELECT * FROM get_rows3)
      ,(SELECT * FROM get_rows4);

-- TAB = ������� 3
SELECT rownum "� �/�"
  FROM (SELECT NULL
          FROM dual
        CONNECT BY 1 = 1
               AND PRIOR dbms_random.value IS NOT NULL)
 WHERE rownum <= &< NAME = "���������� ����� ��� �������" >;

-- TAB = ������� 4
-- ���� ������� �� ����� �������, ���� ������ �� ����������� Explain Plan
SELECT column_value "� �/�"
  FROM TABLE(CAST(MULTISET (SELECT LEVEL FROM dual CONNECT BY LEVEL <= &< NAME = "���������� ����� ��� �������" >) AS sys.odcinumberlist));
