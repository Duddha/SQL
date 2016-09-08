-- TAB = Уволенные на пенсию за год
-- EXCEL = Уволенные на пенсию за год
--       таб. №
--       Ф.И.О.
--       идентификационный код
--       стаж
--       цех
--       домашний адрес
SELECT uv.id_tab "Таб.№"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,nvl(osnn.id_nalog
          ,osn.id_nalog) "Идентификационный код"
       ,qwerty.hr.STAG_TO_CHAR(nvl(pens.stag
                                 ,0) + nvl(pens.stag_d
                                          ,0)) "Стаж"
       --,qwerty.hr.GET_EMPLOYEE_STAG(uv.id_tab) stag2
       ,pdr.name_u "Цех"
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(uv.id_tab
                                           ,1
                                           ,1
                                           ,1) "Адрес"
       ,vw.name_u "Вид увольнения"
       ,uv.data_uvol "Дата увольнения"
  FROM qwerty.sp_ka_uvol      uv
      ,qwerty.sp_rb_fio       rbf
      ,qwerty.sp_ka_perem     p
      ,qwerty.sp_podr         pdr
      ,qwerty.sp_ka_osn       osn
      ,qwerty.sp_ka_osn_nalog osnn
      ,qwerty.sp_ka_pens_all  pens
      ,qwerty.sp_vid_work     vw
 WHERE uv.id_uvol IN (30
                     ,36
                     ,69
                     ,70
                     ,71
                     ,79)
   AND trunc(uv.data_uvol
            ,'YEAR') = '01.01.&<name="Год выхода на пенсию">'
   AND rbf.id_tab = uv.id_tab
   AND p.id_tab = uv.id_tab
   AND p.id_zap = uv.id_zap + (-1 * sign(uv.id_zap))
   AND p.data_kon = uv.data_uvol
   AND pdr.id_cex = p.id_a_cex
   AND uv.id_tab = osn.id_tab(+)
   AND uv.id_tab = osnn.id_tab(+)
   AND uv.id_tab = pens.id_tab
   AND uv.id_uvol = vw.id
 ORDER BY "Ф.И.О."
