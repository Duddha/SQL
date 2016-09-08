--������� ��� ���������� (������ ��� �������� ��������� ����������������� �������� ����������): ���������, ��������� � ������������ ����,  
--� ��������� �� ������� ��������� � � ���������� ���, ��� ������ 45 ���, �� ����� ����
-- ������ ���������:
--   ��������� - ��������� ���p� ��p����� � ������� �����, ���������p������� p�������� ��������� ���������, 
--               ���������p������� p�������� � ����p�������, ���p���p� � ���p���� ���p�������� � �����
--   ��������  - ������������, �������������, �����������, ����������� ��������
--   ���������, ������� �� ������� ���������������� ���������� - ���������� ���������

--YEAR - ��� �������
select decode(kat,
              1,
              '���������',
              2,
              '��������',
              3,
              '������. ����',
              '???') "���������",
       count(*) "�����",
       sum(age_kat) "45 ��� � ������"
  from (select id_tab,
               decode(KAT,
                      '������������',
                      2,
                      '�p�����������',
                      2,
                      '�����������',
                      2,
                      '����������� ��������',
                      2,
                      '��������� ���p� ��p����� � ������� �����',
                      1,
                      '���������p������� p�������� ��������� ���������',
                      1,
                      '���������p������� p�������� � ����p�������',
                      1,
                      '���p���p� � ���p���� ���p�������� � �����',
                      1,
                      '�p�������� �p�������',
                      3,
                      0) kat,
               decode(age_kat, -1, 0, 1, 1, 0, 1) age_kat
          from (select u.id_tab ID_TAB,
                       u.id_uvol ID_UVOL,
                       osn.id_pol ID_POL,
                       ac.name_u DEPT_NAME,
                       ak.name_u KAT,
                       p.id_work ID_WORK,
                       sign(months_between(to_date('31.12.&YEAR',
                                                   'dd.mm.yyyy'),
                                           osn.data_r) - 45 * 12) age_kat
                  from qwerty.sp_ka_uvol  u,
                       qwerty.sp_ka_osn   osn,
                       qwerty.sp_ka_perem p,
                       qwerty.sp_arx_cex  ac,
                       qwerty.sp_arx_kat  ak
                 where trunc(u.data_uvol, 'YEAR') =
                       to_date('01.01.&YEAR', 'dd.mm.yyyy')
                   and osn.id_tab = u.id_tab
                   and p.id_tab = u.id_tab
                   and abs(p.id_zap) = abs(u.id_zap) - 1
                   and p.data_kon = u.data_uvol
                   and ac.id = p.id_n_cex
                   and ak.id = p.id_n_kat))
 group by kat
