--��� ������� - ��� �������
--
--�� ���������� ����� � ������ �� ����� ���� 
--TAB=��������� (����� � ������)
SELECT decode(GROUPING(KAT_NAME)
             ,1
             ,'�����:'
             ,KAT_NAME) "���������"
       ,SUM(1) "�����"
       ,SUM(FEMALE) "������"
  FROM (SELECT rbf.id_tab ID_TAB
              ,kat.name_u KAT_NAME
              ,decode(osn.id_pol
                     ,2
                     ,1
                     ,0) FEMALE
          FROM qwerty.sp_rb_fio rbf
              ,qwerty.sp_rb_key rbk
              ,qwerty.sp_stat   st
              ,qwerty.sp_kat    kat
              ,qwerty.sp_ka_osn osn
         WHERE rbf.id_tab IN (SELECT id_tab
                                FROM qwerty.sp_ka_work
                              UNION ALL
                              SELECT id_tab
                                FROM qwerty.sp_ka_uvol
                               WHERE data_uvol > to_date('31.12.&<name="��� �������" hint=YEAR default="select to_char(sysdate, ' yyyy ') from dual">'
                                                        ,'dd.mm.yyyy')
                              MINUS
                              SELECT id_tab
                                FROM qwerty.sp_ka_work
                               WHERE id_zap = 1
                                 AND data_work > to_date('31.12.&"��� �������"'
                                                        ,'dd.mm.yyyy'))
           AND rbk.id_tab = rbf.id_tab
           AND st.id_stat = rbk.id_stat
           AND kat.id_kat = st.id_kat
           AND osn.id_tab = rbf.id_tab
        UNION ALL
        SELECT dd.id_tab
              ,ak.name_u
              ,decode(osn.id_pol
                     ,2
                     ,1
                     ,0) female
          FROM (SELECT id_tab
                      ,id_zap
                  FROM qwerty.sp_ka_uvol
                 WHERE data_uvol > to_date('31.12.&"��� �������"'
                                          ,'dd.mm.yyyy')) dd
              ,qwerty.sp_ka_perem p
              ,qwerty.sp_arx_kat ak
              ,qwerty.sp_ka_osn osn
         WHERE p.id_tab = dd.id_tab
           AND p.id_zap = dd.id_zap - 1
           AND ak.id = p.id_n_kat
           AND osn.id_tab = dd.id_tab)
 GROUP BY ROLLUP(KAT_NAME);
--�� ���������� ���������� (15-34, 15-24, 50-54, 55-50) ����� � ������. 
--   8-�� ������ 2013 ���� ��������� ��������� 15-35 � 51-55
--   ������ 2015: ��������� ��������� 18-35
--TAB=�� ���������� ���������� (����� � ������)
--
/*
1. �� 15 �� 24 ���
2. �� 15 �� 34 ���
3. �� 15 �� 35 ���
4. �� 18 �� 35 ���
5. �� 50 �� 54 ���
6. �� 51 �� 55 ���
7. �� 55 �� 59 ���
*/
WITH by_age AS
 (SELECT sub_query.*
        , decode(sign((age + 1 - 15) * (age - 1 - 24))
                ,-1
                ,1
                ,0) * power(10
                           ,1 - 1) + decode(sign((age + 1 - 15) * (age - 1 - 34))
                                           ,-1
                                           ,1
                                           ,0) * power(10
                                                                                 ,2 - 1) +
          decode(sign((age + 1 - 15) * (age - 1 - 35))
                ,-1
                ,1
                ,0) * power(10
                           ,3 - 1) + decode(sign((age + 1 - 18) * (age - 1 - 35))
                                           ,-1
                                           ,1
                                           ,0) * power(10
                                                                                 ,4 - 1) +
          decode(sign((age + 1 - 50) * (age - 1 - 54))
                ,-1
                ,1
                ,0) * power(10
                           ,5 - 1) + decode(sign((age + 1 - 51) * (age - 1 - 55))
                                           ,-1
                                           ,1
                                           ,0) * power(10
                                                                                 ,6 - 1) +
          decode(sign((age + 1 - 55) * (age - 1 - 59))
                ,-1
                ,1
                ,0) * power(10
                           ,7 - 1) -- ����� ���������
         /*+ decode(sign((age + 1 - [������_������_���������]) * (age - 1 - [�������_������_���������]))
         ,-1
         ,1
         ,0) * power(10
                    ,[�����_���������] - 1)*/ age_cat
    FROM (SELECT osn.id_tab
                ,osn.id_pol
                ,trunc(months_between(to_date('31.12.&"��� �������"'
                                             ,'dd.mm.yyyy')
                                     ,osn.data_r) / 12) age
            FROM qwerty.sp_ka_osn osn
           WHERE osn.id_tab IN (SELECT id_tab
                                  FROM (SELECT id_tab
                                              ,id_zap
                                          FROM qwerty.sp_ka_work
                                        MINUS
                                        SELECT id_tab
                                              ,id_zap
                                          FROM qwerty.sp_ka_work
                                         WHERE data_work > to_date('31.12.&"��� �������"'
                                                                  ,'dd.mm.yyyy')
                                           AND id_zap = 1
                                        UNION ALL
                                        SELECT id_tab
                                              ,id_zap - 1
                                          FROM qwerty.sp_ka_uvol
                                         WHERE data_uvol > to_date('31.12.&"��� �������"'
                                                                  ,'dd.mm.yyyy')))
          
          ) sub_query)

