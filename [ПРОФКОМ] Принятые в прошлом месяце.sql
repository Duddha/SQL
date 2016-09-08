-- TAB = Принятые в прошлом месяце
-- Заказчик = Профком
-- EXCEL = Принятые в прошлом месяце (дата выборки %date%).xlsx

SELECT f2.nam_cex "Цех"
       ,rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,f2.data_work "Дата приёма"
       ,f2.full_nam_mest "Должность"
  FROM qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_rb_fio       rbf
 WHERE id_zap = 1
   AND lower(f2.nam_work) <> 'вpеменно'
   AND trunc(data_work
            ,'MONTH') = trunc(add_months(SYSDATE
                                        ,-1)
                             ,'MONTH')
   AND f2.id_tab = rbf.id_tab
 ORDER BY 1
         ,3
