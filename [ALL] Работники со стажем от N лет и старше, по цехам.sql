select dept_name "���",
       id_tab "���. �",
       fio "�.�.�.",
       decode(sta_years,
              1,
              sta_years || '�. ' || sta_months || '�.',
              2,
              sta_years || '�. ' || sta_months || '�.',
              3,
              sta_years || '�. ' || sta_months || '�.',
              4,
              sta_years || '�. ' || sta_months || '�.',
              21,
              sta_years || '�. ' || sta_months || '�.',
              22,
              sta_years || '�. ' || sta_months || '�.',
              23,
              sta_years || '�. ' || sta_months || '�.',
              24,
              sta_years || '�. ' || sta_months || '�.',
              31,
              sta_years || '�. ' || sta_months || '�.',
              32,
              sta_years || '�. ' || sta_months || '�.',
              33,
              sta_years || '�. ' || sta_months || '�.',
              34,
              sta_years || '�. ' || sta_months || '�.',
              sta_years || '�. ' || sta_months || '�.') "����",
       --sum_sta,
       data_priem "���� �����"
  from (select p.name_u dept_name,
               rbf.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               f2.data_work data_priem,
               trunc((sta.sum_sta_day - sd.stag_dif) / 12) sta_years,
               trunc(mod((sta.sum_sta_day - sd.stag_dif), 12)) sta_months,
               sta.sum_sta_day sum_sta
          from qwerty.sp_rb_fio rbf,
               qwerty.sp_rb_key rbk,
               qwerty.sp_stat s,
               qwerty.sp_podr p,
               qwerty.sp_kav_perem_f2 f2,
               qwerty.sp_kav_sta_opz_itog sta,
               (select months_between(data,
                                      to_date(&< name = "���� �������"
                                              type = "string"
                                              hint = "��.��.����" >,
                                              'dd.mm.yyyy')) stag_dif
                  from qwerty.sp_zar_data_stag) sd
         where rbf.id_tab = rbk.id_tab
           and rbk.id_stat = s.id_stat
           and s.id_cex = p.id_cex
           and rbf.id_tab = f2.id_tab
           and f2.id_zap = 1
           and rbf.id_tab = sta.id_tab
           and sta.sum_sta_day - sd.stag_dif >= &<
         name = "�������� ����, ������� �"
         hint = "����������� ���-�� ���" type = "integer" > * 12
         order by 1, 3)
