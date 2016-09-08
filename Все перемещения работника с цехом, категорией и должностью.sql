select *
  from (select id_tab,
               id_zap,
               data_zap,
               id_work,
               data_work,
               decode(fl,
                      1,
                      /*to_date('&<name="Дата выборки">',
                                                                          'dd.mm.yyyy') + 1,*/
                      sysdate + 1,
                      2,
                      lead(data_work)
                      over(partition by id_tab order by data_work) - 1,
                      3,
                      data_kon) data_kon, --Для работающих в день выборки - следующий день после выборки,
               --для перемещенных - предыдущий день перед перемещением (чтобы перемещения, сделанные в день выборки, не пересекались с работающими)
               --для уволенных - день увольнения
               id_prikaz,
               razr,
               id_priem_perem,
               id_cex,
               dept_name,
               id_kat,
               kat_name,
               id_mest,
               mest_name,
               fl
          from (select w.id_tab, --Таб. №
                       w.id_zap, --№ записи
                       w.data_zap, --Дата записи
                       w.id_work, --Вид работы
                       w.data_work, --Дата начала работы
                       w.data_kon_w data_kon, --Дата окончания работы
                       w.id_prikaz, --Номер приказа, о приеме/переводе на данное рабочее место
                       w.razr, --Разряд
                       osn.id_priem id_priem_perem, --Вид приема/перемещения
                       s.id_cex, --Код цеха
                       pdr.name_u dept_name, --Название цеха
                       s.id_kat, --Код категории
                       kat.name_u kat_name, --Название категории
                       s.id_mest, --Код рабочего места
                       m.full_name_u mest_name, --Название рабочего места (должности)
                       1 fl --Флаг: 1-текущее место работы, 2-перемещение, 3-увольнение
                  from qwerty.sp_ka_work w,
                       qwerty.sp_rb_key  rbk,
                       qwerty.sp_stat    s,
                       qwerty.sp_ka_osn  osn,
                       qwerty.sp_podr    pdr,
                       qwerty.sp_kat     kat,
                       qwerty.sp_mest    m
                 where w.id_tab = rbk.id_tab
                   and rbk.id_stat = s.id_stat
                   and w.id_tab = osn.id_tab
                   and s.id_cex = pdr.id_cex
                   and s.id_kat = kat.id_kat
                   and s.id_mest = m.id_mest
                union all
                select prm.id_tab,
                       prm.id_zap,
                       prm.data_zap,
                       prm.id_work,
                       prm.data_work,
                       prm.data_kon,
                       prm.id_prikaz,
                       prm.a_razr,
                       prm.id_perem,
                       prm.id_n_cex,
                       acex.name_u,
                       prm.id_n_kat,
                       akat.name_u,
                       prm.id_n_mest,
                       decode(nvl(amest.full_name, ''),
                              '',
                              amest.name_u,
                              amest.full_name),
                       2
                  from qwerty.sp_ka_perem prm,
                       qwerty.sp_arx_cex  acex,
                       qwerty.sp_arx_kat  akat,
                       qwerty.sp_arx_mest amest
                 where prm.id_n_cex = acex.id
                   and prm.id_n_kat = akat.id
                   and prm.id_n_mest = amest.id
                union all
                select u.id_tab,
                       u.id_zap,
                       u.data_zap,
                       u.id_uvol,
                       u.data_uvol,
                       u.data_uvol,
                       u.id_prikaz,
                       -99,
                       -99,
                       -99,
                       '-?-',
                       -99,
                       '-?-',
                       -99,
                       '-?-',
                       3
                  from qwerty.sp_ka_uvol u))
 where to_date('&<name="Дата выборки">', 'dd.mm.yyyy') between data_work and
       data_kon
