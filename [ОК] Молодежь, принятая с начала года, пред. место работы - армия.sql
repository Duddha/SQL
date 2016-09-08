--TAB=Молодежь из армии в тек. году, 1е рабочее место
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   --принят в отчетном году
   and f2.id_zap = 1
   and trunc(f2.data_work, 'YEAR') =
       trunc(to_date(&< name = "Дата выборки" type = "string" >,
                     'dd.mm.yyyy'),
             'YEAR')
   --молодежь - до 35 лет (35*12=420)
   and osn.data_r >= add_months(to_date(&< name = "Дата выборки" >,
                                        'dd.mm.yyyy'),
                                -420)
   and f2.nam_work <> 'вpеменно'
   --первое рабочее место - предыдущее содержит слова "служба в"
   and lower(osn.pred_work) like '%служба в%'
