-- TAB = Список работников отдела АСУ (с датой приёма на завод)
-- EXCEL = Список работников отдела АСУ с датой приёма на завод (дата выборки %date%).xls

SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,f2.DATA_WORK "Дата приёма"
  FROM qwerty.sp_rb_fio       rbf
      ,qwerty.sp_kav_perem_f2 f2
 WHERE rbf.id_tab IN (SELECT id_tab FROM qwerty.sp_rb_key WHERE id_stat IN (SELECT id_stat FROM qwerty.sp_stat WHERE id_cex = 5500))
   AND rbf.id_tab = f2.id_tab
   AND f2.id_zap = 1
 ORDER BY 2
