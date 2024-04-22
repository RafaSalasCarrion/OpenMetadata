
  
  delete from aux_rel_zip_ccoste;
  commit;
    
  select a.s#ins,c.zip, c.city,c.city2
    into ##base_instal
  from ma_installations  as a,addresses as c
  where a.s#addr = c.s#addr
    and  zip is not null and  zip<>'' ;
 
 --------------------------------------------------------

  select * into ##base_instal2  
  from ##base_instal ;

  select distinct a.* into ##base_instal3
  from ##base_instal2  a ;

  select s#ins, zip, city, city2 into ##conjuntoB from  ##base_instal3; --OK
  
  select s#ins, zip, city, city2 into ##base_instal4 from ##base_instal3 ;
 
  select distinct a.* into ##base_instal5
  from ##base_instal4 a  ; 

  insert into ##conjuntoB select s#ins, zip, city, city2 from ##base_instal5 ; --OK
   
  select s#ins, zip, city, city2 into ##base_instal6 from ##base_instal5;
  
 --------------------------------------------------------
 --Tercer intento de asignacion. Los que aun no tiene y tiene mas de un CC por CP pero por poblacion
 --no se logra se asigna uno cualquiera 
  
  select cc, desc_delegado as delegado, desc_gerente as gerente, desc_d_terr as territorial, desc_d_reg as regional
   into ##estr_terr
  from d_estructura_territorial 
  where fecha_cierre=(select max(fecha_cierre) from d_estructura_territorial);
  
  select a.*, b.delegado, b.gerente, b.territorial, b.regional into ##total
  from ##base_instal6 a left join ##estr_terr b on a.idccoste=b.cc;
  
  insert into aux_rel_zip_ccoste (s#ins, idccoste, delegado, gerente, territorial, regional)
  select s#ins, idccoste, delegado, gerente, territorial, regional
  from ##total;

  insert into aux_rel_zip_ccoste (s#ins)
  select s#ins
  from ma_installations
  where s#ins not in (select s#ins from ##total); 
  commit; 
 
