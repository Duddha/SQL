-- TAB = � ������ ��� ���������� ����� ��� ���������������
-- !!! �������� ��� EXCEL �����, �.�. ��� ��������� �� 30 �������� � PL/SQL Developer-� v11 beta 2
-- EXCEL = � ������ ��� ���������� �����
-- RECORDS = ALL


-- ???
-- 19.01.2016
-- Q: ������ ������: � ��������� �� � �����, ������� ������ �� ������ SP_KA_WORK (���� �� ������ ������� ������� ����� ���� ������)?
-- A: ��������� �������, ��� ����/����� ���� ������� �� �������. �� �� �� ����� ����� ��������?
--
-- Q: ����� � �������� "���������� �� �������" � "���������� ��������� ������" ��������� ������ ������� � �����?
-- A: ?

with vyborka as (
-- TAB = � ����� � ������ ������ �� 6 ���
-- ���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ����
SELECT t.*
--,p.name_u "���"
  FROM (SELECT first_value(t.id_tab) over(PARTITION BY children ORDER BY dekr) "���. �"
               ,first_value(fio) over(PARTITION BY children ORDER BY dekr) "�.�.�."
               ,first_value(children) over(PARTITION BY children ORDER BY dekr) "����������"
               ,'1.1' "�����"
               ,'���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ���� (2 �� �����)' "�������� ������"
               ,'���� ����� �� ������: ' || to_char(data_work_zap_1
                                                   ,'dd.mm.yyyy') || decode(dekr
                                                                           ,1
                                                                           ,' (� �������)'
                                                                           ,'') "�������������� ������"
               --,dekr "� �������"
               --,data_work_zap_1 "���� ����� �� ������"
               ,decode(sign(trunc(months_between(to_date(&< NAME = "���� �������" TYPE = "string" required = "yes" DEFAULT = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') + 1, data_r)) - 12 * &< NAME = "���������� ������� ������� �� �.1.1" TYPE = "integer" DEFAULT = "6" >)
                      --�� ����� ���� ������� �������� ���������� �������
                      ,1
                      ,
                      --������� ���������� ����, ����� ������� ��� ��� � ������ ����������� ��������
                      -- �������� �������� � ��������� ������ data_r �� decode(to_char(data_r, 'dd.mm'), '29.02', to_date('28.' || to_char(data_r, 'mm.yyyy')), data_r)
                      -- ��-�� ��������� 29 �������
                      to_date(to_char(decode(to_char(data_r
                                                    ,'dd.mm')
                                            ,'29.02'
                                            ,data_r - 1
                                            ,data_r)
                                     ,'dd.mm.') || to_char(trunc(to_date(&< NAME = "���� �������" >
                                                                         ,'dd.mm.yyyy')
                                                                 ,'YEAR')
                                                           ,'yyyy')
                              ,'dd.mm.yyyy') - (trunc(to_date(&< NAME = "���� �������" >
                                                              ,'dd.mm.yyyy')
                                                      ,'YEAR') - 1)
                      --�� ����� ���� ������� ��� � �������� ����������� �������� 
                      ,365) "���-�� ���� � �������� ����"
          FROM (SELECT t.id_tab
                      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
                      ,REPLACE(children
                              ,';; '
                              ,',' || chr(10)) children
                      ,row_number() over(PARTITION BY children ORDER BY t.id_tab) rn
                      ,dekr
                      ,data_r
                      ,data_work data_work_zap_1
                  FROM (SELECT id_tab
                              ,ltrim(sys_connect_by_path(relative
                                                        ,';; ')
                                    ,';; ') children
                              ,dekr
                              ,data_r
                              ,data_work
                          FROM (SELECT id_tab
                                      ,relative
                                      ,lead(relative) over(PARTITION BY id_tab ORDER BY data_r) next_one
                                      ,lag(relative) over(PARTITION BY id_tab ORDER BY data_r) prev_one
                                      ,data_r
                                      ,dekr
                                      ,data_work
                                  FROM (SELECT fml.id_tab
                                              ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r
                                                                                                                                  ,' (dd.mm.yyyy)') relative
                                              ,MAX(data_r) over(PARTITION BY fml.id_tab) data_r
                                              ,decode(nvl(dekr.id_tab
                                                         ,0)
                                                     ,0
                                                     ,0
                                                     ,1) dekr
                                              ,f2.data_work
                                          FROM qwerty.sp_ka_famil fml
                                              ,qwerty.sp_rod rod
                                              ,(SELECT DISTINCT d.id_tab
                                                  FROM qwerty.sp_ka_dekr d
                                                      ,qwerty.sp_rb_key  rbk
                                                      ,qwerty.sp_stat    s
                                                 WHERE (d.k_dekr > SYSDATE AND NOT nvl(date_vid
                                                                                      ,SYSDATE + 1) <= SYSDATE)
                                                   AND d.id_tab = rbk.id_tab
                                                   AND rbk.id_stat = s.id_stat) dekr
                                              ,qwerty.sp_kav_perem_f2 f2
                                         WHERE fml.id_rod = rod.id
                                           AND fml.id_rod IN (5 /*���*/
                                                             ,6 /*����*/
                                                             ,7 /*������*/)
                                           AND months_between(trunc(to_date(&< NAME = "���� �������" >
                                                                            ,'dd.mm.yyyy')
                                                                    ,'YEAR')
                                                              ,fml.data_r) < (12 * &< NAME = "���������� ������� ������� �� �.1.1" TYPE = "integer" DEFAULT = "6" >)
                                           AND fml.id_tab = f2.ID_TAB
                                           AND f2.id_zap = 1
                                           AND f2.DATA_WORK <= to_date(&< NAME = "���� �������" >
                                                                       ,'dd.mm.yyyy')
                                           AND fml.id_tab = dekr.id_tab(+)
                                         ORDER BY id_tab
                                                 ,data_r
                                                 ,fam_u
                                                 ,f_name_u
                                                 ,s_name_u))
                         WHERE next_one IS NULL
                         START WITH prev_one IS NULL
                        CONNECT BY PRIOR relative = prev_one
                               AND PRIOR id_tab = id_tab) t
                       ,qwerty.sp_rb_fio rbf
                 WHERE t.id_tab = rbf.id_tab) t
               ,qwerty.sp_ka_work w
         WHERE rn = 1
           AND t.id_tab = w.id_tab) t
       ,qwerty.sp_rb_key rbk
       ,qwerty.sp_stat s
       ,qwerty.sp_podr p
 WHERE instr("����������"
             ,',') > 0
   AND t."���. �" = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex

union all

-- TAB = �������� � ������ �� 14 ���
-- ������ ��� ������ � �������� 
--   1. ������ ���� �� 14 ���� 
--   2. ��� �����-������� - !!! � ����� �� ����� ������ ��� !!!
SELECT t.id_tab "���. �"
       ,fio "�.�.�."
       ,'�������� ���������: ' || sempol.name_u || ';' || chr(10) || children "����������"
       ,'1.2' "�����"
       ,'���� � ������ ��� �����, ��� �� ������ � ������ ��� ������ � �������� ������ ���� �� 14 ���� ��� ������-�������' "����� ������"
       ,'���� ����� �� ������: ' || to_char(f2.DATA_WORK
                                           ,'dd.mm.yyyy') "�������������� ������"
       ,to_date(&< NAME = "���� �������" >
               ,'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< NAME = "���� �������" >
                                                                              ,'dd.mm.yyyy')
                                                                      ,-12))
                                       ,-1
                                       ,trunc(to_date(&< NAME = "���� �������" >
                                                     ,'dd.mm.yyyy')
                                             ,'YEAR')
                                       ,f2.DATA_WORK) + 1 "���-�� ���� � �������� ����"
  FROM (SELECT t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(PARTITION BY children ORDER BY t.id_tab) rn
          FROM (SELECT id_tab
                      ,ltrim(sys_connect_by_path(relative
                                                ,', ')
                            ,', ') children
                  FROM (SELECT id_tab
                              ,relative
                              ,lead(relative) over(PARTITION BY id_tab ORDER BY data_r) next_one
                              ,lag(relative) over(PARTITION BY id_tab ORDER BY data_r) prev_one
                          FROM (SELECT id_tab
                                      ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r
                                                                                                                          ,' (dd.mm.yyyy') || '�.�. �������: ' ||
                                       trunc(months_between(trunc(to_date(&< NAME = "���� �������" >
                                                                          ,'dd.mm.yyyy')
                                                                  ,'YEAR')
                                                            ,data_r) / 12) || ' �� ������ ����)' relative
                                       ,data_r
                                  FROM qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 WHERE fml.id_rod = rod.id
                                   AND fml.id_rod IN (5 /*���*/
                                                     ,6 /*����*/
                                                     ,7 /*������*/)
                                   AND months_between(trunc(to_date(&< NAME = "���� �������" TYPE = "string" >
                                                                    ,'dd.mm.yyyy')
                                                            ,'YEAR')
                                                      ,fml.data_r) < (12 * &< NAME = "���������� ������� ������� �� �.1.2" TYPE = "integer" DEFAULT = "14" >)
                                 ORDER BY id_tab
                                         ,data_r
                                         ,fam_u
                                         ,f_name_u
                                         ,s_name_u))
                 WHERE next_one IS NULL
                 START WITH prev_one IS NULL
                CONNECT BY PRIOR relative = prev_one
                       AND PRIOR id_tab = id_tab) t
               ,qwerty.sp_rb_fio rbf
         WHERE t.id_tab = rbf.id_tab) t
       ,qwerty.sp_ka_work w
       ,qwerty.sp_ka_osn osn
       ,qwerty.sp_sempol sempol
       ,qwerty.sp_kav_perem_f2 f2
 WHERE rn = 1
   AND t.id_tab = w.id_tab
   AND t.id_tab = osn.id_tab
   AND osn.id_sempol IN (30 /*����-��������*/
                        ,40 /*����-��������*/
                         -- !!! ���� ����� ���� ��������, �� �� ����������� ������� ����� � ��� !!!
                        ,
                         --50 /*��������*/,
                         --51 /*���������*/,
                         60 /*�����*/
                        ,61 /*������*/)
   AND osn.id_sempol = sempol.id
   AND t.id_tab = f2.id_tab
   AND f2.id_zap = 1
   AND f2.data_work <= to_date(&< NAME = "���� �������" >
                               ,'dd.mm.yyyy')

