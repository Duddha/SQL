--&MONTH_YEAR - мм.гггг - месяц и год, за который проводится расчет

--alter session set nls_sort = UKRAINIAN

--select id_tab, "Прізвище", "Ім'я", "По батькові", count(*) from (

select lpad(rownum, 4, 0) "№ п/п", ttt.* from ( select tt.* from (
--НОВЫЕ РАБОТНИКИ:
--  те, кто появился в новом месяце, по сравнению с предыдущим, и кому платят деньги
--  плюс
--  те, кому в прошлом месяце не платили, а в этом заплатили
select t.*, '7' LAST_COL, 4 SORT_ORDER from (
select 
  osn.id_tab, 
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові"
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn, 
  qwerty.sp_ka_work w
where
  rbf.id_tab in (
                 (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f<>0
                  minus 
                  select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1)
                 )
                 union all
                 (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f<>0
                  intersect 
                  select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and sm_npo_f=0
                 )
                )
 and
  osn.id_tab=rbf.id_tab
 and
  w.id_tab(+)=rbf.id_tab
 and -- минус те, кто принят как пенсионер по возрасту (кроме тех, кого принимают на постоянную работу)
  not(nvl(osn.id_priem, 0)=12 and w.id_work<>60) 
 and --minus временные
  w.id_work(+)<>61
order by 1
) t
--
union all
--ПОМЕНЯВШИЕ ФАМИЛИЮ:
--  работники, которые в отчетном месяце сменили фамилию
select t.*, '7 (зміна прізвища)' LAST_COL, 5 SORT_ORDER from (
select 
  osn.id_tab, 
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові"
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn, 
  qwerty.sp_ka_work w
where
  rbf.id_tab in (select id_tab from qwerty.sp_ka_oldfio oldf
                   where TRUNC(oldf.data_c, 'MONTH')=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                     and id_tab in (select distinct id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                                     where sm_npo_f<>0)                     
                     and (select sm_npo_f from qwerty.sp_zar_itog_pens_npo_arx
                           where id_tab=oldf.id_tab
                             and data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'))<>0
                )
 and
  osn.id_tab=rbf.id_tab
 and -- минус те, кто принят как пенсионер
  nvl(osn.id_priem, 0)<>12
 and
  w.id_tab(+)=rbf.id_tab
 and --minus временные
  w.id_work(+)<>61
order by 1
) t
union all
select t.*, 'сплату припинено (зміна прізвища)' LAST_COL, 2 SORT_ORDER from (
select 
  osn.id_tab, 
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові"
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn, 
  qwerty.sp_ka_work w
where
  rbf.id_tab in (select id_tab from qwerty.sp_ka_oldfio oldf
                   where TRUNC(oldf.data_c, 'MONTH')=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                     and id_tab in (select distinct id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                                     where sm_npo_f<>0)                     
                     and (select sm_npo_f from qwerty.sp_zar_itog_pens_npo_arx
                           where id_tab=oldf.id_tab
                             and data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'))=0
                )
 and
  osn.id_tab=rbf.id_tab
 and -- минус те, кто принят как пенсионер
  nvl(osn.id_priem, 0)<>12
 and
  w.id_tab(+)=rbf.id_tab
 and --minus временные
  w.id_work(+)<>61
order by 1
) t
--
union all
--ПРИОСТАНОВЛЕННЫЕ
--  те, кому в этом месяце не платят, а в прошлом месяце пратили
select t.*, 'сплату припинено' LAST_COL, 1 SORT_ORDER from 
(select 
  rbf.id_tab, osn.id_nalog, rbf.fam_r, rbf.f_name_r, rbf.s_name_r 
from 
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn
where
  rbf.id_tab in 
    (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f=0
     intersect
     select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and sm_npo_f<>0
    )
 and
  osn.id_tab(+) = rbf.id_tab
order by 1) t
--
union all
--УВОЛЕННЫЕ
--  те, кто был в прошлом месяце, но кого уже вообще нет в этом месяце
select t.*, 'звільнено' LAST_COL, 3 SORT_ORDER from 
(select * from 
 (
  select 
    rbf.id_tab, osn.id_nalog, rbf.fam_r, rbf.f_name_r, rbf.s_name_r 
  from 
    qwerty.sp_rb_fio rbf,
    qwerty.sp_ka_osn osn
  where
    rbf.id_tab in (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                     where nvl(id_xara, 0)<>61 and
                           data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1)
                       and sm_npo_f<>0
                    minus 
                    select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                     where nvl(id_xara, 0)<>61 and
                           data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                    minus
                    select id_tab from qwerty.sp_ka_uvol
                     where id_uvol=31
                  )
   and
    osn.id_tab(+) = rbf.id_tab
 )
order by 1) t
union all
--УМЕРШИЕ (уволенные по причине смерти) отдельно
select t.*, 'звільнено (у зв''язку зі смертю)' LAST_COL, 3 SORT_ORDER from 
(select * from 
 (
  select 
    rbf.id_tab, osn.id_nalog, rbf.fam_r, rbf.f_name_r, rbf.s_name_r 
  from 
    qwerty.sp_rb_fio rbf,
    qwerty.sp_ka_osn osn
  where
    rbf.id_tab in (select arx.id_tab from qwerty.sp_zar_itog_pens_npo_arx arx, qwerty.sp_ka_uvol uv
                     where nvl(arx.id_xara, 0)<>61 and
                           arx.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1)
                       and uv.id_tab=arx.id_tab
                       and uv.id_uvol=31
                  )
   and
    osn.id_tab(+) = rbf.id_tab
 )
order by 1) t

order by SORT_ORDER, 3, 4, 5 ) tt) ttt

