--������� ��� ���������� (������ ��� �������� ��������� ����������������� �������� ����������): ���������� �������� �� ������������ ����,  
--� ��������� �� ������� ��������� � � ���������� ���, ��� ������ 45 ���
-- ������ ���������:
--   ��������� - ��������� ���p� ��p����� � ������� �����, ���������p������� p�������� ��������� ���������, 
--               ���������p������� p�������� � ����p�������, ���p���p� � ���p���� ���p�������� � �����
--   ��������  - ������������, �������������, �����������, ����������� ��������
--   ���������, ������� �� ������� ���������������� ���������� - ���������� ���������

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
  from (
        --��� ����������� ����� �� "��� ����������� ��������� � �����, ���������� � ����������.sql"
        select a.dept_name "���",
                a.mest_name "���������",
                a.id_tab "���. �",
                rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
                trunc(months_between(to_date('&<name="���� �������" hint="��.��.����">',
                                             'dd.mm.yyyy'),
                                     osn.data_r) / 12) age_years,
                decode(sign(months_between(to_date('&<name="���� �������" hint="��.��.����">',
                                                   'dd.mm.yyyy'),
                                           osn.data_r) - 45 * 12),
                       1,
                       1,
                       -1,
                       0,
                       0,
                       0,
                       3) age_kat,
                a.id_kat,
                decode(id_kat,
                       1,
                       2,
                       2,
                       2,
                       3,
                       2,
                       4,
                       2,
                       5,
                       1,
                       6,
                       1,
                       7,
                       1,
                       8,
                       1,
                       9,
                       3,
                       -1) kat,
                osn.id_pol,
                a.id_zap
          from (select id_tab,
                        id_zap,
                        data_zap,
                        id_work,
                        data_work,
                        decode(fl,
                               1,
                               /*to_date('&<name="���� �������">',
                               'dd.mm.yyyy') + 1,*/
                               sysdate + 1,
                               2,
                               lead(data_work)
                               over(partition by id_tab order by data_work) - 1,
                               3,
                               data_kon) data_kon, --��� ���������� � ���� ������� - ��������� ���� ����� �������,
                        --��� ������������ - ���������� ���� ����� ������������ (����� �����������, ��������� � ���� �������, �� ������������ � �����������)
                        --��� ��������� - ���� ����������
                        id_prikaz,
                        razr,
                        id_priem_perem,
                        id_cex,
                        dept_name,
                        id_kat,
                        kat_name,
                        id_mest,
                        mest_name,
                        fl
                   from (select w.id_tab, --���. �
                                w.id_zap, --� ������
                                w.data_zap, --���� ������
                                w.id_work, --��� ������
                                w.data_work, --���� ������ ������
                                w.data_kon_w  data_kon, --���� ��������� ������
                                w.id_prikaz, --����� �������, � ������/�������� �� ������ ������� �����
                                w.razr, --������
                                osn.id_priem  id_priem_perem, --��� ������/�����������
                                s.id_cex, --��� ����
                                pdr.name_u    dept_name, --�������� ����
                                s.id_kat, --��� ���������
                                kat.name_u    kat_name, --�������� ���������
                                s.id_mest, --��� �������� �����
                                m.full_name_u mest_name, --�������� �������� ����� (���������)
                                1             fl --����: 1-������� ����� ������, 2-�����������, 3-����������
                           from qwerty.sp_ka_work w,
                                qwerty.sp_rb_key  rbk,
                                qwerty.sp_stat    s,
                                qwerty.sp_ka_osn  osn,
                                qwerty.sp_podr    pdr,
                                qwerty.sp_kat     kat,
                                qwerty.sp_mest    m
                          where w.id_tab = rbk.id_tab
                            and rbk.id_stat = s.id_stat
                            and w.id_tab = osn.id_tab
                            and s.id_cex = pdr.id_cex
                            and s.id_kat = kat.id_kat
                            and s.id_mest = m.id_mest
                         union all
                         select prm.id_tab,
                                prm.id_zap,
                                prm.data_zap,
                                prm.id_work,
                                prm.data_work,
                                prm.data_kon,
                                prm.id_prikaz,
                                prm.a_razr,
                                prm.id_perem,
                                prm.id_a_cex,
                                acex.name_u,
                                prm.id_a_kat,
                                akat.name_u,
                                prm.id_a_mest,
                                decode(nvl(amest.full_name, ''),
                                       '',
                                       amest.name_u,
                                       amest.full_name),
                                2
                           from qwerty.sp_ka_perem prm,
                                qwerty.sp_arx_cex  acex,
                                qwerty.sp_arx_kat  akat,
                                qwerty.sp_arx_mest amest
                          where prm.id_n_cex = acex.id
                            and prm.id_n_kat = akat.id
                            and prm.id_n_mest = amest.id
                         union all
                         select u.id_tab,
                                u.id_zap,
                                u.data_zap,
                                u.id_uvol,
                                u.data_uvol,
                                u.data_uvol,
                                u.id_prikaz,
                                -99,
                                -99,
                                -99,
                                '-?-',
                                -99,
                                '-?-',
                                -99,
                                '-?-',
                                3
                           from qwerty.sp_ka_uvol u)) a,
                qwerty.sp_rb_fio rbf,
                qwerty.sp_ka_osn osn
         where to_date('&<name="���� �������" hint="��.��.����">',
                       'dd.mm.yyyy') between a.data_work and a.data_kon
           and a.id_tab = rbf.id_tab
           and a.fl <> 3
           and a.id_tab = osn.id_tab
         order by 1, 4) --where id_zap = 1
 group by kat
