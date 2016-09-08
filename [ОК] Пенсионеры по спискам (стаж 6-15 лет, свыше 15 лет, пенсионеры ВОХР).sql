-- ������� ����� ����������� �� ����� (6-15 ���, >15 ���) ��� ����������� ����
select * from (
select 
    id_tab, 
    nvl(stag, 0) + nvl(stag_d, 0) stag, 
    dat_uvol,
    kto
  from qwerty.sp_ka_pens_all pall
 where nvl(dat_uvol, to_date(&<name = "���� �������" type="string" hint = "��.��.����" 
                               default = "select to_char(sysdate, 'dd.mm.yyyy') from dual">, 'dd.mm.yyyy')-1)  <= to_date(&<name = "���� �������">, 'dd.mm.yyyy') 
 and pall.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
)
where &<name = "������" list = "stag between (6 * 12) and (15 * 12 - 1), ���� �� 6 �� 15 ���,
                                stag >= (15 * 12), ���� ����� 15 ���,
                                kto = 7, ���������� ����" description = "yes">
                                     
