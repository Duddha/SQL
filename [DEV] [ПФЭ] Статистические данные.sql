-- TAB = ���������� ���
/*
TODO: owner="bishop" category="Fix" priority="1 - High" created="29.01.2015"
text="������� ���� ������ ��
      - ����������� ����
      - ���������
      - �������� �����
      - ������ �����
      - ������ � ����� (�����������!!!)"
*/
SELECT SUM(decode(tests_this_year
                 ,0
                 ,0
                 ,1)) "�������� �������. � ���� ����"
,SUM(decode(passed_test_this_year
                 ,0
                 ,0
                 ,1)) "������ ���������� ����� ����"                 
      ,SUM(decode(num_of_tests
                 ,0
                 ,0
                 ,1)) "�������� ����������"
      ,COUNT(*) "����� ����������"
  FROM (SELECT decode(nvl(id_wt1
                         ,0)
                     ,0
                     ,0
                     ,decode(trunc(nvl2(wt1_last_test
                                       ,wt1_next_test
                                       ,to_date(&< name = "���� �������" type = "string" hint = "���� � ������� ��.��.����" 
                                       default = "select to_char(sysdate, 'dd.mm.yyyy') from dual">, 'dd.mm.yyyy'))
                                  ,'YEAR')
                            ,trunc(to_date(to_date(&< name = "���� �������">, 'dd.mm.yyyy'), 'dd.mm.yyyy')
                                  ,'YEAR')
                            ,1
                            ,0)) + decode(nvl(id_wt2
                                             ,0)
                                         ,0
                                         ,0
                                         ,decode(trunc(nvl2(wt2_last_test
                                                           ,wt2_next_test
                                                           ,to_date(to_date(&< name = "���� �������">, 'dd.mm.yyyy'), 'dd.mm.yyyy'))
                                                      ,'YEAR')
                                                ,trunc(to_date(&< name = "���� �������">, 'dd.mm.yyyy')
                                                      ,'YEAR')
                                                ,1
                                                ,0)) + decode(nvl(id_wt3
                                                                 ,0)
                                                             ,0
                                                             ,0
                                                             ,decode(trunc(nvl2(wt3_last_test
                                                                               ,wt3_next_test
                                                                               ,to_date(&< name = "���� �������">, 'dd.mm.yyyy'))
                                                                          ,'YEAR')
                                                                    ,trunc(to_date(&< name = "���� �������">, 'dd.mm.yyyy')
                                                                          ,'YEAR')
                                                                    ,1
                                                                    ,0)) tests_this_year -- ������ ������ ������ � ���� ����
               
              ,decode(nvl(id_wt1, 0), 0, 0, decode(trunc(wt1_last_test, 'YEAR'), trunc(to_date(&< name = "���� �������">, 'dd.mm.yyyy'), 'YEAR'), 1, 0)) + 
               decode(nvl(id_wt2, 0), 0, 0, decode(trunc(wt2_last_test, 'YEAR'), trunc(to_date(&< name = "���� �������">, 'dd.mm.yyyy'), 'YEAR'), 1, 0)) +
               decode(nvl(id_wt3, 0), 0, 0, decode(trunc(wt3_last_test, 'YEAR'), trunc(to_date(&< name = "���� �������">, 'dd.mm.yyyy'), 'YEAR'), 1, 0)) passed_test_this_year -- ������ ���� � ���� ����
              ,decode(nvl(id_wt1
                         ,0)
                     ,0
                     ,0
                     ,1) + decode(nvl(id_wt2
                                     ,0)
                                 ,0
                                 ,0
                                 ,1) + decode(nvl(id_wt3
                                                 ,0)
                                             ,0
                                             ,0
                                             ,1) num_of_tests -- ������ � ��������
              ,prl.*
          FROM qwerty.sp_pfev_results_last prl
        
        )
