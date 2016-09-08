-- Для Плюты А.И., 08.01.2016
--  Выборка по должности
-- TAB = По штату
SELECT DISTINCT s.id_cex "Код цеха"
                ,p.name_u "Цех"
                ,m.full_name_u "Должность"
                ,s.razr "Разряд"
                ,s.oklad "Оклад"
                ,s.koli "Кол-во по штату"
                /*,s.id_stat "Код РМ"
                ,s.koli "Кол-во по штату"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "Кол-во по факту"
                ,s.oklad "Оклад"*/
  FROM /*qwerty.sp_rb_key rbk
      ,*/qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE/* rbk.id_stat = s.id_stat
   AND */s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND m.id_mest IN (&< name = "Выбираемые должности" hint = "Определите должности для выборки"
                        list = "select distinct id_mest, full_name_u 
                                  from qwerty.sp_mest 
                                 where id_mest in (select id_mest 
                                                     from qwerty.sp_stat 
                                                    where id_stat in (select id_stat 
                                                                        from qwerty.sp_rb_key)) 
                                   and lower(full_name_u) like lower('%слес%ремон%') order by 2" 
                        description = "yes" 
                        multiselect = "yes" >)
    AND s.koli <> 0                        
 ORDER BY s.id_cex, m.full_name_u, s.oklad;
--TAB = По факту
SELECT DISTINCT s.id_cex "Код цеха"
                ,p.name_u "Цех"
                ,m.full_name_u "Должность"
                ,s.id_stat "Код РМ"
                ,rbf.fam_u || ' '|| rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
                ,w.razr "Разряд"
                ,sw.oklad "Оклад"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "Кол-во по факту"
                /*,s.oklad "Оклад"
                ,s.koli "Кол-во по штату"*/
                /*,s.id_stat "Код РМ"
                ,s.koli "Кол-во по штату"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_stat) "Кол-во по факту"
                ,s.oklad "Оклад"*/
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_work w
      ,qwerty.sp_zar_swork sw
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND m.id_mest IN (&< name = "Выбираемые должности" >)
   --AND m.id_mest IN (567,2774,1320,827,3699,2240,1334,1319,6590,7273,2855,5291,6591,8135,605)
    --AND s.koli <> 0                        
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = w.id_tab
   AND rbk.id_tab = sw.id_tab
 ORDER BY 1, 3, 4, 5
