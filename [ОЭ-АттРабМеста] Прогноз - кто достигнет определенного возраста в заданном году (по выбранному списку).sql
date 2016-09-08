-- �� ������������� ������� ������:
--  �� 5 ��� ������ ��� ���������
--  �� ������ 1                  : �������� 50 ���
--  �� ������ 2 � �� ������ 1 � 2: �������� 55 ��� ��� ������ � �������� 50 ��� ��� ������
with ttt as
 (select rbk.id_tab,
         prop.id_prop,
         osn.id_pol,
         osn.data_r,
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

select '&<name = "��� �������">' "���", count(id_tab) "����������"
  from ttt
 where id_prop = &< name = "������" list = "81, �� ������ 1, 82, �� ������ 2, 83, �� ������� 1 � 2" description = "yes" >
   and id_pol = &< name = "���" list = "1,2" type = "string">
   and months_between(to_date('31.12.&<name = "��� �������">', 'dd.mm.yyyy'), data_r) >=
       12 * &< name = "���������� ���" list = "50, 55" >
