-- ����� SCOTT
-- TAB = 1. �������� ���������, ���������� ����� 5 ������ ����������
SELECT *
  FROM stud
 WHERE id IN (SELECT stud
                FROM (SELECT stud
                            ,COUNT(1) num_of_lect
                        FROM lect
                       WHERE lower(subj) = '����������'
                       GROUP BY stud)
               WHERE num_of_lect = 5);

-- TAB = 2. �������� ���������, ���������� ����� 5 ������ ���������� � ��� ���� ������ ���������� ������ ������ ������ (������) �������������
SELECT *
  FROM stud
 WHERE id IN (SELECT stud
                FROM (SELECT DISTINCT stud
                                     ,COUNT(1) over(PARTITION BY subj, stud) num_of_lect
                                     ,COUNT(1) over(PARTITION BY subj, stud, teach) num_of_lect_teach
                        FROM lect
                       WHERE lower(subj) = '����������')
               WHERE num_of_lect = 5
                 AND num_of_lect_teach = 5);

-- TAB = 3. ����� ������, ������� �� ������ ���������� � ���� ����� � ����� � ��� �� ��������� ��� � ������ � ���� �� �������������
SELECT DISTINCT '������ �� ������ ��������� � ����� � ��� �� ���������' "��������"
                ,to_char(l1.lectdate
                       ,'dd.mm.yyyy hh24:mi:ss') "���� ������"
                ,'��������� �' || l1.room || ' - ' || lower(least(l1.subj
                                                                ,l2.subj)) || ' � ' || lower(greatest(l1.subj
                                                                                                     ,l2.subj)) "����������"
  FROM lect l1
      ,lect l2
 WHERE (l1.lectdate = l2.lectdate AND l1.room = l2.room AND l1.subj <> l2.subj)
UNION ALL
SELECT DISTINCT '������ ������ � ������ � ���� �� �������������'
               ,to_char(l1.lectdate
                       ,'dd.mm.yyyy hh24:mi:ss')
               ,'������������� ' || t1.fio || ', ��������� �' || least(l1.room
                                                                      ,l2.room) || ' � �' || greatest(l1.room
                                                                                                     ,l2.room)
  FROM lect  l1
      ,lect  l2
      ,teach t1
      ,teach t2
 WHERE l1.teach = t1.id
   AND l2.teach = t2.id
   AND (l1.lectdate = l2.lectdate AND l1.teach = l2.teach AND l1.room <> l2.room);

-- TAB = 4. ����� ������, ������� �� ������ ������������ �� ������� � ����� � ��� �� ��������� ��� � ������ � ���� �� �������������
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

SELECT DISTINCT '����������� ������ � ����� ���������' "��������"
                ,to_char(l1.room) "���������"
                ,to_char(l1.lect_start
                       ,'dd.mm.yyyy') || ': ' || least(l1.subj || ' [' || l1.fio || '] (� ' || to_char(l1.lect_start
                                                                                                      ,'hh24:mi:ss') || ' �� ' || to_char(l1.lect_finish
                                                                                                                                         ,'hh24:mi:ss') || ')'
                                                      ,l2.subj || ' [' || l2.fio || '] (� ' || to_char(l2.lect_start
                                                                                                      ,'hh24:mi:ss') || ' �� ' || to_char(l2.lect_finish
                                                                                                                                         ,'hh24:mi:ss') || ')') || ' � ' ||
                greatest(l1.subj || ' [' || l1.fio || '] (� ' || to_char(l1.lect_start
                                                                        ,'hh24:mi:ss') || ' �� ' || to_char(l1.lect_finish
                                                                                                           ,'hh24:mi:ss') || ')'
                        ,l2.subj || ' [' || l2.fio || '] (� ' || to_char(l2.lect_start
                                                                        ,'hh24:mi:ss') || ' �� ' || to_char(l2.lect_finish
                                                                                                           ,'hh24:mi:ss') || ')') "����������"
  FROM lectures l1
      ,lectures l2
 WHERE l1.room = l2.room
   AND l2.lect_start BETWEEN l1.lect_start AND l1.lect_finish
   AND l1.lect_start <> l2.lect_start
   AND (l1.teach <> l2.teach OR l1.subj <> l2.subj OR l1.lect_start <> l2.lect_start)

UNION ALL

