-- TAB = EBI: ����� ���������� ����������

SELECT g.update_date "�������"
      ,t.update_date "������"
  FROM EBI_EVENT_DENIED  t
      ,ebi_event_granted g
