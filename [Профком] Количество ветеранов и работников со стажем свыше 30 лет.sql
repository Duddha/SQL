-- EXCEL = Количество ветеранов и работников со стажем свыше 30 лет
-- TAB = Количество ветеранов труда завода/порта, заслуженных работников ОПЗ
SELECT vet_name
      ,COUNT(id_tab)
  FROM (SELECT rbk.id_tab
              ,pl.id_po
              ,vet_name
          FROM qwerty.sp_rb_key rbk
              ,qwerty.sp_stat s
              ,(SELECT id_tab
                      ,id_po
                      ,np.name_u vet_name
                  FROM qwerty.sp_ka_plus
                      ,qwerty.sp_narpo np
                 WHERE id_po IN (3
                                ,7
                                ,11
                                ,12
                                ,14
                                ,18)
                   AND id_po = np.id) pl
         WHERE rbk.id_stat = s.id_stat
           AND rbk.id_stat NOT IN (6108
                                  ,18251)
           AND rbk.id_tab = pl.id_tab(+))
 GROUP BY vet_name;
-- TAB = Количество работников со стажем >= 30 лет
SELECT COUNT(DISTINCT id_tab)
  FROM (SELECT rbk.id_tab
              ,qwerty.hr.GET_EMPLOYEE_STAG_MONTHS(rbk.id_tab) sta_months
          FROM qwerty.sp_rb_key rbk
              ,qwerty.sp_stat   s
         WHERE rbk.id_stat = s.id_stat
           AND rbk.id_stat NOT IN (6108
                                  ,18251))
 WHERE sta_months >= 360