SELECT DISTINCT '�� 15 �� 24 ���' "���������� ���������"
                ,SUM(MOD(age_cat / power(10
                                       ,1 - 1)
                       ,10)) over() "�����"
                ,SUM(MOD(age_cat / power(10
                                       ,1 - 1)
                       ,10) * (id_pol - 1)) over() "�� ��� ������"
  FROM by_age
UNION ALL
SELECT DISTINCT '�� 15 �� 34 ���'
               ,SUM(MOD(floor(age_cat / power(10
                                              ,2 - 1))
                        ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                              ,2 - 1))
                        ,10) * (id_pol - 1)) over()
  FROM by_age
UNION ALL
SELECT DISTINCT '�� 15 �� 35 ���'
               ,SUM(MOD(floor(age_cat / power(10
                                               ,3 - 1))
                         ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                               ,3 - 1))
                         ,10) * (id_pol - 1)) over()
  FROM by_age
UNION ALL
SELECT DISTINCT '�� 18 �� 35 ���'
               ,SUM(MOD(floor(age_cat / power(10
                                                ,4 - 1))
                          ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                                ,4 - 1))
                          ,10) * (id_pol - 1)) over()
  FROM by_age
UNION ALL
SELECT DISTINCT '�� 50 �� 54 ���'
               ,SUM(MOD(floor(age_cat / power(10
                                                 ,5 - 1))
                           ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                                 ,5 - 1))
                           ,10) * (id_pol - 1)) over()
  FROM by_age
UNION ALL
SELECT DISTINCT '�� 51 �� 55 ���'
               ,SUM(MOD(floor(age_cat / power(10
                                                  ,6 - 1))
                            ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                                  ,6 - 1))
                            ,10) * (id_pol - 1)) over()
  FROM by_age
UNION ALL
SELECT DISTINCT '�� 55 �� 59 ���'
               ,SUM(MOD(floor(age_cat / power(10
                                                   ,7 - 1))
                             ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                                   ,7 - 1))
                             ,10) * (id_pol - 1)) over()
  FROM by_age
-- ����� ���������
/*UNION ALL
SELECT DISTINCT '�� [������_������_���������] �� [�������_������_���������] ���'
               ,SUM(MOD(floor(age_cat / power(10
                                                   ,[�����_���������] - 1))
                             ,10)) over()
               ,SUM(MOD(floor(age_cat / power(10
                                                   ,[�����_���������] - 1))
                             ,10) * (id_pol - 1)) over()
  FROM by_age*/
