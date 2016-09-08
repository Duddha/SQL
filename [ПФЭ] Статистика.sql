-- TAB = ��� ��������� ���������� �� ���
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 order by id_cex, fio;

-- TAB = �������� ����������
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 where (nvl(id_wt1, 0) + nvl(id_wt2, 0) + nvl(id_wt3, 0)) > 0
 order by id_cex, fio;

-- TAB = �� �������� ����������
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 where (nvl(id_wt1, 0) + nvl(id_wt2, 0) + nvl(id_wt3, 0)) = 0
 order by id_cex, fio;

-- TAB = ������ ���������
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 where not (id_wt1 is null)
   and nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0) =
       nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
       nvl2(wt3_last_test, 1, 0)
 order by id_cex, fio;
-- ���
-- TAB = ������ ��������� 2
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from (select (nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0)) num_of_wt,
               (nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
               nvl2(wt3_last_test, 1, 0)) num_of_test,
               t.*
          from QWERTY.SP_PFEV_RESULTS_LAST t) prl
 where (num_of_wt <> 0 and num_of_test <> 0)
   and num_of_wt = num_of_test
 order by id_cex, fio;

-- TAB = ������ �� ���������
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from (select (nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0)) num_of_wt,
               (nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
               nvl2(wt3_last_test, 1, 0)) num_of_test,
               t.*
          from QWERTY.SP_PFEV_RESULTS_LAST t) prl
 where (num_of_wt <> 0 and num_of_test <> 0)
   and num_of_wt > num_of_test
 order by id_cex, fio;

-- TAB = �� ������ ����������
select cex_name      "���",
       id_tab        "���. �",
       fio           "�.�.�.",
       mest_name     "���������",
       id_wt1        "��� ����� 1",
       wt1_last_test "���� ����� �� ��1",
       id_group1     "������ ��� �� ��1",
       wt1_next_test "���� ���������� ����� �� ��1",
       id_wt2        "��� ����� 2",
       wt2_last_test "���� ����� �� ��2",
       id_group2     "������ ��� �� ��2",
       wt2_next_test "���� ���������� ����� �� ��2",
       id_wt3        "��� ����� 3",
       wt3_last_test "���� ����� �� ��3",
       id_group3     "������ ��� �� ��3",
       wt3_next_test "���� ���������� ����� �� ��3",
       prl.*
  from (select (nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0)) num_of_wt,
               (nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
               nvl2(wt3_last_test, 1, 0)) num_of_test,
               t.*
          from QWERTY.SP_PFEV_RESULTS_LAST t) prl
 where num_of_wt > 0 and num_of_test = 0
 order by id_cex, fio
