-- TAB = Сверка данных из EBI и ORACLE (через view dbo.EBI_EVENTS)

/*
alter session close database link ebi_mssql_ev.oasu
*/

SELECT *
  FROM dbo.ebi_events@ebi_mssql_ev.oasu
 WHERE "EventID" >= (SELECT MIN(event_id) FROM ebi_events_log)
   AND "ConditionName" = 'GRANTED'
   AND "EventID" NOT IN (SELECT event_id FROM ebi_events_log)
   AND to_date("ServerTime"
               ,'yyyy-mm-dd hh24:mi:ss') < (SELECT update_date FROM ebi_event_granted)
