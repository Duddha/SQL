-- TAB = Данные для загрузки в 1С Профкома
select '1' id_vid, --Для работников
       --'2' id_vid, --Для пенсионеров
       t.id_tab id_tab,
       t.fam_u fam_u,
       t.f_name_u f_name_u,
       t.s_name_u s_name_u,
       o.id_nalog id_nalog,
       o.data_r dat_r,
       f2.DATA_WORK dat_work,
       ' ' dat_uvol,
       --p.numb pas_num,
       --p.ser pas_ser,
       --p.kem pas_kto,
       --p.data_p pas_dat,
       o.id_pol pol,
       decode(o.id_pens, 1, 1, 2) id_pens,
       t.name_cex nam_cex,
       t.ID_CEX id_cex,
       m.full_name_u nam_mest,
       t.id_mest id_mest,
       decode(l.nam, null, 1, 2) id_inv,
       l.nam gr_inv,
       l.numb_comment pf_num,
       adr.post_ind post_ind,
       adr.city city,
       adr.line line,
       adr.dom dom,
       adr.korp korp,
       adr.kvart kvart

  from QWERTY.SP_RBV_TAB_NAME t,
       qwerty.sp_rb_key rbk,
       qwerty.sp_stat s,
       qwerty.sp_mest m,
       qwerty.sp_kav_perem_f2 f2,
       qwerty.sp_ka_osn o,
       (select *
          from (select lgt.id_tab,
                       l.nam,
                       lgt.numb_comment,
                       row_number() over(partition by id_tab, numb_comment order by dat_n desc) rn
                  from qwerty.sp_ka_lgt lgt, qwerty.sp_lgt l
                 where l.id = lgt.id_lgt
                   and nvl(dat_k, sysdate + 10) >= sysdate)
         where rn = 1) l
       --       , qwerty.sp_lgt sl
       --qwerty.sp_podr pp
      ,
       (select *
          from (select adr.id_tab,
                       adr.post_ind,
                       s.name_u city,
                       lower(lin.snam_u) || ' ' || adr.name_line_u line,
                       adr.dom,
                       adr.korp,
                       adr.kvart,
                       row_number() over(partition by id_tab order by id_tab) rn
                  from qwerty.sp_ka_adres adr,
                       qwerty.sp_sity     s,
                       qwerty.sp_line     lin
                 where adr.fl = 1
                   and adr.id_sity = s.id
                   and adr.id_line = lin.id)
         where rn = 1) adr
 where t.id_tab in
       (
       select id_tab from (
select 
    id_tab, 
    nvl(stag, 0) + nvl(stag_d, 0) stag, 
    dat_uvol,
    kto
  from qwerty.sp_ka_pens_all pall
 where nvl(dat_uvol, to_date(&<name = "Дата выборки" type="string" hint = "ДД.ММ.ГГГГ" 
                               default = "select to_char(sysdate, 'dd.mm.yyyy') from dual">, 'dd.mm.yyyy')-1)  <= to_date(&<name = "Дата выборки">, 'dd.mm.yyyy') 
 and pall.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
)
where &<name = "Список" list = "stag between (6 * 12) and (15 * 12 - 1), стаж от 6 до 15 лет,
                                stag >= (15 * 12), стаж свыше 15 лет,
                                kto = 7, пенсионеры ВОХР" description = "yes">
       )
   and rbk.id_tab(+) = t.id_tab
   and s.id_stat(+) = rbk.id_stat
   and m.id_mest(+) = s.id_mest
   and f2.ID_TAB(+) = t.ID_TAB
   and f2.ID_ZAP(+) = 1
   and t.ID_TAB = o.id_tab(+)
   and t.ID_TAB = l.id_tab(+)
   and adr.id_tab(+) = t.id_tab
 order by fam_u, f_name_u, s_name_u, t.data_r;
-- TAB = Дети
select id_tab,
       data_r,
       fam_u,
       f_name_u,
       s_name_u,
       decode(pol, 1, '1', 2, '2', '??') pol,
       decode(id_rod, 5, 'Сын', 6, 'Дочь', 7, 'Опекун') rod
  from qwerty.sp_ka_famil
 where id_rod in (5, 6, 7)
   and id_tab in (select id_tab from qwerty.sp_ka_work)
 order by fam_u, data_r