SELECT DISTINCT '�������������� ������ � ������ � ���� �� �������������' "��������"
                ,decode(l1.room
                      ,l2.room
                      ,l1.room
                      ,least(l1.room
                            ,l2.room) || ' � ' || greatest(l1.room
                                                          ,l2.room)) "���������"
                ,to_char(l1.lect_start
                       ,'dd.mm.yyyy') || ' ' || l1.fio || ': ' || least(l1.subj || ' (� ' || to_char(l1.lect_start
                                                                                                    ,'hh24:mi:ss') || ' �� ' || to_char(l1.lect_finish
                                                                                                                                       ,'hh24:mi:ss') || ')'
                                                                       ,l2.subj || ' (� ' || to_char(l2.lect_start
                                                                                                    ,'hh24:mi:ss') || ' �� ' || to_char(l2.lect_finish
                                                                                                                                       ,'hh24:mi:ss') || ')') || ' � ' ||
                greatest(l1.subj || ' (� ' || to_char(l1.lect_start
                                                     ,'hh24:mi:ss') || ' �� ' || to_char(l1.lect_finish
                                                                                        ,'hh24:mi:ss') || ')'
                        ,l2.subj || ' (� ' || to_char(l2.lect_start
                                                     ,'hh24:mi:ss') || ' �� ' || to_char(l2.lect_finish
                                                                                        ,'hh24:mi:ss') || ')') "����������"
  FROM lectures l1
      ,lectures l2
 WHERE l1.teach = l2.teach
   AND l2.lect_start BETWEEN l1.lect_start AND l1.lect_finish
   AND l1.lect_start <> l2.lect_start
   AND (l1.room <> l2.room OR l1.subj <> l2.subj OR l1.lect_start <> l2.lect_start);

-- TAB = 5. ������� "������". �������: ��� ��������, "����������", "������", "����������������", "���������", "�����", "����� �� ����. �����". ������ - ���������� ���������� ������ ���������������� �������� ��� ������.
SELECT DISTINCT fio "��� ��������"
                ,SUM(decode(lower(subj)
                          ,'����������'
                          ,1
                          ,0)) over(PARTITION BY stud) "����������"
                ,SUM(decode(lower(subj)
                          ,'������'
                          ,1
                          ,0)) over(PARTITION BY stud) "������"
                ,SUM(decode(lower(subj)
                          ,'����������������'
                          ,1
                          ,0)) over(PARTITION BY stud) "����������������"
                ,SUM(decode(lower(subj)
                          ,'���������'
                          ,1
                          ,0)) over(PARTITION BY stud) "���������"
                ,SUM(1) over(PARTITION BY stud) "�����"
                ,SUM(decode(trunc(lectdate
                                ,'MONTH')
                          ,(SELECT trunc(MAX(lectdate)
                                       ,'MONTH')
                             FROM lect)
                          ,1
                          ,0)) over(PARTITION BY stud) "����� �� ����. �����"
  FROM stud s
      ,lect l
 WHERE l.stud = s.id;

-- TAB = 6. ������� "������ ���������". �������: ��� ��������, "����������", "������", "����������������", "���������", "�����", "����� �� ����. �����". ������ - ���������� ���������� ������.
-- ��� ����� ������� ���������� ������ ������� ������� � ��������������� ��������, ����� ����� ���� �������� ����� ���������
-- �� � ����� ������� ��������� ������ ����������� ������ ��� ������� ���������� ������� ����� �� ����� ��������
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

SELECT DISTINCT fio "��� ��������"
                ,SUM(decode(lower(subj)
                          ,'����������'
                          ,1
                          ,0)) over(PARTITION BY stud) "����������"
                ,SUM(decode(lower(subj)
                          ,'������'
                          ,1
                          ,0)) over(PARTITION BY stud) "������"
                ,SUM(decode(lower(subj)
                          ,'����������������'
                          ,1
                          ,0)) over(PARTITION BY stud) "����������������"
                ,SUM(decode(lower(subj)
                          ,'���������'
                          ,1
                          ,0)) over(PARTITION BY stud) "���������"
                ,SUM(1) over(PARTITION BY stud) "�����"
                ,SUM(decode(trunc(lectdate
                                ,'MONTH')
                          ,(SELECT trunc(MAX(lectdate)
                                       ,'MONTH')
                             FROM lect)
                          ,1
                          ,0)) over(PARTITION BY stud) "����� �� ����. �����"
  FROM absence;

-- TAB = 7. ����������� �������. ����� ���������� ���� � ��������� �� �������1 � �������2, ������� ���������� ��� ��������� �������. �� PL/SQL! ���� ������ �� SQL.
-- � ���� ������ ���� ��� ��������:
--  - ���� �� �������� �����, ��������, � ������� ���� ������ ROOM1 = 1, ROOM2 = 2 � ������ ROOM1 = 2, ROOM2 = 1
--  - ����� ������ �� ORACLE (���� ������������ ������, �� � ORACLE 10g ���� NOCYCLE, � � 9i ����� ��������� ���)
--  ...
-- � �����, ���� ����������� ������� ��� �������, � ������� ��� �������� ������, ���������� �� ORACLE 9i
-- 
-- ��������� ���������� &from_room � &to_room - �� ����� ������� � ����� ������� ����� �������
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
