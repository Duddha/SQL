--YEAR - год для выборки
--TAB=Перемещения за год
SELECT f2.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,p.nam_cex "Цех (откуда переведен)"
       ,p.full_nam_mest "Предыдущая должность"
       ,p.razr "Разряд"
       ,p.id_zap "№ предыдущей записи"
       ,f2.id_zap "№ записи"
       ,f2.nam_cex "Цех (куда переведен)"
       ,f2.full_nam_mest "Новая должность"
       ,f2.razr "Разряд"
       ,f2.DATA_WORK "Дата перемещения"
       ,p.nam_perem "Вид перемещения"
  FROM qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_kav_perem_f2 p
      ,qwerty.sp_rb_fio       rbf
 WHERE trunc(f2.data_work
            ,'YEAR') = to_date('0101' || &< NAME = "Год выборки" TYPE = "string" >
                               ,'ddmmyyyy')
   AND f2.razr <> 'УВ'
   AND f2.nam_perem <> 'Уволен'
   AND f2.id_zap > 0
   AND p.id_tab = f2.id_tab
   AND p.id_zap = f2.id_zap - 1
   AND rbf.id_tab = f2.id_tab
 ORDER BY 3
         ,8
         ,2
         ,6
