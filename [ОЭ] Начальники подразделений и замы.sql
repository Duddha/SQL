--Tab=���������� �����
--***����� ����� 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       mst.full_name_u "���������",
       p.name_u "���",
       rbf.id_tab "���. �",
       sw.oklad "�����",
       s.id_stat "��� ��"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ����� ����� 1
--***���������� �����***
   and sw.oklad = (select max(sww.oklad)
                     from qwerty.sp_zar_swork sww,
                          qwerty.sp_rb_key    rbkk,
                          qwerty.sp_stat      stt
                    where rbkk.id_tab = sww.id_tab
                      and stt.id_stat = rbkk.id_stat
                      and stt.id_cex = s.id_cex)
--***end of ���������� �����***                      
--*      
--***����������� �� �����***
/*   and s.id_cex <> 1000
   and (lower(mst.name_u) like '%����������� ����������%' or
       s.id_stat in (9008, 8357, 11512, 12742, 697, 1356))*/
--***end of ����������� �� �����***       
--*      
--***����������� �� ��***
   /*and s.id_cex = 1000
   and lower(mst.name_u) like '�����������%'*/
--***end of ����������� �� ��***   
--*      
--***���������� �� ��***
   /*and s.id_cex = 1000
   and lower(mst.name_u) like '���������%'*/
--***end of ���������� �� ��***   
--***����� ����� 2 (�� �����)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1;

--TAB=����������� �� ����� 
--***����� ����� 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       mst.full_name_u "���������",
       p.name_u "���",
       rbf.id_tab "���. �",
       sw.oklad "�����",
       s.id_stat "��� ��"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ����� ����� 1
--***����������� �� �����***
   and s.id_cex <> 1000
   and (lower(mst.name_u) like '%����������� ����������%' or
       s.id_stat in (9008, 8357, 11512, 12742, 697, 1356))
--***end of ����������� �� �����***       
--***����� ����� 2 (�� �����)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1;
 
--Tab=����������� �� �� 
--***����� ����� 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       mst.full_name_u "���������",
       p.name_u "���",
       rbf.id_tab "���. �",
       sw.oklad "�����",
       s.id_stat "��� ��"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ����� ����� 1
--***����������� �� ��***
   and s.id_cex = 1000
   and lower(mst.name_u) like '�����������%'
--***end of ����������� �� ��***   
--***����� ����� 2 (�� �����)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1;

--Tab=���������� �� �� 
--***����� ����� 1***
select rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       mst.full_name_u "���������",
       p.name_u "���",
       rbf.id_tab "���. �",
       sw.oklad "�����",
       s.id_stat "��� ��"
  from qwerty.sp_rb_fio    rbf,
       qwerty.sp_stat      s,
       qwerty.sp_rb_key    rbk,
       qwerty.sp_mest      mst,
       qwerty.sp_podr      p,
       qwerty.sp_zar_swork sw
 where rbf.status = 1
   and rbk.id_tab = rbf.id_tab
   and s.id_stat = rbk.id_stat
   and mst.id_mest = s.id_mest
   and sw.id_tab = rbf.id_tab
--***end of ����� ����� 1
--***���������� �� ��***
   and s.id_cex = 1000
   and ((lower(mst.name_u) like '%���������%') or (lower(mst.name_u) like '%�������%')) and not (lower(mst.name_u) like '%������%')
--***end of ���������� �� ��***   
--***����� ����� 2 (�� �����)
   and p.id_cex = s.id_cex
 order by p.id_cex, 1
