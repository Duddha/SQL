-- Для Волошина
-- 2015.06.02
--
-- По ремонтному цеху
-- 1. Список работников:
--    - Ф.И.О.
--    - должность
--    - дата рождения
--
-- 2. Список уволенных за последние 3 года (с июня 2012-го)
--    - Ф.И.О.
--    - должность
--    - дата рождения
--    - дата увольнения
--    - вид увольнения (?)

-- TAB = Работники цеха
SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,m.full_name_u "Должность"
       ,to_char(nvl(osn.data_r
                  ,SYSDATE)
              ,'dd.mm.yyyy') "Дата рождения"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_mest   m
 WHERE s.id_cex = &< NAME = "Цех" list = "select id_cex, name_u 
                                            from qwerty.sp_podr 
                                           where substr(type_mask, 3, 1) <> '0' 
                                             and nvl(parent_id, 0) <> 0 
                                           order by 2" description = "yes" >
   AND s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = osn.id_tab
   AND s.id_mest = m.id_mest
 ORDER BY 2;

-- TAB = Уволенные работники цеха с определенной даты
SELECT u.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,am.full_name "Должность"
       ,to_char(nvl(osn.data_r
                  ,SYSDATE)
              ,'dd.mm.yyyy') "Дата рождения"
       ,u.data_uvol "Дата увольнения"
       ,vw.name_u "Вид увольнения"
  FROM qwerty.sp_ka_uvol  u
      ,qwerty.sp_ka_perem p
      ,qwerty.sp_arx_mest am
      ,qwerty.sp_rb_fio   rbf
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_vid_work vw
 WHERE data_uvol >= to_date('01.06.2012'
                           ,'dd.mm.yyyy')
   AND u.id_tab = p.id_tab
   AND u.data_uvol = p.data_kon
   AND abs(u.id_zap) = abs(p.id_zap) + 1
   AND p.id_a_cex = &< NAME = "Цех" >
   AND p.id_n_mest = am.id
   AND u.id_tab = rbf.id_tab
   AND u.id_tab = osn.id_tab
   AND u.id_uvol = vw.id
 ORDER BY 2
