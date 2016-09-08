-- Правильный ROWNUM выборки с сортировкой

-- Source = http://oraclemaniacs.blogspot.com/2011/04/rownum.html
-- TAB = Правильный порядковый номер
SELECT rownum
      ,p.*
  FROM qwerty.sp_podr p
CONNECT BY 1 = 2 -- Заведомо невыполняемое условие, чтобы не образовалось дерево
 ORDER SIBLINGS BY name_u;

-- TAB = В отличие от этого
SELECT rownum
      ,p.*
  FROM qwerty.sp_podr p
 ORDER BY name_u
