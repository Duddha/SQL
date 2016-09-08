--TAB=Женщины с детьми до 6 лет
select distinct (rbf.id_tab)
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_pol = 2
   and f.id_rod in (5, 6)
   and f.data_r >= add_months(to_date(&< name = "Дата выборки" type = "string" hint = "DD.MM.YYYY" default = "select to_char(trunc(sysdate, 'MONTH'), 'dd.mm.yyyy') from dual" >,
                                      'dd.mm.yyyy'),
                              -72);
--TAB=Матери-одиночки с ребенком до 14 лет
select distinct rbf.id_tab
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_sempol = 30 -- МАТЬ-ОДИНОЧКА
   and f.data_r >= add_months(to_date(&< name = "Дата выборки"
                                      type = "string" hint = "DD.MM.YYYY" >,
                                      'dd.mm.yyyy'),
                              -168);
--TAB=Матери с детьми инвалидами
select distinct rbf.id_tab
  from qwerty.sp_rb_fio   rbf,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_ka_famil f
 where wrk.id_tab = rbf.id_tab
   and osn.id_tab = rbf.id_tab
   and f.id_tab = rbf.id_tab
   and osn.id_pens = 52 -- МАТЬ РЕБЕНКА ИНВАЛИДА С ДЕТСТВА
   and f.data_r >= add_months(to_date(&< name = "Дата выборки"
                                      type = "string" hint = "DD.MM.YYYY" >,
                                      'dd.mm.yyyy'),
                              -216); --Мать ребенка (до 18 лет) инвалида с детства (18*12=216)
--TAB=Молодежь, которая закончила школу в 2011 году
-- 2DO: Возможно необходимо проверять молодёжь на "молодость" (т.е. ввести ограничение по возрасту)
select *
  from QWERTY.SP_KA_OBR obr, qwerty.sp_ka_osn osn
 where id_uchzav is null --нет учебного заведения => школа
   and to_char(data_ok, 'yyyy') =
       to_char(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'),
               'yyyy')
   and id_obr = 2 --среднее
   and id_vidobr = 1 --дневное
   and obr.id_tab = osn.id_tab;
--TAB=Молодежь, к-рая закончила ПТУ и не получила направления на работу
select distinct (f2.id_tab)
--select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_obr       obr
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" >, 'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                        'dd.mm.yyyy'),
                                -420) --молодежь - до 35 лет (35*12=420)
   and obr.id_tab = wrk.id_tab
   and obr.id_obr = 5 -- среднее специальное образование
   and osn.id_priem not in (10, 9) --НЕ по направлению из средне-технич. заведения, НЕ по путевке ВУЗа
   and trunc(obr.data_ok, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and f2.nam_work <> 'вpеменно'
   and not (obr.id_uchzav is null) -- не только школа
;
--TAB=Молодежь, к-рая закончила ВУЗ и не получила направления на работу
select distinct (f2.id_tab)
--select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_obr       obr
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                        'dd.mm.yyyy'),
                                -420) --молодежь - до 35 лет (35*12=420)
   and obr.id_tab = wrk.id_tab
   and obr.id_obr = 6 -- высшее образование
   and osn.id_priem not in (10, 9) --НЕ по направлению из средне-технич. заведения, НЕ по путевке ВУЗа
   and trunc(obr.data_ok, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and f2.nam_work <> 'вpеменно'
   and not (obr.id_uchzav is null) -- не только школа
;
--TAB=Молодежь в возрасте до 18 лет
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1 --принят в отчетном году
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                        'dd.mm.yyyy'),
                                -216) --молодежь - до 18 лет (18*12=216)
   and f2.nam_work <> 'вpеменно';
--TAB=Молодежь из армии в тек. году, 1е рабочее место
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1 --принят в отчетном году
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                        'dd.mm.yyyy'),
                                -420) --молодежь - до 35 лет (35*12=420)
   and f2.nam_work <> 'вpеменно'
   and lower(osn.pred_work) like '%служба в%' --первое рабочее место - предыдущее содержит слова "служба в"
;
--TAB=Работники предпенс. возраста, женщины старше 53 лет
--Конкретные работники 
--Женщины
select rbf.id_tab "Таб. №",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О.",
       osn.data_r "Дата рождения",
       to_char(osn.data_r, 'YYYY') "Год рождения",
       trunc(months_between(to_date(&< name = "Дата выборки" >,
                                    'dd.mm.yyyy'),
                            osn.data_r) / 12) "Возраст",
       rbf.ID_CEX "Код цеха",
       dep.name_u "Цех",
       wp.full_name_u "Должность",
       wrk.id_work "Код вида работы",
       vw.name_u "Вид работы"
  from qwerty.sp_rbv_tab  rbf,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_podr     dep,
       qwerty.sp_mest     wp,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_vid_work vw
 where rbf.status = 1
   and osn.id_pol = 2
   and osn.id_tab = rbf.id_tab
   and months_between(to_date(&< name = "Дата выборки" >,
                              'dd.mm.yyyy'),
                      osn.data_r) between &<
 name = "Возраст для женщин с..."
 default = 53 > * 12
   and (&< name = "Возраст для женщин по..." default = 100 >) * 12
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in
       (&< name = "Виды работ" default = "60, 63, 66, 67, 76, 83" >)
   and wrk.id_work = vw.id
 order by osn.data_r, 2;
--TAB=Работники предпенс. возраста, мужчины старше 58 лет
--Мужчины
select rbf.id_tab "Таб. №",
       rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О.",
       osn.data_r "Дата рождения",
       to_char(osn.data_r, 'YYYY') "Год рождения",
       trunc(months_between(to_date(&< name = "Дата выборки" >,
                                    'dd.mm.yyyy'),
                            osn.data_r) / 12) "Возраст",
       rbf.ID_CEX "Код цеха",
       dep.name_u "Цех",
       wp.full_name_u "Должность",
       wrk.id_work "Код вида работы",
       vw.name_u "Вид работы"
  from qwerty.sp_rbv_tab  rbf,
       qwerty.sp_ka_osn   osn,
       qwerty.sp_podr     dep,
       qwerty.sp_mest     wp,
       qwerty.sp_ka_work  wrk,
       qwerty.sp_vid_work vw
 where rbf.status = 1
   and osn.id_pol = 1
   and osn.id_tab = rbf.id_tab
   and months_between(to_date(&< name = "Дата выборки" >,
                              'dd.mm.yyyy'),
                      osn.data_r) between &<
 name = "Возраст для мужчин с..."
 default = 58 > * 12
   and (&< name = "Возраст для мужчин по..." default = 100 >) * 12
   and dep.id_cex = rbf.ID_CEX
   and wp.id_mest = rbf.ID_MEST
   and wrk.id_tab = rbf.ID_TAB
   and wrk.id_work in (&< name = "Виды работ" >)
   and wrk.id_work = vw.id
 order by osn.data_r, 2
