-- TAB = формула расчета количество дней в месяце
--  (без учета високосности года)
--  x = номер месяца
-- f(x) = 28 + (x + floor(x⁄8)) mod 2 + 2 mod x + 2 * floor(1⁄x)
SELECT 28 + MOD(&x + floor(&x / 8)
               ,2) + MOD(2
                        ,&x) + 2 * floor(1 / &x) days_in_month
  FROM dual
