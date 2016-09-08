-- TAB = Ветераны завода и порта по цеху
-- RECORDS = ALL

SELECT rbf.id_tab "Таб. №"
      ,fam_u || ' ' || f_name_u || ' ' || s_name_u "Ф.И.О."
      ,np.name_u "Звание"
      ,plus.data_po "Дата присвоения"
      ,plus.id_prikaz "Приказ"
  FROM qwerty.sp_rb_fio  rbf
      ,qwerty.sp_rb_key  rbk
      ,qwerty.sp_stat    s
      ,qwerty.sp_ka_plus plus
      ,qwerty.sp_narpo   np
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND rbf.id_tab = plus.id_tab
   AND s.id_cex = &< name = "Цех" 
                     type = "integer" 
                     list = "select id_cex, name_u from QWERTY.SP_PODR t
                              where substr(type_mask, 3, 1) <> '0'
                                and nvl(parent_id, 0) <> 0
                              order by 2" 
                     description = "yes">
   AND plus.id_po IN (3
                     ,18)
   AND plus.id_po = np.id
 ORDER BY 2   
