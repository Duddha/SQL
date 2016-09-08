select p.name_u "���",
       m.full_name_u "���������",
       max(s.oklad) "����. �����",
       min(s.oklad) "���. �����",
       sum(s.oklad*s.koli)/sum(s.koli) "�����. �����",
       sum(s.koli) "���������� �� �����"
  from qwerty.sp_stat s, qwerty.sp_mest m, qwerty.sp_podr p
 where m.id_mest = s.id_mest
   and p.id_cex = s.id_cex
   and s.koli<>0
 group by p.name_u, m.full_name_u
 order by 1, 2