;
--�� ����� �����, ������, ��������� � ������������� �� ����� ����
--TAB=�� ����� (�����, ���., ����., ����.)
SELECT decode(GROUPING(DEPT_NAME)
             ,1
             ,'�����:'
             ,DEPT_NAME) "�������������"
       ,SUM(1) "�����"
       ,SUM(FEMALE) "������"
       ,SUM(VREM) "���������"
       ,SUM(SOVM) "�������������"
  FROM (SELECT rbf.id_tab ID_TAB
              ,pdr.name_u DEPT_NAME
              ,decode(osn.id_pol
                     ,2
                     ,1
                     ,0) FEMALE
              ,decode(w.id_work
                     ,61
                     ,1
                     ,0) VREM
              ,decode(w.id_work
                     ,62
                     ,1
                     ,0) SOVM
          FROM qwerty.sp_rb_fio  rbf
              ,qwerty.sp_rb_key  rbk
              ,qwerty.sp_stat    st
              ,qwerty.sp_podr    pdr
              ,qwerty.sp_ka_osn  osn
              ,qwerty.sp_ka_work w
         WHERE rbf.id_tab IN (SELECT id_tab
                                FROM qwerty.sp_ka_work
                              UNION ALL
                              SELECT id_tab
                                FROM qwerty.sp_ka_uvol
                               WHERE data_uvol > to_date('31.12.&"��� �������"'
                                                        ,'dd.mm.yyyy')
                              MINUS
                              SELECT id_tab
                                FROM qwerty.sp_ka_work
                               WHERE id_zap = 1
                                 AND data_work > to_date('31.12.&"��� �������"'
                                                        ,'dd.mm.yyyy'))
           AND rbk.id_tab = rbf.id_tab
           AND st.id_stat = rbk.id_stat
           AND pdr.id_cex = st.id_cex
           AND osn.id_tab = rbf.id_tab
           AND w.id_tab = rbf.id_tab
        UNION ALL
        SELECT dd.id_tab
              ,ac.name_u
              ,decode(osn.id_pol
                     ,2
                     ,1
                     ,0) female
              ,decode(p.id_work
                     ,61
                     ,1
                     ,0) VREM
              ,decode(p.id_work
                     ,62
                     ,1
                     ,0) SOVM
          FROM (SELECT id_tab
                      ,id_zap
                  FROM qwerty.sp_ka_uvol
                 WHERE data_uvol > to_date('31.12.&"��� �������"'
                                          ,'dd.mm.yyyy')) dd
              ,qwerty.sp_ka_perem p
              ,qwerty.sp_arx_cex ac
              ,qwerty.sp_ka_osn osn
         WHERE p.id_tab = dd.id_tab
           AND p.id_zap = dd.id_zap - 1
           AND ac.id = p.id_n_cex
           AND osn.id_tab = dd.id_tab)
 GROUP BY ROLLUP(DEPT_NAME);