--) group by id_tab, "Прізвище", "Ім'я", "По батькові"


-------------------------------------------------------------------------------------------
--СУММАРНЫЕ КОЛИЧЕСТВА ПО КАТЕГОРИЯМ
-------------------------------------------------------------------------------------------
;
select last_col, count(*) from (
select lpad(rownum, 4, 0) "№ п/п", ttt.* from ( select tt.* from (
--Новые работники:
--  те, кто появился в новом месяце, по сравнению с предыдущим, и кому платят деньги
--  плюс
--  те, кому в прошлом месяце не платили, а в этом заплатили
select t.*, '7' LAST_COL, 4 SORT_ORDER from (
select 
  osn.id_tab, 
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові"
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn, 
  qwerty.sp_ka_work w
where
  rbf.id_tab in (
                 (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f<>0
                  minus 
                  select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1)
                 )
                 union all
                 (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f<>0
                  intersect 
                  select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and sm_npo_f=0
                 )
                )
 and
  osn.id_tab=rbf.id_tab
 and
  w.id_tab(+)=rbf.id_tab
 and -- минус те, кто принят как пенсионер по возрасту (кроме тех, кого принимают на постоянную работу)
  not(nvl(osn.id_priem, 0)=12 and w.id_work<>60) 
 and --minus временные
  w.id_work(+)<>61
order by 1
) t
--
union all
--Поменявшие фамилию:
--  работники, которые в отчетном месяце сменили фамилию
select t.*, '7 (зміна прізвища)' LAST_COL, 5 SORT_ORDER from (
select 
  osn.id_tab, 
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові"
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn, 
  qwerty.sp_ka_work w
where
  rbf.id_tab in (select id_tab from qwerty.sp_ka_oldfio oldf
                   where TRUNC(oldf.data_c, 'MONTH')=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                     and id_tab in (select distinct id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                                     where sm_npo_f<>0)                     
                     and (select sm_npo_f from qwerty.sp_zar_itog_pens_npo_arx
                           where id_tab=oldf.id_tab
                             and data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'))<>0
                )
 and
  osn.id_tab=rbf.id_tab
 and -- минус те, кто принят как пенсионер
  nvl(osn.id_priem, 0)<>12
 and
  w.id_tab(+)=rbf.id_tab
 and --minus временные
  w.id_work(+)<>61
order by 1
) t
union all
select t.*, 'сплату припинено (зміна прізвища)' LAST_COL, 2 SORT_ORDER from (
select 
  osn.id_tab, 
  osn.id_nalog "ДРФО (ІНН)", rbf.fam_r "Прізвище", rbf.f_name_r "Ім'я", rbf.s_name_r "По батькові"
from
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn, 
  qwerty.sp_ka_work w
where
  rbf.id_tab in (select id_tab from qwerty.sp_ka_oldfio oldf
                   where TRUNC(oldf.data_c, 'MONTH')=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                     and id_tab in (select distinct id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                                     where sm_npo_f<>0)                     
                     and (select sm_npo_f from qwerty.sp_zar_itog_pens_npo_arx
                           where id_tab=oldf.id_tab
                             and data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'))=0
                )
 and
  osn.id_tab=rbf.id_tab
 and -- минус те, кто принят как пенсионер
  nvl(osn.id_priem, 0)<>12
 and
  w.id_tab(+)=rbf.id_tab
 and --minus временные
  w.id_work(+)<>61
order by 1
) t
--
union all
--Приостановленные
--  те, кому в этом месяце не платят, а в прошлом месяце пратили
select t.*, 'сплату припинено' LAST_COL, 1 SORT_ORDER from 
(select 
  rbf.id_tab, osn.id_nalog, rbf.fam_r, rbf.f_name_r, rbf.s_name_r 
from 
  qwerty.sp_rb_fio rbf,
  qwerty.sp_ka_osn osn
where
  rbf.id_tab in 
    (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy') and sm_npo_f=0
     intersect
     select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                   where data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1) and sm_npo_f<>0
    )
 and
  osn.id_tab(+) = rbf.id_tab
order by 1) t
--
union all
--Уволенные
--  те, кто был в прошлом месяце, но кого уже вообще нет в этом месяце
select t.*, 'звільнено' LAST_COL, 3 SORT_ORDER from 
(select * from 
 (
  select 
    rbf.id_tab, osn.id_nalog, rbf.fam_r, rbf.f_name_r, rbf.s_name_r 
  from 
    qwerty.sp_rb_fio rbf,
    qwerty.sp_ka_osn osn
  where
    rbf.id_tab in (select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                     where nvl(id_xara, 0)<>61 and
                           data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1)
                       and sm_npo_f<>0
                    minus 
                    select id_tab from qwerty.sp_zar_itog_pens_npo_arx 
                     where nvl(id_xara, 0)<>61 and
                           data=to_date('01.&MONTH_YEAR', 'dd.mm.yyyy')
                    minus
                    select id_tab from qwerty.sp_ka_uvol
                     where id_uvol=31
                  )
   and
    osn.id_tab(+) = rbf.id_tab
 )
order by 1) t
union all
--Умершие (уволенные по причине смерти) отдельно
select t.*, 'звільнено (у зв''язку зі смертю)' LAST_COL, 3 SORT_ORDER from 
(select * from 
 (
  select 
    rbf.id_tab, osn.id_nalog, rbf.fam_r, rbf.f_name_r, rbf.s_name_r 
  from 
    qwerty.sp_rb_fio rbf,
    qwerty.sp_ka_osn osn
  where
    rbf.id_tab in (select arx.id_tab from qwerty.sp_zar_itog_pens_npo_arx arx, qwerty.sp_ka_uvol uv
                     where nvl(arx.id_xara, 0)<>61 and
                           arx.data=add_months(to_date('01.&MONTH_YEAR', 'dd.mm.yyyy'), -1)
                       and uv.id_tab=arx.id_tab
                       and uv.id_uvol=31
                  )
   and
    osn.id_tab(+) = rbf.id_tab
 )
order by 1) t

order by SORT_ORDER, 3, 4, 5 ) tt) ttt
) group by last_col
