-- TAB = ������� ��������� �.�.�. � ������� ���������

SELECT id_tab
      ,fam_u
      ,decode(fam_u
             ,nvl(lag(fam_u) over(PARTITION BY id_tab ORDER BY event_date)
                 ,fam_u)
             ,''
             ,'!!!') "-"
       ,fam_r
       ,decode(fam_r
             ,nvl(lag(fam_r) over(PARTITION BY id_tab ORDER BY event_date)
                 ,fam_r)
             ,''
             ,'!!!') "-"
       ,f_name_u
       ,decode(f_name_u
             ,nvl(lag(f_name_u) over(PARTITION BY id_tab ORDER BY event_date)
                 ,f_name_u)
             ,''
             ,'!!!') "-"
       ,f_name_r
       ,decode(f_name_r
             ,nvl(lag(f_name_r) over(PARTITION BY id_tab ORDER BY event_date)
                 ,f_name_r)
             ,''
             ,'!!!') "-"
       ,s_name_u
       ,decode(s_name_u
             ,nvl(lag(s_name_u) over(PARTITION BY id_tab ORDER BY event_date)
                 ,s_name_u)
             ,''
             ,'!!!') "-"
       ,s_name_r
       ,decode(s_name_r
             ,nvl(lag(s_name_r) over(PARTITION BY id_tab ORDER BY event_date)
                 ,s_name_r)
             ,''
             ,'!!!') "-"
       ,status
       ,decode(status
             ,nvl(lag(status) over(PARTITION BY id_tab ORDER BY event_date)
                 ,status)
             ,''
             ,'!!!') "-"
       ,aa1
       ,decode(aa1
             ,nvl(lag(aa1) over(PARTITION BY id_tab ORDER BY event_date)
                 ,aa1)
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
  FROM (SELECT rbfm.id_tab
              ,rbfm.fam_u
              ,rbfm.fam_r
              ,rbfm.f_name_u
              ,rbfm.f_name_r
              ,rbfm.s_name_u
              ,rbfm.s_name_r
              ,rbfm.status
              ,rbfm.aa1
              ,rbfm.event_type
              ,rbfm.event_date
              ,rbfm.event_user
              ,rbfm.event_terminal
              ,1 fl
          FROM qwerty.sp_rb_fio_ment rbfm
         WHERE id_tab = &< NAME = "���. �" HINT = "��������� ����� ���������, �� �������� ���������� �����" >
        UNION ALL
        SELECT rbf.*
              ,0
              ,SYSDATE
              ,USER
              ,''
              ,2
          FROM qwerty.sp_rb_fio rbf
         WHERE id_tab = &< NAME = "���. �" >)
 ORDER BY fl
         ,event_date
