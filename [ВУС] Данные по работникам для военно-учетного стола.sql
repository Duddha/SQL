-- TAB = ������� ��� ������� (�������� ������ ������-�������� �����, ������� ���� � ���������� ����)
select vuch.id_tab    "���. �",
       vuch.id_grvuc  "������ �����",
       grvuc.name_u   "�������� ������ �����",
       vuch.kauc      "��������� �����",
       vuch.id_sostav "��� �������",
       sostav.name_u  "������",
       vuch.id_zvan   "��� ��������� ������",
       zvan.name_u    "�������� ������",
       vuch.vus       "���",
       vuch.id_godn   "��� �������� � ������",
       godn.name_u    "�������� � ������",
       vuch.id_voenk "��� ����������",
       voenk.name_u  "���������",
              
       vuch.nouc     "����� ���������",
       vuch.id_ware  "��� ������� � ������",
       ware.name_u   "������� � ������"
  from qwerty.sp_ka_vuch vuch,
       qwerty.sp_grvuc   grvuc,
       qwerty.sp_sostav  sostav,
       qwerty.sp_zvan    zvan,
       qwerty.sp_godn    godn,
       qwerty.sp_voenk   voenk,
       qwerty.sp_ware    ware
 where vuch.id_tab in (select id_tab from qwerty.sp_ka_work)
   and vuch.id_grvuc = grvuc.id(+)
   and vuch.id_sostav = sostav.id(+)
   and vuch.id_zvan = zvan.id(+)
   and vuch.id_godn = godn.id(+)
   and vuch.id_voenk = voenk.id(+)
   and vuch.id_ware = ware.id(+)
 order by 1
