--YEAR - ��� �������
select DEPT_NAME "���", sum(VSE) "�����", sum(FEMALE) "������",
       sum(UV28) "�� ��������", sum(UV29) "� �����", sum(UV30) "�� ������", 
       sum(UV31) "� ����� �� ��.", 
       sum(UV36) "�� ����. �� ���", 
       sum(UV37) "�� ����. �����", sum(UV41) "�������", sum(UV43) "�� ������. ���.", 
       sum(UV49) "�� �����. ��. ����. ����", sum(UV52) "���������� ������", 
       sum(UV53) "��������� ����. �����", sum(UV55) "�� ��. �� ���. �� 14 �", 
       sum(UV69) "�� ����. �� ���. 1��", sum(UV70) "�� ����. �� ���. 2��.", 
       sum(UV71) "�� ����. �� ���. 3��.", sum(UV79) "�� ����. ��. � ����. ����."
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(ID_UVOL, 28, 1, 0) UV28, decode(ID_UVOL, 29, 1, 0) UV29, 
       decode(ID_UVOL, 30, 1, 0) UV30,
       decode(ID_UVOL, 31, 1, 0) UV31, decode(ID_UVOL, 36, 1, 0) UV36,
       decode(ID_UVOL, 37, 1, 0) UV37,
       decode(ID_UVOL, 41, 1, 0) UV41, decode(ID_UVOL, 43, 1, 0) UV43,
       decode(ID_UVOL, 49, 1, 0) UV49, decode(ID_UVOL, 52, 1, 0) UV52,
       decode(ID_UVOL, 53, 1, 0) UV53, decode(ID_UVOL, 55, 1, 0) UV55,
       decode(ID_UVOL, 69, 1, 0) UV69, decode(ID_UVOL, 70, 1, 0) UV70, 
       decode(ID_UVOL, 71, 1, 0) UV71, decode(ID_UVOL, 79, 1, 0) UV79
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
)) group by DEPT_NAME
--
union all
--
select '�����:', sum(VSE) "�����", sum(FEMALE) "������",
       sum(UV28) "�� ��������", sum(UV29) "� �����", sum(UV30) "�� ������", 
       sum(UV31) "� ����� �� ��.", sum(UV36) "�� ����. �� ���", 
       sum(UV37) "�� ����. �����", sum(UV41) "�������", sum(UV43) "�� ������. ���.", 
       sum(UV49) "�� �����. ��. ����. ����", sum(UV52) "���������� ������", 
       sum(UV53) "��������� ����. �����", sum(UV55) "�� ��. �� ���. �� 14 �", 
       sum(UV69) "�� ����. �� ���. 1��", sum(UV70) "�� ����. �� ���. 2��.", 
       sum(UV71) "�� ����. �� ���. 3��.", sum(UV79) "�� ����. ��. � ����. ����."
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(ID_UVOL, 28, 1, 0) UV28, decode(ID_UVOL, 29, 1, 0) UV29, 
       decode(ID_UVOL, 30, 1, 0) UV30,
       decode(ID_UVOL, 31, 1, 0) UV31, decode(ID_UVOL, 36, 1, 0) UV36,
       decode(ID_UVOL, 37, 1, 0) UV37,
       decode(ID_UVOL, 41, 1, 0) UV41, decode(ID_UVOL, 43, 1, 0) UV43,
       decode(ID_UVOL, 49, 1, 0) UV49, decode(ID_UVOL, 52, 1, 0) UV52,
       decode(ID_UVOL, 53, 1, 0) UV53, decode(ID_UVOL, 55, 1, 0) UV55,
       decode(ID_UVOL, 69, 1, 0) UV69, decode(ID_UVOL, 70, 1, 0) UV70, 
       decode(ID_UVOL, 71, 1, 0) UV71, decode(ID_UVOL, 79, 1, 0) UV79
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
))