union all

-- TAB = �������� � ������ ���������� � �������
-- ������ ��� ������ � �������� 
--   1. ������� � ��������� (��������� �� ���) 
--   2. ��/��� ������� I ����� (��������� �� ������� ����������) - !!! � ����� �� ����� ������ ��� !!!
SELECT DISTINCT rbf.id_tab "���. �"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
                ,'�������� ���������: ' || pens.sempol_name_u || ';' || chr(10) || '��� ������: ' || pens.name_u "����������"
                ,'1.3' "�����"
                ,'���� � ������ ��� �����, ��� �� ������ � ������ ��� ������ � �������� ������� � ��������� (��������� �� ���) ��/��� ������� I ����� (��������� �� ������� ����������)' "����� ������"
                ,'���� ����� �� ������: ' || to_char(f2.DATA_WORK
                                                    ,'dd.mm.yyyy') "�������������� ������"
                ,to_date(&< NAME = "���� �������" TYPE = "string" >
                        ,'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< NAME = "���� �������" >
                                                                                       ,'dd.mm.yyyy')
                                                                               ,-12))
                                                ,-1
                                                ,trunc(to_date(&< NAME = "���� �������" >
                                                              ,'dd.mm.yyyy')
                                                      ,'YEAR')
                                                ,f2.DATA_WORK) + 1 "���-�� ���� � �������� ����"
  FROM qwerty.sp_ka_work w
      ,qwerty.sp_rb_fio rbf
      ,(SELECT osn.id_tab
              ,osn.id_sempol
              ,sempol.name_u sempol_name_u
              ,osn.id_pens
              ,p.name_u
          FROM qwerty.sp_ka_osn osn
              ,qwerty.sp_pens   p
              ,qwerty.sp_sempol sempol
         WHERE id_pens IN (52 /*���� ������� �������� � �������*/
                          ,56 /*���� ������� �������� � �������*/
                           -- 19.01.2016 ��������� ����� ��� ������ � ����� � ���������� ����������� ������
                          ,75 /*�� �������� (����/���� ������ �������� � �������)*/)
           AND osn.id_pens = p.id
           AND osn.id_sempol IN (30 /*����-��������*/
                                ,40 /*����-��������*/
                                ,50 /*��������*/
                                ,51 /*���������*/
                                ,60 /*�����*/
                                ,61 /*������*/)
           AND osn.id_sempol = sempol.id
        UNION ALL
        SELECT ktp.id_tab
              ,osn.id_sempol
              ,sempol.name_u sempol_name_u
              ,ktp.id_property
              ,prop.name
          FROM qwerty.sp_ka_tab_prop ktp
              ,qwerty.sp_properties  prop
              ,qwerty.sp_ka_osn      osn
              ,qwerty.sp_sempol      sempol
         WHERE id_property IN (101 /*���� ������-�������� � �������*/
                              ,102 /*���� ������-�������� � �������*/)
           AND ktp.id_property = prop.id
           AND ktp.id_tab = osn.id_tab
           AND osn.id_sempol IN (30 /*����-��������*/
                                ,40 /*����-��������*/
                                ,50 /*��������*/
                                ,51 /*���������*/
                                ,60 /*�����*/
                                ,61 /*������*/)
           AND osn.id_sempol = sempol.id) pens
      ,qwerty.sp_kav_perem_f2 f2
 WHERE w.id_tab = pens.id_tab
   AND w.id_tab = rbf.id_tab
   AND w.id_tab = f2.id_tab
   AND f2.id_zap = 1
   AND f2.data_work <= to_date(&< NAME = "���� �������" >
                               ,'dd.mm.yyyy')

