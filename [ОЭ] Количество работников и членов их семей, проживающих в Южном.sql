--Сколько работников и членов их семей проживают в Южном (фактически или по паспорту)
-- ЗАПРОС очень сильно НЕ ОПТИМИЗИРОВАН!!!
select distinct fio, data_r from (
select distinct a.id_tab, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u fio, osn.data_r
  from qwerty.sp_ka_adres a, qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn
 where a.id_tab in (select id_tab from qwerty.sp_ka_work)
   and a.id_sity = 176
   and fl = 2
   and a.id_tab = rbf.id_tab
   and a.id_tab = osn.id_tab
union all
select distinct a.id_tab, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u fio, osn.data_r
  from qwerty.sp_ka_adres a, qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn
 where a.id_tab in (select id_tab from qwerty.sp_ka_work)
   and a.id_sity = 176
   and a.id_tab not in
       (select distinct id_tab
          from qwerty.sp_ka_adres a
         where id_tab in (select id_tab from qwerty.sp_ka_work)
           and a.id_sity = 176
           and fl = 2)
   
   and a.id_tab = rbf.id_tab
   and a.id_tab = osn.id_tab
union all   
--Добавляем членов семей
select -1 d, fam_u||' '||f_name_u||' '||s_name_u, data_r from qwerty.sp_ka_famil
where id_tab in (select distinct a.id_tab
  from qwerty.sp_ka_adres a, qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn
 where a.id_tab in (select id_tab from qwerty.sp_ka_work)
   and a.id_sity = 176
   and fl = 2
   and a.id_tab = rbf.id_tab
   and a.id_tab = osn.id_tab
union all
select distinct a.id_tab
  from qwerty.sp_ka_adres a, qwerty.sp_rb_fio rbf, qwerty.sp_ka_osn osn
 where a.id_tab in (select id_tab from qwerty.sp_ka_work)
   and a.id_sity = 176
   and a.id_tab not in
       (select distinct id_tab
          from qwerty.sp_ka_adres a
         where id_tab in (select id_tab from qwerty.sp_ka_work)
           and a.id_sity = 176
           and fl = 2)
   
   and a.id_tab = rbf.id_tab
   and a.id_tab = osn.id_tab))
