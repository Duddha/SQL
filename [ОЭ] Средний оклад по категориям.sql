-- TAB = ������� ����� �� ����������
-- Excel = ������� ����� �� ����������

-- ��� ����� ���, � ���� ������� ����� (�.�. ���������) [sal_is_null]
 
select id_category "��� ���������"
       ,category "���������"
       ,am_fkt - sal_is_null "���������� ����������"
       ,sm_fkt "����� �������"
       ,sm_fkt / (am_fkt - sal_is_null) "������� �����"
  from (select distinct id_category
                       ,category
                       ,sum(amount_fakt) over(partition by id_category) am_fkt
                       ,sum(summa_fakt) over(partition by id_category) sm_fkt
                       ,sum(sal_is_null) over(partition by id_category) sal_is_null
          from (select distinct id_category
                               ,category
                               ,id_staff
                               ,amount_fakt
                               ,summa_fakt
                               ,sum(salary_is_null) over(partition by id_staff) sal_is_null
                  from (SELECT id_staff
                              ,id_department
                              ,id_category
                              ,category
                              ,id_workplace
                              ,workplace
                              ,NVL(amount,
                                   0) amount
                              ,NVL(kolf,
                                   0) amount_fakt
                              ,degree
                              ,salary
                              ,NVL(summa,
                                   0) summa
                              ,NVL(sum_okl,
                                   0) summa_fakt
                              ,id_profcode
                              ,profcode
                              ,status
                              ,department
                              ,kp.name_l profcode_name
                              ,data_finish
                              ,id_mvz
                              ,name_mvz
                              ,nvl(attestat.name,
                                   '--- �� ����������� --- ') workplace_attestat
                              ,decode(nvl(emp_salary,
                                          0),
                                      0,
                                      1,
                                      0) salary_is_null
                          FROM qwerty.sp_staff_today st
                              ,qwerty.sp_rbv_kolf rbv
                              ,qwerty.sp_kp kp
                              ,(select id_stat stat_id
                                      ,decode(id_prop,
                                              81,
                                              '����������� �� ������ �1',
                                              82,
                                              '����������� �� ������ �2',
                                              83,
                                              '����������� �� ������� �1 � �2') name
                                  from qwerty.sp_st_pr_zar
                                 where id_prop in (81,
                                                   82,
                                                   83)) attestat
                              ,qwerty.sp_employee emp
                         WHERE (rbv.id_stat(+) = id_staff)
                           AND (kp.id_kp(+) = profcode)
                           and (attestat.stat_id(+) = id_staff)
                           and id_staff = emp.id_stat
                           -- ����� ��� ������� �� �����, �.�. ������� �������� ���-�� ���������� � ������� �������
                           --and emp.emp_salary <> 0
                         ORDER BY profcode ASC
                                 ,salary   DESC
                                 ,degree   DESC)))