--����������� �� ����������
--TAB=����������� �� ����������
SELECT decode(GROUPING(OBR_NAME)
             ,1
             ,'�����:'
             ,OBR_NAME) "�����������"
       ,SUM(1) "�����"
       ,SUM(FEMALE) "������"
       ,SUM(RUK) "������������"
       ,SUM(PROF) "�������������"
       ,SUM(SPEC) "�����������"
       ,SUM(RAB_SF_TBU) "��������� ����� �������� � ���"
       ,SUM(KV_RAB_SX) "����������������� ��������� ��"
       ,SUM(KV_RAB_S_INST) "����������������� ��������� ��"
       ,SUM(OPER) "��������� � �������� ���������"
       ,SUM(TEX_SL) "����������� ��������"
       ,SUM(PROST) "���������� ���������"
  FROM (SELECT rbf.id_tab ID_TAB
              ,obr.name_u OBR_NAME
              ,decode(osn.id_pol
                     ,2
                     ,1
                     ,0) FEMALE
              ,decode(kat.id_kat
                     ,1
                     ,1
                     ,0) RUK
              ,decode(kat.id_kat
                     ,2
                     ,1
                     ,0) PROF
              ,decode(kat.id_kat
                     ,3
                     ,1
                     ,0) SPEC
              ,decode(kat.id_kat
                     ,4
                     ,1
                     ,0) TEX_SL
              ,decode(kat.id_kat
                     ,5
                     ,1
                     ,0) RAB_SF_TBU
              ,decode(kat.id_kat
                     ,6
                     ,1
                     ,0) KV_RAB_SX
              ,decode(kat.id_kat
                     ,7
                     ,1
                     ,0) KV_RAB_S_INST
              ,decode(kat.id_kat
                     ,8
                     ,1
                     ,0) OPER
              ,decode(kat.id_kat
                     ,9
                     ,1
                     ,0) PROST
          FROM qwerty.sp_rb_fio rbf
              ,qwerty.sp_rb_key rbk
              ,qwerty.sp_stat st
              ,qwerty.sp_kat kat
              ,qwerty.sp_ka_osn osn
              ,(SELECT id_tab
                      ,id_obr
                  FROM qwerty.sp_ka_obr o1
                 WHERE data_ok = (SELECT MAX(data_ok) FROM qwerty.sp_ka_obr WHERE id_tab = o1.id_tab)) kobr
              ,(SELECT id
                      ,decode(id
                             ,14
                             ,id
                             ,decode(parent_id
                                    ,0
                                    ,id
                                    ,parent_id)) par_id
                  FROM qwerty.sp_obr) obr2
              ,qwerty.sp_obr obr
         WHERE rbf.id_tab IN (SELECT id_tab
                                FROM qwerty.sp_ka_work
                              UNION ALL
                              SELECT id_tab
                                FROM qwerty.sp_ka_uvol
                               WHERE data_uvol > to_date('31.12.&"��� �������"'
                                                        ,'dd.mm.yyyy')
                              MINUS
                              SELECT id_tab
                                FROM qwerty.sp_ka_work
                               WHERE id_zap = 1
                                 AND data_work > to_date('31.12.&"��� �������"'
                                                        ,'dd.mm.yyyy'))
           AND rbk.id_tab = rbf.id_tab
           AND st.id_stat = rbk.id_stat
           AND kat.id_kat = st.id_kat
           AND osn.id_tab = rbf.id_tab
           AND kobr.id_tab = rbf.id_tab
           AND obr2.id = kobr.id_obr
           AND obr.id = obr2.par_id
        UNION ALL
        SELECT dd.id_tab
              ,obr.name_u
              ,decode(osn.id_pol
                     ,2
                     ,1
                     ,0) female
              ,decode(ak.name_u
                     ,'������������'
                     ,1
                     ,0) RUK
              ,decode(ak.name_u
                     ,'�p�����������'
                     ,1
                     ,0) PROF
              ,decode(ak.name_u
                     ,'�����������'
                     ,1
                     ,0) SPEC
              ,decode(ak.name_u
                     ,'����������� ��������'
                     ,1
                     ,0) TEX_SL
              ,decode(ak.name_u
                     ,'��������� ���p� ��p����� � ������� �����'
                     ,1
                     ,0) RAB_SF_TBU
              ,decode(ak.name_u
                     ,'���������p������� p�������� ��������� ���������'
                     ,1
                     ,0) KV_RAB_SX
              ,decode(ak.name_u
                     ,'���������p������� p�������� � ����p�������'
                     ,1
                     ,0) KV_RAB_S_INST
              ,decode(ak.name_u
                     ,'���p���p� � ���p���� ���p�������� � �����'
                     ,1
                     ,0) OPER
              ,decode(ak.name_u
                     ,'�p�������� �p�������'
                     ,1
                     ,0) PROST
          FROM (SELECT id_tab
                      ,id_zap
                  FROM qwerty.sp_ka_uvol
                 WHERE data_uvol > to_date('31.12.&"��� �������"'
                                          ,'dd.mm.yyyy')) dd
              ,qwerty.sp_ka_perem p
              ,qwerty.sp_arx_kat ak
              ,qwerty.sp_ka_osn osn
              ,(SELECT id_tab
                      ,id_obr
                  FROM qwerty.sp_ka_obr o1
                 WHERE data_ok = (SELECT MAX(data_ok) FROM qwerty.sp_ka_obr WHERE id_tab = o1.id_tab)) kobr
              ,(SELECT id
                      ,decode(id
                             ,14
                             ,id
                             ,decode(parent_id
                                    ,0
                                    ,id
                                    ,parent_id)) par_id
                  FROM qwerty.sp_obr) obr2
              ,qwerty.sp_obr obr
         WHERE p.id_tab = dd.id_tab
           AND p.id_zap = dd.id_zap - 1
           AND ak.id = p.id_n_kat
           AND osn.id_tab = dd.id_tab
           AND kobr.id_tab = dd.id_tab
           AND obr2.id = kobr.id_obr
           AND obr.id = obr2.par_id)
 GROUP BY ROLLUP(OBR_NAME);