union all

-- TAB = �������� ����� ����� ��� ��.���������, ��� ������� ����� ������ ����� ������
--  ������, ��� �������� ��� ��������� �������� � ��������������, ���������-�������� � ����� ���������� �������� 
--  (�������� ����� ������ ���� ��������� ��� ���������� ��������) � ��� ������ ���������� �� ������
SELECT TAB_ID "���. �"
       ,FIO "�.�.�."
       ,REMARK "����������"
       ,PUNKT "�����"
       ,PUNKT_TEXT "����� ������"
       ,'���� ����� �� ������: ' || to_char(DATA_WORK
                                           ,'dd.mm.yyyy') || ', ������� ����� ����� �� ������: ' || DIFF_WORK || ';' || chr(10) || '���� ��������� ���: ' ||
       ltrim(sys_connect_by_path(DATA_FINISH
                                ,'; ')
            ,'; ') || ', ������� ����� ��������� ���: ' || DIFF_OBR "�������������� ������"
       --,ltrim(sys_connect_by_path(DATA_FINISH,
       --                          '; '),
       --      '; ') "���� ��������� ���"
       --,DIFF_OBR "������� ����� ��������� ���"
       --,DIFF_WORK "������� ����� ����� �� ������"
       ,to_date(&< NAME = "���� �������" >
               ,'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< NAME = "���� �������" >
                                                                           ,'dd.mm.yyyy')
                                                                   ,-12))
                                       ,-1
                                       ,trunc(to_date(&< NAME = "���� �������" >
                                                     ,'dd.mm.yyyy')
                                             ,'YEAR')
                                       ,DATA_WORK) + 1 "���-�� ���� � �������� ����"
  FROM (SELECT DISTINCT rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'���������� ����� ������: ' || osn.pred_work || '; ����: ' || nvl(osn.publ_sta
                                                                                         ,0) || '�. ' || nvl(osn.publ_sta_m
                                                                                                            ,0) || '�. ' || nvl(osn.publ_sta_d
                                                                                                                               ,0) || '�.' REMARK
                       ,'5.1' PUNKT
                       ,'������, ��� �������� ��� ��������� �������� � ��������������, ���������-�������� � ����� ���������� �������� ... (�������� ����� ������ ���� ��������� ��� ���������� ��������) � ��� ������ ���������� �� ������' PUNKT_TEXT
                       ,f2.DATA_WORK DATA_WORK
                       ,to_char(obr.data_ok
                               ,'dd.mm.yyyy') DATA_FINISH
                       ,lag(obr.data_ok) over(PARTITION BY obr.id_tab ORDER BY obr.data_ok) PREV_DATA_FINISH
                       ,lead(obr.data_ok) over(PARTITION BY obr.id_tab ORDER BY obr.data_ok) NEXT_DATA_FINISH
                       ,round(months_between(f2.data_work
                                            ,obr.data_ok)
                             ,1) DIFF_OBR
                       ,round(months_between(to_date(&< NAME = "���� �������" TYPE = "string" >
                                                     ,'dd.mm.yyyy')
                                             ,f2.data_work)
                              ,1) DIFF_WORK
          FROM qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
              ,qwerty.sp_ka_osn       osn
              ,qwerty.sp_rb_fio       rbf
              ,qwerty.sp_ka_obr       obr
         WHERE f2.id_tab = wrk.id_tab
           AND osn.id_tab = wrk.id_tab
              --������ � ������� ��������� 3-� ���
           AND f2.id_zap = 1
           AND months_between(to_date(&< NAME = "���� �������" TYPE = "string" >
                                      ,'dd.mm.yyyy')
                              ,f2.data_work) <= 36
              --�������� - �� 35 ��� (35*12=420)
           AND osn.data_r >= add_months(to_date(&< NAME = "���� �������" >
                                                ,'dd.mm.yyyy')
                                        ,-35 * 12)
              --and f2.nam_work <> '�p������'
           AND nvl(osn.publ_sta
                  ,0) + nvl(osn.publ_sta_m
                           ,0) + nvl(osn.publ_sta_d
                                    ,0) = 0
              --������ ������� ����� - ���������� �������� ����� "�����"
           AND lower(osn.pred_work) LIKE '%�����%'
           AND f2.id_tab = rbf.id_tab
           AND f2.id_tab = obr.id_tab
              --������ ������� �����������       
           AND obr.id_vidobr = 1
              --������� �� ��������� �������� �� ����� �� ������
           AND months_between(f2.data_work
                             ,obr.data_ok) BETWEEN 0 AND 6)
 WHERE NEXT_DATA_FINISH IS NULL
 START WITH PREV_DATA_FINISH IS NULL
