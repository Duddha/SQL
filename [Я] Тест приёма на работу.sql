-- Схема SCOTT
-- TAB = 1. Отобрать студентов, посетивших ровно 5 уроков математики
SELECT *
  FROM stud
 WHERE id IN (SELECT stud
                FROM (SELECT stud
                            ,COUNT(1) num_of_lect
                        FROM lect
                       WHERE lower(subj) = 'математика'
                       GROUP BY stud)
               WHERE num_of_lect = 5);

-- TAB = 2. Отобрать студентов, посетивших ровно 5 уроков математики и при этом всегда посещавших лекции только одного (любого) преподавателя
SELECT *
  FROM stud
 WHERE id IN (SELECT stud
                FROM (SELECT DISTINCT stud
                                     ,COUNT(1) over(PARTITION BY subj, stud) num_of_lect
                                     ,COUNT(1) over(PARTITION BY subj, stud, teach) num_of_lect_teach
                        FROM lect
                       WHERE lower(subj) = 'математика')
               WHERE num_of_lect = 5
                 AND num_of_lect_teach = 5);

-- TAB = 3. Найти лекции, которые по ошибке начинаются в одно время в одной и той же аудитории или у одного и того же преподавателя
SELECT DISTINCT 'Лекции по разным предметам в одной и той же аудитории' "Проблема"
                ,to_char(l1.lectdate
                       ,'dd.mm.yyyy hh24:mi:ss') "Дата лекции"
                ,'аудитория №' || l1.room || ' - ' || lower(least(l1.subj
                                                                ,l2.subj)) || ' и ' || lower(greatest(l1.subj
                                                                                                     ,l2.subj)) "Примечания"
  FROM lect l1
      ,lect l2
 WHERE (l1.lectdate = l2.lectdate AND l1.room = l2.room AND l1.subj <> l2.subj)
UNION ALL
SELECT DISTINCT 'Разные лекции у одного и того же преподавателя'
               ,to_char(l1.lectdate
                       ,'dd.mm.yyyy hh24:mi:ss')
               ,'преподаватель ' || t1.fio || ', аудитории №' || least(l1.room
                                                                      ,l2.room) || ' и №' || greatest(l1.room
                                                                                                     ,l2.room)
  FROM lect  l1
      ,lect  l2
      ,teach t1
      ,teach t2
 WHERE l1.teach = t1.id
   AND l2.teach = t2.id
   AND (l1.lectdate = l2.lectdate AND l1.teach = l2.teach AND l1.room <> l2.room);

-- TAB = 4. Найти лекции, которые по ошибке пересекаются по времени в одной и той же аудитории или у одного и того же преподавателя
WITH lectures AS
 (SELECT DISTINCT teach
                 ,subj
                 ,lectdate lect_start
                 ,(lectdate + lectdur / 24 / 60) lect_finish
                 ,room
                 ,fio
    FROM lect  l
        ,teach t
   WHERE l.teach = t.id)

SELECT DISTINCT 'Пересечение лекций в одной аудитории' "Проблема"
                ,to_char(l1.room) "Аудитория"
                ,to_char(l1.lect_start
                       ,'dd.mm.yyyy') || ': ' || least(l1.subj || ' [' || l1.fio || '] (с ' || to_char(l1.lect_start
                                                                                                      ,'hh24:mi:ss') || ' по ' || to_char(l1.lect_finish
                                                                                                                                         ,'hh24:mi:ss') || ')'
                                                      ,l2.subj || ' [' || l2.fio || '] (с ' || to_char(l2.lect_start
                                                                                                      ,'hh24:mi:ss') || ' по ' || to_char(l2.lect_finish
                                                                                                                                         ,'hh24:mi:ss') || ')') || ' и ' ||
                greatest(l1.subj || ' [' || l1.fio || '] (с ' || to_char(l1.lect_start
                                                                        ,'hh24:mi:ss') || ' по ' || to_char(l1.lect_finish
                                                                                                           ,'hh24:mi:ss') || ')'
                        ,l2.subj || ' [' || l2.fio || '] (с ' || to_char(l2.lect_start
                                                                        ,'hh24:mi:ss') || ' по ' || to_char(l2.lect_finish
                                                                                                           ,'hh24:mi:ss') || ')') "Примечания"
  FROM lectures l1
      ,lectures l2
 WHERE l1.room = l2.room
   AND l2.lect_start BETWEEN l1.lect_start AND l1.lect_finish
   AND l1.lect_start <> l2.lect_start
   AND (l1.teach <> l2.teach OR l1.subj <> l2.subj OR l1.lect_start <> l2.lect_start)

UNION ALL

