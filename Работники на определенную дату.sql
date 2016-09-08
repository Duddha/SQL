select *
  from (select fl,
               id_tab,
               id_zap,
               data_zap,
               id_work,
               data_work,
               data_kon,
               nvl2(data_kon,
                    data_kon,
                    decode(fl,
                           3,
                           to_date(null),
                           lead(data_work)
                           over(partition by id_tab order by data_work))) data_kon2
          from (select 1 fl,
                       id_tab,
                       id_zap,
                       data_zap,
                       id_work,
                       data_work,
                       --nvl(data_kon_w, sysdate + 1) data_kon --Данный вариант не подошел, потому что в SP_KA_WORK есть работники с установленной DATA_KON_W
                       sysdate + 1 data_kon --Если выборка берется на будущую дату то здесь дата должна быть не меньше даты выборки
                  from qwerty.sp_ka_work
                union all
                select 2,
                       id_tab,
                       id_zap,
                       data_zap,
                       id_work,
                       data_work,
                       data_kon
                  from qwerty.sp_ka_perem
                union all
                select 3, id_tab, id_zap, data_zap, id_uvol, data_uvol, null
                  from qwerty.sp_ka_uvol)
        --where id_tab=1456
         order by id_tab, data_work)
 where to_date('&DATE', 'dd.mm.yyyy') between data_work and data_kon2
