--TAB = �������� �� 35 ��� � ������ ������������
select distinct * from (
select p.name_u "���", rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       m.full_name_u "���������",
       osn.data_r "���� ��������",
       trunc(months_between(sysdate, osn.data_r) / 12) "�������, ���",
       qwerty.hr.GET_STAG_CHAR(rbf.id_tab) "����", s.id_cex
       -- ��� ����� �.�. ������ ���� �� � �������� ������ �����������
       , decode(nvl(obr.id_obr, -1), -1, '', '+') "������ �����������"
  from qwerty.sp_rb_fio rbf,
       --qwerty.sp_ka_obr obr,
       (select id_tab, id_obr from qwerty.sp_ka_obr where id_obr in (6, 14, 15, 16, 17, 18, 21)) obr,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat   s,
       qwerty.sp_podr   p,
       qwerty.sp_mest   m,
       qwerty.sp_ka_osn osn
 where obr.id_tab(+) = rbf.id_tab
   -- ��� ����� �.�. ������� ����������� �� ����������� (��� ��������� �������)
   --and obr.id_obr = 6 /*������ ������ �����������*/
   and obr.id_obr in (6, 14, 15, 16, 17, 18, 21) /*������ �����������, �����������, ������� ����������� ����, ��������� ��, �� � ��, � ����� ������ ������������*/

   and months_between(sysdate, osn.data_r) <= 35 * 12-- and trunc(osn.data_r, 'YEAR') = to_date('01.01.1977')
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and p.id_cex = s.id_cex
   and m.id_mest = s.id_mest
   and osn.id_tab = rbf.id_tab
)   
 order by id_cex, "�.�.�."
