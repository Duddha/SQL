/*
������� � ������� ��������������� �������� (�� ������������� ���� ��������):
  ���������� �� ������� ���������
  � ������� ���� ��������������� ������ �� ������
*/
select decode(stag_grp,
              1,
              '������ 6 ���',
              2,
              '�� 6 �� 15 ���',
              3,
              '�� 15 �� 25 ���',
              4,
              '����� 25 ���',
              '???') "����",
       count(*) "���-��"
  from (select rbf.id_tab "���. �",
               rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
               stg.stag_m "����",
               case
                 when stg.stag_m < 72 then
                  1
                 when (stg.stag_m >= 72 and stg.stag_m < 15 * 12) then
                  2
                 when (stg.stag_m >= 15 * 12 and stg.stag_m < 25 * 12) then
                  3
                 when stg.stag_m >= 25 * 12 then
                  4
               end stag_grp,
               osn.data_r "���� ��������",
               to_char(osn.data_r, 'YYYY') "��� ��������",
               trunc(months_between(to_date('&<name="���� �������">',
                                            'dd.mm.yyyy'),
                                    osn.data_r) / 12) "�������",
               rbf.ID_CEX "��� ����",
               dep.name_u "���",
               wp.full_name_u "���������",
               wrk.id_work "��� ���� ������",
               vw.name_u "��� ������"
          from qwerty.sp_rbv_tab rbf,
               qwerty.sp_ka_osn osn,
               qwerty.sp_podr dep,
               qwerty.sp_mest wp,
               qwerty.sp_ka_work wrk,
               qwerty.sp_vid_work vw,
               (select id_tab,
                       nvl(round(sum_sta_day -
                                 months_between(sta.data,
                                                to_date(&<
                                                        name =
                                                        "���� ������ �� ������"
                                                        type = "string" >,
                                                        'dd.mm.yyyy'))),
                           0) stag_m
                  from qwerty.sp_kav_sta_opz_itog_all it,
                       qwerty.SP_ZAR_DATA_Stag        sta) stg
         where rbf.status = 1
           and osn.id_pol = 1
           and osn.id_tab = rbf.id_tab
           and months_between(to_date('&<name="���� �������">',
                                      'dd.mm.yyyy'),
                              osn.data_r) between &<
         name = "������� ��� ������ �..."
         default = 58 > * 12
           and (&< name = "������� ��� ������ ��..." default = 100 >) * 12
           and dep.id_cex = rbf.ID_CEX
           and wp.id_mest = rbf.ID_MEST
           and wrk.id_tab = rbf.ID_TAB
           and wrk.id_work in
               (&< name = "���� �����" default = "60, 63, 66, 67, 76, 83" >)
           and wrk.id_work = vw.id
           and to_number(to_char(osn.data_r, 'YYYY')) <= 1951
           and rbf.id_tab = stg.id_tab
         order by osn.data_r, 2)
 group by stag_grp;
--�������
select decode(stag_grp,
              1,
              '������ 6 ���',
              2,
              '�� 6 �� 15 ���',
              3,
              '�� 15 �� 25 ���',
              4,
              '����� 25 ���',
              '???') "����",
       count(*) "���-��"
  from (select rbf.id_tab "���. �",
               rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "�.�.�.",
               stg.stag_m "����",
               case
                 when stg.stag_m < 72 then
                  1
                 when (stg.stag_m >= 72 and stg.stag_m < 15 * 12) then
                  2
                 when (stg.stag_m >= 15 * 12 and stg.stag_m < 25 * 12) then
                  3
                 when stg.stag_m >= 25 * 12 then
                  4
               end stag_grp,
               osn.data_r "���� ��������",
               to_char(osn.data_r, 'YYYY') "��� ��������",
               trunc(months_between(to_date('&<name="���� �������" >',
                                            'dd.mm.yyyy'),
                                    osn.data_r) / 12) "�������",
               rbf.ID_CEX "��� ����",
               dep.name_u "���",
               wp.full_name_u "���������",
               wrk.id_work "��� ���� ������",
               vw.name_u "��� ������"
          from qwerty.sp_rbv_tab rbf,
               qwerty.sp_ka_osn osn,
               qwerty.sp_podr dep,
               qwerty.sp_mest wp,
               qwerty.sp_ka_work wrk,
               qwerty.sp_vid_work vw,
               (select id_tab,
                       nvl(round(sum_sta_day -
                                 months_between(sta.data,
                                                to_date(&<
                                                        name =
                                                        "���� ������ �� ������"
                                                        type = "string" >,
                                                        'dd.mm.yyyy'))),
                           0) stag_m
                  from qwerty.sp_kav_sta_opz_itog_all it,
                       qwerty.SP_ZAR_DATA_Stag        sta) stg
         where rbf.status = 1
           and osn.id_pol = 2
           and osn.id_tab = rbf.id_tab
           and months_between(to_date('&<name="���� �������">',
                                      'dd.mm.yyyy'),
                              osn.data_r) between &<
         name = "������� ��� ������ �..."
         default = 53 > * 12
           and (&< name = "������� ��� ������ ��..." default = 100 >) * 12
           and dep.id_cex = rbf.ID_CEX
           and wp.id_mest = rbf.ID_MEST
           and wrk.id_tab = rbf.ID_TAB
           and wrk.id_work in
               (&< name = "���� �����" default = "60, 63, 66, 67, 76, 83" >)
           and wrk.id_work = vw.id
           and to_number(to_char(osn.data_r, 'YYYY')) <= 1956
           and rbf.id_tab = stg.id_tab
         order by osn.data_r, 2)
 group by stag_grp
