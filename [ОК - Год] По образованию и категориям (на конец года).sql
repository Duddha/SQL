--&DATE - ��������� ���� ����
select OBR_NAME "�����������",
       sum(1) "�����",
       sum(FEMALE) "������",
       sum(RUK) "������������",
       sum(PROF) "�������������",
       sum(SPEC) "�����������",
       sum(RAB_SF_TBU) "���-�� ����� ����",
       sum(KV_RAB_SX) "����. ���. ��",
       sum(KV_RAB_S_INST) "����. ���. � ����.",
       sum(OPER) "���������",
       sum(TEX_SL) "����. ��������",
       sum(PROST) "�����. ���-��"
  from (select rbf.id_tab ID_TAB,
               obr.name_u OBR_NAME,
               decode(osn.id_pol, 2, 1, 0) FEMALE,
               decode(kat.id_kat, 1, 1, 0) RUK,
               decode(kat.id_kat, 2, 1, 0) PROF,
               decode(kat.id_kat, 3, 1, 0) SPEC,
               decode(kat.id_kat, 4, 1, 0) TEX_SL,
               decode(kat.id_kat, 5, 1, 0) RAB_SF_TBU,
               decode(kat.id_kat, 6, 1, 0) KV_RAB_SX,
               decode(kat.id_kat, 7, 1, 0) KV_RAB_S_INST,
               decode(kat.id_kat, 8, 1, 0) OPER,
               decode(kat.id_kat, 9, 1, 0) PROST
          from qwerty.sp_rb_fio rbf,
               qwerty.sp_rb_key rbk,
               qwerty.sp_stat st,
               qwerty.sp_kat kat,
               qwerty.sp_ka_osn osn,
               (select id_tab, id_obr
                  from qwerty.sp_ka_obr o1
                 where data_ok = (select max(data_ok)
                                    from qwerty.sp_ka_obr
                                   where id_tab = o1.id_tab)) kobr,
               (select id,
                       decode(id, 14, id, decode(parent_id, 0, id, parent_id)) par_id
                  from qwerty.sp_obr) obr2,
               qwerty.sp_obr obr
         where rbf.id_tab in
               (select id_tab
                  from qwerty.sp_ka_work
                union all
                select id_tab
                  from qwerty.sp_ka_uvol
                 where data_uvol > to_date('&DATE', 'dd.mm.yyyy')
                minus
                select id_tab
                  from qwerty.sp_ka_work
                 where id_zap = 1
                   and data_work > to_date('&DATE', 'dd.mm.yyyy'))
           and rbk.id_tab = rbf.id_tab
           and st.id_stat = rbk.id_stat
           and kat.id_kat = st.id_kat
           and osn.id_tab = rbf.id_tab
           and kobr.id_tab = rbf.id_tab
           and obr2.id = kobr.id_obr
           and obr.id = obr2.par_id
        union all
        select dd.id_tab,
               obr.name_u,
               decode(osn.id_pol, 2, 1, 0) female,
               decode(ak.name_u, '������������', 1, 0) RUK,
               decode(ak.name_u, '�p�����������', 1, 0) PROF,
               decode(ak.name_u, '�����������', 1, 0) SPEC,
               decode(ak.name_u,
                      '����������� ��������',
                      1,
                      0) TEX_SL,
               decode(ak.name_u,
                      '��������� ���p� ��p����� � ������� �����',
                      1,
                      0) RAB_SF_TBU,
               decode(ak.name_u,
                      '���������p������� p�������� ��������� ���������',
                      1,
                      0) KV_RAB_SX,
               decode(ak.name_u,
                      '���������p������� p�������� � ����p�������',
                      1,
                      0) KV_RAB_S_INST,
               decode(ak.name_u,
                      '���p���p� � ���p���� ���p�������� � �����',
                      1,
                      0) OPER,
               decode(ak.name_u,
                      '�p�������� �p�������',
                      1,
                      0) PROST
          from (select id_tab, id_zap
                  from qwerty.sp_ka_uvol
                 where data_uvol > to_date('&DATE', 'dd.mm.yyyy')) dd,
               qwerty.sp_ka_perem p,
               qwerty.sp_arx_kat ak,
               qwerty.sp_ka_osn osn,
               (select id_tab, id_obr
                  from qwerty.sp_ka_obr o1
                 where data_ok = (select max(data_ok)
                                    from qwerty.sp_ka_obr
                                   where id_tab = o1.id_tab)) kobr,
               (select id,
                       decode(id, 14, id, decode(parent_id, 0, id, parent_id)) par_id
                  from qwerty.sp_obr) obr2,
               qwerty.sp_obr obr
         where p.id_tab = dd.id_tab
           and p.id_zap = dd.id_zap - 1
           and ak.id = p.id_n_kat
           and osn.id_tab = dd.id_tab
           and kobr.id_tab = dd.id_tab
           and obr2.id = kobr.id_obr
           and obr.id = obr2.par_id)
 group by OBR_NAME
