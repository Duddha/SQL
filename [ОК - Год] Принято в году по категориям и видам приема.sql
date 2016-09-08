--YEAR - ��� �������
-- ���� (p.id_zap=1 or p.id_zap=-1), ������ � ������ ��������         
select VID_PRIEM "��� ������", sum(KOL) "�����", sum(FEMALE) "������",
       sum(RUK) "������������",
       sum(PROF) "�������������",
       sum(SPEC) "�����������", sum(TEX_SL) "����������� ��������",
       sum(RAB_SF_TiBU) "��������� ��. ��p�. � ��",
       sum(KVAL_RAB_SX) "����. p��. ��", 
       sum(KVAL_RAB_S_INSTRU) "����. p��. � ����p�.", 
       sum(OPER) "���p���p� � ���p����", 
       sum(PROST) "�p�������� �p�������", 
       sum(VREM) "��������"--, sum(SOVM) "������������"
from (
select VID_PRIEM, 1 KOL, decode(POL, 2, 1, 0) FEMALE,
       decode(KAT, '������������', 1, 0) RUK, decode(KAT, '�p�����������', 1, 0) PROF, 
       decode(KAT, '�����������', 1, 0) SPEC, decode(KAT, '����������� ��������', 1, 0) TEX_SL, 
       decode(KAT, '��������� ���p� ��p����� � ������� �����', 1, 0) RAB_SF_TiBU, 
       decode(KAT, '���������p������� p�������� ��������� ���������', 1, 0) KVAL_RAB_SX, 
       decode(KAT, '���������p������� p�������� � ����p�������', 1, 0) KVAL_RAB_S_INSTRU, 
       decode(KAT, '���p���p� � ���p���� ���p�������� � �����', 1, 0) OPER, 
       decode(KAT, '�p�������� �p�������', 1, 0) PROST,
       decode(ID_WORK, 61, 1, 0) VREM, decode(ID_WORK, 62, 1, 0) SOVM
from (
  select w.id_tab ID_TAB, w.id_work ID_WORK, osn.id_priem ID_PRIEM, osn.id_pol POL, kat.name_u KAT, vw.name_u VID_PRIEM
   from qwerty.sp_ka_work w, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_kat kat, qwerty.sp_ka_osn osn, qwerty.sp_vid_work vw
   where w.id_zap=1 and trunc(w.data_work, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
     and rbk.id_tab=w.id_tab and st.id_stat=rbk.id_stat and kat.id_kat=st.id_kat
     and osn.id_tab=w.id_tab
     and vw.id=osn.id_priem
 union all
  select p.id_tab, p.id_work, osn.id_priem, osn.id_pol, ak.name_u, vw.name_u
   from qwerty.sp_ka_perem p, qwerty.sp_ka_osn osn, qwerty.sp_arx_kat ak, qwerty.sp_vid_work vw
   where --p.id_zap=1 and 
         (p.id_zap=1 or p.id_zap=-1) and
         trunc(p.data_work, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
     and ak.id=p.id_n_kat
     and osn.id_tab=p.id_tab
     and vw.id=osn.id_priem
))
group by VID_PRIEM
--

union all
--
select '�����:', 
       sum(KOL) "�����", sum(FEMALE) "������",
       sum(RUK) "������������",
       sum(PROF) "�������������",
       sum(SPEC) "�����������", sum(TEX_SL) "����������� ��������",
       sum(RAB_SF_TiBU) "��������� ��. ��p�. � ��",
       sum(KVAL_RAB_SX) "����. p��. ��", 
       sum(KVAL_RAB_S_INSTRU) "����. p��. � ����p�.", 
       sum(OPER) "���p���p� � ���p����", 
       sum(PROST) "�p�������� �p�������", 
       sum(VREM) "��������"--, sum(SOVM) "������������"
from (
select VID_PRIEM, 1 KOL, decode(POL, 2, 1, 0) FEMALE,
       decode(KAT, '������������', 1, 0) RUK, decode(KAT, '�p�����������', 1, 0) PROF, 
       decode(KAT, '�����������', 1, 0) SPEC, decode(KAT, '����������� ��������', 1, 0) TEX_SL, 
       decode(KAT, '��������� ���p� ��p����� � ������� �����', 1, 0) RAB_SF_TiBU, 
       decode(KAT, '���������p������� p�������� ��������� ���������', 1, 0) KVAL_RAB_SX, 
       decode(KAT, '���������p������� p�������� � ����p�������', 1, 0) KVAL_RAB_S_INSTRU, 
       decode(KAT, '���p���p� � ���p���� ���p�������� � �����', 1, 0) OPER, 
       decode(KAT, '�p�������� �p�������', 1, 0) PROST,
       decode(ID_WORK, 61, 1, 0) VREM, decode(ID_WORK, 62, 1, 0) SOVM
from (
  select w.id_tab ID_TAB, w.id_work ID_WORK, osn.id_priem ID_PRIEM, osn.id_pol POL, kat.name_u KAT, vw.name_u VID_PRIEM
   from qwerty.sp_ka_work w, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_kat kat, qwerty.sp_ka_osn osn, qwerty.sp_vid_work vw
   where w.id_zap=1 and trunc(w.data_work, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
     and rbk.id_tab=w.id_tab and st.id_stat=rbk.id_stat and kat.id_kat=st.id_kat
     and osn.id_tab=w.id_tab
     and vw.id=osn.id_priem
 union all
  select p.id_tab, p.id_work, osn.id_priem, osn.id_pol, ak.name_u, vw.name_u
   from qwerty.sp_ka_perem p, qwerty.sp_ka_osn osn, qwerty.sp_arx_kat ak, qwerty.sp_vid_work vw
   where --p.id_zap=1 and 
         (p.id_zap=1 or p.id_zap=-1) and
         trunc(p.data_work, 'YEAR')=to_date('01.01.&YEAR', 'dd.mm.yyyy')
     and ak.id=p.id_n_kat
     and osn.id_tab=p.id_tab
     and vw.id=osn.id_priem
))