CONNECT BY PRIOR DATA_FINISH = PREV_DATA_FINISH
       AND PRIOR TAB_ID = TAB_ID

union all

-- TAB = �������� ����� �����, ��� ������� ����� ������ ����� ������
-- ������, ��� ���������� �� �������� ������� ��� ������������� (���������) ������ 
--  (�������� ����� ������ ���� ��������� ��� ���������� ������)
SELECT TAB_ID "���. �"
       ,FIO "�.�.�."
       ,REMARK "����������"
       ,PUNKT "�����"
       ,PUNKT_TEXT "����� ������"
       ,'���� ����� �� ������: ' || to_char(DATA_WORK
                                           ,'dd.mm.yyyy') || ', ������� ����� ����� �� ������: ' || DIFF_WORK || ';' || chr(10) || '���� ��������� ������: ' ||
       to_char(DATE_FINISH
              ,'dd.mm.yyyy') || ', ������� ����� ��������� ������: ' || DIFF_VSU "�������������� ������"
       --,DATA_WORK "���� ����� �� ������"
       --,DATE_FINISH "���� ��������� ������"
       --,DIFF_VSU "������� ����� ��������� ������"
       --,DIFF_WORK "������� ����� ����� �� ������"
       ,to_date(&< NAME = "���� �������" >
               ,'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< NAME = "���� �������" >
                                                                           ,'dd.mm.yyyy')
                                                                   ,-12))
                                       ,-1
                                       ,trunc(to_date(&< NAME = "���� �������" >
                                                     ,'dd.mm.yyyy')
                                             ,'YEAR')
                                       ,DATA_WORK) + 1 "���-�� ���� � �������� ����"
  FROM (SELECT DISTINCT rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'���������� ����� ������: ' || osn.pred_work || '; ����: ' || nvl(osn.publ_sta
                                                                                         ,0) || '�. ' || nvl(osn.publ_sta_m
                                                                                                            ,0) || '�. ' || nvl(osn.publ_sta_d
                                                                                                                               ,0) || '�.' REMARK
                       ,'5.2' PUNKT
                       ,'������, ��� ���������� �� �������� ������� ��� ������������� (���������) ������ (�������� ����� ������ ���� ��������� ��� ���������� ������)' PUNKT_TEXT
                       ,f2.data_work DATA_WORK
                       ,round(months_between(to_date(&< NAME = "���� �������" TYPE = "string" >
                                                     ,'dd.mm.yyyy')
                                             ,f2.data_work)
                              ,1) DIFF_WORK
                        ,osn.DATE_FINISH
                        ,round(months_between(f2.data_work
                                            ,osn.DATE_FINISH)
                             ,1) DIFF_VSU
          FROM qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
               --,qwerty.sp_ka_osn       osn
              ,(SELECT id_tab
                      ,publ_sta
                      ,publ_sta_m
                      ,publ_sta_d
                      ,data_r
                      ,pred_work
                      ,no_char
                      ,decode(instr(no_char
                                   ,'-')
                             ,0
                             ,to_date(substr(no_char
                                            ,1
                                            ,8)
                                     ,'ddmmyyyy')
                             ,to_date(substr(no_char
                                            ,instr(no_char
                                                  ,'-') + 1
                                            ,8)
                                     ,'ddmmyyyy')) DATE_FINISH
                  FROM (SELECT id_tab
                              ,publ_sta
                              ,publ_sta_m
                              ,publ_sta_d
                              ,data_r
                              ,pred_work
                               
                              ,TRIM(translate(pred_work
                                             ,'0123456789-.�������������������������������������Ũ�������������������������� '
                                             ,'0123456789-')) no_char
                          FROM qwerty.sp_ka_osn)) osn
              ,qwerty.sp_rb_fio rbf
         WHERE f2.id_tab = wrk.id_tab
              
              --and osn2.id_tab = wrk.id_tab
              --������ � ������� ��������� 3-� ���
           AND f2.id_zap = 1
           AND months_between(to_date(&< NAME = "���� �������" TYPE = "string" >
                                      ,'dd.mm.yyyy')
                              ,f2.data_work) <= 36
           AND osn.id_tab = wrk.id_tab
              --�������� - �� 35 ��� (35*12=420)              
           AND osn.data_r >= add_months(to_date(&< NAME = "���� �������" >
                                                ,'dd.mm.yyyy')
                                        ,-35 * 12)
              --� ������� �������� ����� ���������� �� �����
           AND months_between(f2.data_work
                             ,osn.DATE_FINISH) BETWEEN 0 AND 6
              --and f2.nam_work <> '�p������'
           AND nvl(osn.publ_sta
                  ,0) + nvl(osn.publ_sta_m
                           ,0) + nvl(osn.publ_sta_d
                                    ,0) = 0
              --������ ������� ����� - ���������� �������� ����� "������ �"
           AND lower(osn.pred_work) LIKE '%������ �%'
           AND f2.id_tab = rbf.id_tab)

