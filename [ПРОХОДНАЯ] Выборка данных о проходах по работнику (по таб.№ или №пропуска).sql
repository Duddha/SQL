-- ������� �� ��������� �� ���������� ������ ��� ������ ��������

SELECT *
  FROM zakaz.sp_zk_ev_day  ed
      ,zakaz.sp_zk_sppoint p
 WHERE id_tab = (SELECT id_tab
                   FROM qwerty.sp_ka_osn
                  -- NoFormat Start
                  WHERE &< NAME = "�� ���������� ������ ��� �� � ��������" 
                           HINT = "������� - ��������� �����, ����� - ����� ��������" 
                           CHECKBOX = "id_tab,id_prop" 
                           DEFAULT = "id_tab" > = &< NAME = "��������" HINT = "��������� ����� ��� ����� ��������" >)
                  -- NoFormat End
   AND ed.id_point = p.id
 ORDER BY dat_ev DESC
