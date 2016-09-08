-- TAB = �� ��������� �����
select to_char(dat_bal, 'Month yyyy') "����",
       sum(ssp_chi) "��������������� �����������"
  from (select distinct max(ssp_chi) over(partition by id_cex, dat_bal) ssp_chi,
                        dat_bal
          from qwerty.sp_zarv_baltim_itog_mm
         where dat_bal = to_date('01.' || &< name = "����� �������" hint = "����� � ��� � ������� MM.����" type = "string" default = "select to_char(add_months(sysdate, -1), 'mm.yyyy') from dual" >,
                                 'dd.mm.yyyy'))
 group by dat_bal;

-- TAB = �� ���         
select to_char(dat_bal, 'Month yyyy') "����",
       sum(ssp_chi) "��������������� �����������"
  from (select distinct max(ssp_chi) over(partition by id_cex, dat_bal) ssp_chi,
                        dat_bal
          from qwerty.sp_zarv_baltim_itog_mm
         where dat_bal in (select distinct data_graf
                             from qwerty.sp_zar_grafik
                            where trunc(data_graf, 'YEAR') =
                                  to_date('01.01.' || &< name = "��� �������" type = "string" hint = "��� � ������� ����" default = "select to_char(add_months(sysdate, -1), 'yyyy') from dual" >,
                                          'dd.mm.yyyy')))
 group by dat_bal
