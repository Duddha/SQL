select t.*,
       substr(kem,
              instr(translate(kem,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999'),
                    '9'),
              1) wrong_symbol,
        translate(kem,
                              'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                              '999999999999999999999999999999999999999999999999999999') tr
       ,rowid
  from qwerty.sp_ka_pasport t
 where kem <>
       translate(kem,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"`',
                 '999999999999999999999999999999999999999999999999999999')
