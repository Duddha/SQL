--select distinct(f2.id_tab)
select *
  from qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_work      wrk,
       qwerty.sp_ka_osn       osn,
       qwerty.sp_ka_obr       obr
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
   and f2.id_zap = 1
   and f2.data_work >= trunc(sysdate, 'YEAR')
   -- !!!!!!!!!!!!!!!!!!!!!!!! Не ясно что за следующая дата
   -- наверняка имеет отношение к "молодежь" но до конца не ясно
   and osn.data_r >= to_date('01.10.1973', 'dd.mm.yyyy')
   and obr.id_tab = wrk.id_tab
   --and obr.id_obr = 2   -- СРЕДНЕЕ ОБРАЗОВАНИЕ
   and f2.nam_work <> 'вpеменно'
   -- ТОЛЬКО ШКОЛА
   --and obr.id_uchzav is null
   -- НЕ ТОЛЬКО ШКОЛА
   and not(obr.id_uchzav is null)
   -- Предыдущее место работы - Учеба в...
   --and lower(pred_work) like '%учеба%'