--���������� ������ �� ����������
--TAB=���������� ������ �� ����������
SELECT decode(GROUPING(age_kat)
             ,1
             ,'�����:'
             ,age_kat) "���������� ���������"
       ,COUNT(f.id_tab) "�����"
       ,SUM(decode(o.id_pol
                 ,2
                 ,1
                 ,0)) "�� ��� ������"
       ,SUM(decode(id_kat
                 ,1
                 ,1
                 ,0)) "������������"
       ,SUM(decode(id_kat
                 ,2
                 ,1
                 ,0)) "�������������"
       ,SUM(decode(id_kat
                 ,3
                 ,1
                 ,0)) "�����������"
       ,SUM(decode(id_kat
                 ,5
                 ,1
                 ,0)) "��������� ����� �������� � ���"
       ,SUM(decode(id_kat
                 ,6
                 ,1
                 ,0)) "����������������� ��������� ��"
       ,SUM(decode(id_kat
                 ,7
                 ,1
                 ,0)) "����������������� ��������� ��"
       ,SUM(decode(id_kat
                 ,8
                 ,1
                 ,0)) "��������� � �������� ���������"
       ,SUM(decode(id_kat
                 ,4
                 ,1
                 ,0)) "����������� ��������"
       ,SUM(decode(id_kat
                 ,9
                 ,1
                 ,0)) "���������� ���������"
  FROM qwerty.sp_rb_fio f
      ,qwerty.sp_ka_osn o
      ,qwerty.sp_rb_key k
      ,qwerty.sp_stat s
      ,(SELECT id_tab
              ,age
              ,'�� 18 ���' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age < 18
        UNION
        SELECT id_tab
              ,age
              ,'c 18 �� 20' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age BETWEEN 18 AND 19
        UNION
        SELECT id_tab
              ,age
              ,'� 20 �� 25' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age BETWEEN 20 AND 24
        UNION
        SELECT id_tab
              ,age
              ,'� 25 �� 30' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age BETWEEN 25 AND 29
        UNION
        SELECT id_tab
              ,age
              ,'� 30 �� 40' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age BETWEEN 30 AND 39
        UNION
        SELECT id_tab
              ,age
              ,'� 40 �� 50' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age BETWEEN 40 AND 49
        UNION
        SELECT id_tab
              ,age
              ,'� 50 � ����' AS age_kat
          FROM (SELECT id_tab
                      ,trunc(months_between(to_date('31.12.&"��� �������"'
                                                   ,'dd.mm.yyyy')
                                           ,data_r) / 12) AS age
                  FROM qwerty.sp_ka_osn)
         WHERE age > 49) d
 WHERE f.id_tab IN ((SELECT id_tab
                       FROM qwerty.sp_ka_work w
                     MINUS
                     SELECT id_tab
                       FROM qwerty.sp_kav_perem_f2 w
                      WHERE (w.data_work > to_date('31.12.&"��� �������"'
                                                  ,'dd.mm.yyyy') AND id_zap = 1)) UNION ALL SELECT id_tab FROM qwerty.sp_ka_uvol u WHERE u.data_uvol > to_date('31.12.&"��� �������"'
                                         ,'dd.mm.yyyy'))
   AND f.id_tab = o.id_tab
   AND f.id_tab = k.id_tab(+)
   AND s.id_stat(+) = k.id_stat
   AND f.id_tab = d.id_tab
 GROUP BY ROLLUP(d.age_kat);
