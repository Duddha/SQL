-- EXCEL = � ������ ��� ���������� �����
select &<name = "������� �������" 
         list = "select 'distinct ""�����"", ""�������� ������"", count(*) over(partition by ""�����"") ""����������""', '���������� �� �������' from dual 
                 union all 
                 select 'distinct ""���. �"", ""�.�.�."", round(max(""���-�� ���� � �������� ����"") over (partition by ""���. �"")/365, 2) ""�����������"", '' '' ""-""', '���������� ��������� ������' from dual
                 union all                                         
                 select 'row_number() over (partition by ""�����"" order by ""�����"", ""�.�.�."") ""� �/� � ������"", vyborka.*', '��� ������' from dual"
         default = "row_number() over (partition by ""�����"" order by ""�����"", ""�.�.�."") ""� �/� � ������"", vyborka.*"
         description = "yes" >
from (

-- TAB = � ������ �� 6 ���
-- ���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ����
/*select first_value(t.id_tab) over(partition by children order by dekr) "���. �"
       ,first_value(fio) over(partition by children order by dekr) "�.�.�."
       ,first_value(children) over(partition by children order by dekr) "����������"
       ,'1.1' "�����"
       ,'���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ����' "�������� ������"
       ,'���� �������� �� ������: ' || to_char(data_work_zap_1, 'dd.mm.yyyy') || decode(dekr, 1, ' (� �������)', '') "�������������� ������"
       --,dekr "� �������"
       --,data_work_zap_1 "���� �������� �� ������"
       ,decode(sign(trunc(months_between(to_date(&< name = "���� �������" type = "string" required = "yes" default = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') + 1, data_r)) - 12 * &< name = "���������� ������� ������� �� �.1.1" type = "integer" default = 6 >)
              --�� ����� ���� ������� �������� ���������� �������
              ,
              1,
              --������� ���������� ����, ����� ������� ��� ��� � ������ ����������� ��������
              to_date(to_char(data_r,
                              'dd.mm.') || to_char(trunc(to_date(&< name = "���� �������" >,
                                                                 'dd.mm.yyyy'),
                                                         'YEAR'),
                                                   'yyyy'),
                      'dd.mm.yyyy') - (trunc(to_date(&< name = "���� �������" >,
                                                     'dd.mm.yyyy'),
                                             'YEAR') - 1)
              --�� ����� ���� ������� ��� � �������� ����������� �������� 
              ,
              365) "���-�� ���� � �������� ����"
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
              ,dekr
              ,data_r
              ,data_work data_work_zap_1
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative,
                                                 ', '),
                             ', ') children
                      ,dekr
                      ,data_r
                      ,data_work
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                              ,data_r
                              ,dekr
                              ,data_work
                          from (select fml.id_tab
                                      ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r,
                                                                                                                           ' (dd.mm.yyyy)') relative
                                      ,max(data_r) over(partition by fml.id_tab) data_r
                                      ,decode(nvl(dekr.id_tab,
                                                  0),
                                              0,
                                              0,
                                              1) dekr
                                      ,f2.data_work
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod rod
                                      ,(select distinct d.id_tab
                                          from qwerty.sp_ka_dekr d
                                              ,qwerty.sp_rb_key  rbk
                                              ,qwerty.sp_stat    s
                                         where (d.k_dekr > sysdate and not nvl(date_vid,
                                                                               sysdate + 1) <= sysdate)
                                           and d.id_tab = rbk.id_tab
                                           and rbk.id_stat = s.id_stat) dekr
                                      ,qwerty.sp_kav_perem_f2 f2
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 \*���*\,
                                                      6 \*����*\,
                                                      7 \*������*\)
                                   and months_between(trunc(to_date(&< name = "���� �������" >,
                                                                    'dd.mm.yyyy'),
                                                            'YEAR'),
                                                      fml.data_r) < (12 * &< name = "���������� ������� ������� �� �.1.1" type = "integer" default = 6 >)
                                   and fml.id_tab = f2.ID_TAB
                                   and f2.id_zap = 1
                                   and f2.DATA_WORK <= to_date(&< name = "���� �������" >, 'dd.mm.yyyy')         
                                   and fml.id_tab = dekr.id_tab(+)                                   
                                 order by id_tab
                                         ,data_r
                                         ,fam_u
                                         ,f_name_u
                                         ,s_name_u))
                 where next_one is null
                 start with prev_one is null
                connect by prior relative = prev_one
                       and prior id_tab = id_tab) t
               ,qwerty.sp_rb_fio rbf
         where t.id_tab = rbf.id_tab) t
       ,qwerty.sp_ka_work w
 where rn = 1
   and t.id_tab = w.id_tab
*/
--/*

-- TAB = � ����� � ������ ������ �� 6 ���
-- ���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ����
select t.*
      --,p.name_u "���"
  from (select first_value(t.id_tab) over(partition by children order by dekr) "���. �"
               ,first_value(fio) over(partition by children order by dekr) "�.�.�."
               ,first_value(children) over(partition by children order by dekr) "����������"
               ,'1.1' "�����"
               ,'���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ���� (2 �� �����)' "�������� ������"
               ,'���� �������� �� ������: ' || to_char(data_work_zap_1,
                                                      'dd.mm.yyyy') || decode(dekr,
                                                                              1,
                                                                              ' (� �������)',
                                                                              '') "�������������� ������"
               --,dekr "� �������"
               --,data_work_zap_1 "���� �������� �� ������"
               ,decode(sign(trunc(months_between(to_date(&< name = "���� �������" type = "string" required = "yes" default = "select to_char(trunc(sysdate, 'YEAR') - 1, 'dd.mm.yyyy') from dual" >, 'dd.mm.yyyy') + 1, data_r)) - 12 * &< name = "���������� ������� ������� �� �.1.1" type = "integer" default = 6 >)
                      --�� ����� ���� ������� �������� ���������� �������
                      ,
                      1,
                      --������� ���������� ����, ����� ������� ��� ��� � ������ ����������� ��������
                      to_date(to_char(data_r,
                                      'dd.mm.') || to_char(trunc(to_date(&< name = "���� �������" >,
                                                                         'dd.mm.yyyy'),
                                                                 'YEAR'),
                                                           'yyyy'),
                              'dd.mm.yyyy') - (trunc(to_date(&< name = "���� �������" >,
                                                             'dd.mm.yyyy'),
                                                     'YEAR') - 1)
                      --�� ����� ���� ������� ��� � �������� ����������� �������� 
                      ,
                      365) "���-�� ���� � �������� ����"
          from (select t.id_tab
                      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
                      ,children
                      ,row_number() over(partition by children order by t.id_tab) rn
                      ,dekr
                      ,data_r
                      ,data_work data_work_zap_1
                  from (select id_tab
                              ,ltrim(sys_connect_by_path(relative,
                                                         ', '),
                                     ', ') children
                              ,dekr
                              ,data_r
                              ,data_work
                          from (select id_tab
                                      ,relative
                                      ,lead(relative) over(partition by id_tab order by data_r) next_one
                                      ,lag(relative) over(partition by id_tab order by data_r) prev_one
                                      ,data_r
                                      ,dekr
                                      ,data_work
                                  from (select fml.id_tab
                                              ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r,
                                                                                                                                   ' (dd.mm.yyyy)') relative
                                              ,max(data_r) over(partition by fml.id_tab) data_r
                                              ,decode(nvl(dekr.id_tab,
                                                          0),
                                                      0,
                                                      0,
                                                      1) dekr
                                              ,f2.data_work
                                          from qwerty.sp_ka_famil fml
                                              ,qwerty.sp_rod rod
                                              ,(select distinct d.id_tab
                                                  from qwerty.sp_ka_dekr d
                                                      ,qwerty.sp_rb_key  rbk
                                                      ,qwerty.sp_stat    s
                                                 where (d.k_dekr > sysdate and not nvl(date_vid,
                                                                                       sysdate + 1) <= sysdate)
                                                   and d.id_tab = rbk.id_tab
                                                   and rbk.id_stat = s.id_stat) dekr
                                              ,qwerty.sp_kav_perem_f2 f2
                                         where fml.id_rod = rod.id
                                           and fml.id_rod in (5, --���
                                                              6, --����
                                                              7) --������
                                           and months_between(trunc(to_date(&< name = "���� �������" >,
                                                                            'dd.mm.yyyy'),
                                                                    'YEAR'),
                                                              fml.data_r) < (12 * &< name = "���������� ������� ������� �� �.1.1" type = "integer" default = 6 >)
                                           and fml.id_tab = f2.ID_TAB
                                           and f2.id_zap = 1
                                           and f2.DATA_WORK <= to_date(&< name = "���� �������" >,
                                                                       'dd.mm.yyyy')
                                           and fml.id_tab = dekr.id_tab(+)
                                         order by id_tab
                                                 ,data_r
                                                 ,fam_u
                                                 ,f_name_u
                                                 ,s_name_u))
                         where next_one is null
                         start with prev_one is null
                        connect by prior relative = prev_one
                               and prior id_tab = id_tab) t
                       ,qwerty.sp_rb_fio rbf
                 where t.id_tab = rbf.id_tab) t
               ,qwerty.sp_ka_work w
         where rn = 1
           and t.id_tab = w.id_tab) t
       ,qwerty.sp_rb_key rbk
       ,qwerty.sp_stat s
       ,qwerty.sp_podr p
 where instr("����������",
             ',') > 0
   and t."���. �" = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_cex = p.id_cex
 --order by 8
    --     ,2
--*/

--;
union all

-- TAB = �������� � ������ �� 14 ���
-- ������ ��� ������ � �������� 
--   1. ������ ���� �� 14 ���� 
--   2. ��� �����-������� - !!! � ����� �� ����� ������ ��� !!!
select t.id_tab "���. �"
      ,fio "�.�.�."
      ,'�������� ���������: ' || sempol.name_u || '; ' || children "����������"
      ,'1.2' "�����"
      ,'���� � ������ ��� �����, ��� �� ������ � ������ ��� ������ � �������� ������ ���� �� 14 ���� ��� ������-�������' "����� ������"
      ,'���� �������� �� ������: ' || to_char(f2.DATA_WORK, 'dd.mm.yyyy') "�������������� ������"
      ,to_date(&< name = "���� �������" >, 'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), 'YEAR'),
                                      f2.DATA_WORK) + 1 "���-�� ���� � �������� ����"
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative,
                                                 ', '),
                             ', ') children
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                          from (select id_tab
                                      ,lower(rod.name_u) || ': ' || fam_u || ' ' || f_name_u || ' ' || s_name_u || to_char(data_r,
                                                                                                                           ' (dd.mm.yyyy') || '�.�. �������: ' ||
                                       trunc(months_between(trunc(to_date(&< name = "���� �������" >,
                                                                          'dd.mm.yyyy'),
                                                                  'YEAR'),
                                                            data_r) / 12) || ' �� ������ ����)' relative
                                       ,data_r
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 /*���*/,
                                                      6 /*����*/,
                                                      7 /*������*/)
                                   and months_between(trunc(to_date(&< name = "���� �������" type = "string" >,
                                                                    'dd.mm.yyyy'),
                                                            'YEAR'),
                                                      fml.data_r) < (12 * &< name = "���������� ������� ������� �� �.1.2" type = "integer" default = 14 >)
                                 order by id_tab
                                         ,data_r
                                         ,fam_u
                                         ,f_name_u
                                         ,s_name_u))
                 where next_one is null
                 start with prev_one is null
                connect by prior relative = prev_one
                       and prior id_tab = id_tab) t
               ,qwerty.sp_rb_fio rbf
         where t.id_tab = rbf.id_tab) t
       ,qwerty.sp_ka_work w
       ,qwerty.sp_ka_osn osn
       ,qwerty.sp_sempol sempol
       ,qwerty.sp_kav_perem_f2 f2
 where rn = 1
   and t.id_tab = w.id_tab
   and t.id_tab = osn.id_tab
   and osn.id_sempol in (30 /*����-��������*/,
                         40 /*����-��������*/
                         -- !!! ���� ����� ���� ��������, �� �� ����������� ������� ����� � ��� !!!
                        ,
                         --50 /*��������*/,
                         --51 /*���������*/,
                         60 /*�����*/,
                         61 /*������*/)
   and osn.id_sempol = sempol.id
   and t.id_tab = f2.id_tab
   and f2.id_zap = 1
   and f2.data_work <= to_date(&<name="���� �������">, 'dd.mm.yyyy')

