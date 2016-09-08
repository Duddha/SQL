-- TAB = ��������
-- RECORDS = ALL

-- 04.07.2014
-- �������� ���������� ��� - ����������� �� �����������, ����������� � ����� �� ����

-- 08.12.2015
-- ��� ��������� � ���������� �� �������� ��������� "��� ��������" ����� ��������������� WITH

with calculation_form as (select tab "���. �"
      ,opl "��� ���� ������"
      ,spvid.name_ful "��� ������"
      ,case
         when opl between 209 and 298 then
           '          �� ����'
         when spvid.pid_vid = 998 then
           '          ���������'
         when spvid.pid_vid = 999 then
           '          ����������'
         else
           '������'
       end "���"
      ,sm "�����"      
      ,'' " "
      ,zar.*
  from QWERTY.SP_ZAR_ZAR13 zar
      ,QWERTY.SP_ZAR_SPVID_R spvid
 where tab = &<name = "���. �" 
               type = "integer" 
               hint = "��������� ����� ���������, �������� �������� ������� ����������"
               list = "select id_tab, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u fio from qwerty.sp_rb_fio rbf order by 2"
               description = "yes" 
               default = "4875">
   and gmr = (select to_number(&< name = "���" hint = "��� � ������� ����" type = "string"
                                  --list = "select distinct gg from qwerty.sp_zar_zar13" 
                                  list = "select rownum + 1994 mon from (select null 
                                                                           from dual 
                                                                        connect by 1 = 1 
                                                                               and prior dbms_random.value is not null) 
                                           where rownum < = to_number(to_char(sysdate, 'yyyy') - 1994)"
                                  default = "select to_number(to_char(sysdate, 'yyyy')) from dual" 
                                > || 
                                lpad(&< name = "�����" type = "string" 
                                        list = "select rownum, to_char(to_date(lpad(to_char(rownum), 2, '0'), 'mm'), 'month') from dual connect by level <= 12" 
                                        description = "yes" 
                                        default = "select to_number(to_char(add_months(sysdate, -1), 'mm')) from dual" 
                                      >
                                      , 2, '0')
                                    ) 
               from dual)
    and zar.opl = spvid.id_vid(+)
    order by 2) 
    
&< name = "��� ��������" 
   list = "select 'select ""���. �""
                         ,""��� ���� ������""
                         ,decode(grouping(""��� ������"")
                         ,1
                         ,""���""
                         ,0
                         ,""��� ������"") ""���""
                         ,decode(grouping(""��� ������"")
                                         ,0
                                         ,""�����""
                                         ,sum(""�����"")) ""�����"" 
                   from (select * from calculation_form) 
                   group by grouping sets ((""���""), (""���. �"", ""��� ���� ������"", ""��� ������"", ""���"", ""�����""))', '����������' 
             from dual
           union all
           select 'select * from calculation_form', '�����������' from dual"
   default = "select 'select * from calculation_form' from dual"
   description = "yes">
