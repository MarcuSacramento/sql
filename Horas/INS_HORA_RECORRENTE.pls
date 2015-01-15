create or replace PROCEDURE         INS_HORA_RECORRENTE(
    MATRICULA    IN VARCHAR2 ,
    DATA_INICIAL IN VARCHAR2 ,
    HORA_INICIAL IN VARCHAR2 ,
    HORA_FINAL   IN VARCHAR2 ,
    QTDE_DIAS    IN NUMBER ,
    tipo in varchar2,
    observacao in varchar2,
    status in varchar2
    )
AS
  qtde_insert NUMBER :=0;
  data_inicio DATE;
  data_fim    DATE;
BEGIN
  data_inicio := to_date(DATA_INICIAL||' '||HORA_INICIAL,'DD/MM/YYYY HH24:MI');
  data_fim    := to_date(DATA_INICIAL||' '||HORA_FINAL,'DD/MM/YYYY HH24:MI');
  LOOP
    IF(TO_CHAR (data_inicio, 'DY') NOT IN('SÁB','DOM'))THEN
    begin
      INSERT
      INTO tbl_controle_horas
        (
          ID,
          TR,
          DATA_INICIO,
          DATA_FIM,
          TIPO,
          DESCRICAO,
          PRODUTIVIDADE,
          SITUACAO,
          DATA_INCLUSAO,
          IP
        )
        VALUES
        (
          tbl_controle_horas_seq.nextval ,
          MATRICULA,
          data_inicio,
          data_fim,
          tipo,
          observacao,
          'NULL',
          status,
          sysdate,
          to_char(sysdate,'MM/YYYY')
        );
        
        exception when others
        then
          DBMS_OUTPUT.PUT_LINE('Erro:'||SQLERRM);
        end;
      data_inicio :=data_inicio+1;
      data_fim    :=data_fim   +1;
      qtde_insert :=qtde_insert+1;
    ELSE
      data_inicio:=data_inicio+2;
      data_fim   :=data_fim   +2;
    END IF;
    EXIT
  WHEN qtde_insert = QTDE_DIAS ;
  END LOOP;
END INS_HORA_RECORRENTE;