--;
union all

-- TAB = �������� � ������ ���������� � �������
-- ������ ��� ������ � �������� 
--   1. ������� � ��������� (��������� �� ���) 
--   2. ��/��� ������� I ����� (��������� �� ������� ����������) - !!! � ����� �� ����� ������ ��� !!!
select distinct rbf.id_tab "���. �"
               ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
               ,'�������� ���������: ' || sempol.name_u || '; ��� ������: ' || pens.name_u "����������"
               ,'1.3' "�����"
               ,'���� � ������ ��� �����, ��� �� ������ � ������ ��� ������ � �������� ������� � ��������� (��������� �� ���) ��/��� ������� I ����� (��������� �� ������� ����������)' "����� ������"
               ,'���� �������� �� ������: ' || to_char(f2.DATA_WORK, 'dd.mm.yyyy') "�������������� ������"
      ,to_date(&< name = "���� �������" >, 'dd.mm.yyyy') - decode(sign(f2.DATA_WORK - add_months(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), 'YEAR'),
                                      f2.DATA_WORK) + 1 "���-�� ���� � �������� ����"
  from qwerty.sp_ka_work w
      ,qwerty.sp_rb_fio  rbf
      ,qwerty.sp_ka_osn  osn
      ,qwerty.sp_pens    pens
      ,qwerty.sp_sempol  sempol
      ,qwerty.sp_kav_perem_f2 f2
 where w.id_tab = osn.id_tab
   and osn.id_sempol in (30 /*����-��������*/,
                         40 /*����-��������*/,
                         50 /*��������*/,
                         51 /*���������*/,
                         60 /*�����*/,
                         61 /*������*/)
   and osn.id_pens in (52 /*���� ������� �������� � �������*/,
                       56 /*���� ������� �������� � �������*/)
   and w.id_tab = rbf.id_tab
   and osn.id_pens = pens.id
   and osn.id_sempol = sempol.id
   and w.id_tab = f2.id_tab
   and f2.id_zap = 1
   and f2.data_work <= to_date(&<name="���� �������">, 'dd.mm.yyyy') 

