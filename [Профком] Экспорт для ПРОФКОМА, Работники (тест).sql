-- TAB = Ýêñïîðò äëÿ ÏÐÎÔÊÎÌÀ: Ðàáîòíèêè
-- ÐÀÁÎÒÍÈÊÈ
select '1' id_vid,
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
       --l.id_lgt
       l.nam          gr_inv,
       l.numb_comment pf_num,
       adr.post_ind   post_ind,
       adr.city       city,
       adr.line       line,
       adr.dom        dom,
       adr.korp       korp,
       adr.kvart      kvart
--t.address ADRES

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
       (select id_tab
          from qwerty.sp_ka_work
        minus
        select id_tab
          from qwerty.sp_ka_pens_all
         where id_tab not in
               (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
           and kto <> 7)
   and rbk.id_tab = t.id_tab
   and s.id_stat = rbk.id_stat
   and m.id_mest = s.id_mest
   and f2.ID_TAB = t.ID_TAB
   and f2.ID_ZAP = 1
   and t.ID_TAB = o.id_tab(+)
   and t.ID_TAB = l.id_tab(+)
   and adr.id_tab(+) = t.id_tab
--   and l.id_lgt = sl.id
 order by fam_u, f_name_u, s_name_u, t.data_r;
 -- TAB = Ýêñïîðò äëÿ ÏÐÎÔÊÎÌÀ: Ïåíñèîíåðû
-- ÏÅÍÑÈÎÍÅÐÛ
select '2' id_vid,
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
       decode(t.ID_CEX, 0, null, t.name_cex)  nam_cex,
       decode(t.ID_CEX, 0, null, t.ID_CEX) id_cex,
       m.full_name_u nam_mest,
       decode(t.id_mest, 0, null, t.id_mest) id_mest,
       decode(l.nam, null, 1, 2) id_inv,
       --l.id_lgt
       l.nam          gr_inv,
       l.numb_comment pf_num,
       adr.post_ind   post_ind,
       adr.city       city,
       adr.line       line,
       adr.dom        dom,
       adr.korp       korp,
       adr.kvart      kvart
--t.address ADRES

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
       (/*select id_tab
          from qwerty.sp_ka_work
        minus*/
        select id_tab
          from qwerty.sp_ka_pens_all
         where id_tab not in
               (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
           and kto <> 7)
   and rbk.id_tab(+) = t.id_tab
   and s.id_stat(+) = rbk.id_stat
   and m.id_mest(+) = s.id_mest
   and f2.ID_TAB(+) = t.ID_TAB
   and f2.ID_ZAP(+) = 1
   and t.ID_TAB = o.id_tab(+)
   and t.ID_TAB = l.id_tab(+)
   and adr.id_tab(+) = t.id_tab
--   and l.id_lgt = sl.id
 order by fam_u, f_name_u, s_name_u, t.data_r
