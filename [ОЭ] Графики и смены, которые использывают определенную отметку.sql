SELECT mark_id
      ,schedule_id
      ,schedule_name
      ,schedule_name || ' (����' || decode(LEVEL
                                          ,1
                                          ,'� '
                                          ,'� ') || ltrim(sys_connect_by_path(shift_id
                                                                             ,', ')
                                                         ,', ') || ')' shifts
  FROM (SELECT tbls.id_otmetka mark_id
              ,tbls.id_smen shift_id
              ,ss.name_u shift_name
              ,ss.tip_smen schedule_id
              ,ts.name_u schedule_name
              ,lag(ss.id_smen) over(PARTITION BY ss.tip_smen ORDER BY ss.id_smen) prev_shift_id
              ,lead(ss.id_smen) over(PARTITION BY ss.tip_smen ORDER BY ss.id_smen) next_shift_id
          FROM qwerty.sp_zar_tabl_smen tbls
              ,qwerty.sp_zar_s_smen    ss
              ,qwerty.sp_zar_t_smen    ts
         WHERE tbls.id_otmetka = &<NAME="ID_OTMETKA" TYPE="string">
           AND tbls.id_smen = ss.id_smen
           AND ss.tip_smen = ts.tip_smen
        UNION ALL
        SELECT id_otmetka
              ,'-'
              ,'��� ' || tip
              ,-1
              ,'������� ������: ' || opis
              ,NULL
              ,NULL
          FROM qwerty.sp_zar_otne_prop
         WHERE id_otmetka = &ID_OTMETKA)
 WHERE next_shift_id IS NULL
CONNECT BY PRIOR schedule_id = schedule_id
       AND PRIOR shift_id = prev_shift_id
 START WITH prev_shift_id IS NULL
