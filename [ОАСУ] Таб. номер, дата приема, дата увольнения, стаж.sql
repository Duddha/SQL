select d.id_tab "Таб.№", rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u "Ф.И.О.",
       trunc(sta/12)||'л. '||trunc(mod(sta, 12))||'м.' "Стаж",
       d.data_pr "Дата приема", d.data_uv "Дата увольнения",
       /*vw.name_u vid_pr, */vw1.name_u"Причина увольнения", 
       decode(nvl(pl.data_po, ''), '', '','Ветеран труда завода ('||pl.data_po||')') "Ветеранство"  from 
(select id_tab id_tab, min(data_work) data_pr, max(data_kon) data_uv, sum(sta) sta from (
select c.id_tab, c.data_work, c.data_kon, months_between(data_kon, data_work) sta from (
select a.id_tab, a.rnum, a.data_work, nvl(b.data_work, sysdate) data_kon, 
       a.flag, b.flag, a.id_zap, a.data_zap, a.id_work from kav_perem a, kav_perem b
where b.id_tab=a.id_tab and b.rnum=a.rnum+1 and a.flag<>3
  --and a.id_tab=4979
  and a.id_work not in (select id from qwerty.sp_vid_work where p_id=27
                        union all
                        select 61 from dual)
   --Убираем временных
   --and a.id_work not in (61)
) c
) group by id_tab) d,
qwerty.sp_ka_perem per,
qwerty.sp_ka_uvol uv,
--qwerty.sp_vid_work vw,
qwerty.sp_vid_work vw1,
qwerty.sp_ka_plus pl,
qwerty.sp_rb_fio rbf
where d.id_tab in (select id_tab from qwerty.sp_ka_pens_all
                   minus
                   select id_tab from qwerty.sp_ka_lost where lost_type = 1)
  and per.id_tab = d.id_tab and per.data_work = d.data_pr
  and uv.id_tab = d.id_tab and uv.data_uvol = d.data_uv
  /*and vw.id=per.id_work */and vw1.id = uv.id_uvol
  --Ветераны
  and pl.id_tab(+) = d.id_tab and pl.id_po(+) = 3
  and rbf.id_tab = d.id_tab
--Разбиваем по стажности
--  and sta between 0 and 71
  and sta between 72 and 179
--  and sta between 180 and 299
--  and sta >= 300
order by 2
