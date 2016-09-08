-- RECORDS = ALL

-- TAB = ���������� ������� �������� �����
SELECT p.*
      ,ROWID
  FROM qwerty.sp_prop_st_zar p
 ORDER BY p.id;

-- TAB = ���������� ����������� ������������ ������� �������� �����
SELECT pe.*
      ,ROWID
  FROM qwerty.sp_prop_st_zar_ext pe
 ORDER BY pe.id_prop;

-- TAB = ������ ������� �������� �����
SELECT id
      ,lpad(' '
           ,(LEVEL - 1) * 10
           ,' ') || nvl(full_name_u
                       ,p.name) property_name
      ,pro
      ,VALUE
  FROM qwerty.sp_prop_st_zar     p
      ,qwerty.sp_prop_st_zar_ext pe
 WHERE p.id = pe.id_prop(+)
CONNECT BY PRIOR id = parent_id
 START WITH parent_id = 0
 ORDER SIBLINGS BY NAME
