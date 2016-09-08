select t.tab_id, rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u "Ф.И.О.", 
t.uvol_date, to_char(t.uvol_date, 'yyyy') "Год увольнения", am.full_name "Последняя должность", 
hr.GET_EMPLOYEE_ADDRESS(t.tab_id, 1, 1)
from (
select pa.*, u.*, p.*, pa.id_tab tab_id, pa.dat_uvol uvol_date from qwerty.sp_ka_pens_all pa, qwerty.sp_ka_uvol u, qwerty.sp_ka_perem p
where pa.id_tab not in (select id_tab from qwerty.sp_ka_lost where lost_type=1)
and u.id_tab=pa.id_tab and u.id_uvol not in (49, 53)
and p.id_tab=u.id_tab and p.data_kon=u.data_uvol and p.id_a_cex in (1200, 210)
) t, qwerty.sp_rb_fio rbf, qwerty.sp_arx_mest am, qwerty.sp_ka_adres adr
where rbf.id_tab=t.tab_id
and am.id=t.id_n_mest
and adr.id_tab=t.tab_id and adr.fl=1
order by 4
