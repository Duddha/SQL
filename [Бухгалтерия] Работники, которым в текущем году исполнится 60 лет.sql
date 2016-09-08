SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       --,osn.data_r
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "���� ��������"
       ,qwerty.hr.GET_EMPLOYEE_STAG(rbf.id_tab) "���� �� ���� �������"
       ,sw.oklad "�����"
  FROM qwerty.sp_rb_fio    rbf
      ,qwerty.sp_ka_osn    osn
      ,qwerty.sp_rb_key    rbk
      ,qwerty.sp_zar_swork sw
 WHERE rbf.id_tab = rbk.id_tab
   AND not(rbk.id_stat in (6108, 18251))
   AND rbf.id_tab = osn.id_tab
   AND trunc(osn.data_r
            ,'YEAR') = to_date('01.01.' || to_char(to_number(to_char(SYSDATE, 'yyyy')) - &< NAME = "�������" TYPE = "integer" DEFAULT = 60 >)
                               ,'dd.mm.yyyy')
   AND rbf.id_tab = sw.id_tab
 ORDER BY 2
