-- TAB = ������� ��������� ���������� ������ ���������

SELECT id_tab
      ,id_sity
      ,decode(id_sity
             ,nvl(lag(id_sity) over(PARTITION BY id_tab ORDER BY event_date)
                 ,id_sity)
             ,''
             ,'!!!') "-"
       ,ser
       ,decode(ser
             ,nvl(lag(ser) over(PARTITION BY id_tab ORDER BY event_date)
                 ,ser)
             ,''
             ,'!!!') "-"
       ,numb
       ,decode(numb
             ,nvl(lag(numb) over(PARTITION BY id_tab ORDER BY event_date)
                 ,numb)
             ,''
             ,'!!!') "-"
       ,data_p
       ,decode(data_p
             ,nvl(lag(data_p) over(PARTITION BY id_tab ORDER BY event_date)
                 ,data_p)
             ,''
             ,'!!!') "-"
       ,kem
       ,decode(kem
             ,nvl(lag(kem) over(PARTITION BY id_tab ORDER BY event_date)
                 ,kem)
             ,''
             ,'!!!') "-"
       ,decode(event_type
             ,0
             ,'������� ��������'
             ,1
             ,'�������� ������'
             ,2
             ,'��������� ������'
             ,3
             ,'�������� ������'
             ,'???') "��������"
       ,event_date "���� ��������"
       ,event_user "��� ������"
       ,event_terminal "� ������ ����������"
  FROM (SELECT pm.id_tab
              ,pm.id_sity
              ,pm.ser
              ,pm.numb
              ,pm.data_p
              ,pm.kem
              ,1 fl
              ,pm.event_date
              ,pm.event_type
              ,pm.event_user
              ,pm.event_terminal
          FROM qwerty.sp_ka_pasport_ment pm
         WHERE id_tab = &< NAME = "���. �" HINT = "��������� ����� ���������, �� �������� ���������� �����" >
        UNION ALL
        SELECT p.*
              ,2
              ,SYSDATE
              ,0
              ,USER
              ,''
          FROM qwerty.sp_ka_pasport p
         WHERE id_tab = &< NAME = "���. �" >)
 ORDER BY fl
         ,event_date
