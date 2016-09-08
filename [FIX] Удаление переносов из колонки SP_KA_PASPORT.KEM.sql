update qwerty.sp_ka_pasport
set kem=replace(kem, chr(10), ' ')
where kem like '%'||chr(10)||'%'
