
  CREATE TABLE "SYS"."TBL_FERIADO" 
   (	"DATA" DATE, 
	"FERIADO" VARCHAR2(80 BYTE), 
	"DATA_CHAR" VARCHAR2(20 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;


  CREATE TABLE "SYS"."TBL_CONTROLE_HORAS" 
   (	"ID" NUMBER, 
	"TR" VARCHAR2(20 BYTE), 
	"DATA_INICIO" DATE, 
	"DATA_FIM" DATE, 
	"TIPO" VARCHAR2(80 BYTE), 
	"DESCRICAO" VARCHAR2(500 BYTE), 
	"PRODUTIVIDADE" VARCHAR2(500 BYTE), 
	"SITUACAO" VARCHAR2(80 BYTE), 
	"DATA_INCLUSAO" VARCHAR2(20 BYTE) DEFAULT SYSDATE, 
	"IP" VARCHAR2(80 BYTE) DEFAULT '127.0.0.0', 
	"GOOGLE" VARCHAR2(2 BYTE), 
	"BANCO" VARCHAR2(20 BYTE) DEFAULT to_char(sysdate,'MM/YYYY')
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;

  CREATE UNIQUE INDEX "SYS"."TBL_CONTROLE_HORAS_INDEX1" ON "SYS"."TBL_CONTROLE_HORAS" ("TR", "DATA_INICIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;


  CREATE TABLE "SYS"."TBL_USUARIO" 
   (	"DSC_LOGIN" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"DSC_NOME" VARCHAR2(255 BYTE), 
	"CENTRO_CUSTO" VARCHAR2(255 BYTE), 
	"LIDER" VARCHAR2(255 BYTE), 
	 CONSTRAINT "TBL_USUARIO_PK" PRIMARY KEY ("DSC_LOGIN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;

  CREATE TABLE "SYS"."TBL_CONTROLE_HORAS" 
   (	"ID" NUMBER, 
	"TR" VARCHAR2(20 BYTE), 
	"DATA_INICIO" DATE, 
	"DATA_FIM" DATE, 
	"TIPO" VARCHAR2(80 BYTE), 
	"DESCRICAO" VARCHAR2(120 BYTE), 
	"PRODUTIVIDADE" VARCHAR2(20 BYTE), 
	"SITUACAO" VARCHAR2(80 BYTE), 
	"DATA_INCLUSAO" VARCHAR2(20 BYTE) DEFAULT SYSDATE, 
	"IP" VARCHAR2(80 BYTE) DEFAULT '127.0.0.0', 
	"GOOGLE" VARCHAR2(2 BYTE), 
	"BANCO" VARCHAR2(20 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;

  CREATE UNIQUE INDEX "SYS"."TBL_CONTROLE_HORAS_INDEX1" ON "SYS"."TBL_CONTROLE_HORAS" ("TR", "DATA_INICIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;



  CREATE OR REPLACE FORCE VIEW "SYS"."VW_HORAS_CALCULADAS" ("TR", "PROFISSIONAL", "DATA", "TIPO", "DIA", "TOTAL", "CINQUENTA_PERC", "CEM_PERC", "CENTO_CINQUENTA_PERC", "FERIADO", "CENTRO_CUSTO") AS 
  SELECT tr,
  usr.dsc_nome as Profissional,
  TO_CHAR (data_inicio, 'DD/MM/YYYY') as Data,
  hora.tipo,
  TO_CHAR (data_inicio, 'DY') as dia,
  TO_CHAR ( NUMTODSINTERVAL (ROUND (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 5 ), 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI' ) as total,
  (
  CASE
    WHEN (TO_CHAR (data_inicio, 'DY') = 'SAB')
    AND fer.feriado                  IS NULL
    THEN TO_CHAR ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
    WHEN ( NUMTODSINTERVAL (ROUND ( SUM ( (data_fim          - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') < NUMTODSINTERVAL (0, 'HOUR') )
    AND tipo                                                                                                                              = 'Hora Extra'
    AND NOT ( (TO_CHAR (data_inicio, 'DY')                                                                                                = 'DOM')
    OR fer.feriado                                                                                                                       IS NOT NULL )
    THEN TO_CHAR ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
    WHEN ( NUMTODSINTERVAL (ROUND ( SUM ( (data_fim          - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') >= NUMTODSINTERVAL (0, 'HOUR') )
    AND tipo                                                                                                                               = 'Hora Extra'
    AND NOT ( (TO_CHAR (data_inicio, 'DY')                                                                                                 = 'DOM')
    OR fer.feriado                                                                                                                        IS NOT NULL )
    THEN TO_CHAR ( ( (NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) ) - ( NUMTODSINTERVAL (SUM ( ( data_fim - data_inicio ) * 24 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') ) ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
  END ) as cinquenta_perc,
  (
  CASE
    WHEN ( NUMTODSINTERVAL (ROUND ( SUM ( (data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') > NUMTODSINTERVAL (0, 'HOUR') )
    AND tipo                                                                                                                     = 'Hora Extra'
    AND NOT ( ( TO_CHAR (data_inicio, 'DY')                                                                                      = 'DOM'
    OR TO_CHAR (data_inicio, 'DY')                                                                                               = 'SAB' )
    OR fer.feriado                                                                                                              IS NOT NULL )
    THEN TO_CHAR ( ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
    WHEN (TO_CHAR (data_inicio, 'DY') = 'DOM')
    AND fer.feriado                  IS NULL
    THEN TO_CHAR ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
      /* WHEN TO_CHAR (data_inicio, 'DY') = 'SAB' and fer.feriado is null
      THEN
      TO_CHAR (NUMTODSINTERVAL (SUM ( (data_fim - data_inicio) * 24 )+0.0004, 'HOUR') + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI')*/
  END ) as cem_perc,
  (
  CASE
    WHEN fer.feriado IS NOT NULL
    THEN TO_CHAR ( NUMTODSINTERVAL ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
  END ) as cento_cinquenta_PERC,
  fer.feriado,
  usr.centro_custo
FROM tbl_controle_horas hora,
  tbl_usuario usr,
  tbl_feriado fer
WHERE 1                                      = 1
AND TO_CHAR (hora.data_inicio, 'DD/MM/YYYY') = fer.data_char(+)
AND usr.dsc_login                            = hora.tr
AND hora.situacao                            = 'Aprovada'
GROUP BY tr,
  usr.dsc_nome,
  TO_CHAR (data_inicio, 'DD/MM/YYYY'),
  hora.tipo,
  TO_CHAR (data_inicio, 'DY'),
  fer.DATA,
  fer.feriado,
  usr.centro_custo
  order by usr.dsc_nome,
  TO_CHAR (data_inicio, 'DD/MM/YYYY');



  CREATE OR REPLACE FORCE VIEW "SYS"."VW_HORAS_CALCULADAS_ENVIO" ("TR", "PROFISSIONAL", "DATA", "TIPO", "DIA", "TOTAL", "CINQUENTA_PERC", "CEM_PERC", "CENTO_CINQUENTA_PERC", "FERIADO", "CENTRO_CUSTO") AS 
  SELECT tr,
  usr.dsc_nome as Profissional,
  TO_CHAR (data_inicio, 'DD/MM/YYYY') as Data,
  hora.tipo,
  TO_CHAR (data_inicio, 'DY') as dia,
  TO_CHAR ( NUMTODSINTERVAL (ROUND (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 5 ), 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI' ) as total,
  (
  CASE
    WHEN (TO_CHAR (data_inicio, 'DY') = 'SAB')
    AND fer.feriado                  IS NULL
    THEN TO_CHAR ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
    WHEN ( NUMTODSINTERVAL (ROUND ( SUM ( (data_fim          - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') < NUMTODSINTERVAL (0, 'HOUR') )
    AND tipo                                                                                                                              = 'Hora Extra'
    AND NOT ( (TO_CHAR (data_inicio, 'DY')                                                                                                = 'DOM')
    OR fer.feriado                                                                                                                       IS NOT NULL )
    THEN TO_CHAR ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
    WHEN ( NUMTODSINTERVAL (ROUND ( SUM ( (data_fim          - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') >= NUMTODSINTERVAL (0, 'HOUR') )
    AND tipo                                                                                                                               = 'Hora Extra'
    AND NOT ( (TO_CHAR (data_inicio, 'DY')                                                                                                 = 'DOM')
    OR fer.feriado                                                                                                                        IS NOT NULL )
    THEN TO_CHAR ( ( (NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) ) - ( NUMTODSINTERVAL (SUM ( ( data_fim - data_inicio ) * 24 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') ) ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
  END ) as cinquenta_perc,
  (
  CASE
    WHEN ( NUMTODSINTERVAL (ROUND ( SUM ( (data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') > NUMTODSINTERVAL (0, 'HOUR') )
    AND tipo                                                                                                                     = 'Hora Extra'
    AND NOT ( ( TO_CHAR (data_inicio, 'DY')                                                                                      = 'DOM'
    OR TO_CHAR (data_inicio, 'DY')                                                                                               = 'SAB' )
    OR fer.feriado                                                                                                              IS NOT NULL )
    THEN TO_CHAR ( ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) - NUMTODSINTERVAL (3, 'HOUR') ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
    WHEN (TO_CHAR (data_inicio, 'DY') = 'DOM')
    AND fer.feriado                  IS NULL
    THEN TO_CHAR ( NUMTODSINTERVAL (ROUND ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
      /* WHEN TO_CHAR (data_inicio, 'DY') = 'SAB' and fer.feriado is null
      THEN
      TO_CHAR (NUMTODSINTERVAL (SUM ( (data_fim - data_inicio) * 24 )+0.0004, 'HOUR') + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI')*/
  END ) as cem_perc,
  (
  CASE
    WHEN fer.feriado IS NOT NULL
    THEN TO_CHAR ( NUMTODSINTERVAL ( SUM ( ( data_fim - data_inicio ) * 24 ) + 0.0004, 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS' ), 'HH24:MI' )
  END ) as cento_cinquenta_PERC,
  fer.feriado,
  usr.centro_custo
FROM tbl_controle_horas hora,
  tbl_usuario usr,
  tbl_feriado fer
WHERE 1                                      = 1
AND TO_CHAR (hora.data_inicio, 'DD/MM/YYYY') = fer.data_char(+)
AND usr.dsc_login                            = hora.tr
GROUP BY tr,
  usr.dsc_nome,
  TO_CHAR (data_inicio, 'DD/MM/YYYY'),
  hora.tipo,
  TO_CHAR (data_inicio, 'DY'),
  fer.DATA,
  fer.feriado,
  usr.centro_custo order by usr.dsc_nome,
  TO_CHAR (data_inicio, 'DD/MM/YYYY');



  CREATE OR REPLACE FORCE VIEW "SYS"."VW_HORAS_REALIZADA" ("ID", "LIDER", "CENTRO_CUSTO", "TR", "DSC_NOME", "DATA_INICIO", "DATA_FIM", "TIPO", "TOTAL", "DIA") AS 
  SELECT th.id,tu.Lider, tu.centro_custo,
 th.tr ,tu.dsc_nome,th.data_inicio,th.data_fim,th.tipo,
 TO_CHAR ( NUMTODSINTERVAL (ROUND (ROUND ( ( th.data_fim - th.data_inicio ) * 24  + 0.0004, 5 ), 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI' ) as total,
 TO_CHAR (data_inicio, 'DY') as dia
  FROM tbl_controle_horas th , tbl_usuario tu  
  where 1=1 
   AND TH.tr = tu.dsc_login 
   AND th.situacao = 'Aprovada'
   order by th.data_inicio,tu.dsc_nome;

 
  CREATE OR REPLACE FORCE VIEW "SYS"."VW_HORAS_REALIZADA_ENVIO" ("ID", "LIDER", "CENTRO_CUSTO", "TR", "DSC_NOME", "DATA_INICIO", "DATA_FIM", "TIPO", "DESCRICAO", "TOTAL", "DIA", "TIPO_DIA", "VALIDACAO") AS 
  SELECT th.id,
    tu.Lider,
    tu.centro_custo,
    th.tr ,
    tu.dsc_nome,
    th.data_inicio,
    th.data_fim,
    th.tipo,
    NVL(th.DESCRICAO,' ')                                                                                                                                                                AS descricao,
    TO_CHAR ( NUMTODSINTERVAL (ROUND (ROUND ( ( th.data_fim - th.data_inicio ) * 24 + 0.0004, 5 ), 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI' ) AS total,
    TO_CHAR (data_inicio, 'DY')                                                                                                                                                          AS dia,
    CASE
      WHEN fer.data                   IS NULL
      AND TO_CHAR (data_inicio, 'DY') IN('SAB','DOM')
      THEN 'Final de semana'
      WHEN fer.data                       IS NULL
      AND TO_CHAR (data_inicio, 'DY') NOT IN('SAB','DOM')
      THEN 'Dia útil'
      WHEN fer.data IS NOT NULL
      THEN 'Feriado-'
        ||fer.feriado
    END AS TIPO_DIA,
    CASE
      WHEN data_inicio>=data_fim
      THEN 'Data Início é Maior que Data Fim'
      WHEN TO_CHAR(data_inicio,'DD/MM/YYYY')!=TO_CHAR( data_fim ,'DD/MM/YYYY')
      THEN 'Data Início é diferente da Data Fim'
      WHEN TO_CHAR (data_inicio, 'DY') IN('SEG','TER','QUA','QUI','SEX')
      AND (data_inicio BETWEEN to_date(TO_CHAR(data_inicio,'DD/MM/YYYY')
        ||' 08:00','DD/MM/YYYY HH24:MI')
      AND to_date(TO_CHAR(data_inicio,'DD/MM/YYYY')
        ||' 11:59','DD/MM/YYYY HH24:MI')
      OR data_inicio BETWEEN to_date(TO_CHAR(data_inicio,'DD/MM/YYYY')
        ||' 14:00','DD/MM/YYYY HH24:MI')
      AND to_date(TO_CHAR(data_inicio,'DD/MM/YYYY')
        ||' 17:59','DD/MM/YYYY HH24:MI'))
      THEN 'Hora cadastrada no período de trabalho'
      ELSE 'Hora Validada'
    END AS validacao
  FROM tbl_controle_horas th ,
    tbl_usuario tu,
    TBL_FERIADO fer
  WHERE 1                   =1
  AND TH.tr                 = tu.dsc_login
  AND TRUNC(th.data_inicio) = TRUNC(fer.data(+))
  ORDER BY tu.dsc_nome,
    th.data_inicio;



  CREATE OR REPLACE FORCE VIEW "SYS"."VW_HORAS_REALIZADA_GOOGLE" ("DSC_NOME", "DATA_INICIO", "DATA_FIM", "TIPO", "DESCRICAO", "TOTAL") AS 
  SELECT tu.dsc_nome,th.data_inicio,th.data_fim,th.tipo, th.DESCRICAO,
 TO_CHAR ( NUMTODSINTERVAL (ROUND (ROUND ( ( th.data_fim - th.data_inicio ) * 24  + 0.0004, 5 ), 4 ), 'HOUR' ) + TO_DATE ('01/01/2011 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'HH24:MI' ) as total
  FROM tbl_controle_horas th , tbl_usuario tu  
  where 1=1 
   AND TH.tr = tu.dsc_login 
   AND th.situacao = 'Aprovada'
   AND th.GOOGLE is null
   order by tu.dsc_nome,th.data_inicio;

DECLARE
  V_DATA      DATE;
  V_FERIADO   VARCHAR2(125);
  V_DATA_CHAR VARCHAR2(50);
TYPE T_FERIADO
IS
  TABLE OF VARCHAR2 ( 120 ) ;
  D_FERIADO T_FERIADO := T_FERIADO('01/01/2016;Confraternização Universal',
'09/02/2016;Carnaval',
'25/03/2016;Sexta-feira Santa',
'27/03/2016;Páscoa',
'21/04/2016;Tiradentes',
'01/05/2016;Dia do Trabalhador',
'08/05/2016;Dia das Mães',
'26/05/2016;Corpus Christi',
'14/08/2016;Dia dos Pais',
'07/09/2016;Independência do Brasil',
'12/10/2016;Nossa Senhora da Conceição Aparecida',
'02/11/2016;Finados',
'15/11/2016;Proclamação da República',
'25/12/2016;Natal',
'30/11/2015;Dia do Protestante',
'30/11/2016;Dia do Protestante');
BEGIN
  FOR i IN D_FERIADO.FIRST .. D_FERIADO.LAST
  LOOP
    V_DATA      :=to_date (REPLACE(regexp_substr(D_FERIADO(i), '.*[;]'),';',''),'DD/MM/YYYY');
    V_FERIADO   := REPLACE(regexp_substr(D_FERIADO(i), '[;].*'),';','');
    V_DATA_CHAR := REPLACE(regexp_substr(D_FERIADO(i), '.*[;]'),';','');
    INSERT INTO tbl_feriado ( DATA, FERIADO, DATA_CHAR ) VALUES
    (
      V_DATA,V_FERIADO,V_DATA_CHAR
    )
    ;
    dbms_output.put_line(V_FERIADO);
  END LOOP;
END;

REM INSERTING into TBL_FERIADO
SET DEFINE OFF;
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('01/01/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Confraternização Universal 2015','01/01/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('17/02/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Carnaval 2015','17/02/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('03/04/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Sexta-feira Santa 2015','03/04/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('05/04/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Páscoa 2015','05/04/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('21/04/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Tiradentes 2015','21/04/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('01/05/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Dia do Trabalhador 2015','01/05/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('10/05/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Dia das Mães 2015','10/05/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('04/06/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Corpus Christi 2015','04/06/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('09/08/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Dia dos Pais 2015','09/08/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('07/09/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Independência do Brasil 2015','07/09/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('12/10/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Nossa Senhora da Conceição Aparecida 2015','12/10/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('02/11/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Finados 2015','02/11/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('15/11/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Proclamação da República 2015','15/11/2015');
Insert into TBL_FERIADO (DATA,FERIADO,DATA_CHAR) values (to_date('25/12/15 00:00:00','DD/MM/RR HH24:MI:SS'),'Natal 2015','25/12/2015');


REM INSERTING into TBL_USUARIO
SET DEFINE OFF;
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR027446','Alessandro Werneck De Carvalho','VITRIA','Yuri Silva');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR110230','Daniel Neves Praxedes','CRM','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR026702','Ellen Yuri Uramoto','OSS','Cirineu Braga');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR027470','Fabio Gerardi Souza Brasil','OSS','Cirineu Braga');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR131883','Flavio Martins Dos Reis','CRM','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR064810','Manoel De Jesus Mendes','VITRIA','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR097985','Marcelo Iranzo De Camillis Gil','CRM','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR113778','Marcus Vinicius Cardozo Do Sacramento','CRM','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('pedro.dourado','Pedro Henrique Souza Dourado','CRM','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR143556','Pedro Henrique Vieira Silva Costa','VITRIA','Yuri Silva');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR026723','Rogerio Da Costa Arcanjo','CRM','Thomas Wagner');
Insert into TBL_USUARIO (DSC_LOGIN,DSC_NOME,CENTRO_CUSTO,LIDER) values ('TR064808','Edgar Karol Pereira De Melo','VITRIA','Yuri Silva');

