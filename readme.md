# Documentação de Configuração do Oracle Database

Este arquivo README documenta as alterações feitas na configuração do Oracle Database e os comandos SQL executados para garantir a compatibilidade e o funcionamento adequado com a versão 19c do Oracle.

## Alterações no Arquivo `init.ora`

Foram realizadas as seguintes mudanças no arquivo `init.ora` para garantir a compatibilidade com a versão 19c do Oracle Database:

1. **Atualização do Parâmetro `compatible`**
   - **Antes:**
     ```plaintext
     compatible='11.2.0'
     ```
   - **Depois:**
     ```plaintext
     compatible='19.0.0'
     ```
   - **Motivo:** Atualizado para garantir que o Oracle esteja configurado para operar com a versão 19c, evitando problemas de compatibilidade com arquivos de controle e dados.

2. **Correção de Duplicações**
   - **Antes:**
     ```plaintext
     audit_file_dest=/opt/oracle/admin/orcl/adump
     ...
     control_files = (ora_control1, ora_control2)
     ...
     audit_file_dest=/opt/oracle/admin/orcl/adump
     control_files='/opt/oracle/oradata/ORCLCDB/control01.ctl','/opt/oracle/oradata/ORCLCDB/control02.ctl'
     ```
   - **Depois:**
     ```plaintext
     audit_file_dest='/opt/oracle/admin/orcl/adump'
     ...
     control_files='/opt/oracle/oradata/ORCLCDB/control01.ctl','/opt/oracle/oradata/ORCLCDB/control02.ctl'
     ```
   - **Motivo:** Remoção de duplicações de parâmetros para evitar conflitos e garantir o uso correto dos caminhos e configurações.

3. **Remoção de Parâmetros Obsoletos ou Comentados**
   - **Antes:**
     ```plaintext
     # db_recovery_file_dest='<ORACLE_BASE>/fast_recovery_area'
     # db_recovery_file_dest_size=2G
     # db_recovery_file_dest=2G
     ```
   - **Depois:**
     ```plaintext
     # (Esses parâmetros foram mantidos como comentados ou removidos, pois não eram necessários para a configuração atual.)
     ```
   - **Motivo:** Simplificação do arquivo de configuração ao manter os parâmetros obsoletos ou não necessários comentados.

## Comandos SQL Executados

Aqui está uma lista dos comandos SQL que foram executados durante o processo de recuperação e configuração do banco de dados:

1. **Verificação dos Arquivos de Controle**
   ```sql
   SHOW PARAMETER control_files;




CREATE CONTROLFILE REUSE DATABASE "ORCLCDB" RESETLOGS ARCHIVELOG
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
MAXINSTANCES 8
MAXLOGHISTORY 292
LOGFILE
  GROUP 1 '/opt/oracle/oradata/ORCLCDB/redo01.log'  SIZE 50M,
  GROUP 2 '/opt/oracle/oradata/ORCLCDB/redo02.log'  SIZE 50M,
  GROUP 3 '/opt/oracle/oradata/ORCLCDB/redo03.log'  SIZE 50M
DATAFILE
  '/opt/oracle/oradata/ORCLCDB/system01.dbf',
  '/opt/oracle/oradata/ORCLCDB/sysaux01.dbf',
  '/opt/oracle/oradata/ORCLCDB/undotbs01.dbf',
  '/opt/oracle/oradata/ORCLCDB/users01.dbf'
CHARACTER SET AL32UTF8;

SELECT * FROM v$version;

STARTUP NOMOUNT;
ALTER DATABASE MOUNT;

ALTER SYSTEM SET control_files='/opt/oracle/oradata/ORCLCDB/control01.ctl','/opt/oracle/oradata/ORCLCDB/control02.ctl' SCOPE=SPFILE;

CREATE CONTROLFILE REUSE DATABASE "ORCLCDB" RESETLOGS ARCHIVELOG
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
MAXINSTANCES 8
MAXLOGHISTORY 292
LOGFILE
  GROUP 1 '/opt/oracle/oradata/ORCLCDB/redo01.log'  SIZE 50M,
  GROUP 2 '/opt/oracle/oradata/ORCLCDB/redo02.log'  SIZE 50M,
  GROUP 3 '/opt/oracle/oradata/ORCLCDB/redo03.log'  SIZE 50M
DATAFILE
  '/opt/oracle/oradata/ORCLCDB/system01.dbf',
  '/opt/oracle/oradata/ORCLCDB/sysaux01.dbf',
  '/opt/oracle/oradata/ORCLCDB/undotbs01.dbf',
  '/opt/oracle/oradata/ORCLCDB/users01.dbf'
CHARACTER SET AL32UTF8;


STARTUP;

SELECT status, instance_name FROM v$instance;

ALTER SYSTEM SET control_files='/opt/oracle/oradata/ORCLCDB/control01.ctl','/opt/oracle/oradata/ORCLCDB/control02.ctl' SCOPE=BOTH;