--;
union all

-- TAB = �������� ����� ����� ��� ��.���������, ��� ������� ����� ������ ����� ������
--  ������, ��� �������� ��� ��������� �������� � ��������������, ���������-�������� � ����� ���������� �������� 
--  (�������� ����� ������ ���� ��������� ��� ���������� ��������) � ��� ������ ���������� �� ������
select TAB_ID "���. �"
       ,FIO "�.�.�."
       ,REMARK "����������"
       ,PUNKT "�����"
       ,PUNKT_TEXT "����� ������"
       ,'���� �������� �� ������: ' || to_char(DATA_WORK, 'dd.mm.yyyy') || ', ������� ����� �������� �� ������: ' || DIFF_WORK || '; ���� ��������� ���: ' || ltrim(sys_connect_by_path(DATA_FINISH, '; '), '; ') || ', ������� ����� ��������� ���: ' || DIFF_OBR "�������������� ������"
       --,ltrim(sys_connect_by_path(DATA_FINISH,
       --                          '; '),
       --      '; ') "���� ��������� ���"
       --,DIFF_OBR "������� ����� ��������� ���"
       --,DIFF_WORK "������� ����� ����� �� ������"
       ,to_date(&< name = "���� �������" >, 'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), 'YEAR'),
                                      DATA_WORK) + 1 "���-�� ���� � �������� ����"
  from (select distinct rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'���������� ����� ������: ' || osn.pred_work || '; ����: ' || nvl(osn.publ_sta,
                                                                                          0) || '�. ' || nvl(osn.publ_sta_m,
                                                                                                             0) || '�. ' || nvl(osn.publ_sta_d,
                                                                                                                                0) || '�.' REMARK
                       ,'5.1' PUNKT
                       ,'������, ��� �������� ��� ��������� �������� � ��������������, ���������-�������� � ����� ���������� �������� ... (�������� ����� ������ ���� ��������� ��� ���������� ��������) � ��� ������ ���������� �� ������' PUNKT_TEXT
                       ,f2.DATA_WORK DATA_WORK
                       ,to_char(obr.data_ok,
                                'dd.mm.yyyy') DATA_FINISH
                       ,lag(obr.data_ok) over(partition by obr.id_tab order by obr.data_ok) PREV_DATA_FINISH
                       ,lead(obr.data_ok) over(partition by obr.id_tab order by obr.data_ok) NEXT_DATA_FINISH
                       ,round(months_between(f2.data_work,
                                             obr.data_ok),
                              1) DIFF_OBR
                       ,round(months_between(to_date(&< name = "���� �������" type = "string" >,
                                                     'dd.mm.yyyy'),
                                             f2.data_work),
                              1) DIFF_WORK
          from qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
              ,qwerty.sp_ka_osn       osn
              ,qwerty.sp_rb_fio       rbf
              ,qwerty.sp_ka_obr       obr
         where f2.id_tab = wrk.id_tab
           and osn.id_tab = wrk.id_tab
              --������ � ������� ��������� 3-� ���
           and f2.id_zap = 1
           and months_between(to_date(&< name = "���� �������" type = "string" >,
                                      'dd.mm.yyyy'),
                              f2.data_work) <= 36
              --�������� - �� 35 ��� (35*12=420)
           and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                                'dd.mm.yyyy'),
                                        -35 * 12)
              --and f2.nam_work <> '�p������'
           and nvl(osn.publ_sta,
                   0) + nvl(osn.publ_sta_m,
                            0) + nvl(osn.publ_sta_d,
                                     0) = 0
              --������ ������� ����� - ���������� �������� ����� "�����"
           and lower(osn.pred_work) like '%�����%'
           and f2.id_tab = rbf.id_tab
           and f2.id_tab = obr.id_tab
              --������ ������� �����������       
           and obr.id_vidobr = 1
              --������� �� ��������� �������� �� ����� �� ������
           and months_between(f2.data_work,
                              obr.data_ok) between 0 and 6)
 where NEXT_DATA_FINISH is null
 start with PREV_DATA_FINISH is null
