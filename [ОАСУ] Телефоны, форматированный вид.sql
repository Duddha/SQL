--TAB = ��������������� ������ ���������

select id_tab
      ,num_tel
      ,hom_wor
      ,ltrim(replace('(' || substr(phone,
                                   1,
                                   3) || ') ' || substr(phone,
                                                        4,
                                                        3) || '-' || substr(phone,
                                                                            7,
                                                                            2) || '-' || substr(phone,
                                                                                                9,
                                                                                                2),
                     '(   )',
                     '*'),
             ' *-') phone_number
  from (select id_tab
              ,num_tel
              ,replace(num_tel,
                       '-') phone_number
              ,lpad(translate(num_tel,
                            '0123456789- ', '0123456789'),
                    10,
                    ' ') phone
              ,hom_wor
          from qwerty.sp_ka_telef) 
