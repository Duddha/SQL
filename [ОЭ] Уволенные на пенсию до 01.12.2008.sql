--������ ���������� ��� ��������� ���������� � ��� 2009 ����.
--���������� �������� �� ��� ���������: ���� �� 6 �� 15 ���,
--                                      ���� ����� 15 ���
--������ ��, ��� ��� ������ �� ������ � 01.12.2009 �� ������ ���� ������� � ���� ������,
-- �.�. ����� �� ������ ������������� ��� ��, ��� � ������� ���������� ������
select pa.id_tab "���. �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       case
         when (mod(trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12), 10) between 1 and 4) and
              not
               (trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12) between 11 and 14) then
          trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12) || '�. '
         else
          trunc((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)) / 12) || '�. '
       end || mod((nvl(pa.stag, 0) + nvl(pa.stag_d, 0)), 12) || '�.' "����",
       pa.dat_uvol "���� ������ �� ������"
  from qwerty.sp_ka_pens_all pa, qwerty.sp_rb_fio rbf
 where pa.id_tab not in
       (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and pa.kto <> 7
      
   and (nvl(pa.stag, 0) + nvl(pa.stag_d, 0) >=
       (&< name = "���� ��, ���" ifempty = 0> * 12) and
       nvl(pa.stag, 0) + nvl(pa.stag_d, 0) <
       (&< name = "���� ��, ���" ifempty = 10000 > * 12))
      
   and nvl(pa.dat_uvol,
           to_date('&<name="�� ��������� ��������� �" hint="��.��.����">',
                   'dd.mm.yyyy') - 1) <
       to_date('&<name="�� ��������� ��������� �">',
               'dd.mm.yyyy')
   and rbf.id_tab = pa.id_tab
 order by 2, 4
