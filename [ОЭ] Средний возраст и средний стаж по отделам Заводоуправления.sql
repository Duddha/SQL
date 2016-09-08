SELECT /*id_bri "��� ������"
       ,*/
 name_u "�������� ������"
 ,qwerty.hr.STAG_TO_CHAR(AVG(age_months)) "������� �������"
 ,qwerty.hr.STAG_TO_CHAR(AVG(stag_months)) "������� ���� �� ������"
 ,count(id_tab) "���������� ����������"
  FROM (
        
        SELECT s.id_cex
               ,sw.id_bri
               ,p.name_u
               ,rbk.id_tab
               ,osn.data_r
               ,months_between(SYSDATE,
                               osn.data_r) age_months
               ,qwerty.hr.GET_EMPLOYEE_STAG_MONTHS(rbk.id_tab) stag_months
          FROM qwerty.sp_rb_key    rbk
               ,qwerty.sp_stat      s
               ,qwerty.sp_zar_swork sw
               ,qwerty.sp_podr      p
               ,qwerty.sp_ka_osn    osn
         WHERE s.id_cex = 1000
           AND s.id_stat = rbk.id_stat
           AND rbk.id_tab = sw.id_tab
           AND sw.id_bri = p.id_cex
           AND osn.id_tab = rbk.id_tab
        
        )
 GROUP BY ROLLUP(name_u)
