SELECT DISTINCT s.id_kat
               ,k.name_u
               ,COUNT(*) over(PARTITION BY s.id_kat) "�����"
                --,osn.id_pol
                ,SUM(decode(osn.id_pol
                          ,1
                          ,1
                          ,0)) over(PARTITION BY s.id_kat) "������"
                ,round(SUM(decode(osn.id_pol
                                ,1
                                ,1
                                ,0)) over(PARTITION BY s.id_kat) / COUNT(*) over(PARTITION BY s.id_kat) * 100
                     ,2) "% ������"
                ,SUM(decode(osn.id_pol
                          ,2
                          ,1
                          ,0)) over(PARTITION BY s.id_kat) "������"
                ,round(SUM(decode(osn.id_pol
                                ,2
                                ,1
                                ,0)) over(PARTITION BY s.id_kat) / COUNT(*) over(PARTITION BY s.id_kat) * 100
                     ,2) "% ������"
--,round(COUNT(*) over(PARTITION BY s.id_kat, id_pol) / COUNT(*) over(PARTITION BY s.id_kat) * 100, 2) "%"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_kat    k
 WHERE /*s.id_kat = 1
   AND */
 s.id_stat = rbk.id_stat
 AND rbk.id_tab = osn.id_tab
 AND s.id_kat = k.id_kat
