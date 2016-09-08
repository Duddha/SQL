-- TAB = История изменения паспортных данных работника

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
             ,'текущее значение'
             ,1
             ,'создание записи'
             ,2
             ,'изменение записи'
             ,3
             ,'удаление записи'
             ,'???') "Действие"
       ,event_date "Дата действия"
       ,event_user "Кто сделал"
       ,event_terminal "С какого компьютера"
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
         WHERE id_tab = &< NAME = "Таб. №" HINT = "Табельный номер работника, по которому проводится поиск" >
        UNION ALL
        SELECT p.*
              ,2
              ,SYSDATE
              ,0
              ,USER
              ,''
          FROM qwerty.sp_ka_pasport p
         WHERE id_tab = &< NAME = "Таб. №" >)
 ORDER BY fl
         ,event_date
