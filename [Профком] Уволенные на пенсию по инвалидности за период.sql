-- TAB = Уволенные на пенсию по инвалидности за период
-- EXCEL = Уволенные на пенсию по инвалидности за период
SELECT u.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,to_char(u.data_uvol
              ,'dd.mm.yyyy') "Дата увольнения"
       ,vw.name_u "Вид увольнения"
       ,ac.name_u "Цех"
       ,am.full_name "Должность"
  FROM qwerty.sp_ka_uvol  u
      ,qwerty.sp_vid_work vw
      ,qwerty.sp_rb_fio   rbf
      ,qwerty.sp_ka_perem p
      ,qwerty.sp_arx_cex  ac
      ,qwerty.sp_arx_mest am
 WHERE u.id_uvol IN (69 -- на пенсию по инвалидности 1 гр.
                    ,70 -- на пенсию по инвалидности 2 гр.
                    ,71 -- на пенсию по инвалидности 3 гр.
                    ,36 -- на пенсию по инвалидности
                     )
   AND u.data_uvol BETWEEN to_date(&< NAME = "Начало периода" TYPE = "string" hint = "Дата в формате ДД.ММ.ГГГГ" >
                                   ,'dd.mm.yyyy') AND to_date(&< NAME = "Конец периода" TYPE = "string" hint = "Дата в формате ДД.ММ.ГГГГ" >
                                                              ,'dd.mm.yyyy')
   AND u.id_uvol = vw.id
   AND u.id_tab = rbf.id_tab
   AND (u.id_tab = p.id_tab AND u.data_uvol = p.data_kon AND abs(u.id_zap) = abs(p.id_zap) + 1)
   AND p.id_n_cex = ac.id
   AND p.id_n_mest = am.id
 ORDER BY 2