connect by prior DATA_FINISH = PREV_DATA_FINISH
       and prior TAB_ID = TAB_ID
-- order by 2

--;
union all

-- TAB = �������� ����� �����, ��� ������� ����� ������ ����� ������
-- ������, ��� ���������� �� �������� ������� ��� ������������� (���������) ������ 
--  (�������� ����� ������ ���� ��������� ��� ���������� ������)
select TAB_ID "���. �"
       ,FIO "�.�.�."
       ,REMARK "����������"
       ,PUNKT "�����"
       ,PUNKT_TEXT "����� ������"
       ,'���� �������� �� ������: ' || to_char(DATA_WORK, 'dd.mm.yyyy') || ', ������� ����� ����� �� ������: ' || DIFF_WORK || '; ���� ��������� ������: ' || to_char(DATE_FINISH, 'dd.mm.yyyy') || ', ������� ����� ��������� ������: ' || DIFF_VSU "�������������� ������"
       --,DATA_WORK "���� �������� �� ������"
       --,DATE_FINISH "���� ��������� ������"
       --,DIFF_VSU "������� ����� ��������� ������"
       --,DIFF_WORK "������� ����� ����� �� ������"
       ,to_date(&< name = "���� �������" >, 'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), 'YEAR'),
                                      DATA_WORK) + 1 "���-�� ���� � �������� ����"
  from (select distinct rbf.id_tab TAB_ID
                       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u FIO
                       ,'���������� ����� ������: ' || osn.pred_work || '; ����: ' || nvl(osn.publ_sta,
                                                                                          0) || '�. ' || nvl(osn.publ_sta_m,
                                                                                                             0) || '�. ' || nvl(osn.publ_sta_d,
                                                                                                                                0) || '�.' REMARK
                       ,'5.2' PUNKT
                       ,'������, ��� ���������� �� �������� ������� ��� ������������� (���������) ������ (�������� ����� ������ ���� ��������� ��� ���������� ������)' PUNKT_TEXT
                       ,f2.data_work DATA_WORK
                       ,round(months_between(to_date(&< name = "���� �������" type = "string" >,
                                                     'dd.mm.yyyy'),
                                             f2.data_work),
                              1) DIFF_WORK
                        ,osn.DATE_FINISH
                        ,round(months_between(f2.data_work,
                                             osn.DATE_FINISH),
                              1) DIFF_VSU
          from qwerty.sp_kav_perem_f2 f2
              ,qwerty.sp_ka_work      wrk
               --,qwerty.sp_ka_osn       osn
              ,(select id_tab
                      ,publ_sta
                      ,publ_sta_m
                      ,publ_sta_d
                      ,data_r
                      ,pred_work
                      ,no_char
                      ,decode(instr(no_char,
                                    '-'),
                              0,
                              to_date(substr(no_char,
                                             1,
                                             8),
                                      'ddmmyyyy'),
                              to_date(substr(no_char,
                                             instr(no_char,
                                                   '-') + 1,
                                             8),
                                      'ddmmyyyy')) DATE_FINISH
                  from (select id_tab
                              ,publ_sta
                              ,publ_sta_m
                              ,publ_sta_d
                              ,data_r
                              ,pred_work
                               
                              ,trim(translate(pred_work,
                                              '0123456789-.�������������������������������������Ũ�������������������������� ',
                                              '0123456789-')) no_char
                          from qwerty.sp_ka_osn)) osn
              ,qwerty.sp_rb_fio rbf
         where f2.id_tab = wrk.id_tab
              
              --and osn2.id_tab = wrk.id_tab
              --������ � ������� ��������� 3-� ���
           and f2.id_zap = 1
           and months_between(to_date(&< name = "���� �������" type = "string" >,
                                      'dd.mm.yyyy'),
                              f2.data_work) <= 36
           and osn.id_tab = wrk.id_tab
              --�������� - �� 35 ��� (35*12=420)              
           and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                                'dd.mm.yyyy'),
                                        -35 * 12)
              --� ������� �������� ����� ���������� �� �����
           and months_between(f2.data_work,
                              osn.DATE_FINISH) between 0 and 6
              --and f2.nam_work <> '�p������'
           and nvl(osn.publ_sta,
                   0) + nvl(osn.publ_sta_m,
                            0) + nvl(osn.publ_sta_d,
                                     0) = 0
              --������ ������� ����� - ���������� �������� ����� "������ �"
           and lower(osn.pred_work) like '%������ �%'
           and f2.id_tab = rbf.id_tab)
