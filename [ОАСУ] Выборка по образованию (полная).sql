SELECT id_tab
      ,REPLACE(ltrim(sys_connect_by_path(chr(10) || rn || ') ' || TRIM(education)
                                        ,';;')
                    ,';;' || chr(10))
              ,';;'
              ,';') education
      ,LEVEL num_of_eductns
  FROM (SELECT id_tab
              ,education
              ,lag(education) over(PARTITION BY id_tab ORDER BY data_ok) AS prev_eductn
              ,lead(education) over(PARTITION BY id_tab ORDER BY data_ok) AS next_eductn
              ,rn
          FROM (SELECT obr.id_tab
                      ,
                       --������ �����������
                       --�����������(!) - ��� �������� - ���� ���������(!) - ��� - �������������
                       -- ������������ - ������ - ���� ������ �������
                       ob.name_u --��� �����������: ������, �������,...  !!!������������ ����!!!
                       || decode(nvl(vo.name_u
                                    ,'')
                                ,''
                                ,''
                                ,', ' || vo.name_u) --��� �����������: �������, �������,...
                       || ', ' || to_char(obr.data_ok
                                         ,'dd.mm.yyyy') --���� ���������  !!!������������ ����!!!
                       || decode(nvl(uz.name_u
                                    ,'')
                                ,''
                                ,''
                                ,', ' || uz.name_u || decode(nvl(uz.id_syti
                                                                ,0)
                                                            ,0
                                                            ,''
                                                            ,', ' || decode(pnkt.id
                                                                           ,28
                                                                           ,''
                                                                           ,pnkt.snam_u) || c.name_u)) --������� ���������
                       || decode(nvl(spob.name_u
                                    ,'')
                                ,''
                                ,''
                                ,', ' || spob.name_u) --�������������
                       || decode(nvl(kvob.name_u
                                    ,'')
                                ,''
                                ,''
                                ,', ' || kvob.name_u) --������������
                       || decode(nvl(obr.diplom
                                    ,'')
                                ,''
                                ,''
                                ,', ������ ' || obr.diplom || decode(nvl(obr.data_dip
                                                                        ,'')
                                                                    ,''
                                                                    ,''
                                                                    ,' ����� ' || to_char(obr.data_dip
                                                                                         ,'dd.mm.yyyy'))) --������ � ���� ������ �������
                       
                       education
                      ,obr.data_ok
                      ,row_number() over(PARTITION BY id_tab ORDER BY data_ok) rn
                  FROM qwerty.sp_ka_obr obr
                      ,qwerty.sp_uchzav uz
                      ,qwerty.sp_sity   c
                      ,qwerty.sp_punkt  pnkt
                      ,qwerty.sp_vidobr vo
                      ,qwerty.sp_obr    ob
                      ,qwerty.sp_spobr  spob
                      ,qwerty.sp_kvobr  kvob
                 WHERE ob.id(+) = obr.id_obr
                   AND uz.id(+) = obr.id_uchzav
                   AND c.id(+) = uz.id_syti
                   AND pnkt.id(+) = c.id_punkt
                   AND vo.id(+) = obr.id_vidobr
                   AND spob.id(+) = obr.id_spobr
                   AND kvob.id(+) = obr.id_kvobr
                --   and obr.id_tab = &ID_TAB
                ))
 WHERE next_eductn IS NULL
 START WITH prev_eductn IS NULL
CONNECT BY PRIOR education = prev_eductn
       AND PRIOR id_tab = id_tab
