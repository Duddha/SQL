-- TAB = Работники ЗУ по отделам
-- Excel = Работники ЗУ по отделам (дата выборки %date%).xls

-- Примечание:
--   Диспетчера завода относятся к Производственно-техническому отделу
SELECT row_number() over(PARTITION BY s.id_cex ORDER BY s.id_cex, mvz.name, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "№ п/п по цеху"
       ,row_number() over(PARTITION BY s.id_cex, decode(s.id_mvz, 102900091, 101500092, s.id_mvz) ORDER BY id_mvz, rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u) "№ п/п по отделу"
       ,p.name_u "Цех"
       ,mvz.name "Отдел"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,decode(s.id_mvz
             ,102900091
             ,101500092
             ,s.id_mvz) "Код МВЗ"
  FROM qwerty.sp_rb_key      rbk
      ,qwerty.sp_stat        s
      ,qwerty.sp_zar_sap_mvz mvz
      ,qwerty.sp_rb_fio      rbf
      ,qwerty.sp_podr        p
 WHERE s.id_cex = 1000
   AND s.id_stat = rbk.id_stat
   AND decode(s.id_mvz
             ,102900091
             ,101500092
             ,s.id_mvz) = mvz.id
   AND rbk.id_tab = rbf.id_tab
   AND s.id_cex = p.id_cex
 ORDER BY 3
         ,4
         ,5
