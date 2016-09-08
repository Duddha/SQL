--EXCEL = ���������� �� ������������� '������������������ ���������� ���������������� ����������' �� N ���.xls
--TAB = ���������� �� ������������ ������������� �� N ���
select 
  rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u "�.�.�.", 
  p.name_u                                        "���", 
  m.full_name_u                                   "���������", 
  obr.data_dip                                    "���� �������" 
from 
  qwerty.sp_rb_fio rbf, 
  qwerty.sp_rb_key rbk, 
  qwerty.sp_stat   s, 
  qwerty.sp_podr   p, 
  qwerty.sp_mest m,
  (select *
     from qwerty.sp_ka_obr obr
    where id_spobr = 1780
      and id_uchzav in
          (&< name = "������� ���������" 
              list = "select uz.id, pnkt.snam_u || s.name_u || ': ' || uz.name_u || ' [' || uz.id ||']' vuz 
                        from qwerty.sp_uchzav uz, 
                             qwerty.sp_sity   s,
                             qwerty.sp_punkt  pnkt  
                       where uz.id_syti = s.id    
                         and s.id_punkt = pnkt.id  
                    order by s.name_u, uz.name_u"
              description = "yes" 
              multiselect = "yes" >)
     and months_between(to_date(&< name = "���� �������" type = "string" hint = "���� � ������� '��.��.����'" default = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >,
                                'dd.mm.yyyy'),
                        data_dip) <= &< name = "���������� ��� ��� �������" type = "integer" > * 12) obr
where obr.id_tab = rbf.id_tab
and rbf.id_tab = rbk.id_tab
and rbk.id_stat = s.id_stat                                      
and s.id_cex = p.id_cex
and s.id_mest = m.id_mest
order by 4, 1
