-- TAB = ����� ��������� ������ ��������� (� �����)
SELECT a.id_department "��� ����"
       ,a.id_workplace  "��� ��"
       ,p.name_u        "���"
       ,m.full_name_u   "���������"
       ,a.salary        "��������� ������"
       ,a.data          "���� ���������"
       ,a.author        "��� �������"
  FROM qwerty.sp_arch a
      ,qwerty.sp_podr p
      ,qwerty.sp_mest m
 WHERE a.id_event = 5
   AND a.id_department = p.id_cex(+)
   AND a.id_workplace = m.id_mest(+)
 ORDER BY a.id_archive
