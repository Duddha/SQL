select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       u.id_tab "���. �",
       ac.name_u "���",
       am.full_name "���������",
       u.data_uvol "���� ����������",
       vw.name_u "�������� ������"
  from qwerty.sp_ka_uvol  u,
       qwerty.sp_ka_perem p,
       qwerty.sp_rb_fio   rbf,
       qwerty.sp_arx_cex  ac,
       qwerty.sp_arx_mest am,
       qwerty.sp_vid_work vw
 where u.data_uvol >= to_date('01.10.2006', 'dd.mm.yyyy')
   and p.id_tab = u.id_tab
   and p.data_kon = u.data_uvol
   and p.id_n_mest <> 1232
      --and p.id_work<>61
   and rbf.id_tab = u.id_tab
   and ac.id = p.id_n_cex
   and am.id = p.id_n_mest
   and vw.id = p.id_work
 order by 1
--group by id_tab
