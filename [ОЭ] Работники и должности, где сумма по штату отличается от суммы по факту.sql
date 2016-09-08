SELECT rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       rbf.id_tab "Таб. №",
       department "Цех",
       category "Категория",
       workplace "Должность",
       id_staff "Код по штату",
       NVL(amount, 0) /*amount */"Кол-во (штат)",
       NVL(kolf, 0) /*amount_fakt */"Кол-во (факт)",
       degree "Разряд",
       salary "Оклад",
       NVL(summa, 0) /*summa */"Сумма (штат)",
       NVL(sum_okl, 0) /*summa_fakt */"Сумма (факт)"
  FROM qwerty.sp_staff_today st,
       qwerty.sp_rbv_kolf    kolf,
       qwerty.sp_kp          e,
       qwerty.sp_rb_key      rbk,
       qwerty.sp_rb_fio      rbf
 WHERE (id_department IN (SELECT dept_id
                            FROM qwerty.sp_department_today
                          CONNECT BY PRIOR dept_id = dept_parent_id
                           START WITH dept_id = 0))
   AND (kolf.id_stat(+) = id_staff)
   AND (e.id_kp(+) = profcode)
--Сумма по факту выше произведения оклада на фактическое количество   
   --and sum_okl > salary * kolf
--Сумма по факту выше суммы по штату   
   and sum_okl > summa
   and rbk.id_stat = st.id_staff
   and rbf.id_tab = rbk.id_tab
 ORDER BY 3, 6, 2, 4
