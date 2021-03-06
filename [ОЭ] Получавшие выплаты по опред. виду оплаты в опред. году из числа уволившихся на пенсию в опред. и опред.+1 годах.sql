-- ����������� �� ������ �� ������ �� 2006 ���
--��� ������ �� ������ - 2005 (����������� � 2006)
--��� ������� - 2006
--��� ������ - 18
select gmr,
       sm,
       tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
  from qwerty.sp_zar_zar13 z13, qwerty.sp_rb_fio rbf
 where tab in (select "���.�"
                 from (select uv.id_tab "���.�",
                              uv.data_uvol "���� ������������",
                              rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                              rbf.s_name_u "�.�.�.",
                              pdr.name_u "���",
                              p.id_a_cex,
                              uv.id_uvol
                         from qwerty.sp_ka_uvol  uv,
                              qwerty.sp_rb_fio   rbf,
                              qwerty.sp_ka_perem p,
                              qwerty.sp_podr     pdr
                        where uv.id_uvol in (30, 36, 69, 70, 71, 79)
                          and (trunc(uv.data_uvol, 'YEAR') = '01.01.&<name="��� ������ �� ������">' or
                              trunc(uv.data_uvol, 'YEAR') =
                              add_months('01.01.&<name="��� ������ �� ������">', 12))
                          and rbf.id_tab = uv.id_tab
                          and p.id_tab = uv.id_tab
                          and p.id_zap = uv.id_zap + (-1 * sign(uv.id_zap))
                          and p.data_kon = uv.data_uvol
                          and pdr.id_cex = p.id_a_cex
                        order by "���", "�.�.�."))
   and gmr between &<name="��� ������">*100+1 and &<name="��� ������">*100+12
   and opl = &<name="��� ������">
   and z13.tab = rbf.id_tab
 order by 1, 4
-- order by 4, 1
