--select stag, count(*) from (
select tt.id_tab,
       case
         when stag >= 300 then
          'более 25'
         when (stag >= 180 and stag < 300) then
          'от 15 до 25'
       end stag
  from (select pall.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               pall.dat_uvol,
               nvl(pall.stag, 0) + nvl(pall.stag_d, 0) stag,
               pall.kto
          from qwerty.sp_ka_pens_all pall, qwerty.sp_rb_fio rbf
         where pall.kto in (0, 1)
           and pall.dat_uvol <= to_date('01.02.2011', 'dd.mm.yyyy')
           and pall.id_tab = rbf.id_tab
           and not
                (pall.id_tab in
                (select id_tab from qwerty.sp_ka_lost where lost_type = 1))) tt
 where tt.stag >= 180
--) group by stag 
