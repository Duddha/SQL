--YEAR - ��� �������
select DEPT_NAME "���", sum(VSE) "�����", sum(FEMALE) "������",
       sum(RUK) "������������", sum(PROF) "�������������", 
       sum(SPEC) "�����������", sum(TEX_SL) "������. ��������", sum(RAB_SF_TiBU) "���. ��. ����. � ��", 
       sum(RAB_SX) "����. ���. ��", sum(RAB_S_INSTRU) "����. ���. � ������.", 
       sum(OPER) "��������� � ��������", sum(PROST) "���������� ���������",
       sum(VREM) "��������", sum(SOVM) "������������"
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(KAT, '������������', 1, 0) RUK, decode(KAT, '�p�����������', 1, 0) PROF, 
       decode(KAT, '�����������', 1, 0) SPEC, decode(KAT, '����������� ��������', 1, 0) TEX_SL,
       decode(KAT, '��������� ���p� ��p����� � ������� �����', 1, 0) RAB_SF_TiBU, 
       decode(KAT, '���������p������� p�������� ��������� ���������', 1, 0) RAB_SX, 
       decode(KAT, '���������p������� p�������� � ����p�������', 1, 0) RAB_S_INSTRU, 
       decode(KAT, '���p���p� � ���p���� ���p�������� � �����', 1, 0) OPER, 
       decode(KAT, '�p�������� �p�������', 1, 0) PROST,
       decode(ID_WORK, 61, 1, 0) VREM, decode(ID_WORK, 62, 1, 0) SOVM
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME, ak.name_u KAT, p.id_work ID_WORK
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_arx_kat ak
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
   and ak.id=p.id_n_kat
)) group by DEPT_NAME
--

union all
--
select '�����:', sum(VSE) "�����", sum(FEMALE) "������",
       sum(RUK) "������������", sum(PROF) "�������������", 
       sum(SPEC) "�����������", sum(TEX_SL) "������. ��������", sum(RAB_SF_TiBU) "���. ��. ����. � ��", 
       sum(RAB_SX) "����. ���. ��", sum(RAB_S_INSTRU) "����. ���. � ������.", 
       sum(OPER) "��������� � ��������", sum(PROST) "���������� ���������",
       sum(VREM) "��������", sum(SOVM) "������������"
from (
select DEPT_NAME, 1 VSE, decode(ID_POL, 2, 1, 0) FEMALE,
       decode(KAT, '������������', 1, 0) RUK, decode(KAT, '�p�����������', 1, 0) PROF, 
       decode(KAT, '�����������', 1, 0) SPEC, decode(KAT, '����������� ��������', 1, 0) TEX_SL,
       decode(KAT, '��������� ���p� ��p����� � ������� �����', 1, 0) RAB_SF_TiBU, 
       decode(KAT, '���������p������� p�������� ��������� ���������', 1, 0) RAB_SX, 
       decode(KAT, '���������p������� p�������� � ����p�������', 1, 0) RAB_S_INSTRU, 
       decode(KAT, '���p���p� � ���p���� ���p�������� � �����', 1, 0) OPER, 
       decode(KAT, '�p�������� �p�������', 1, 0) PROST,
       decode(ID_WORK, 61, 1, 0) VREM, decode(ID_WORK, 62, 1, 0) SOVM
from (       
  select u.id_tab ID_TAB, u.id_uvol ID_UVOL, osn.id_pol ID_POL, ac.name_u DEPT_NAME, ak.name_u KAT, p.id_work ID_WORK
  from qwerty.sp_ka_uvol u, qwerty.sp_ka_osn osn, qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_arx_kat ak
  where 
    trunc(u.data_uvol, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
   and osn.id_tab=u.id_tab
   and p.id_tab=u.id_tab and abs(p.id_zap)=abs(u.id_zap)-1 and p.data_kon=u.data_uvol
   and ac.id=p.id_n_cex
   and ak.id=p.id_n_kat
))