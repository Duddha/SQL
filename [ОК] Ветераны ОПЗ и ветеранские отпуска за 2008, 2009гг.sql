select pl.id_tab "Таб. №",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       a.vacancy "Отпуск 2008",
       nvl(a.vac_year, 0) "Год",
       a.lv "Кол-во 2008",
       b.vacancy "Отпуск 2009",
       nvl(b.vac_year, 0) "Год",
       b.lv "Кол-во 2009"
  from (select tab_id,
               substr(sys_connect_by_path(vac, '; '), 3) vacancy,
               vac_year,
               level lv
          from (select tab_id,
                       vac,
                       lag(vac) over(partition by tab_id, vac_year order by vac_n) prev_vac,
                       lead(vac) over(partition by tab_id, vac_year order by vac_n) next_vac,
                       rn,
                       vac_n,
                       vac_year
                  from (select pl.id_tab tab_id,
                               otp.dat_n vac_n,
                               to_char(otp.dat_n, 'dd.mm.yyyy') || '-' ||
                               to_char(otp.dat_k, 'dd.mm.yyyy') vac,
                               to_number(to_char(otp.dat_n, 'yyyy')) vac_year,
                               row_number() over(partition by pl.id_tab order by otp.dat_n) rn
                          from qwerty.sp_ka_plus pl, qwerty.sp_ka_otpusk otp
                         where pl.id_po = 3
                           and pl.id_tab = otp.id_tab(+)
                           and otp.id_otp = 22
                           and trunc(otp.dat_n, 'YEAR') >= '01.01.2008'
                         order by 1, vac_n))
         where next_vac is null
         start with prev_vac is null
        connect by prior vac = prev_vac
               and prior tab_id = tab_id) a,
       (select tab_id,
               substr(sys_connect_by_path(vac, '; '), 3) vacancy,
               vac_year,
               level lv
          from (select tab_id,
                       vac,
                       lag(vac) over(partition by tab_id, vac_year order by vac_n) prev_vac,
                       lead(vac) over(partition by tab_id, vac_year order by vac_n) next_vac,
                       rn,
                       vac_n,
                       vac_year
                  from (select pl.id_tab tab_id,
                               otp.dat_n vac_n,
                               to_char(otp.dat_n, 'dd.mm.yyyy') || '-' ||
                               to_char(otp.dat_k, 'dd.mm.yyyy') vac,
                               to_number(to_char(otp.dat_n, 'yyyy')) vac_year,
                               row_number() over(partition by pl.id_tab order by otp.dat_n) rn
                          from qwerty.sp_ka_plus pl, qwerty.sp_ka_otpusk otp
                         where pl.id_po = 3
                           and pl.id_tab = otp.id_tab(+)
                           and otp.id_otp = 22
                           and trunc(otp.dat_n, 'YEAR') >= '01.01.2008'
                         order by 1, vac_n))
         where next_vac is null
         start with prev_vac is null
        connect by prior vac = prev_vac
               and prior tab_id = tab_id) b,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_ka_plus pl
 where pl.id_po = 3
   and pl.id_tab = rbf.id_tab
   and pl.id_tab = a.tab_id(+)
   and a.vac_year(+) = 2008
   and pl.id_tab = b.tab_id(+)
   and b.vac_year(+) = 2009
 order by 2