--
union all
--
select '�����:',
       sum(1) "�����",
       sum(FEMALE) "������",
       sum(RUK) "������������",
       sum(PROF) "�������������",
       sum(SPEC) "�����������",
       sum(RAB_SF_TBU) "���-�� ����� ����",
       sum(KV_RAB_SX) "����. ���. ��",
       sum(KV_RAB_S_INST) "����. ���. � ����.",
       sum(OPER) "���������",
       sum(TEX_SL) "����. ��������",
       sum(PROST) "�����. ���-��"
  from (select rbf.id_tab ID_TAB,
               obr.name_u OBR_NAME,
               decode(osn.id_pol, 2, 1, 0) FEMALE,
               decode(kat.id_kat, 1, 1, 0) RUK,
               decode(kat.id_kat, 2, 1, 0) PROF,
               decode(kat.id_kat, 3, 1, 0) SPEC,
               decode(kat.id_kat, 4, 1, 0) TEX_SL,
               decode(kat.id_kat, 5, 1, 0) RAB_SF_TBU,
               decode(kat.id_kat, 6, 1, 0) KV_RAB_SX,
               decode(kat.id_kat, 7, 1, 0) KV_RAB_S_INST,
               decode(kat.id_kat, 8, 1, 0) OPER,
               decode(kat.id_kat, 9, 1, 0) PROST
          from qwerty.sp_rb_fio rbf,
               qwerty.sp_rb_key rbk,
               qwerty.sp_stat st,
               qwerty.sp_kat kat,
               qwerty.sp_ka_osn osn,
               (select id_tab, id_obr
                  from qwerty.sp_ka_obr o1
                 where data_ok = (select max(data_ok)
                                    from qwerty.sp_ka_obr
                                   where id_tab = o1.id_tab)) kobr,
               (select id,
                       decode(id, 14, id, decode(parent_id, 0, id, parent_id)) par_id
                  from qwerty.sp_obr) obr2,
               qwerty.sp_obr obr
         where rbf.id_tab in
               (select id_tab
                  from qwerty.sp_ka_work
                union all
                select id_tab
                  from qwerty.sp_ka_uvol
                 where data_uvol > to_date('&DATE', 'dd.mm.yyyy')
                minus
                select id_tab
                  from qwerty.sp_ka_work
                 where id_zap = 1
                   and data_work > to_date('&DATE', 'dd.mm.yyyy'))
           and rbk.id_tab = rbf.id_tab
           and st.id_stat = rbk.id_stat
           and kat.id_kat = st.id_kat
           and osn.id_tab = rbf.id_tab
           and kobr.id_tab = rbf.id_tab
           and obr2.id = kobr.id_obr
           and obr.id = obr2.par_id
        union all
        select dd.id_tab,
               obr.name_u,
               decode(osn.id_pol, 2, 1, 0) female,
               decode(ak.name_u, '������������', 1, 0) RUK,
               decode(ak.name_u, '�p�����������', 1, 0) PROF,
               decode(ak.name_u, '�����������', 1, 0) SPEC,
               decode(ak.name_u,
                      '����������� ��������',
                      1,
                      0) TEX_SL,
               decode(ak.name_u,
                      '��������� ���p� ��p����� � ������� �����',
                      1,
                      0) RAB_SF_TBU,
               decode(ak.name_u,
                      '���������p������� p�������� ��������� ���������',
                      1,
                      0) KV_RAB_SX,
               decode(ak.name_u,
                      '���������p������� p�������� � ����p�������',
                      1,
                      0) KV_RAB_S_INST,
               decode(ak.name_u,
                      '���p���p� � ���p���� ���p�������� � �����',
                      1,
                      0) OPER,
               decode(ak.name_u,
                      '�p�������� �p�������',
                      1,
                      0) PROST
          from (select id_tab, id_zap
                  from qwerty.sp_ka_uvol
                 where data_uvol > to_date('&DATE', 'dd.mm.yyyy')) dd,
               qwerty.sp_ka_perem p,
               qwerty.sp_arx_kat ak,
               qwerty.sp_ka_osn osn,
               (select id_tab, id_obr
                  from qwerty.sp_ka_obr o1
                 where data_ok = (select max(data_ok)
                                    from qwerty.sp_ka_obr
                                   where id_tab = o1.id_tab)) kobr,
               (select id,
                       decode(id, 14, id, decode(parent_id, 0, id, parent_id)) par_id
                  from qwerty.sp_obr) obr2,
               qwerty.sp_obr obr
         where p.id_tab = dd.id_tab
           and p.id_zap = dd.id_zap - 1
           and ak.id = p.id_n_kat
           and osn.id_tab = dd.id_tab
           and kobr.id_tab = dd.id_tab
           and obr2.id = kobr.id_obr
           and obr.id = obr2.par_id)
