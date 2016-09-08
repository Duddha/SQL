--select distinct fio, count(*) from (
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       /*pall.dat_uvol, uv.data_uvol, */
       osn.data_r "Дата рождения", /*pall.kto, */
       --       to_char((pall.stag+nvl(pall.stag_d, 0) div 12))||' л. '||to_char((nvl(pall.stag, 0)+nvl(pall.stag_d, 0)) mod 12)||' м.' "Стаж",
       trunc((pall.stag + nvl(pall.stag_d, 0)) / 12) "Стаж, лет",
       (pall.stag + nvl(pall.stag_d, 0)) -
       trunc((pall.stag + nvl(pall.stag_d, 0)) / 12) * 12 "Стаж, месяцев",
       hr.GET_EMPLOYEE_ADDRESS_BY_FL(pall.id_tab, 1, 1, 1, 1) "Адрес",
       tel.num_tel "Телефон"
  from qwerty.sp_ka_pens_all pall,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_ka_osn osn,
       (select id_tab,
               replace(ltrim(sys_connect_by_path(trim(num_tel), ';; '),
                             ';; ' || chr(10)),
                       ';; ',
                       '; ') num_tel,
               level num_of_tel
          from (select id_tab,
                       num_tel,
                       lag(num_tel) over(partition by id_tab order by id_tab) as prev_tel,
                       lead(num_tel) over(partition by id_tab order by id_tab) as next_tel
                  from (select id_tab, num_tel
                          from qwerty.sp_ka_telef
                         where hom_wor = 2
                         order by id_tab))
         where next_tel is null
         start with prev_tel is null
        connect by prior num_tel = prev_tel
               and prior id_tab = id_tab) tel,
       (select uv.id_tab, data_uvol
          from qwerty.sp_ka_uvol uv, qwerty.sp_ka_perem p
         where uv.id_uvol in (30, 36, 69, 70, 71, 79)
           and uv.id_tab = p.id_tab
           and abs(uv.id_zap) = abs(p.id_zap) + 1
           and uv.data_uvol = p.data_kon
           and id_n_cex in
               (select id
                  from qwerty.sp_arx_cex
                 where (lower(name_u) like '%з/у%' or
                       lower(name_u) like '%упр%')
                   and id not in (105, 119, 429, 431, 75))) uv
 where pall.kto <> 7
   and pall.id_tab not in
       (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and pall.id_tab = rbf.id_tab
   and pall.id_tab = osn.id_tab(+)
   and pall.id_tab = tel.id_tab(+)
   and pall.id_tab = uv.id_tab
--) group by fio
order by 1
