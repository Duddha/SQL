-- RECORDS = ALL
-- TAB = �������. ����������
SELECT t.*
      ,ROWID
  FROM qwerty.sp_narpo t
 ORDER BY id;
-- TAB = ����������� ��������
SELECT t.*
      ,ROWID
  FROM qwerty.sp_narpo_ext t
 ORDER BY id_narpo
