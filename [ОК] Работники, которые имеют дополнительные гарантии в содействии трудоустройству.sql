-- EXCEL = ��������, ������� ����� �������������� �������� � ���������� ���������������.xls
select &<name = "������� �������" list = "select 'distinct ""�����"", ""�������� ������"", count(*) over(partition by ""�����"") ""����������""', '���������� �� �������' from dual 
                                         union all 
                                         select 'distinct ""���. �"", ""�.�.�.""', '���������� ��������� ������' from dual
                                         union all
                                         select '*', '��� ������' from dual"
                           default = "*"
                           description = "yes" >
from (
-- TAB = � ������ �� 6 ���
-- ���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ����
select t.id_tab "���. �"
       ,fio "�.�.�."
       ,children "����������"
       ,'1.1' "�����"
       ,'���� � ������ ��� �����, ��� �� ������ � �� �� �������� ���� ���� �� ����� ����' "�������� ������"
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative, ', '), ', ') children
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                          from (select id_tab
                                      ,lower(rod.name_u) || ': ' || 
                                                   fam_u || ' ' || f_name_u || ' ' || s_name_u || 
                                                   to_char(data_r,' (dd.mm.yyyy)') relative
                                      ,data_r
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 /*���*/,
                                                      6 /*����*/,
                                                      7 /*������*/)
                                   and months_between(to_date(&< name = "���� �������" type = "string" required = "yes" default = "select to_char(trunc(sysdate, 'MONTH'), 'dd.mm.yyyy') from dual" >,'dd.mm.yyyy'),
                                                      fml.data_r) < (12 * &< name = "���������� ������� ������� �� �.1.1" type = "integer" default = 6 >)
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

union all

