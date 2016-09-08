-- CLIENT = ������� �.�.
-- TAB = ��������� ������������ ��������� ���������� ����
WITH edctn AS
 (SELECT id_tab
         -- ���� ���� �����������, ����� "1)" �� ������������
        ,decode(LEVEL
               ,1
               ,ltrim(REPLACE(ltrim(sys_connect_by_path(chr(10) || rn || ') ' || TRIM(education)
                                                       ,';;')
                                   ,';;' || chr(10))
                             ,';;'
                             ,';')
                     ,'1) ')
               ,REPLACE(ltrim(sys_connect_by_path(chr(10) || rn || ') ' || TRIM(education)
                                                 ,';;')
                             ,';;' || chr(10))
                       ,';;'
                       ,';')) education
        ,ed_type
        ,LEVEL num_of_eductns
    FROM (SELECT id_tab
                ,education
                ,lag(education) over(PARTITION BY id_tab ORDER BY data_ok) AS prev_eductn
                ,lead(education) over(PARTITION BY id_tab ORDER BY data_ok) AS next_eductn
                ,MAX(ed_type) over(PARTITION BY id_tab) ed_type
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
                                           ,'dd.mm.yyyy') --���� ���������  !!!������������ ����!!!J
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
                        ,obr.id_obr
                        ,decode(obr.id_obr
                               ,6
                               ,1
                               ,decode(ob.parent_id
                                      ,6
                                      ,1
                                      ,0)) ed_type
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
                     AND kvob.id(+) = obr.id_kvobr))
   WHERE next_eductn IS NULL
   START WITH prev_eductn IS NULL
  CONNECT BY PRIOR education = prev_eductn
         AND PRIOR id_tab = id_tab)

SELECT p.name_u "���"
       ,k.name_u "���������"
       ,rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,qwerty.hr.GET_EMPLOYEE_AGE(rbf.id_tab) "�������"
       ,m.full_name_u "���������"
       ,qwerty.hr.GET_EMPLOYEE_STAG(rbf.id_tab) "����"
       ,e.education "�����������"
  FROM qwerty.sp_stat s
      ,qwerty.sp_mest m
      ,qwerty.sp_podr p
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_kat k
      ,(SELECT * FROM edctn) e
 WHERE s.id_cex = &< NAME = "���" hint = "�������� ���" list = "select id_cex, name_u from qwerty.sp_podr order by id_cex" description = "yes" >
   AND s.id_kat IN (&< NAME = "���������" hint = "��������� ��� �������" list = "select id_kat, name_u from qwerty.sp_kat order by 1" multiselect = "yes" description = "yes" >)
   AND s.id_mest = m.id_mest
   AND s.id_cex = p.id_cex
   AND s.id_stat = rbk.id_stat
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = e.id_tab
   AND s.id_kat = k.id_kat
 ORDER BY 1
         ,2
         ,6
         ,qwerty.hr.GET_EMPLOYEE_AGE_MONTHS(rbk.id_tab) DESC
