-- Excel = ��������� �� �������� ����������� �� �� (���� ������� - %date%).xls
-- TAB = �������� ����������, ����������� � ������� ����
select p.name_u "���",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       lt.id_tab "���. �",
       to_char(start_date, 'yyyy')||'_'||la.id_cex||'_'||la_number "�",
       la.name "��������",
       la.start_date "���� ������",
       la.finish_date "���� ���������"
  from qwerty.sp_zar_labor_agreement la,
       qwerty.sp_zar_la_tab          lt,
       qwerty.sp_podr                p,
       qwerty.sp_rb_fio              rbf
 where sysdate between start_date and finish_date
   and la.id = lt.id_la
   and la.id_cex = p.id_cex
   and lt.id_tab = rbf.id_tab
   and la.id_cex = 1000
order by 1, 2
