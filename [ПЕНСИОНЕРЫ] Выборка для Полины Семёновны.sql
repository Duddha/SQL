select row_number() over(order by t.staj_list, t.fio) "№ п/п", 
       row_number() over(partition by t.staj_list order by t.fio) "№ в группе по стажу",
       t.id_tab     "Таб. №",
       t.fio        "Ф.И.О.",
       p.date_priem "Дата приема",
       t.date_uvol  "Дата увольнения",
       vw.name_u "Вид увольнения",
       decode(trunc(t.staj / 12),
              1,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              2,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              3,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              4,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              21,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              22,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              23,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              24,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              31,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              32,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              33,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              34,
              trunc(t.staj / 12) || 'г. ' || trunc(mod(t.staj, 12)) || 'м.',
              trunc(t.staj / 12) || 'л. ' || trunc(mod(t.staj, 12)) || 'м.') "Стаж",
       --t.staj "Стаж",
       decode(nvl(pl.data_po, ''),
              '',
              '',
              'Ветеран завода (' || pl.data_po || ')') "Ветеран ОПЗ",
       t.prim "Примечания",
       decode(t.staj_list, 1, 'Стаж до 6 лет', 2, 'Стаж от 6 до 15 лет', 3, 'Стаж от 15 до 25 лет', 4, 'Стаж более 25 лет', 'ОШИБКА') "Список"
  from (select pens.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               pens.dat_uvol date_uvol,
               nvl(pens.stag, 0) + nvl(pens.stag_d, 0) staj,
               l.lost_note prim,
               l.lost_type,
               case when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) < 72 then 1
            when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) >= 72 and nvl(pens.stag, 0) + nvl(pens.stag_d, 0) <180 then 2
            when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) >=180 and nvl(pens.stag, 0) + nvl(pens.stag_d, 0) < 300 then 3
            when nvl(pens.stag, 0) + nvl(pens.stag_d, 0) >= 300 then 4
        end staj_list
          from qwerty.sp_ka_pens_all pens,
               qwerty.sp_rb_fio      rbf,
               qwerty.sp_ka_lost     l
         where pens.kto <> 7
           and rbf.id_tab = pens.id_tab
           and l.id_tab(+) = pens.id_tab
           and nvl(l.lost_type, 0) <> 1) t,
       qwerty.sp_ka_uvol u,
       qwerty.sp_vid_work vw,
       (select id_tab, min(data_work) date_priem
          from qwerty.sp_ka_perem
         where abs(id_zap) = 1
           and id_work <> 61
         group by id_tab) p,
       (select id_tab, data_po from qwerty.sp_ka_plus where id_po = 3) pl
 where u.id_tab(+) = t.id_tab
   and nvl(u.data_uvol, sysdate) = t.date_uvol
   and vw.id(+) = nvl(u.id_uvol, 0)
   and p.id_tab(+) = t.id_tab
   and pl.id_tab(+) = t.id_tab
 order by t.staj_list, t.fio
