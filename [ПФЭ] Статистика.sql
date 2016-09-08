-- TAB = Все последние результаты по ПФЭ
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 order by id_cex, fio;

-- TAB = Подлежат экспертизе
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 where (nvl(id_wt1, 0) + nvl(id_wt2, 0) + nvl(id_wt3, 0)) > 0
 order by id_cex, fio;

-- TAB = НЕ подлежат экспертизе
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 where (nvl(id_wt1, 0) + nvl(id_wt2, 0) + nvl(id_wt3, 0)) = 0
 order by id_cex, fio;

-- TAB = Прошли полностью
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from QWERTY.SP_PFEV_RESULTS_LAST prl
 where not (id_wt1 is null)
   and nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0) =
       nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
       nvl2(wt3_last_test, 1, 0)
 order by id_cex, fio;
-- или
-- TAB = Прошли полностью 2
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from (select (nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0)) num_of_wt,
               (nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
               nvl2(wt3_last_test, 1, 0)) num_of_test,
               t.*
          from QWERTY.SP_PFEV_RESULTS_LAST t) prl
 where (num_of_wt <> 0 and num_of_test <> 0)
   and num_of_wt = num_of_test
 order by id_cex, fio;

-- TAB = Прошли НЕ полностью
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from (select (nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0)) num_of_wt,
               (nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
               nvl2(wt3_last_test, 1, 0)) num_of_test,
               t.*
          from QWERTY.SP_PFEV_RESULTS_LAST t) prl
 where (num_of_wt <> 0 and num_of_test <> 0)
   and num_of_wt > num_of_test
 order by id_cex, fio;

-- TAB = Не прошли экспертизу
select cex_name      "Цех",
       id_tab        "Таб. №",
       fio           "Ф.И.О.",
       mest_name     "Должность",
       id_wt1        "Вид работ 1",
       wt1_last_test "Дата теста по ВР1",
       id_group1     "Группа ПФЭ по ВР1",
       wt1_next_test "Дата следующего теста по ВР1",
       id_wt2        "Вид работ 2",
       wt2_last_test "Дата теста по ВР2",
       id_group2     "Группа ПФЭ по ВР2",
       wt2_next_test "Дата следующего теста по ВР2",
       id_wt3        "Вид работ 3",
       wt3_last_test "Дата теста по ВР3",
       id_group3     "Группа ПФЭ по ВР3",
       wt3_next_test "Дата следующего теста по ВР3",
       prl.*
  from (select (nvl2(id_wt1, 1, 0) + nvl2(id_wt2, 1, 0) + nvl2(id_wt3, 1, 0)) num_of_wt,
               (nvl2(wt1_last_test, 1, 0) + nvl2(wt2_last_test, 1, 0) +
               nvl2(wt3_last_test, 1, 0)) num_of_test,
               t.*
          from QWERTY.SP_PFEV_RESULTS_LAST t) prl
 where num_of_wt > 0 and num_of_test = 0
 order by id_cex, fio
