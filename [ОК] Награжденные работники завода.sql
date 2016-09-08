-- CLIENT = ����� ������, ����� �.�.
-- TAB = ������������ ��������� ������
-- RECORDS = ALL
SELECT nvl(npe.full_name_u
          ,np.name_u) "�������"
       ,row_number() over(PARTITION BY p.id_po ORDER BY p.data_po) || '. ' || rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u || ' - �.�.' || p.id_tab || ', ' || nvl(wrk.workplace, '(��� ������)') || '.' || chr(10) || lpad(' ', length(row_number() over(PARTITION BY p.id_po ORDER BY p.data_po)) + 2, ' ') || '���� ����������: ' || decode(to_char(p.data_po, 'ddmm'), '0101', decode(p.id_po, 18, to_char(p.data_po, 'dd.mm.yyyy'), to_char(p.data_po, 'yyyy') || ' ���'), to_char(p.data_po, 'dd.mm.yyyy')) || decode(nvl(p.id_prikaz, '-'), '-', '', ', ������: ' || p.id_prikaz) || decode(nvl(p.text, '-'), '-', '', ', ����������: ' || p.text) row_value
  FROM qwerty.sp_ka_plus p
      ,qwerty.sp_narpo np
      ,qwerty.sp_narpo_ext npe
      ,qwerty.sp_rb_fio rbf
      ,(SELECT id_tab
              ,ltrim(name_u || ', ' || full_name_u || decode(fl
                                                            ,2
                                                            ,' (' || remark || ')')
                    ,',  ') workplace
          FROM (SELECT wrk_temp.*
                      ,row_number() over(PARTITION BY id_tab ORDER BY fl) rn
                  FROM (SELECT w.id_tab
                              ,w.id_zap
                              ,w.data_zap
                              ,w.id_work
                              ,w.data_work
                              ,p.name_u
                              ,m.full_name_u
                              ,'��������' remark
                              ,1 fl
                          FROM qwerty.sp_ka_work w
                              ,qwerty.sp_rb_key  rbk
                              ,qwerty.sp_stat    s
                              ,qwerty.sp_podr    p
                              ,qwerty.sp_mest    m
                         WHERE w.id_tab = rbk.id_tab
                           AND rbk.id_stat = s.id_stat
                           AND s.id_cex = p.id_cex
                           AND s.id_mest = m.id_mest
                           AND w.id_work <> 61
                        UNION ALL
                        SELECT prm.id_tab
                              ,prm.id_zap
                              ,prm.data_zap
                              ,prm.id_work
                              ,prm.data_kon
                              ,TRIM(ac.name_u)
                              ,TRIM(am.name_u)
                              ,decode(osn.id_pol
                                     ,2
                                     ,'�������'
                                     ,'������')
                              ,2 fl
                          FROM qwerty.sp_ka_perem prm
                              ,qwerty.sp_ka_uvol  u
                              ,qwerty.sp_arx_cex  ac
                              ,qwerty.sp_arx_mest am
                              ,qwerty.sp_ka_osn   osn
                         WHERE prm.id_work <> 61
                           AND prm.id_tab = u.id_tab
                           AND abs(u.id_zap) = abs(prm.id_zap) + 1
                           AND u.data_uvol = prm.data_kon
                           AND prm.id_n_cex = ac.id(+)
                           AND prm.id_n_mest = am.id(+)
                           AND prm.id_tab = osn.id_tab) wrk_temp
                 ORDER BY fl)
         WHERE rn = 1) wrk
 WHERE p.id_po IN
        --NoFormat Start
                   (&< NAME = "������� ��� �������" 
                       HINT = "�������� ������� ��� �������"
                       LIST = "select id
                                     ,nvl(narpoe.full_name_u, name_u)
                                 from qwerty.sp_narpo narpo
                                     ,qwerty.sp_narpo_ext narpoe 
                                where parent_id = 1 
                                  and narpo.id = narpoe.id_narpo(+) 
                                order by 2" 
                       DESCRIPTION = "yes" 
                       MULTISELECT = "yes"
                       REQUIRED = "yes">)
        --NoFormat End
   AND p.id_po = np.id
   AND np.parent_id = 1
   AND p.id_po = npe.id_narpo(+)
   AND p.id_tab = rbf.id_tab
   AND p.id_tab = wrk.id_tab(+)
 ORDER BY 1
         ,p.data_po
