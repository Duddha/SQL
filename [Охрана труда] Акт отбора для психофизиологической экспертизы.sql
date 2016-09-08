--TAB = ��� ������ (���������)
select "��� ����",
       "������������ ����",
       "���������",
       "���������",
       count(id_tab) "���������� ����������",
       "��� ���������",
       --"����������� ���� ���������",
       '' "��� ������"
  from (select s.id_cex      "��� ����",
               p.name_u      "������������ ����",
               s.id_kat      "���������",
               m.full_name_u "���������",
               rbk.id_tab,
               s.id_kp       "��� ���������",
               kp.name_l     "����������� ���� ���������"
          from qwerty.sp_stat   s,
               qwerty.sp_podr   p,
               qwerty.sp_mest   m,
               qwerty.sp_kp     kp,
               qwerty.sp_rb_key rbk
         where s.id_kat in (5, 6, 7, 8)
           and p.id_cex(+) = s.id_cex
           and m.id_mest(+) = s.id_mest
           and kp.id_kp(+) = s.id_kp
           and rbk.id_stat = s.id_stat
         order by s.id_cex, s.id_kp)
 group by "��� ����",
          "������������ ����",
          "���������",
          "���������",
          "��� ���������",
          "����������� ���� ���������";
--TAB = ��� ������ (� ������) 
select s.id_cex "��� ����",
       p.name_u "������������ ����",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       decode(osn.id_pol, 1, '�', 2, '�', '???') "���",
       to_char(osn.DATA_R, 'dd.mm.yyyy') "���� ��������",
       --to_char(osn.DATA_R, 'yyyy') "��� ��������",
       decode(nvl(osnn.id_nalog, '-'), '-', to_char(osn.id_nalog),
              osnn.id_nalog) "����������������� ���",
       s.id_kat "���������",
       m.full_name_u "���������",
       s.id_kp "��� ���������",
       --kp.name_l "����������� ���� ���������",
       '' "��� ������",
       decode(w.years, 0, w.months || ' ���.', w.years) "�� ���� ���������, ���"
  from qwerty.sp_stat s,
       qwerty.sp_podr p,
       qwerty.sp_mest m,
       qwerty.sp_kp kp,
       qwerty.sp_rb_key rbk,
       qwerty.sp_rb_fio rbf,
       (select id_tab,
               trunc(months_between(sysdate, data_work_first) / 12) years,
               trunc(mod(months_between(sysdate, data_work_first), 12)) months
          from (select id_tab, data_work_first
                  from (select id_tab,
                               data_work,
                               first_value(data_work) over(partition by id_tab, floor(id_kp) order by id_tab, data_work RANGE UNBOUNDED PRECEDING) data_work_first,
                               id_kp,
                               fl
                          from (select w.id_tab, w.data_work, s.id_kp, 1 fl
                                  from qwerty.sp_ka_work w,
                                       qwerty.sp_rb_key  rbk,
                                       qwerty.sp_stat    s
                                 where rbk.id_stat = s.id_stat
                                   and w.id_tab = rbk.id_tab
                                union all
                                select id_tab, data_work, id_a_kp, 2
                                  from qwerty.sp_ka_perem
                                 where id_zap > 0)
                         order by id_tab, data_work)
                 where fl = 1)) w,
       qwerty.sp_ka_osn osn,
       qwerty.sp_ka_osn_nalog osnn
 where s.id_kat in (5, 6, 7, 8)
   and p.id_cex(+) = s.id_cex
   and m.id_mest(+) = s.id_mest
   and kp.id_kp(+) = s.id_kp
   and rbk.id_stat = s.id_stat
   and rbf.id_tab = rbk.id_tab
   and w.id_tab = rbk.id_tab
   and osn.id_tab = rbk.id_tab
   and osnn.id_tab(+) = rbk.id_tab
 order by 1, 6, 2
