-- ���������� ROWNUM ������� � �����������

-- Source = http://oraclemaniacs.blogspot.com/2011/04/rownum.html
-- TAB = ���������� ���������� �����
SELECT rownum
      ,p.*
  FROM qwerty.sp_podr p
CONNECT BY 1 = 2 -- �������� ������������� �������, ����� �� ������������ ������
 ORDER SIBLINGS BY name_u;

-- TAB = � ������� �� �����
SELECT rownum
      ,p.*
  FROM qwerty.sp_podr p
 ORDER BY name_u