--���� ������ �� ����������
-- ���� (p.id_zap=1 or p.id_zap=-1), ������ � ������ ��������         
--TAB=������� (�� ����� � ����������)
SELECT decode(GROUPING(VID_PRIEM)
             ,1
             ,'�����:'
             ,VID_PRIEM) "��� ������"
       ,SUM(KOL) "�����"
       ,SUM(FEMALE) "������"
       ,SUM(RUK) "������������"
       ,SUM(PROF) "�������������"
       ,SUM(SPEC) "�����������"
       ,SUM(TEX_SL) "����������� ��������"
       ,SUM(RAB_SF_TiBU) "��������� ����� �������� � ���"
       ,SUM(KVAL_RAB_SX) "����������������� ��������� ��"
       ,SUM(KVAL_RAB_S_INSTRU) "����������������� ��������� ��"
       ,SUM(OPER) "��������� � �������� ���������"
       ,SUM(PROST) "���������� ���������"
       ,SUM(VREM) "��������" --, sum(SOVM) "������������"
  FROM (SELECT VID_PRIEM
              ,1 KOL
              ,decode(POL
                     ,2
                     ,1
                     ,0) FEMALE
              ,decode(KAT
                     ,'������������'
                     ,1
                     ,0) RUK
              ,decode(KAT
                     ,'�p�����������'
                     ,1
                     ,0) PROF
              ,decode(KAT
                     ,'�����������'
                     ,1
                     ,0) SPEC
              ,decode(KAT
                     ,'����������� ��������'
                     ,1
                     ,0) TEX_SL
              ,decode(KAT
                     ,'��������� ���p� ��p����� � ������� �����'
                     ,1
                     ,0) RAB_SF_TiBU
              ,decode(KAT
                     ,'���������p������� p�������� ��������� ���������'
                     ,1
                     ,0) KVAL_RAB_SX
              ,decode(KAT
                     ,'���������p������� p�������� � ����p�������'
                     ,1
                     ,0) KVAL_RAB_S_INSTRU
              ,decode(KAT
                     ,'���p���p� � ���p���� ���p�������� � �����'
                     ,1
                     ,0) OPER
              ,decode(KAT
                     ,'�p�������� �p�������'
                     ,1
                     ,0) PROST
              ,decode(ID_WORK
                     ,61
                     ,1
                     ,0) VREM
              ,decode(ID_WORK
                     ,62
                     ,1
                     ,0) SOVM
          FROM (SELECT w.id_tab     ID_TAB
                       ,w.id_work    ID_WORK
                       ,osn.id_priem ID_PRIEM
                       ,osn.id_pol   POL
                       ,kat.name_u   KAT
                       ,vw.name_u    VID_PRIEM
                   FROM qwerty.sp_ka_work  w
                       ,qwerty.sp_rb_key   rbk
                       ,qwerty.sp_stat     st
                       ,qwerty.sp_kat      kat
                       ,qwerty.sp_ka_osn   osn
                       ,qwerty.sp_vid_work vw
                  WHERE w.id_zap = 1
                    AND trunc(w.data_work
                             ,'YEAR') = to_date('01.01.&"��� �������"'
                                               ,'dd.mm.yyyy')
                    AND rbk.id_tab = w.id_tab
                    AND st.id_stat = rbk.id_stat
                    AND kat.id_kat = st.id_kat
                    AND osn.id_tab = w.id_tab
                    AND vw.id = osn.id_priem
                 UNION ALL
                 SELECT p.id_tab
                       ,p.id_work
                       ,osn.id_priem
                       ,osn.id_pol
                       ,ak.name_u
                       ,vw.name_u
                   FROM qwerty.sp_ka_perem p
                       ,qwerty.sp_ka_osn   osn
                       ,qwerty.sp_arx_kat  ak
                       ,qwerty.sp_vid_work vw
                  WHERE --p.id_zap=1 and 
                  (p.id_zap = 1 OR p.id_zap = -1)
               AND trunc(p.data_work
                       ,'YEAR') = to_date('01.01.&"��� �������"'
                                         ,'dd.mm.yyyy')
               AND ak.id = p.id_n_kat
               AND osn.id_tab = p.id_tab
               AND vw.id = osn.id_priem))
 GROUP BY ROLLUP(VID_PRIEM);
--���� ������ �� �����
-- ���� (p.id_zap=1 or p.id_zap=-1), ������ � ������ ��������         
--TAB=������� (�� �����)
SELECT decode(GROUPING(DEPT_NAME)
             ,1
             ,'�����:'
             ,DEPT_NAME) "���"
       ,SUM(KOL) "�����"
       ,SUM(FEMALE) "������"
       ,SUM(VOLN_N) "�� �������� �����"
       ,SUM(IZ_ARM) "�� �����"
       ,SUM(PO_PEREVODU) "�� ��������"
       ,SUM(PUT_VUZ) "�� ������� ����"
       ,SUM(PO_NAPR_BZ) "�� ����������� ���� ���������"
       ,SUM(KAK_PENS) "��� ���������"
       ,SUM(VREM) "��������"
  FROM (SELECT DEPT_NAME
              ,1 KOL
              ,decode(POL
                     ,2
                     ,1
                     ,0) FEMALE
              ,decode(ID_PRIEM
                     ,2
                     ,1
                     ,0) VOLN_N
              ,decode(ID_PRIEM
                     ,3
                     ,1
                     ,0) IZ_ARM
              ,decode(ID_PRIEM
                     ,6
                     ,1
                     ,0) PO_PEREVODU
              ,decode(ID_PRIEM
                     ,9
                     ,1
                     ,0) PUT_VUZ
              ,decode(ID_PRIEM
                     ,11
                     ,1
                     ,0) PO_NAPR_BZ
              ,decode(ID_PRIEM
                     ,12
                     ,1
                     ,0) KAK_PENS
              ,decode(ID_WORK
                     ,61
                     ,1
                     ,0) VREM
          FROM (SELECT w.id_tab     ID_TAB
                       ,w.id_work    ID_WORK
                       ,osn.id_priem ID_PRIEM
                       ,osn.id_pol   POL
                       ,pdr.name_u   DEPT_NAME
                   FROM qwerty.sp_ka_work w
                       ,qwerty.sp_rb_key  rbk
                       ,qwerty.sp_stat    st
                       ,qwerty.sp_podr    pdr
                       ,qwerty.sp_ka_osn  osn
                  WHERE w.id_zap = 1
                    AND trunc(w.data_work
                             ,'YEAR') = to_date('01.01.&"��� �������"'
                                               ,'dd.mm.yyyy')
                    AND rbk.id_tab = w.id_tab
                    AND st.id_stat = rbk.id_stat
                    AND pdr.id_cex = st.id_cex
                    AND osn.id_tab = w.id_tab
                 UNION ALL
                 SELECT p.id_tab
                       ,p.id_work
                       ,osn.id_priem
                       ,osn.id_pol
                       ,ac.name_u
                   FROM qwerty.sp_ka_perem p
                       ,qwerty.sp_arx_cex  ac
                       ,qwerty.sp_ka_osn   osn
                  WHERE --p.id_zap=1 and 
                  (p.id_zap = 1 OR p.id_zap = -1)
               AND trunc(p.data_work
                       ,'YEAR') = to_date('01.01.&"��� �������"'
                                         ,'dd.mm.yyyy')
               AND ac.id = p.id_n_cex
               AND osn.id_tab = p.id_tab))
 GROUP BY ROLLUP(DEPT_NAME);