-- TAB = �������� � ������ �� 14 ���
-- ������ ��� ������ � �������� 
--   1. ������ ���� �� 14 ���� 
--   2. ��� �����-������� - !!! � ����� �� ����� ������ ��� !!!
select t.id_tab
       ,fio
       ,'�������� ���������: ' || sempol.name_u || '; ' || children
       ,'1.2.1'
       ,'������ ��� ������ � �������� ������ ���� �� 14 ���� ��� �����-�������'
  from (select t.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,children
              ,row_number() over(partition by children order by t.id_tab) rn
          from (select id_tab
                      ,ltrim(sys_connect_by_path(relative, ', '), ', ') children
                  from (select id_tab
                              ,relative
                              ,lead(relative) over(partition by id_tab order by data_r) next_one
                              ,lag(relative) over(partition by id_tab order by data_r) prev_one
                          from (select id_tab
                                      ,lower(rod.name_u) || ': ' || 
                                                   fam_u || ' ' || f_name_u || ' ' || s_name_u || 
                                                   to_char(data_r,' (dd.mm.yyyy)') relative
                                      ,data_r
                                  from qwerty.sp_ka_famil fml
                                      ,qwerty.sp_rod      rod
                                 where fml.id_rod = rod.id
                                   and fml.id_rod in (5 /*���*/,
                                                      6 /*����*/,
                                                      7 /*������*/)
                                   and months_between(to_date(&< name = "���� �������" type = "string" >,'dd.mm.yyyy'),
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
 where rn = 1
   and t.id_tab = w.id_tab
   and t.id_tab = osn.id_tab
   and osn.id_sempol in (30 /*����-��������*/,
                         40 /*����-��������*/
                         -- !!! ���� ����� ���� ��������, �� �� ����������� ������� ����� � ��� !!!
                        ,
                         50 /*��������*/,
                         51 /*���������*/,
                         60 /*�����*/,
                         61 /*������*/)
   and osn.id_sempol = sempol.id

union all

-- TAB = �������� � ������ ���������� � �������
-- ������ ��� ������ � �������� 
--   1. ������� � ��������� (��������� �� ���) 
--   2. ��/��� ������� I ����� (��������� �� ������� ����������) - !!! � ����� �� ����� ������ ��� !!!
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'�������� ���������: ' || sempol.name_u || '; ��� ������: ' || pens.name_u
                ,'1.3.1'
                ,'������ ��� ������ � �������� ������� � ��������� (��������� �� ���) ��/��� ������� I ����� (��������� �� ������� ����������)'
  from qwerty.sp_ka_work w
      ,qwerty.sp_rb_fio  rbf
      ,qwerty.sp_ka_osn  osn
      ,qwerty.sp_pens    pens
      ,qwerty.sp_sempol  sempol
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

union all

-- TAB = �������� ����� ����� ��� ��.���������, ��� ������� ����� ������ ����� ������
-- ������, ��� �������� ��� ��������� �������� � ��������������, ���������-�������� � ����� ���������� �������� ([�������� ����� ������ ���� ��������� ��� ���������� ��������]) � ��� ������ ���������� �� ������
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'���������� ����� ������: ' || osn.pred_work || 
                 '; ����: ' || nvl(osn.publ_sta, 0) || '�. ' || 
                               nvl(osn.publ_sta_m, 0) || '�. ' || 
                               nvl(osn.publ_sta_d, 0) || '�.'
                ,'4.1'
                ,'������, ��� �������� ��� ��������� �������� � ��������������, ���������-�������� � ����� ���������� �������� ([�������� ����� ������ ���� ��������� ��� ���������� ��������]) � ��� ������ ���������� �� ������'
  from qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_ka_work      wrk
      ,qwerty.sp_ka_osn       osn
      ,qwerty.sp_rb_fio       rbf
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
      --������ � �������� ����
   and f2.id_zap = 1
   and trunc(f2.data_work,
             'YEAR') = trunc(to_date(&< name = "���� �������" >,
                                     'dd.mm.yyyy'),
                             'YEAR')
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

union all

-- TAB = �������� ����� �����, ��� ������� ����� ������ ����� ������
-- ������, ��� ���������� �� �������� ������� ��� ������������� (���������) ������ ([�������� ����� ������ ���� ��������� ��� ���������� ������])
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'���������� ����� ������: ' || osn.pred_work || 
                 '; ����: ' || nvl(osn.publ_sta, 0) || '�. ' || 
                               nvl(osn.publ_sta_m, 0) || '�. ' || 
                               nvl(osn.publ_sta_d, 0) || '�.'
                ,'4.2'
                ,'������, ��� ���������� �� �������� ������� ��� ������������� (���������) ������ ([�������� ����� ������ ���� ��������� ��� ���������� ������])'
  from qwerty.sp_kav_perem_f2 f2
      ,qwerty.sp_ka_work      wrk
      ,qwerty.sp_ka_osn       osn
      ,qwerty.sp_rb_fio       rbf
 where f2.id_tab = wrk.id_tab
   and osn.id_tab = wrk.id_tab
      --������ � �������� ����
   and f2.id_zap = 1
   and trunc(f2.data_work,
             'YEAR') = trunc(to_date(&< name = "���� �������" >,
                                     'dd.mm.yyyy'),
                             'YEAR')
      --�������� - �� 35 ��� (35*12=420)
   and osn.data_r >= add_months(to_date(&< name = "���� �������" >,
                                        'dd.mm.yyyy'),
                                -35 * 12)
      --and f2.nam_work <> '�p������'
   and nvl(osn.publ_sta,
           0) + nvl(osn.publ_sta_m,
                    0) + nvl(osn.publ_sta_d,
                             0) = 0
      --������ ������� ����� - ���������� �������� ����� "������ �"
   and lower(osn.pred_work) like '%������ �%'
   and f2.id_tab = rbf.id_tab

union all

-- TAB = ��������� ��������������� ��������
-- �����, ���� �� �������� ����� �� ����� �� ���� �������� �� ����� 26 ������ ������ "��� ������������'������ �������� ������� �����������" ���������� 10 � ����� ����
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'�������, ���: ' || to_char(trunc(age / 12)) || '; �� ������, ���: ' || abs(round(till_pens / 12)) || '; ���: ' || pol
                ,'5'
                ,'�����, ���� �� �������� ����� �� ����� �� ���� �������� �� ����� 26 ������ ������ "��� ������������''������ �������� ������� �����������" ���������� 10 � ����� ����'
  from (select id_tab
              ,age
              ,age - pens_age till_pens
              ,decode(id_pol,
                      1, '�',
                      2, '�',
                      '?') pol
          from (select osn.*
                      ,months_between(to_date(&< name = "���� �������" >,
                                              'dd.mm.yyyy') - 1,
                                      osn.data_r) age
                       ,decode(osn.id_pol,
                              1, &< name = "���������� ������� ��� ������ (�.5, 6)" type = "float" default = 60 >,
                              2, &< name = "���������� ������� ��� ������ (�.5, 6)" type = "float" default = "56,5" >) * 12 pens_age
                  from qwerty.sp_ka_work w
                      ,qwerty.sp_ka_osn  osn
                 where w.id_tab = osn.id_tab
                   and w.id_work <> 61)) t
       ,qwerty.sp_rb_fio rbf
 where till_pens between (-12 * &< name = "���������� ��� �� ������ (�.5, 6)" type = "integer" default = "10" >) /*��� ��� �������*/
       and 0
   and t.id_tab = rbf.id_tab

union all

-- TAB = �������� ������������� ��������
-- �������, �� �� ������� ��������� ���, �������������� ������� 26 ������ ������ "��� ������������'������ �������� ������� �����������"
select distinct rbf.id_tab
                ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u
                ,'�������, ���: ' || to_char(trunc(age / 12)) || '; ������������: ' || name_pens
                ,'6'
                ,'�������, �� �� ������� ��������� ���, �������������� ������� 26 ������ ������ "��� ������������''������ �������� ������� �����������"'
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
          from qwerty.sp_ka_work w
              ,qwerty.sp_ka_osn  osn
              ,qwerty.sp_pens    pens
         where w.id_tab = osn.id_tab
           and osn.id_pens in (9 /*������� � ������� 1 ������*/,
                               12 /*������� 2 ������ ������ �����.-������.����*/,
                               21 /*������� �p��� 2 �p����*/,
                               22 /*������� �p��� 3 �p����*/,
                               23 /*������� ���.���. 3�p.,����.2-� �������� ������p��*/,
                               24 /*������� ���.���. 2�p.,����.2-� �������� ������p��*/,
                               25 /*������� � �������,����. 1 �����.������p��*/,
                               30 /*������� ������ ����������� 1 �p����*/,
                               31 /*������� ������ ����������� 2 �p����*/,
                               32 /*������� ������ ����������� 3 �p����*/,
                               33 /*������� ��*/,
                               34 /*������� � �������*/,
                               35 /*������� ������������� �����*/,
                               36 /*������� (��p������)*/,
                               37 /*������� �� �p�p�����. � ��������� ���*/,
                               --52 /*���� ������� �������� � �������*/,
                               --56 /*���� ������� �������� � �������*/,
                               59 /*�� 2,������� ������ ����������� 3 ������*/,
                               60 /*��������� 2 ������ ������������*/,
                               61 /*������� 3 ������ �� ������.�������*/,
                               62 /*������� � ������� 2 ������*/,
                               63 /*������� � ������� 3 ������*/,
                               64 /*������� 2 ������, �������� ��� ����������� ������*/)
           and w.id_work <> 61
           and osn.id_pens = pens.id) t
       ,qwerty.sp_rb_fio rbf
 where before_pens_age < -12 * &< name = "���������� ��� �� ������ (�.5, 6)" >
   and t.id_tab = rbf.id_tab
 order by 4
         ,2
)
