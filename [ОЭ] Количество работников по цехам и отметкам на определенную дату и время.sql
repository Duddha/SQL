select a.dept_id, a.otm, a.kolvo, p.name_u, ot.*
  from (select id_cex dept_id, otm, count(*) kolvo
          from qwerty.sp_zar_tabel_e02_arx
         where data = to_date(&< name = "Дата выборки" hint = "Дата в формате ДД.ММ.ГГГГ" type = "string">, 'dd.mm.yyyy')
           and otm in (select trim(id_otmetka)
                         from qwerty.sp_zar_ot_prop
                        where t_begin <= '1200'
                          and t_end >= '1200')
         group by id_cex, otm) a,
       qwerty.sp_podr p,
       qwerty.sp_zar_ot_prop ot
 where p.id_cex = a.dept_id
   and trim(ot.id_otmetka(+)) = a.otm
 order by dept_id, otm
