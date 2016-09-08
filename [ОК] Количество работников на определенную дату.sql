-- TAB = Выборка всех работников завода на определенную дату
--
-- !!! ВНИМАНИЕ !!!
--   ID_WORK соответствует значению из первой записи
with all_work as
 (select id_tab,
         id_zap,
         data_zap,
         id_work,
         data_work,
         nvl(data_kon_w, sysdate) data_kon,
         id_prikaz,
         razr,
         1 fl
    from qwerty.sp_ka_work
  union all
  select id_tab,
         id_zap,
         data_zap,
         id_work,
         data_work,
         data_kon,
         id_prikaz,
         a_razr,
         2
    from qwerty.sp_ka_perem
  union all
  select id_tab,
         id_zap,
         data_zap,
         id_uvol,
         data_uvol,
         null,
         id_prikaz,
         null,
         3
    from qwerty.sp_ka_uvol)

select *
  from (select t.*,
               max(data_kon) over(partition by id_tab, group_id) data_finish
          from (select aw.*,
                       sum(decode(abs(aw.id_zap), 1, 1, 0)) over(partition by id_tab order by id_tab, data_work) group_id
                  from all_work aw
                 order by id_tab, data_work) t)
 where abs(id_zap) = 1
   and to_date(&< name = "Дата выборки" type = "string" 
                  hint = "Дата в формате ДД.ММ.ГГГГ (пусто = текущая дата)" 
                  default = "select to_char(sysdate, 'dd.mm.yyyy') from dual"
                  ifempty = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >,
               'dd.mm.yyyy') between data_work and data_finish
