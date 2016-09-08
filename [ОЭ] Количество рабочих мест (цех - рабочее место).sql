select 
  distinct st.id_cex, st.id_mest, m.full_name_u
from 
  qwerty.sp_stat st, qwerty.sp_mest m
where
  m.id_mest=st.id_mest
order by 1, 3  
--group by
--  st.id_cex, st.id_mest, m.full_name_u
