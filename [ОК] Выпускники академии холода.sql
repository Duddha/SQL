--TAB=���������� �������� ������
select distinct rbf.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       f2.data_work "���� ������ �� ���",
       to_number(to_char(f2.data_work, 'yyyy')) "��� ������ �� ���",
       p.name_u "���",
       m.full_name_u "���������",
       obr.data_ok "���� ���������",
       spobr.name_u "�������������",
       kvobr.name_u "������������",
       uz.name_u "���"
  from qwerty.sp_rb_fio rbf,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat   s,
       qwerty.sp_podr   p,
       qwerty.sp_mest   m,
       qwerty.sp_ka_obr obr,
       qwerty.sp_uchzav uz,
       qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_kvobr kvobr,
       qwerty.sp_spobr spobr
 where rbf.id_tab in (select distinct f2.id_tab
                        from qwerty.sp_kav_perem_f2 f2, qwerty.sp_ka_obr obr
                       where id_zap = 1
                         and trunc(data_work, 'YEAR') >=
                             to_date('01.01.2006', 'dd.mm.yyyy')
                         and f2.id_tab = obr.id_tab
                         and obr.id_uchzav = 12)
and rbf.id_tab = rbk.id_tab
and rbk.id_stat = s.id_stat
and s.id_cex = p.id_cex
and s.id_mest = m.id_mest
and rbf.id_tab = obr.id_tab
and obr.id_uchzav = uz.id
and obr.id_uchzav = 12
and rbf.id_tab = f2.id_tab
and f2.id_zap = 1
and obr.id_kvobr = kvobr.id
and obr.id_spobr = spobr.id
order by "�.�.�.", "���� ���������"
