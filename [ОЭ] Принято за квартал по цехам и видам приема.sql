select DEPT_NAME "���", sum(KOL) "�����", sum(FEMALE) "������",
       sum(VOLN_N) "�� �������� �����",
       sum(IZ_ARM) "�� �����", sum(PUT_VUZ) "�� ������� ����",
       sum(PO_NAPR_BZ) "�� ����������� ���� ���������",
       sum(KAK_PENS) "��� ���������", sum(VREM) "��������"
from (
select DEPT_NAME, 1 KOL, decode(POL, 2, 1, 0) FEMALE,
       decode(ID_PRIEM, 2, 1, 0) VOLN_N, decode(ID_PRIEM, 3, 1, 0) IZ_ARM, 
       decode(ID_PRIEM, 9, 1, 0) PUT_VUZ, decode(ID_PRIEM, 11, 1, 0) PO_NAPR_BZ, 
       decode(ID_PRIEM, 12, 1, 0) KAK_PENS, decode(ID_WORK, 61, 1, 0) VREM
from (
  select w.id_tab ID_TAB, w.id_work ID_WORK, osn.id_priem ID_PRIEM, osn.id_pol POL, pdr.name_u DEPT_NAME 
   from qwerty.sp_ka_work w, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_podr pdr, qwerty.sp_ka_osn osn
   where w.id_zap=1 and --w.data_work between to_date('01.01.2009', 'dd.mm.yyyy') and to_date('01.12.2009', 'dd.mm.yyyy')
                        w.data_work between trunc(to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy'), 'Q') and to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy')
     and rbk.id_tab=w.id_tab and st.id_stat=rbk.id_stat and pdr.id_cex=st.id_cex
     and osn.id_tab=w.id_tab
 union all
  select p.id_tab, p.id_work, osn.id_priem, osn.id_pol, ac.name_u 
   from qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_ka_osn osn
   where --p.id_zap=1 and 
         (p.id_zap=1 or p.id_zap=-1) and
         p.data_work between trunc(to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy'), 'Q') and to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy')
     and ac.id=p.id_n_cex
     and osn.id_tab=p.id_tab
))
group by DEPT_NAME
--
union all
--
select '�����:', 
       sum(KOL) "�����", sum(FEMALE) "������",
       sum(VOLN_N) "�� �������� �����",
       sum(IZ_ARM) "�� �����", sum(PUT_VUZ) "�� ������� ����",
       sum(PO_NAPR_BZ) "�� ����������� ���� ���������",
       sum(KAK_PENS) "��� ���������", sum(VREM) "��������"
from (
select DEPT_NAME, 1 KOL, decode(POL, 2, 1, 0) FEMALE,
       decode(ID_PRIEM, 2, 1, 0) VOLN_N, decode(ID_PRIEM, 3, 1, 0) IZ_ARM, 
       decode(ID_PRIEM, 9, 1, 0) PUT_VUZ, decode(ID_PRIEM, 11, 1, 0) PO_NAPR_BZ, 
       decode(ID_PRIEM, 12, 1, 0) KAK_PENS, decode(ID_WORK, 61, 1, 0) VREM
from (
  select w.id_tab ID_TAB, w.id_work ID_WORK, osn.id_priem ID_PRIEM, osn.id_pol POL, pdr.name_u DEPT_NAME 
   from qwerty.sp_ka_work w, qwerty.sp_rb_key rbk, qwerty.sp_stat st, qwerty.sp_podr pdr, qwerty.sp_ka_osn osn
   where w.id_zap=1 and w.data_work between trunc(to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy'), 'Q') and to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy')
     and rbk.id_tab=w.id_tab and st.id_stat=rbk.id_stat and pdr.id_cex=st.id_cex
     and osn.id_tab=w.id_tab
 union all
  select p.id_tab, p.id_work, osn.id_priem, osn.id_pol, ac.name_u 
   from qwerty.sp_ka_perem p, qwerty.sp_arx_cex ac, qwerty.sp_ka_osn osn
   where --p.id_zap=1 and 
         (p.id_zap=1 or p.id_zap=-1) and
         p.data_work between trunc(to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy'), 'Q') and to_date(&<name="���� �������" type="string" hint="��.��.���">, 'dd.mm.yyyy')
     and ac.id=p.id_n_cex
     and osn.id_tab=p.id_tab
))
