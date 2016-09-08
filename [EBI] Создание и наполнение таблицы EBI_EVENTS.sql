-- Создание и наполнение таблицы EBI_EVENTS

--drop table ZAKAZ.EBI_EVENTS
/*create table ZAKAZ.EBI_EVENTS as
SELECT ee."EventID" EventID
       ,ee."Action" Action
       ,ee."AreaName" AreaName
       ,to_date(ee."ServerTime"
               ,'yyyy-mm-dd hh24:mi:ss') ServerTime
       ,to_date(ee."EventTime"
               ,'yyyy-mm-dd hh24:mi:ss') EventTime
       ,ee."Source" Source
       ,to_number(ee."CardNumber") CardNumber
       ,ee."AccessReason" AccessReason
       ,ee."ConditionName" ConditionName
       ,0 Flag
  FROM dbo.ebi_events@ebi_mssql_ev.oasu ee*/

MERGE INTO zakaz.ebi_events t
USING (SELECT "EventID" EventID
              ,"Action" Action
              ,"AreaName" AreaName
              ,to_date("ServerTime"
                      ,'yyyy-mm-dd hh24:mi:ss') ServerTime
              ,to_date("EventTime"
                      ,'yyyy-mm-dd hh24:mi:ss') EventTime
              ,to_number("CardNumber") CardNumber
              ,"AccessReason" AccessReason
              ,"ConditionName" ConditionName
         FROM dbo.ebi_events@ebi_mssql_ev.oasu) ebi
ON (t.EventID = ebi.EventID)
WHEN NOT MATCHED THEN
  INSERT (t.EventID, t.Action, t.AreaName, t.ServerTime, t.EventTime, t.CardNumber, t.AccessReason, t.ConditionName, t.Flag) VALUES (ebi.EventID, ebi.Action, ebi.AreaName, ebi.ServerTime, ebi.EventTime, ebi.CardNumber, ebi.AccessReason, ebi.ConditionName, 0)
WHEN MATCHED THEN
  UPDATE
     SET t.Flag = t.Flag
  
  -- alter session close database link ebi_mssql_ev.oasu