-- order by 2
 
--;
union all

-- TAB = ��������� ��������������� ��������
-- �����, ���� �� �������� ����� �� ����� �� ���� �������� �� ����� 26 ������ ������ "��� ������������'������ �������� ������� �����������" ���������� 10 � ����� ����
select distinct rbf.id_tab "���. �"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
                ,'�������, ���: ' || to_char(trunc(age / 12)) || '; �� ������, ���: ' || abs(round(till_pens / 12)) || '; ���: ' || pol "����������"
                ,'6' "�����"
                ,'�����, ���� �� �������� ����� �� ����� �� ���� �������� �� ����� 26 ������ ������ "��� ������������''������ �������� ������� �����������" ���������� 10 � ����� ����' "����� ������"
                ,'���� �������� �� ������: ' || to_char(DATA_WORK, 'dd.mm.yyyy') "�������������� ������"
                ,to_date(&< name = "���� �������" >, 'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), -12)),
                                      -1,
                                      trunc(to_date(&< name = "���� �������" >, 'dd.mm.yyyy'), 'YEAR'),
                                      DATA_WORK) + 1 "���-�� ���� � �������� ����"
  from (select id_tab
              ,age
              ,age - pens_age till_pens
              ,decode(id_pol,
                      1,
                      '�',
                      2,
                      '�',
                      '?') pol
              ,DATA_WORK
          from (select osn.*
                      ,months_between(to_date(&< name = "���� �������" type = "string" >,
                                              'dd.mm.yyyy') - 1,
                                      osn.data_r) age
                       ,decode(osn.id_pol,
                              1,
                              &<         name = "���������� ������� ��� ������ (�.5, 6)" type = "float" default = 60 >,
                              2,
                              &<         name = "���������� ������� ��� ������ (�.5, 6)" type = "float" default = 60 /*"56,5"*/ >) * 12 pens_age
                       ,f2.DATA_WORK DATA_WORK
                  from qwerty.sp_ka_work      w
                      ,qwerty.sp_ka_osn       osn
                      ,qwerty.sp_kav_perem_f2 f2
                 where w.id_tab = osn.id_tab
                   and w.id_work <> 61
                   and w.id_tab = f2.id_tab
                   and f2.id_zap = 1)) t
       ,qwerty.sp_rb_fio rbf
 where till_pens between (-12 * &< name = "���������� ��� �� ������ (�.5, 6)" type = "integer" default = "10" >) /*��� ��� �������*/
       and 0
   and t.id_tab = rbf.id_tab

