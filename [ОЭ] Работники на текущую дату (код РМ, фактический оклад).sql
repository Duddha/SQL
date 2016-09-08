-- TAB = ��������� �� ������� ���� (��� ��, ����������� �����)
select name_u      "���",
       id_tab      "���.�",
       fio         "�.�.�.",
       full_name_u "���������",
       id_stat     "��� ��",
       oklad       "����. �����"
  from (select rbf.id_tab,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               p.name_u,
               m.full_name_u,
               s.id_stat,
               sw.oklad
          from qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_rb_fio    rbf,
               qwerty.sp_mest      m,
               qwerty.sp_podr      p,
               qwerty.sp_zar_swork sw
         where s.id_stat = rbk.id_stat
           and rbk.id_tab = rbf.id_tab
           and s.id_mest = m.id_mest
           and s.id_cex = p.id_cex
           and rbk.id_tab = sw.id_tab)
 order by name_u, fio
