SELECT RBF.ID_TAB "Таб.№",
       RBF.FAM_U || ' ' || RBF.F_NAME_U || ' ' || RBF.S_NAME_U "Ф.И.О.",
       P.NAME_U "Цех",
       M.FULL_NAME_U "Должность",
       F2.DATA_WORK "Дата приёма"
  FROM QWERTY.SP_KAV_PEREM_F2 F2,
       QWERTY.SP_RB_FIO       RBF,
       QWERTY.SP_RB_KEY       RBK,
       QWERTY.SP_STAT         ST,
       QWERTY.SP_PODR         P,
       QWERTY.SP_MEST         M
 WHERE F2.ID_ZAP = 1
   AND F2.DATA_WORK <= TO_DATE('01.01.1979', 'dd.mm.yyyy')
   AND RBF.ID_TAB = F2.ID_TAB
   AND RBF.STATUS = 1
   AND RBK.ID_TAB = RBF.ID_TAB
   AND ST.ID_STAT = RBK.ID_STAT
   AND P.ID_CEX = ST.ID_CEX
   AND M.ID_MEST = ST.ID_MEST
 ORDER BY F2.DATA_WORK
