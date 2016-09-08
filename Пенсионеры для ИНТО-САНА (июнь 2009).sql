--Пенсионеры завода, вышедшие на пенсию до 7 июня 2007
select p.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
       decode(nvl(osnn.id_nalog, ''),
              '',
              to_char(osn.id_nalog),
              osnn.id_nalog) id_nalog,
       1 kto
  from qwerty.sp_ka_pens_all  p,
       qwerty.sp_rb_fio       rbf,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_osn_nalog osnn
 where p.id_tab not in
       (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and nvl(p.dat_uvol, to_date('06.06.2007', 'dd.mm.yyyy')) < to_date('07.06.2007', 'dd.mm.yyyy')       
   and nvl(p.stag, 0)+nvl(p.stag_d, 0) >= 72
   and p.id_tab = rbf.id_tab
   and p.id_tab = osn.id_tab(+)
   and p.id_tab = osnn.id_tab(+)
union all   
--Пенсионеры завода, вышедшие на пенсию после 7 июня 2007
select p.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
       decode(nvl(osnn.id_nalog, ''),
              '',
              to_char(osn.id_nalog),
              osnn.id_nalog) id_nalog,
       2 kto
  from qwerty.sp_ka_pens_all  p,
       qwerty.sp_rb_fio       rbf,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_osn_nalog osnn
 where p.id_tab not in
       (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and nvl(p.dat_uvol, to_date('06.06.2007', 'dd.mm.yyyy')) >= to_date('07.06.2007', 'dd.mm.yyyy')       
   and nvl(p.stag, 0)+nvl(p.stag_d, 0) >= 180
   and p.id_tab = rbf.id_tab
   and p.id_tab = osn.id_tab(+)
   and p.id_tab = osnn.id_tab(+)

--Пенсионеры, которых добавили в список персонально   
-- по состоянию на 10.06.2009:
--    2447 (Смирнов Всеволод Борисович)
--    4399 (Жарская Алевтина Михайловна*/)
&<name="Персонально" hint="табельные номера через ','" 
prefix="
union all   
select rbf.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
       decode(nvl(osnn.id_nalog, ''),
              '',
              to_char(osn.id_nalog),
              osnn.id_nalog) id_nalog,
       3 kto
  from qwerty.sp_rb_fio       rbf,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_osn_nalog osnn
 where rbf.id_tab in (" 
                     suffix=")
   and rbf.id_tab = osn.id_tab(+)
   and rbf.id_tab = osnn.id_tab(+)">
