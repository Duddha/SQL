-- TAB = EBI: время последнего обновления

SELECT g.update_date "Проходы"
      ,t.update_date "Отказы"
  FROM EBI_EVENT_DENIED  t
      ,ebi_event_granted g
