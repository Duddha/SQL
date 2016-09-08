select a.id_tab "Òàá. ¹",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ô.È.Î.",
       a.sum_otp "Îáùåå êîë-âî äíåé îòïóñêà",
       b.name_u "Öåõ",
       b.full_name_u "Äîëæíîñòü"
  from (select id_tab, sum(kol_d) sum_otp
          from (select id_tab, dat_k - dat_n + 1 kol_d, dat_n, dat_k
                  from qwerty.sp_ka_otpusk t
                 where id_otp = 53
                 order by id_tab)
         group by id_tab) a,
       qwerty.sp_rb_fio rbf,
       (select w.id_tab, p.name_u, m.full_name_u
          from qwerty.sp_ka_work w,
               qwerty.sp_rb_key  rbk,
               qwerty.sp_stat    s,
               qwerty.sp_podr    p,
               qwerty.sp_mest    m
         where w.id_tab = rbk.id_tab
           and rbk.id_stat = s.id_stat
           and s.id_cex = p.id_cex
           and s.id_mest = m.id_mest) b
 where a.id_tab = rbf.id_tab
   and a.sum_otp >= 30
   and a.id_tab = b.id_tab(+)
 order by 4, 2
