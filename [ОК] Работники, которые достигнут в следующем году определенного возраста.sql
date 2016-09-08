-- Excel = Предполагаемые пенсионеры будущего года.xls
-- ver: 1 (16.10.2013)
-- TAB = Мужчины, 60 лет
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "Мужчины, 1 группа, год рождения:" 
                              type = "string" 
                              hint = "год рождения: в формате ГГГГ" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 60 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 1
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = Мужчины, 55 лет
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "Мужчины, 2 группа, год рождения:" 
                              type = "string" 
                              hint = "год рождения: в формате ГГГГ" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 55 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 1
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = Мужчины, 50 лет
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "Мужчины, 3 группа, год рождения:" 
                              type = "string" 
                              hint = "год рождения: в формате ГГГГ" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 50 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 1
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = Женщины, 55 лет
-- 21.11.2014 - Бабкина сказала, что эта категория женщин уже не нужна
-- Но попросила добавить рожденных в период с 01.04.1958 по 30.09.1958
/*
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "Женщины, 1 группа, год рождения:" 
                              type = "string" 
                              hint = "год рождения: в формате ГГГГ" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 55 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
*/
select 'Данная категория больше не используется! (c 21.11.2014)' title from dual;
-- TAB = Женщины, 01.04-30.09.1958
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and osn.data_r between to_date(&< name = "Женщины за период, начало периода:" 
                                     type = "string" 
                                     hint = "год рождения: в формате ГГГГ" 
                                     default = "select '01.04.1958' from dual" >, 'dd.mm.yyyy') 
                      and to_date(&< name = "Женщины за период, конец периода:" 
                                     type = "string" 
                                     hint = "год рождения: в формате ГГГГ" 
                                     default = "select '30.09.1958' from dual" >, 'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = Женщины, 50 лет
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "Женщины, 2 группа, год рождения:" 
                              type = "string" 
                              hint = "год рождения: в формате ГГГГ" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 50 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
;
-- TAB = Женщины, 45 лет
select rbf.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.data_r "Дата рождения",
       p.name_u "Цех",
       to_char(osn.data_r, 'Month') "Месяц"
  from qwerty.sp_ka_work w,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_rb_fio  rbf,
       qwerty.sp_rb_key  rbk,
       qwerty.sp_stat    s,
       qwerty.sp_podr    p
 where w.id_tab = osn.id_tab
   and trunc(osn.data_r, 'YEAR') =
       to_date('01.01.' || &< name = "Женщины, 3 группа, год рождения:" 
                              type = "string" 
                              hint = "год рождения: в формате ГГГГ" 
                              default = "select to_char(add_months(sysdate, 12), 'yyyy') - 45 from dual" >,
               'dd.mm.yyyy')
   and osn.id_pol = 2
   and w.id_tab = rbf.id_tab
   and w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 order by 3, 2
