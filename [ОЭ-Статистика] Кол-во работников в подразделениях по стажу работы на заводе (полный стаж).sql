select id_cex "��� ����",
       name_u "��������",
       sum(decode(st, 1, 1, 0)) "�� 1 �.",
       sum(decode(st, 2, 1, 0)) "�� 1 �. �� 3 �.",
       sum(decode(st, 3, 1, 0)) "�� 3 �. �� 5 �.",
       sum(decode(st, 4, 1, 0)) "�� 5 �. �� 10 �.",
       sum(decode(st, 5, 1, 0)) "�� 10 �. �� 15 �.",
       sum(decode(st, 6, 1, 0)) "�� 15 �. �� 20 �.",
       sum(decode(st, 7, 1, 0)) "�� 20 �. �� 25 �.",
       sum(decode(st, 8, 1, 0)) "�� 25 �. �� 30 �.",
       sum(decode(st, 9, 1, 0)) "�� 30 �. �� 35 �.",
       sum(decode(st, 10, 1, 0)) "����� 35 �."
  from (select id_cex,
               name_u,
               case
                 when stag < 1 then
                  1
                 when stag >= 1 and stag < 3 then
                  2
                 when stag >= 3 and stag < 5 then
                  3
                 when stag >= 5 and stag < 10 then
                  4
                 when stag >= 10 and stag < 15 then
                  5
                 when stag >= 15 and stag < 20 then
                  6
                 when stag >= 20 and stag < 25 then
                  7
                 when stag >= 25 and stag < 30 then
                  8
                 when stag >= 30 and stag < 35 then
                  9
                 when stag >= 35 then
                  10
               end st
          from (select s.id_cex,
                       p.name_u,
                       (stg.sum_sta_day + months_between(sysdate, sta.data)) / 12 stag
                  from qwerty.sp_stat                 s,
                       qwerty.sp_rb_key               rbk,
                       qwerty.sp_kav_sta_opz_itog_fio stg,
                       qwerty.SP_ZAR_DATA_Stag        sta,
                       qwerty.sp_podr                 p
                 where s.id_stat = rbk.id_stat
                   and rbk.id_tab = stg.id_tab
                   and s.id_cex = p.id_cex
                   and nvl(stg.sum_sta_day, -1) <> -1))
 group by id_cex, name_u
 order by 1