--���� ���������� �� �����
--TAB=������� (�� �����)
SELECT decode(GROUPING(DEPT_NAME)
             ,1
             ,'�����:'
             ,DEPT_NAME) "���"
       ,SUM(VSE) "�����"
       ,SUM(FEMALE) "������"
       ,SUM(UV28) "�� ��������"
       ,SUM(UV29) "� �����"
       ,SUM(UV30) "�� ������"
       ,SUM(UV31) "� ����� �� �������"
       ,SUM(UV32) "�� �������� ������"
       ,SUM(UV36) "�� ������ �� ���"
       ,SUM(UV37) "�� ���������� �����"
       ,SUM(UV41) "�������"
       ,SUM(UV43) "�� ������������ �������"
       ,SUM(UV49) "�� ��������� ����� ��������� �"
       ,SUM(UV51) "�������� ����� ����������"
       ,SUM(UV52) "���������� ������"
       ,SUM(UV53) "��������� ��������� �����"
       ,SUM(UV55) "�� ����� �� �������� �� 14 �"
       ,SUM(UV69) "�� ������ �� ������������ 1��"
       ,SUM(UV70) "�� ������ �� ������������ 2��."
       ,SUM(UV71) "�� ������ �� ������������ 3��."
       ,SUM(UV79) "�� ���������� ����� � ���.��.�"
  FROM (SELECT DEPT_NAME
              ,1 VSE
              ,decode(ID_POL
                     ,2
                     ,1
                     ,0) FEMALE
              ,decode(ID_UVOL
                     ,28
                     ,1
                     ,0) UV28
              ,decode(ID_UVOL
                     ,29
                     ,1
                     ,0) UV29
              ,decode(ID_UVOL
                     ,30
                     ,1
                     ,0) UV30
              ,decode(ID_UVOL
                     ,31
                     ,1
                     ,0) UV31
              ,decode(ID_UVOL
                     ,32
                     ,1
                     ,0) UV32
              ,decode(ID_UVOL
                     ,36
                     ,1
                     ,0) UV36
              ,decode(ID_UVOL
                     ,37
                     ,1
                     ,0) UV37
              ,decode(ID_UVOL
                     ,41
                     ,1
                     ,0) UV41
              ,decode(ID_UVOL
                     ,43
                     ,1
                     ,0) UV43
              ,decode(ID_UVOL
                     ,49
                     ,1
                     ,0) UV49
              ,decode(ID_UVOL
                     ,51
                     ,1
                     ,0) UV51
              ,decode(ID_UVOL
                     ,52
                     ,1
                     ,0) UV52
              ,decode(ID_UVOL
                     ,53
                     ,1
                     ,0) UV53
              ,decode(ID_UVOL
                     ,55
                     ,1
                     ,0) UV55
              ,decode(ID_UVOL
                     ,69
                     ,1
                     ,0) UV69
              ,decode(ID_UVOL
                     ,70
                     ,1
                     ,0) UV70
              ,decode(ID_UVOL
                     ,71
                     ,1
                     ,0) UV71
              ,decode(ID_UVOL
                     ,79
                     ,1
                     ,0) UV79
          FROM (SELECT u.id_tab   ID_TAB
                      ,u.id_uvol  ID_UVOL
                      ,osn.id_pol ID_POL
                      ,ac.name_u  DEPT_NAME
                  FROM qwerty.sp_ka_uvol  u
                      ,qwerty.sp_ka_osn   osn
                      ,qwerty.sp_ka_perem p
                      ,qwerty.sp_arx_cex  ac
                 WHERE trunc(u.data_uvol
                            ,'YEAR') = to_date('01.01.&"��� �������"'
                                              ,'dd.mm.yyyy')
                   AND osn.id_tab = u.id_tab
                   AND p.id_tab = u.id_tab
                   AND abs(p.id_zap) = abs(u.id_zap) - 1
                   AND p.data_kon = u.data_uvol
                   AND ac.id = p.id_n_cex))
 GROUP BY ROLLUP(DEPT_NAME);
