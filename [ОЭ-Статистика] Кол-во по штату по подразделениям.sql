select s.id_cex "��� ����", p.name_u "��������", sum(s.koli)
  from qwerty.sp_stat s, qwerty.sp_podr p
 where s.id_cex = p.id_cex
 group by s.id_cex, p.name_u
 order by 1
