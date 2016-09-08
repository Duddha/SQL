-- ��������� � ����������, ����������� �� ������������ �������

-- TAB = ���������
-- RECORDS = ALL
SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,p.id_cex "��� ����"
       ,p.name_u "���"
       ,m.full_name_u "���������"
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(rbf.id_tab
                                           ,1
                                           ,1
                                           ,1) "�����"
  FROM qwerty.sp_rb_fio   rbf
      ,qwerty.sp_rb_key   rbk
      ,qwerty.sp_stat     s
      ,qwerty.sp_podr     p
      ,qwerty.sp_mest     m
      ,qwerty.sp_ka_adres a
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND rbf.id_tab = a.id_tab
   AND a.fl = 1
 -- NoFormat Start
   AND a.id_sity = &< name = "�����"
                      hint = "�������� ��������� �����"
                      list = "SELECT DISTINCT ss.id, sp.snam_u || ' ' || ss.name_u
                                FROM qwerty.sp_sity ss
                                    ,qwerty.sp_punkt sp
                               WHERE ss.id_punkt = sp.id
                                 AND ss.id IN (SELECT DISTINCT id_sity 
                                                 FROM QWERTY.SP_KA_ADRES
                                                WHERE id_tab IN (SELECT id_tab FROM qwerty.sp_rb_key
                                                                 UNION ALL
                                                                 SELECT id_tab FROM qwerty.sp_ka_pens_all where nvl(stag, 0) + nvl(stag_d, 0) >= 72))
                               ORDER BY 2"
                      description = "yes"
                      restricted = "yes" >                      
   AND a.id_sity || a.name_line_u || a.dom IN (&< name = "������ ��� �������" 
                                                  hint = "�������� ��� ����������� �����" 
                                                  list = "SELECT DISTINCT '''' || a.id_sity || a.name_line_u || a.dom || ''''
                                                                         ,pnkt.snam_u || ' ' || c.name_u || ', ' || a.name_line_u || ', �.' || a.dom
                                                          FROM qwerty.sp_ka_adres a
                                                              ,qwerty.sp_sity     c
                                                              ,qwerty.sp_punkt    pnkt
                                                         WHERE a.id_tab IN (SELECT id_tab FROM qwerty.sp_rb_key
                                                                            UNION ALL
                                                                            SELECT id_tab FROM qwerty.sp_ka_pens_all where nvl(stag, 0) + nvl(stag_d, 0) >= 72)
                                                           AND a.fl = 1
                                                           AND a.id_sity = :�����
                                                           AND a.id_sity = c.id
                                                           AND c.id_punkt = pnkt.id
                                                         ORDER BY 2"
                                                  description = "yes"
                                                  restricted = "yes"
                                                  multiselect = "yes" >)
  -- NoFormat End
 ORDER BY 4
         ,2;

-- TAB = ����������
-- RECORDS = ALL
SELECT rbf.id_tab "���. �"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�."
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS_BY_FL(rbf.id_tab
                                           ,1
                                           ,1
                                           ,1) "�����"
  FROM qwerty.sp_rb_fio      rbf
      ,qwerty.sp_ka_pens_all pall
      ,qwerty.sp_ka_adres    a
 WHERE rbf.id_tab = pall.id_tab
   AND nvl(pall.stag
          ,0) + nvl(pall.stag_d
                   ,0) >= 72
   AND pall.id_tab = a.id_tab
   AND a.fl = 1
   AND a.id_sity || a.name_line_u || a.dom IN (&< NAME = "������ ��� �������" >)
 ORDER BY a.name_line_u
         ,to_number(TRANSLATE(lower(nvl(a.dom
                                       ,0))
                             ,'0123456789abcdefghijklmnopqrstuvwxyz����������������������������������-/ "'''
                             ,'0123456789'))
         ,a.dom
         ,nvl(a.korp, ' ')
         ,to_number(substr(translate(lower(a.kvart)
                                    ,'0123456789,-/.abcdefghijklmnopqrstuvwxyz���������������������������������� ''"'
                                    ,'0123456789----')
                          ,1
                          ,decode(instr(translate(lower(a.kvart)
                                                 ,'0123456789,-/.abcdefghijklmnopqrstuvwxyz���������������������������������� ''"'
                                                 ,'0123456789----')
                                       ,'-') - 1
                                 ,-1
                                 ,length(a.kvart)
                                 ,instr(translate(lower(a.kvart)
                                                 ,'0123456789,-/.abcdefghijklmnopqrstuvwxyz���������������������������������� ''"'
                                                 ,'0123456789----')
                                       ,'-') - 1)))
         ,a.kvart
