-- TAB = Средний стаж работы по категориям
SELECT id_kat
      ,name_u
      ,qwerty.hr.STAG_TO_CHAR(stg)
  FROM (SELECT DISTINCT k.id_kat
                       ,k.name_u
                       /*,osn.id_pol, rbk.id_tab, */
                       ,AVG(qwerty.hr.GET_EMPLOYEE_STAG_MONTHS(rbk.id_tab)) over(PARTITION BY s.id_kat) stg
          FROM qwerty.sp_stat   s
              ,qwerty.sp_rb_key rbk
              ,qwerty.sp_ka_osn osn
              ,qwerty.sp_kat    k
         WHERE s.id_stat = rbk.id_stat
           AND rbk.id_tab = osn.id_tab
           AND s.id_kat = k.id_kat)
