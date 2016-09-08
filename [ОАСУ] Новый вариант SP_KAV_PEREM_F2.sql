-- TAB = Новый KAV_PEREM_F2
select *
  from qwerty.sp_kav_perem_f2 --where id_tab = 5103
 order by id_tab
         ,data_work;

select id_tab
      ,id_zap
      ,data_zap
      ,decode(flag,
              3,
              lag(nam_work) over(partition by id_tab order by data_work),
              nam_work) nam_work
      ,data_work
      ,data_kon
      ,id_prikaz
      ,decode(flag,
              3,
              lag(nam_cex) over(partition by id_tab order by data_work),
              nam_cex) nam_cex
      ,decode(flag,
              3,
              lag(nam_mest) over(partition by id_tab order by data_work),
              nam_mest) nam_mest
      ,razr
      ,nam_perem
      ,decode(flag,
              3,
              lag(full_nam_mest) over(partition by id_tab order by data_work),
              full_nam_mest) full_nam_mest /*, flag*/
  from (
        
        -- перемещения
        select p.id_tab
               ,p.id_zap
               ,p.data_zap
               ,nvl(vww.name_u, ' Не определено') nam_work
               ,p.data_work
               ,p.data_kon
               ,p.id_prikaz
               ,nvl(ac.name_u, ' Не определено') nam_cex
               ,nvl(am.name_u, ' Не определено') nam_mest
               ,to_char(nvl(p.a_razr,
                            0)) razr
               ,nvl(vwp.name_u, ' Не определено') nam_perem
               ,nvl(am.full_name, ' Не определено') full_nam_mest
               ,2 flag
          from qwerty.sp_ka_perem p
               ,qwerty.sp_vid_work vww
               ,qwerty.sp_vid_work vwp
               ,qwerty.sp_arx_cex  ac
               ,qwerty.sp_arx_mest am
         where p.id_work = vww.id(+)
           and p.id_perem = vwp.id(+)
           and p.id_n_cex = ac.id(+)
           and p.id_n_mest = am.id(+)
        -- работа
        union all
        select w.id_tab
               ,w.id_zap
               ,w.data_zap
               ,nvl(vw.name_u, ' Не определено')
               ,w.data_work
               ,w.data_kon_w
               ,w.id_prikaz
               ,nvl(rbv.name_cex, ' Не определено')
               ,nvl(rbv.name_mest, ' Не определено')
               ,to_char(nvl(w.razr,
                            0))
               ,'Работает'
               ,rbv.full_name_u
               ,1
          from qwerty.sp_ka_work  w
               ,qwerty.sp_rbv_fio  rbv
               ,qwerty.sp_vid_work vw
         where w.id_tab = rbv.id_tab
           and w.id_work = vw.id(+)
        -- увольнение
        union all
        select u.id_tab
               ,u.id_zap
               ,u.data_zap
               ,nvl(null, ' Не определено')
               ,u.data_uvol
               ,null
               ,u.id_prikaz
               ,nvl(null, ' Не определено')
               ,nvl(null, ' Не определено')
               ,'УВ'
               ,nvl(vw.name_u, ' Не определено')
               ,nvl(null, ' Не определено')
               ,3
          from qwerty.sp_ka_uvol  u
               ,qwerty.sp_vid_work vw
         where u.id_uvol = vw.id(+)
         order by id_tab
                  ,data_work)
