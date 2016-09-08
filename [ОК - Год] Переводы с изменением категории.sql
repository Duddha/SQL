select tt.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О",
       --prm.id_a_kat prev_kat,
       aak.name_u    "Предыдущая категория",
       aac.name_u    "Предыдущий цех",
       aam.full_name "Предыдущая должность",
       tt.data_work  "Дата перевода",
       kk.name_u     "Новая категория",
       tt.name_u     "Новый цех",
       tt.full_name  "Новая должность"
  from (select p.id_tab,
               p.id_zap,
               p.data_zap,
               p.id_work,
               p.data_work,
               p.data_kon,
               p.id_a_cex,
               p.id_a_kat,
               p.id_a_mest,
               ac.name_u,
               am.full_name
          from qwerty.sp_ka_perem p,
               qwerty.sp_arx_cex  ac,
               qwerty.sp_arx_mest am
         where trunc(p.data_work, 'YEAR') = '01.01.&YEAR'
           and abs(id_zap) <> 1
           and ac.id = p.id_n_cex
           and am.id = p.id_n_mest
        union all
        select w.id_tab,
               w.id_zap,
               w.data_zap,
               w.id_work,
               w.data_work,
               w.data_kon_w,
               s.id_cex,
               s.id_kat,
               s.id_mest,
               pdr.name_u,
               m.full_name_u
          from qwerty.sp_ka_work w,
               qwerty.sp_rb_key  rbk,
               qwerty.sp_stat    s,
               qwerty.sp_podr    pdr,
               qwerty.sp_mest    m
         where w.id_zap <> 1
           and trunc(w.data_work, 'YEAR') = '01.01.&YEAR'
           and rbk.id_tab = w.id_tab
           and s.id_stat = rbk.id_stat
           and pdr.id_cex = s.id_cex
           and m.id_mest = s.id_mest) tt,
       qwerty.sp_ka_perem prm,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_arx_cex aac,
       qwerty.sp_arx_kat aak,
       qwerty.sp_arx_mest aam,
       qwerty.sp_kat kk
 where prm.id_tab = tt.id_tab
   and prm.id_zap = tt.id_zap - 1
--   and prm.id_a_kat > tt.id_a_kat
   and prm.id_a_kat < tt.id_a_kat
   and rbf.id_tab = tt.id_tab
   and aac.id = prm.id_n_cex
   and aak.id = prm.id_n_kat
   and aam.id = prm.id_n_mest
   and kk.id_kat = tt.id_a_kat
 order by 2
