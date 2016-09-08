select TAB_ID "���. �",
       fio "�.�.�.",
       data_r "���� ��������",
       address "�����",
       data_po "���� ���������� ��������",
       decode(kto, 0, '1. �������������� ������ �����������', 1,
              '2. ���� �� ������ � ������', 2, '3. ������������ � ����������� ���',
              '???') "����������",
       lost_note "�������",
       floor(stag/12)||'�. '||mod(stag, 12)||'�. ' "����",
       decode(instr(address, '�����'), 0, 0, 1) FL
  from (select pall.id_tab TAB_ID,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               osn.data_r,
               qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(pall.id_tab, 1, 1, 12) address,
               pl.data_po,
               nvl(lost.lost_type, 0) lost_type,
               pall.kto,
               nvl(pall.stag,0)+nvl(pall.stag_d,0) stag,
               lost.lost_note
          from qwerty.sp_ka_pens_all pall,
               qwerty.sp_ka_osn      osn,
               qwerty.sp_ka_plus     pl,
               qwerty.sp_rb_fio      rbf,
               qwerty.sp_ka_lost     lost
         where pall.id_tab = osn.id_tab
           and pall.id_tab = pl.id_tab
           and pall.id_tab = rbf.id_tab
           and pl.id_po = 3
           and osn.id_pol = 2
           and pall.id_tab = lost.id_tab(+))
 where lost_type <> 1 and stag >= 25*12
 order by fl desc, 6, 2
