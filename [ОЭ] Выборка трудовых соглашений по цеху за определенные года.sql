select la.name "��������",
       la.start_date "���� ������",
       la.finish_date "���� ���������",
       to_char(la.start_date, 'yyyy')||'_'||la.id_cex||'_'||la.la_number "�����",
       lt.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
  from qwerty.sp_zar_labor_agreement la,
       qwerty.sp_zar_la_tab          lt,
       qwerty.sp_rb_fio              rbf
 where id_cex = 1000
   and to_char(start_date, 'yyyy') in ('2011', '2012')
   and la.id = lt.id_la
   and lt.id_tab = rbf.id_tab
order by trunc(la.start_date, 'YEAR'), la.la_number   