/*--;
union all

-- TAB = �������� ������������� ��������
-- �������, �� �� ������� ��������� ���, �������������� ������� 26 ������ ������ "��� ������������'������ �������� ������� �����������"
select distinct rbf.id_tab "���. �"
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
                ,'�������, ���: ' || to_char(trunc(age / 12)) || '; ������������: ' || name_pens "����������"
                ,'6' "�����"
                ,'�������, �� �� ������� ��������� ���, �������������� ������� 26 ������ ������ "��� ������������''������ �������� ������� �����������"' "����� ������"
                ,DATA_WORK "���� �������� �� ������"
                ,to_date('31.12.' || &< name = "�������� ���" type = "string" default = "select to_char(sysdate-365, 'yyyy') from dual" >,
               'dd.mm.yyyy') - decode(sign(DATA_WORK - add_months(to_date('31.12.' || &< name = "�������� ���" >,
                                                                          'dd.mm.yyyy'),
                                                                  -12)),
                                      -1,
                                      to_date('01.01.' || &< name = "�������� ���" >,
                                              'dd.mm.yyyy'),
                                      DATA_WORK) + 1 "���-�� ���� � �������� ����"
  from (select osn.*
  
              ,months_between(to_date(&< name = "���� �������" >,
                                      'dd.mm.yyyy') - 1,
                              osn.data_r) - decode(osn.id_pol,
                                                   1,
                                                   &< name = "���������� ������� ��� ������ (�.5, 6)" >,
                                                   2,
                                                   &< name = "���������� ������� ��� ������ (�.5, 6)" >) * 12 before_pens_age
               ,months_between(to_date(&< name = "���� �������" >,
                                      'dd.mm.yyyy') - 1,
                              osn.data_r) age                              
               ,pens.name_u name_pens
               ,f2.DATA_WORK DATA_WORK
          from qwerty.sp_ka_work w
              ,qwerty.sp_ka_osn  osn
              ,qwerty.sp_pens    pens
              ,qwerty.sp_kav_perem_f2 f2
         where w.id_tab = osn.id_tab
           and osn.id_pens in (9 \*������� � ������� 1 ������*\,
                               12 \*������� 2 ������ ������ �����.-������.����*\,
                               21 \*������� �p��� 2 �p����*\,
                               22 \*������� �p��� 3 �p����*\,
                               23 \*������� ���.���. 3�p.,����.2-� �������� ������p��*\,
                               24 \*������� ���.���. 2�p.,����.2-� �������� ������p��*\,
                               25 \*������� � �������,����. 1 �����.������p��*\,
                               30 \*������� ������ ����������� 1 �p����*\,
                               31 \*������� ������ ����������� 2 �p����*\,
                               32 \*������� ������ ����������� 3 �p����*\,
                               33 \*������� ��*\,
                               34 \*������� � �������*\,
                               35 \*������� ������������� �����*\,
                               36 \*������� (��p������)*\,
                               37 \*������� �� �p�p�����. � ��������� ���*\,
                               --52 \*���� ������� �������� � �������*\,
                               --56 \*���� ������� �������� � �������*\,
                               59 \*�� 2,������� ������ ����������� 3 ������*\,
                               60 \*��������� 2 ������ ������������*\,
                               61 \*������� 3 ������ �� ������.�������*\,
                               62 \*������� � ������� 2 ������*\,
                               63 \*������� � ������� 3 ������*\,
                               64 \*������� 2 ������, �������� ��� ����������� ������*\)
           and w.id_work <> 61
           and osn.id_pens = pens.id
           and w.id_tab = f2.id_tab
           and f2.id_zap = 1) t
       ,qwerty.sp_rb_fio rbf
 where before_pens_age < -12 * &< name = "���������� ��� �� ������ (�.5, 6)" >
   and t.id_tab = rbf.id_tab
 order by 4
         ,2*/
) vyborka       
order by 4, 2 