union all

-- TAB = ��������� ��������������� ��������
-- �����, ���� �� �������� ����� �� ����� �� ���� �������� �� ����� 26 ������ ������ "��� ������������'������ �������� ������� �����������" ���������� 10 � ����� ����
SELECT DISTINCT rbf.id_tab "���. �"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
                ,'�������, ���: ' || to_char(trunc(age / 12)) || '; �� ������, ���: ' || abs(round(till_pens / 12)) || '; ���: ' || pol "����������"
                ,'6' "�����"
                ,'�����, ���� �� �������� ����� �� ����� �� ���� �������� �� ����� 26 ������ ������ "��� ������������''������ �������� ������� �����������" ���������� 10 � ����� ����' "����� ������"
                ,'���� ����� �� ������: ' || to_char(DATA_WORK
                                                    ,'dd.mm.yyyy') "�������������� ������"
                ,to_date(&< NAME = "���� �������" >
                        ,'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< NAME = "���� �������" >
                                                                                    ,'dd.mm.yyyy')
                                                                            ,-12))
                                                ,-1
                                                ,trunc(to_date(&< NAME = "���� �������" >
                                                              ,'dd.mm.yyyy')
                                                      ,'YEAR')
                                                ,DATA_WORK) + 1 "���-�� ���� � �������� ����"
  FROM (SELECT id_tab
              ,age
              ,age - pens_age till_pens
              ,decode(id_pol
                     ,1
                     ,'�'
                     ,2
                     ,'�'
                     ,'?') pol
              ,DATA_WORK
          FROM (SELECT osn.*
                      ,months_between(to_date(&< NAME = "���� �������" TYPE = "string" >
                                              ,'dd.mm.yyyy') - 1
                                      ,osn.data_r) age
                       ,decode(osn.id_pol
                             ,1
                             ,&<         NAME = "���������� ������� ��� ������ (�.5, 6)" TYPE = "float" DEFAULT = "60" >
                              ,2
                              ,&<         NAME = "���������� ������� ��� ������ (�.5, 6)" TYPE = "float" DEFAULT = "60" /*"56,5"*/
                                                                                                                >) * 12 pens_age
                       ,f2.DATA_WORK DATA_WORK
                  FROM qwerty.sp_ka_work      w
                      ,qwerty.sp_ka_osn       osn
                      ,qwerty.sp_kav_perem_f2 f2
                 WHERE w.id_tab = osn.id_tab
                   AND w.id_work <> 61
                   AND w.id_tab = f2.id_tab
                   AND f2.id_zap = 1)) t
       ,qwerty.sp_rb_fio rbf
 WHERE till_pens BETWEEN (-12 * &< NAME = "���������� ��� �� ������ (�.5, 6)" TYPE = "integer" DEFAULT = "10" >) /*��� ��� �������*/
       AND 0
   AND t.id_tab = rbf.id_tab
)

select &<name = "������� �������" 
         list = "select 'distinct ""�����"", ""�������� ������"", count(*) over(partition by ""�����"") ""����������"", '''' ""-"" from  vyborka order by 1', '���������� �� �������' from dual 
                 union all 
                 select 'distinct ""���. �"", ""�.�.�."", round(max(""���-�� ���� � �������� ����"") over (partition by ""���. �"")/365, 2) ""�����������"", '' '' ""-"" from  vyborka order by 2', '���������� ��������� ������' from dual
                 union all                                         
                 select 'row_number() over (partition by ""�����"" order by ""�����"", ""�.�.�."") ""� �/� � ������"", vyborka.* from  vyborka order by 5, 1', '��� ������' from dual"
         default = "row_number() over (partition by ""�����"" order by ""�����"", ""�.�.�."") ""� �/� � ������"", vyborka.* from  vyborka order by 5, 1"
         description = "yes" >
