--select vid_uvol, sum(1) from (
select 
  DEPT "���", ID_TAB "���. �", FIO "�.�.�.", DAT "���� ����������", ID_PRIKAZ "������", 
  VID_UVOL "��� ����������", VID_WORK "��� ������" from (
select 
  u.*, pdr.name_u DEPT, vw.name_u VID_WORK, vw1.name_u VID_UVOL, 
  rbf.fam_u||' '||rbf.f_name_u||' '||rbf.s_name_u FIO
from
  qwerty.sp_kav_uvi u,
  qwerty.sp_podr pdr,
  qwerty.sp_vid_work vw,
  qwerty.sp_vid_work vw1,
  qwerty.sp_rb_fio rbf
where
  trunc(dat, 'YEAR')=to_date('01.01.2007', 'dd.mm.yyyy')
 and
  pdr.id_cex=u.id_cex
 and
  vw.id=u.id_xara
 and
  vw1.id=u.id_uvol
 and
  rbf.id_tab=u.id_tab
 and vw.name_u<>'�p������'
order by DEPT, FIO
)
--)group by vid_uvol