--���� ���������� �� ����������
--TAB=������� (�� ����������)
SELECT decode(GROUPING(DEPT_NAME)
             ,1
             ,'�����:'
             ,DEPT_NAME) "���"
       ,SUM(VSE) "�����"
       ,SUM(FEMALE) "������"
       ,SUM(RUK) "������������"
       ,SUM(PROF) "�������������"
       ,SUM(SPEC) "�����������"
       ,SUM(TEX_SL) "����������� ��������"
       ,SUM(RAB_SF_TiBU) "��������� ����� �������� � ���"
       ,SUM(RAB_SX) "����������������� ��������� ��"
       ,SUM(RAB_S_INSTRU) "����������������� ��������� ��"
       ,SUM(OPER) "��������� � �������� ���������"
       ,SUM(PROST) "���������� ���������"
       ,SUM(VREM) "��������"
       ,SUM(SOVM) "������������"
  FROM (SELECT DEPT_NAME
              ,1 VSE
              ,decode(ID_POL
                     ,2
                     ,1
                     ,0) FEMALE
              ,decode(KAT
                     ,'������������'
                     ,1
                     ,0) RUK
              ,decode(KAT
                     ,'�p�����������'
                     ,1
                     ,0) PROF
              ,decode(KAT
                     ,'�����������'
                     ,1
                     ,0) SPEC
              ,decode(KAT
                     ,'����������� ��������'
                     ,1
                     ,0) TEX_SL
              ,decode(KAT
                     ,'��������� ���p� ��p����� � ������� �����'
                     ,1
                     ,0) RAB_SF_TiBU
              ,decode(KAT
                     ,'���������p������� p�������� ��������� ���������'
                     ,1
                     ,0) RAB_SX
              ,decode(KAT
                     ,'���������p������� p�������� � ����p�������'
                     ,1
                     ,0) RAB_S_INSTRU
              ,decode(KAT
                     ,'���p���p� � ���p���� ���p�������� � �����'
                     ,1
                     ,0) OPER
              ,decode(KAT
                     ,'�p�������� �p�������'
                     ,1
                     ,0) PROST
              ,decode(ID_WORK
                     ,61
                     ,1
                     ,0) VREM
              ,decode(ID_WORK
                     ,62
                     ,1
                     ,0) SOVM
          FROM (SELECT u.id_tab   ID_TAB
                      ,u.id_uvol  ID_UVOL
                      ,osn.id_pol ID_POL
                      ,ac.name_u  DEPT_NAME
                      ,ak.name_u  KAT
                      ,p.id_work  ID_WORK
                  FROM qwerty.sp_ka_uvol  u
                      ,qwerty.sp_ka_osn   osn
                      ,qwerty.sp_ka_perem p
                      ,qwerty.sp_arx_cex  ac
                      ,qwerty.sp_arx_kat  ak
                 WHERE trunc(u.data_uvol
                            ,'YEAR') = to_date('01.01.&"��� �������"'
                                              ,'dd.mm.yyyy')
                   AND osn.id_tab = u.id_tab
                   AND p.id_tab = u.id_tab
                   AND abs(p.id_zap) = abs(u.id_zap) - 1
                   AND p.data_kon = u.data_uvol
                   AND ac.id = p.id_n_cex
                   AND ak.id = p.id_n_kat))
 GROUP BY ROLLUP(DEPT_NAME)
