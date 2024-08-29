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

```
init.ora file should looks like 

#
# $Header: rdbms/admin/init.ora /main/25 2015/05/14 15:02:30 kasingha Exp $
#
# Copyright (c) 1991, 2015, Oracle and/or its affiliates. All rights reserved.
# NAME
#   init.ora
# FUNCTION
# NOTES
# MODIFIED
#     kasingha   05/12/15  - 21041456 - fix copyright header
#     ysarig     02/01/12  - Renaming flash_recovery_area to
#                            fast_recovery_area
#     ysarig     05/14/09  - Updating compatible to 11.2
#     ysarig     08/13/07  - Fixing the sample for 11g
#     atsukerm   08/06/98 -  fix for 8.1.
#     hpiao      06/05/97 -  fix for 803
#     glavash    05/12/97 -  add oracle_trace_enable comment
#     hpiao      04/22/97 -  remove ifile=, events=, etc.
#     alingelb   09/19/94 -  remove vms-specific stuff
#     dpawson    07/07/93 -  add more comments regarded archive start
#     maporter   10/29/92 -  Add vms_sga_use_gblpagfile=TRUE
#     jloaiza    03/07/92 -  change ALPHA to BETA
#     danderso   02/26/92 -  change db_block_cache_protect to _db_block_cache_p
#     ghallmar   02/03/92 -  db_directory -> db_domain
#     maporter   01/12/92 -  merge changes from branch 1.8.308.1
#     maporter   12/21/91 -  bug 76493: Add control_files parameter
#     wbridge    12/03/91 -  use of %c in archive format is discouraged
#     ghallmar   12/02/91 -  add global_names=true, db_directory=us.acme.com
#     thayes     11/27/91 -  Change default for cache_clone
#     jloaiza    08/13/91 -         merge changes from branch 1.7.100.1
#     jloaiza    07/31/91 -         add debug stuff
#     rlim       04/29/91 -         removal of char_is_varchar2
#   Bridge     03/12/91 - log_allocation no longer exists
#   Wijaya     02/05/91 - remove obsolete parameters
#
##############################################################################
# Example INIT.ORA file
#
# This file is provided by Oracle Corporation as a starting point for
# customizing the Oracle Database installation for your site.
#
# NOTE: The values that are used in this file are example values only.
# You may want to adjust those values for your specific requirements.
# You might also consider using the Database Configuration Assistant
# tool (DBCA) to create a server-side initialization parameter file
# and to size your initial set of tablespaces. See the
# Oracle Database 2 Day DBA guide for more information.
###############################################################################

# Change '<ORACLE_BASE>' to point to the oracle base (the one you specify at
# install time)

db_name='ORCLCDB'
memory_target=1G
processes = 150
audit_trail ='db'
db_block_size=8192
db_domain=''
diagnostic_dest='<ORACLE_BASE>'
dispatchers='(PROTOCOL=TCP) (SERVICE=ORCLXDB)'
open_cursors=300
remote_login_passwordfile='EXCLUSIVE'
undo_tablespace='UNDOTBS1'
# You may want to ensure that control files are created on separate physical
# devices
compatible='19.0.0'
# db_recovery_file_dest=2G
# db_recovery_file_dest=2G
control_files='/opt/oracle/oradata/ORCLCDB/control01.ctl','/opt/oracle/oradata/ORCLCDB/control02.ctl'
