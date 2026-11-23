-- 1: DataWarehouse - star schema tabelas
.read 01_tables_data_warehouse.sql

-- 2: DataWarehouse- Carregar CSV p/ star schema
.read 02_load_schema_dw.sql

-- 3: Criar flat mart
.read 03_flat_table.sql

-- 4: Criar priority mart
.read 06_create_priority_mart.sql

--5: Inserir dados priority mart
.read 07_update_priority_mart.sql