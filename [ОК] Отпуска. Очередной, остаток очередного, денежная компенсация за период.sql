-- TAB = ������� (���������, ������� ����������, ���. �����������) �� ������
SELECT otp.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,o.name_u "��� �������"
       ,otp.dat_n "���� ������"
       ,otp.dat_k "���� ���������"
       ,to_char(otp.n_period
              ,'dd.mm.yyyy') || ' - ' || to_char(otp.k_period
                                                ,'dd.mm.yyyy') "������"
       ,decode(otp.u_obrab
             ,0
             ,'�� ����������'
             ,1
             ,'����������'
             ,'???') "���������� ��������� �������"
  FROM qwerty.sp_ka_otpusk otp
      ,qwerty.sp_otpusk    o
      ,qwerty.sp_rb_fio    rbf
 WHERE id_otp IN (4
                 ,6
                 ,34)
   AND dat_n BETWEEN to_date('01.06.2015'
                            ,'dd.mm.yyyy') AND to_date('05.06.2015'
                                                      ,'dd.mm.yyyy')
   AND otp.id_otp = o.id
   AND otp.id_tab = rbf.id_tab
   --and otp.id_tab in (select id_tab from qwerty.sp_ka_uvol where data_uvol >= trunc(sysdate, 'YEAR'))
 ORDER BY dat_n, 2
