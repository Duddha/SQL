-- �� ������������� ������� ������:
--  1�� ������: ������� (� ������� ?) �� ������ ������ 10 ��� � ������ 50 ���
--  2�� � 1�� � 2�� ������: ������� �� ������ ������ 12,5 ��� � ������ 55 ���
--                        : ������� �� ������ ������ 10 ��� � ������ 50 ���                
with ttt as
 (select rbk.id_tab,
         prop.id_prop,
         osn.id_pol,
         nvl(round(sum_sta_day - months_between(sta.data, sysdate)), 0) sta_m,
         nvl(round(months_between(sysdate, osn.data_r)), 0) age
    from qwerty.sp_st_pr_zar            prop,
         qwerty.sp_stat                 s,
         qwerty.sp_rb_key               rbk,
         qwerty.sp_ka_osn               osn,
         qwerty.sp_kav_sta_opz_itog_all it,
         qwerty.sp_zar_data_stag        sta
  
   where prop.id_prop in (81, 82, 83)
     and s.id_stat = prop.id_stat
     and rbk.id_stat = s.id_stat
     and osn.id_tab(+) = rbk.id_tab
     and rbk.id_tab = it.id_tab
   order by id_prop, id_pol)

select decode(id_prop, 81, '�� ������ 1', 82, '�� ������ 2', 83,
              '�� ������� 1 � 2', '?') "������",
       decode(id_pol, 1, '���', 2, '���', '?') "���",
       sum(flag) "����������"
  from (select id_tab,
               id_prop,
               id_pol,
               trunc(sta_m / 12) sta,
               trunc(age / 12) age,
               flag
          from (select id_tab,
                       id_prop,
                       id_pol,
                       sta_m,
                       age,
                       decode(id_prop, 81, 
                              decode(sign(sta_m - 120), 1,
                                      decode(sign(age - 600), -1, 1, 0), 0), 82,
                              decode(id_pol, 1,
                                      decode(sign(sta_m - 150), 1,
                                              decode(sign(age - 660), -1, 1, 0), 0),
                                      2,
                                      decode(sign(sta_m - 120), 1,
                                              decode(sign(age - 600), -1, 1, 0), 0)),
                              83,
                              decode(id_pol, 1,
                                      decode(sign(sta_m - 150), 1,
                                              decode(sign(age - 660), -1, 1, 0), 0),
                                      2,
                                      decode(sign(sta_m - 120), 1,
                                              decode(sign(age - 600), -1, 1, 0), 0))) flag
                  from ttt)
         order by id_prop, id_pol, sta desc, age)
 group by id_prop, id_pol
