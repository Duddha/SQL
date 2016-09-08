--Количество работников по категориям
-- TAB = По категориям, женщины
select id_kat "Код категории", "Категория", count(*) "Кол-во"
  from (select rbf.id_tab "Таб. №",
               rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О.",
               osn.data_r "Дата рождения",
               to_char(osn.data_r, 'YYYY') "Год рождения",
               trunc(months_between(to_date('&<name="Дата выборки" hint="ДД.ММ.ГГГГ" 
                                               default="select to_char(sysdate, 'dd.mm.yyyy') from dual" 
                                               ifempty="select to_char(sysdate, 'dd.mm.yyyy') from dual">',
                                            'dd.mm.yyyy'), osn.data_r) / 12) "Возраст",
               rbf.ID_CEX "Код цеха",
               dep.name_u "Цех",
               kat.name_u "Категория",
               wp.full_name_u "Должность",
               wrk.id_work "Вид работы",
               rbf.id_kat
          from qwerty.sp_rbv_tab rbf,
               qwerty.sp_ka_osn  osn,
               qwerty.sp_podr    dep,
               qwerty.sp_mest    wp,
               qwerty.sp_ka_work wrk,
               qwerty.sp_kat     kat
         where rbf.status = 1
           and osn.id_pol = 2
           and osn.id_tab = rbf.id_tab
           and osn.data_r <=
               to_date('31.12.' ||
                       to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "Возраст для женщин" default = 55 ifempty = 55 >))
           and dep.id_cex = rbf.ID_CEX
           and wp.id_mest = rbf.ID_MEST
           and wrk.id_tab = rbf.ID_TAB
           and rbf.ID_KAT = kat.id_kat
           and wrk.id_work in
               (&< name = "Виды работ" hint = "Виды работ для выборки" default = "60, 63, 66, 67, 76, 83"
                                                                                ifempty =
                                                                                "60, 63, 66, 67, 76, 83" >)
         order by osn.data_r, 2)
 group by id_kat, "Категория"
 order by 1;
-- TAB = По категориям, мужчины
select id_kat "Код категории", "Категория", count(*) "Кол-во"
  from (select rbf.id_tab "Таб. №",
               rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О.",
               osn.data_r "Дата рождения",
               to_char(osn.data_r, 'YYYY') "Год рождения",
               trunc(months_between(to_date('&<name="Дата выборки">',
                                            'dd.mm.yyyy'), osn.data_r) / 12) "Возраст",
               rbf.ID_CEX "Код цеха",
               dep.name_u "Цех",
               kat.name_u "Категория",
               wp.full_name_u "Должность",
               wrk.id_work "Вид работы",
               rbf.id_kat
          from qwerty.sp_rbv_tab rbf,
               qwerty.sp_ka_osn  osn,
               qwerty.sp_podr    dep,
               qwerty.sp_mest    wp,
               qwerty.sp_ka_work wrk,
               qwerty.sp_kat     kat
         where rbf.status = 1
           and osn.id_pol = 1
           and osn.id_tab = rbf.id_tab
           and osn.data_r <=
               to_date('31.12.' ||
                       to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "Возраст для мужчин" default = 60 ifempty = 60>))
           and dep.id_cex = rbf.ID_CEX
           and wp.id_mest = rbf.ID_MEST
           and wrk.id_tab = rbf.ID_TAB
           and rbf.ID_KAT = kat.id_kat
           and wrk.id_work in (&< name = "Виды работ" >)
         order by osn.data_r, 2)
 group by id_kat, "Категория"
 order by 1;
--Конкретные работники 
-- TAB = Конкретные работники, женщины
select rbf.id_tab "Таб. №",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О.",
       osn.data_r "Дата рождения",
       to_char(osn.data_r, 'YYYY') "Год рождения",
       trunc(months_between(to_date('&<name="Дата выборки">', 'dd.mm.yyyy'),
                            osn.data_r) / 12) "Возраст",
       rbf.ID_CEX "Код цеха",
       dep.name_u "Цех",
       wp.full_name_u "Должность",
       wrk.id_work "Вид работы"
  from qwerty.sp_rbv_tab rbf,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_podr    dep,
       qwerty.sp_mest    wp,
       qwerty.sp_ka_work wrk
 where rbf.status = 1
   and osn.id_pol = 2
   and osn.id_tab = rbf.id_tab
   and osn.data_r <=
       to_date('31.12.' ||
               to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "Возраст для женщин" >))
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in (&< name = "Виды работ" >)
 order by osn.data_r, 2;
-- TAB = Конкретные работники, мужчины
select rbf.id_tab "Таб. №",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О.",
       osn.data_r "Дата рождения",
       to_char(osn.data_r, 'YYYY') "Год рождения",
       trunc(months_between(to_date('&<name="Дата выборки">', 'dd.mm.yyyy'),
                            osn.data_r) / 12) "Возраст",
       rbf.ID_CEX "Код цеха",
       dep.name_u "Цех",
       wp.full_name_u "Должность",
       wrk.id_work "Вид работы"
  from qwerty.sp_rbv_tab rbf,
       qwerty.sp_ka_osn  osn,
       qwerty.sp_podr    dep,
       qwerty.sp_mest    wp,
       qwerty.sp_ka_work wrk
 where rbf.status = 1
   and osn.id_pol = 1
   and osn.id_tab = rbf.id_tab
   and osn.data_r <=
       to_date('31.12.' ||
               to_char(to_number(to_char(sysdate, 'YYYY')) - &< name = "Возраст для мужчин" >))
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in (&< name = "Виды работ" >)
 order by osn.data_r, 2