SELECT DISTINCT 'Пересекающиеся лекции у одного и того же преподавателя' "Проблема"
                ,decode(l1.room
                      ,l2.room
                      ,l1.room
                      ,least(l1.room
                            ,l2.room) || ' и ' || greatest(l1.room
                                                          ,l2.room)) "Аудитория"
                ,to_char(l1.lect_start
                       ,'dd.mm.yyyy') || ' ' || l1.fio || ': ' || least(l1.subj || ' (с ' || to_char(l1.lect_start
                                                                                                    ,'hh24:mi:ss') || ' по ' || to_char(l1.lect_finish
                                                                                                                                       ,'hh24:mi:ss') || ')'
                                                                       ,l2.subj || ' (с ' || to_char(l2.lect_start
                                                                                                    ,'hh24:mi:ss') || ' по ' || to_char(l2.lect_finish
                                                                                                                                       ,'hh24:mi:ss') || ')') || ' и ' ||
                greatest(l1.subj || ' (с ' || to_char(l1.lect_start
                                                     ,'hh24:mi:ss') || ' по ' || to_char(l1.lect_finish
                                                                                        ,'hh24:mi:ss') || ')'
                        ,l2.subj || ' (с ' || to_char(l2.lect_start
                                                     ,'hh24:mi:ss') || ' по ' || to_char(l2.lect_finish
                                                                                        ,'hh24:mi:ss') || ')') "Примечания"
  FROM lectures l1
      ,lectures l2
 WHERE l1.teach = l2.teach
   AND l2.lect_start BETWEEN l1.lect_start AND l1.lect_finish
   AND l1.lect_start <> l2.lect_start
   AND (l1.room <> l2.room OR l1.subj <> l2.subj OR l1.lect_start <> l2.lect_start);

-- TAB = 5. Вывести "журнал". Колонки: имя студента, "математика", "физика", "программирование", "экономика", "всего", "всего за посл. месяц". Строки - количество посещенных лекций соответствующего предмета или месяца.
SELECT DISTINCT fio "имя студента"
                ,SUM(decode(lower(subj)
                          ,'математика'
                          ,1
                          ,0)) over(PARTITION BY stud) "математика"
                ,SUM(decode(lower(subj)
                          ,'физика'
                          ,1
                          ,0)) over(PARTITION BY stud) "физика"
                ,SUM(decode(lower(subj)
                          ,'программирование'
                          ,1
                          ,0)) over(PARTITION BY stud) "программирование"
                ,SUM(decode(lower(subj)
                          ,'экономика'
                          ,1
                          ,0)) over(PARTITION BY stud) "экономика"
                ,SUM(1) over(PARTITION BY stud) "всего"
                ,SUM(decode(trunc(lectdate
                                ,'MONTH')
                          ,(SELECT trunc(MAX(lectdate)
                                       ,'MONTH')
                             FROM lect)
                          ,1
                          ,0)) over(PARTITION BY stud) "всего за посл. месяц"
  FROM stud s
      ,lect l
 WHERE l.stud = s.id;

-- TAB = 6. Вывести "журнал пропусков". Колонки: имя студента, "математика", "физика", "программирование", "экономика", "всего", "всего за посл. месяц". Строки - количество пропущеных лекций.
-- Для этого журнала необходимо сперва навести порядок с пересекающимися лекциями, иначе может быть чересчур много пропусков
-- Да и такой вариант получения списка пропущенных лекций при большом количестве записей будет не очень оправдан
WITH absence AS
 (SELECT DISTINCT id stud
                 ,fio
                 ,teach
                 ,subj
                 ,lectdate
                 ,room
  
    FROM lect
        ,stud
  MINUS
  SELECT stud
        ,fio
        ,teach
        ,subj
        ,lectdate
        ,room
    FROM lect
        ,stud
   WHERE stud = id)

SELECT DISTINCT fio "имя студента"
                ,SUM(decode(lower(subj)
                          ,'математика'
                          ,1
                          ,0)) over(PARTITION BY stud) "математика"
                ,SUM(decode(lower(subj)
                          ,'физика'
                          ,1
                          ,0)) over(PARTITION BY stud) "физика"
                ,SUM(decode(lower(subj)
                          ,'программирование'
                          ,1
                          ,0)) over(PARTITION BY stud) "программирование"
                ,SUM(decode(lower(subj)
                          ,'экономика'
                          ,1
                          ,0)) over(PARTITION BY stud) "экономика"
                ,SUM(1) over(PARTITION BY stud) "всего"
                ,SUM(decode(trunc(lectdate
                                ,'MONTH')
                          ,(SELECT trunc(MAX(lectdate)
                                       ,'MONTH')
                             FROM lect)
                          ,1
                          ,0)) over(PARTITION BY stud) "всего за посл. месяц"
  FROM absence;

-- TAB = 7. Продвинутый уровень. Найти кратчайший путь в лабиринте из комнаты1 в комнату2, которые передаются как параметры запроса. НЕ PL/SQL! Один запрос на SQL.
-- К этой задаче есть ряд вопросов:
--  - есть ли обратные связи, например, в таблице есть строка ROOM1 = 1, ROOM2 = 2 и строка ROOM1 = 2, ROOM2 = 1
--  - какая версия БД ORACLE (если использовать дерево, то в ORACLE 10g есть NOCYCLE, а в 9i этого параметра нет)
--  ...
-- в общем, ниже представлен вариант для таблицы, в которой нет обратных связей, работающий на ORACLE 9i
-- 
-- Параметры обозначены &from_room и &to_room - из какой комнаты в какую комнату хотим попасть
SELECT maze_path
  FROM (SELECT lvl
              ,maze_path
              ,MIN(lvl) over() min_level
          FROM (SELECT room1
                      ,room2
                      ,LEVEL lvl
                      ,least(&from_room
                            ,&to_room) || sys_connect_by_path(room2
                                                             ,' - ') maze_path
                  FROM maze
                CONNECT BY PRIOR room2 = room1
                 START WITH room1 = least(&from_room
                                         ,&to_room))
         WHERE room2 = greatest(&from_room
                               ,&to_room)
         ORDER BY lvl)
 WHERE lvl = min_level;
