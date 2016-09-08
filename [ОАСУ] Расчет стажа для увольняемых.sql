select id_tab, months_between(data_k, data_w) from (
select t.id_tab, 0 id_cex, 0 id_stat,
      max(t.data_w)  data_w,
      max(t.data_k)  data_k,
      max(t.data_uw) data_uw,
      decode(max(t.data_uw), to_date(null),to_date(null), max(t.data_uk)) data_uk,
      max(t.data_dw) data_dw,
      max(t.data_dk) data_dk,
      max(nvl(t.id_xara,0)) id_xara,
      max(nvl(t.id_perem,0)) id_perem,
      min(t.ukr)  ukr,
      sum(sta_uvol) sta_uvol
   from
(   
SELECT distinct 1 ukr,
              w.ID_TAB, s.id_cex, s.id_mest id_stat,
              decode(nvl(w.ID_ZAP,0),1,w.data_work,p.data_work) data_w,
              d.dada data_k,
              to_date(null) data_uw,
              decode(nvl(w.ID_ZAP,0),1,w.data_work,p.data_work) data_uk,
              to_date(null) data_dw,
              to_date(null) data_dk,
              nvl(w.id_work,0) id_xara,
              0 id_perem, 0 sta_uvol
      FROM QWERTY.SP_KA_PEREM P,
           qwerty.sp_ka_work  w,
           qwerty.sp_rb_key   k,
           qwerty.sp_stat     s,
           (select sysdate dada from dual) d
      where  w.id_tab=p.id_tab(+) and
             decode(nvl(w.ID_ZAP,0),1,w.id_zap,p.id_zap)=1 and
             w.id_tab=k.id_tab and k.id_stat=s.id_stat
             and w.id_tab=4875
) t
  group by t.id_tab)
