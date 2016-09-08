select t.*,
       'Фамилия, укр.' flag,
       substr(fam_r,
              instr(translate(fam_r,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1) wrong_symbol,
       rowid
  from qwerty.sp_rb_fio t
 where fam_r <>
       translate(fam_r,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
union all
select t.*,
       'Имя, укр.',
       substr(f_name_r,
              instr(translate(f_name_r,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1),
       rowid
  from qwerty.sp_rb_fio t
 where f_name_r <>
       translate(f_name_r,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
union all
select t.*,
       'Отчество, укр.',
       substr(s_name_r,
              instr(translate(s_name_r,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1),
       rowid
  from qwerty.sp_rb_fio t
 where s_name_r <>
       translate(s_name_r,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
union all
select t.*,
       'Фамилия, рус.',
       substr(fam_u,
              instr(translate(fam_u,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1),
       rowid
  from qwerty.sp_rb_fio t
 where fam_u <>
       translate(fam_u,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
union all
select t.*,
       'Имя, рус.',
       substr(f_name_u,
              instr(translate(f_name_u,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1),
       rowid
  from qwerty.sp_rb_fio t
 where f_name_u <>
       translate(f_name_u,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
union all
select t.*,
       'Отчество, рус.',
       substr(s_name_u,
              instr(translate(s_name_u,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1),
       rowid
  from qwerty.sp_rb_fio t
 where s_name_u <>
       translate(s_name_u,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
