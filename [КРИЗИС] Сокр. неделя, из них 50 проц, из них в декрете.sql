select sum(ff), sum(otp53), sum(dekr) from (
select p62.id_tab,
       p62.id_cex,
       p62.id_otp,
       p62.data_n,
       p62.data_k,
       nvl2(o.id_tab, 1, 0) otp53,
       nvl2(d.id_tab, 1, 0) dekr,
       1 ff
  from qwerty.sp_ka_otpusk_p62 p62,
       qwerty.sp_ka_otpusk     o,
       qwerty.sp_ka_dekr       d
 where p62.id_otp = 92
   and to_date('&Дата_выборки', 'dd.mm.yyyy') between p62.data_n and
       p62.data_k
   and o.id_tab(+) = p62.id_tab
   and o.id_otp(+) = 53
   and to_date('&Дата_выборки', 'dd.mm.yyyy') between o.dat_n(+) and
       o.dat_k(+)
   and d.id_tab(+) = p62.id_tab
   and (to_date('&Дата_выборки', 'dd.mm.yyyy') >= d.n_dekr(+) and
       to_date('&Дата_выборки', 'dd.mm.yyyy') <=
       decode(d.date_vid(+), null, d.k_dekr(+), d.date_vid(+)))
      )
