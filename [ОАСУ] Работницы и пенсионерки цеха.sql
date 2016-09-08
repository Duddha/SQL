-- TAB = Работницы отдела
-- Код цеха = 5500, пол - женский
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  from qwerty.sp_stat   s,
       qwerty.sp_rb_key rbk,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_ka_osn osn
 where s.id_cex = 5500
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and rbk.id_tab = osn.id_tab
   and osn.id_pol = 2
 order by 1;
-- TAB = Пенсионерки отдела 
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
       u.data_uvol
  from qwerty.sp_ka_pens_all pall,
       qwerty.sp_rb_fio      rbf,
       qwerty.sp_ka_uvol     u,
       qwerty.sp_ka_perem    p,
       qwerty.sp_ka_osn      osn
 where pall.id_tab = rbf.id_tab
   and pall.id_tab = u.id_tab
   and u.id_uvol in (30, 36, 69, 70, 71, 79)
   and pall.id_tab = p.id_tab
   and u.data_uvol = p.data_kon
   and p.id_a_cex = 5500
   and pall.id_tab = osn.id_tab
   and osn.id_pol = 2
 order by 1
