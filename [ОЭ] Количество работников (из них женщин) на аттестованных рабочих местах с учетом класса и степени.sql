-- TAB = ���������� ���������� (�� ��� ������) �� ������������� ������� ������ � ������ ������ � �������
-- Excel = ���������� ���������� (�� ��� ������) �� ������������� ������� ������ � ������ ������ � ������� (���� ������� %date%).xls
select *
  from (select distinct attestat_name "����������"
                        ,klass_name "�����"
                        ,stepen_name "�������"
                        ,count(s.id_stat) over(partition by attestat_name, klass_name, stepen_name) "���������� ������� ������"
                        ,count(distinct s.id_cex * 100000 + s.id_mest) over(partition by attestat_name, klass_name, stepen_name) "���������� ������� ����"
                        ,sum(emp.emp_total) over(partition by attestat_name, klass_name, stepen_name) "����� ����������"
                        ,sum(emp.emp_female) over(partition by attestat_name, klass_name, stepen_name) "�� ��� ������"
                        ,attestat "��� ����������"
                        ,klass "��� ����������"
                        ,stepen "��� �������"
          from qwerty.sp_stat s
              ,qwerty.sp_mest m
              ,(select st1.id_stat
                      ,st1.id_prop attestat
                      ,st1.name    attestat_name
                      ,st2.id_prop klass
                      ,st2.name    klass_name
                      ,st3.id_prop stepen
                      ,st3.name    stepen_name
                  from (select *
                          from qwerty.sp_st_pr_zar   stpr
                              ,qwerty.sp_prop_st_zar prop
                         where stpr.id_prop = prop.id
                           and prop.id in (81,
                                           82,
                                           83)) st1
                      ,(select *
                          from qwerty.sp_st_pr_zar   stpr
                              ,qwerty.sp_prop_st_zar prop
                         where stpr.id_prop = prop.id
                           and prop.id in (84,
                                           85,
                                           86)) st2
                      ,(select *
                          from qwerty.sp_st_pr_zar   stpr
                              ,qwerty.sp_prop_st_zar prop
                         where stpr.id_prop = prop.id
                           and prop.id in (87,
                                           88,
                                           89)) st3
                 where st1.id_stat = st2.id_stat
                   and st1.id_stat = st3.id_stat) att
              ,(select distinct id_stat
                               ,count(id_tab) over(partition by id_stat) emp_total
                               ,sum(male) over(partition by id_stat) emp_male
                               ,sum(female) over(partition by id_stat) emp_female
                  from (select rbk.id_stat
                              ,rbk.id_tab
                              ,decode(osn.id_pol,
                                      1,
                                      1,
                                      0) male
                              ,decode(osn.id_pol,
                                      2,
                                      1,
                                      0) female
                          from qwerty.sp_rb_key rbk
                              ,qwerty.sp_ka_osn osn
                         where rbk.id_tab = osn.id_tab)) emp
         where s.id_mest = m.id_mest
           and s.id_stat = att.id_stat
           and s.id_stat = emp.id_stat(+))
 order by 8
         ,9
         ,10
