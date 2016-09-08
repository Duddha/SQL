-- TAB = ���������� �� ������ �� 15-�� ��� � ����� 15-�� ��� (��� ������� � ��������)
SELECT pens.id_tab, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u fio--, pens.dat_uvol
  FROM qwerty.sp_ka_pens_all pens, qwerty.sp_rb_fio rbf
 WHERE &<name = "���������" list = "select 'nvl(stag, 0) + nvl(stag_d, 0) < 15 * 12 AND nvl(stag, 0) + nvl(stag_d, 0) >= 6 * 12', '���� �� 15 ���' from dual
                                    union all
                                    select 'nvl(stag, 0) + nvl(stag_d, 0) >= 15 * 12', '���� ����� 15 ���' from dual"
                            description = "yes">
 AND pens.id_tab NOT IN (SELECT id_tab
                       FROM qwerty.sp_ka_lost
                      WHERE lost_type IN (1
                                         ,2))
 AND pens.id_tab = rbf.id_tab                                         
 ORDER BY pens.id_tab
