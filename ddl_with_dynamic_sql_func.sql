/* Создадим структуру таблиц */

/* Перед созданием удалим, на случай если такие таблицы уже есть */
drop table src_transactions;
drop table fact_transactions;
drop table dim_cards_hist;
drop table dim_accounts_hist;
drop table dim_terminals_hist;
drop table dim_clients_hist;
drop table report;

/* создаем SRC, STG, FACT и DIM таблицы*/
create table src_transactions(
    trans_id varchar2(10 BYTE),
    tr_date timestamp,
    card_num varchar2(25 BYTE),
    account_num varchar2(25 BYTE),
    account_valid_to date,
    client_id varchar2(20 BYTE),
    last_name varchar2(100 BYTE),
    first_name varchar2(100 BYTE),
    patronymic varchar2(100 BYTE),
    date_of_birth date,
    passport_num varchar2(10 BYTE),
    passport_valid_to date,
    phone varchar2(20 BYTE),
    oper_type varchar2(20 BYTE),
    amount number(9,2),
    oper_result varchar2(20 BYTE),
    terminal_id varchar2(20 BYTE),
    terminal_type varchar2(10 BYTE),
    terminal_city varchar2(100 BYTE),
    terminal_address varchar2(500 BYTE)
);
comment on column src_transactions.trans_id is 'Transaction id';
comment on column src_transactions.tr_date is 'Transaction date time';
comment on column src_transactions.card_num is 'Transaction card num';
comment on column src_transactions.account_num is 'Account num';
comment on column src_transactions.account_valid_to is 'Account valid to date';
comment on column src_transactions.client_id is 'Client id';
comment on column src_transactions.last_name is 'Client last name';
comment on column src_transactions.first_name is 'Client first name';
comment on column src_transactions.patronymic is 'Client patronymic';
comment on column src_transactions.date_of_birth is 'Client date of birth';
comment on column src_transactions.passport_num is 'Passport num';
comment on column src_transactions.passport_valid_to is 'Passport valid to date';
comment on column src_transactions.phone is 'Client phone';
comment on column src_transactions.oper_type is 'Operation type';
comment on column src_transactions.amount is 'Amount';
comment on column src_transactions.oper_result is 'Oper result';
comment on column src_transactions.terminal_id is 'Terminal num';
comment on column src_transactions.terminal_type is 'Terminal type';
comment on column src_transactions.terminal_city is 'City';
comment on column src_transactions.terminal_address is 'Address';

create table dim_terminals_hist(
    terminal_id varchar2(20 BYTE),
    terminal_type varchar2(10 BYTE),
    terminal_city varchar2(100 BYTE),
    terminal_address varchar2(500 BYTE),
    start_dt timestamp,
    end_dt timestamp,
    constraint dim_term_hist_t_id_e_dt_pk primary key (terminal_id, end_dt)
);
comment on column dim_terminals_hist.terminal_id is 'Terminal num';
comment on column dim_terminals_hist.terminal_type is 'Terminal type';
comment on column dim_terminals_hist.terminal_city is 'City of terminal';
comment on column dim_terminals_hist.terminal_address is 'Address of terminal';
comment on column dim_terminals_hist.start_dt is 'Start period version existence';
comment on column dim_terminals_hist.end_dt is 'End period version existence';

create table dim_clients_hist(
    client_id varchar2(20 BYTE),
    last_name varchar2(100 BYTE),
    first_name varchar2(100 BYTE),
    patronymic varchar2(100 BYTE),
    date_of_birth date,
    passport_num varchar2(10 BYTE),
    passport_valid_to date,
    phone varchar2(20 BYTE),
    start_dt timestamp,
    end_dt timestamp,
    constraint dim_clients_hist_c_id_e_dt_pk primary key (client_id, end_dt)
);

comment on column dim_clients_hist.client_id is 'Client id';
comment on column dim_clients_hist.last_name is 'Client last name';
comment on column dim_clients_hist.first_name is 'Client first name';
comment on column dim_clients_hist.patronymic is 'Client patronymic';
comment on column dim_clients_hist.date_of_birth is 'Client date of birth';
comment on column dim_clients_hist.passport_num is 'Passport num';
comment on column dim_clients_hist.passport_valid_to is 'Passport valid to date';
comment on column dim_clients_hist.phone is 'Client phone';
comment on column dim_clients_hist.start_dt is 'Start period version existence';
comment on column dim_clients_hist.end_dt is 'End period version existence';

create table dim_accounts_hist(
    account_num varchar2(25 BYTE),
    valid_to date,
    client_id varchar2(20 BYTE),
    start_dt timestamp,
    end_dt timestamp,
    constraint dim_acc_hist_a_num_e_dt_pk primary key (account_num, end_dt)
);
comment on column dim_accounts_hist.account_num is 'Account num';
comment on column dim_accounts_hist.valid_to is 'Account valid to date';
comment on column dim_accounts_hist.client_id is 'Client id';
comment on column dim_accounts_hist.start_dt is 'Start period version existence';
comment on column dim_accounts_hist.end_dt is 'End period version existence';

create table dim_cards_hist(
    card_num varchar2(25 BYTE),
    account_num varchar2(25 BYTE),
    start_dt timestamp,
    end_dt timestamp,
    constraint dim_card_hist_c_num_e_dt_pk primary key (card_num, end_dt)
);
comment on column dim_cards_hist.card_num is 'Card num';
comment on column dim_cards_hist.account_num is 'Account num';
comment on column dim_cards_hist.start_dt is 'Start period version existence';
comment on column dim_cards_hist.end_dt is 'End period version existence';

create table fact_transactions(
    trans_id varchar2(10 BYTE),
    trans_date timestamp,
    card_num varchar2(25 BYTE),
    oper_type varchar2(20 BYTE),
    amount number(9,2),
    oper_result varchar2(20 BYTE),
    terminal_id varchar2(20 BYTE),
    constraint dim_tran_hist_t_id_pk primary key (trans_id)
);
comment on column fact_transactions.trans_id is 'Transaction id';
comment on column fact_transactions.trans_date is 'Transaction date time';
comment on column fact_transactions.card_num is 'Transaction card num';
comment on column fact_transactions.oper_type is 'Operation type';
comment on column fact_transactions.amount is 'Amount';
comment on column fact_transactions.oper_result is 'Oper result';
comment on column fact_transactions.terminal_id is 'Terminal num';

create table report(
    fraud_dt timestamp,
    passport varchar2(10 BYTE),
    fio varchar2(300 BYTE),
    phone varchar2(20 BYTE),
    fraud_type varchar2(120 BYTE),
    report_dt timestamp,
    -- добавлю такой составной PK, чтобы защититься от повторной вставки в отчет одинаковых записей (если запускать report-скрипт несколько раз подряд, например:)
    constraint report_fr_dt_pass_fr_type_pk primary key (fraud_dt, passport, fraud_type)
);
comment on column report.fraud_dt is 'Fraud time (last fraud time)';
comment on column report.passport is 'Client''s passport num';
comment on column report.fio is 'FIO of client';
comment on column report.phone is 'Client''s phone';
comment on column report.fraud_type is 'Fraud type';
comment on column report.report_dt is 'Report time';

/* создаем таблицы для ETL-процесса, предварительно удалив их */
drop table meta_increment;
drop table stg_transactions;

-- meta-данные
create table meta_increment
(table_name varchar2(30),
max_tran_dt timestamp,
previous_max_tran_dt timestamp); -- добавим для понимания интервала инкремента

-- stage-таблица
create table stg_transactions as select * from src_transactions where 1=0;

/* Создадим пакет  с реализацией функционала ETL*/
CREATE OR REPLACE PACKAGE etl_process 
IS
DEFAULT_MIN_DATE CONSTANT timestamp := to_timestamp('01.01.1800 00:00:00', 'DD.MM.YYYY HH24:MI:SS');
DEFAULT_MAX_DATE CONSTANT timestamp := to_timestamp('31.12.9999 23:59:59', 'DD.MM.YYYY HH24:MI:SS');
ONE_SECOND_INTERVAL CONSTANT INTERVAL DAY TO SECOND := '0 00:00:01';

procedure meta_first_fill;
procedure update_meta;
procedure clean_stage;
procedure insert_into_stage;
procedure insert_into_dim_terminals_hist(term_row IN dim_terminals_hist%ROWTYPE);
procedure load_data_into_dim_terminals;
procedure insert_into_dim_clients_hist(client_row IN dim_clients_hist%ROWTYPE);
procedure load_data_into_dim_clients;
procedure insert_into_dim_accounts_hist(acc_row IN dim_accounts_hist%ROWTYPE);
procedure load_data_into_dim_accounts;
procedure insert_into_dim_cards_hist(card_row IN dim_cards_hist%ROWTYPE);
procedure load_data_into_dim_cards;
procedure load_data_into_fact_trans;
procedure load_data_into_all_tbls;
END etl_process;
/

CREATE OR REPLACE PACKAGE BODY etl_process 
IS
    /* Вспомогательная ф-я для проверки наличия записи в таблице по какому-то "id"
    Используем динамический SQL
    table_name_in - название таблицы, в которой ищем запись
    field_name - поле, по которому ищем запись
    field_id - идентификатор записи 
    RETURN: TRUE - запись есть в таблице; FALSE - записи нет*/
    function is_record_in_tbl(table_name_in IN varchar2, field_name IN varchar2, field_id IN varchar2)
    return BOOLEAN
    IS
    query_str varchar2(32767);
    rec_count number;
    BEGIN
        query_str := 'select count(*) from ' || table_name_in ||
        ' where '|| field_name ||' = :field_id';

        EXECUTE IMMEDIATE query_str INTO rec_count 
        USING field_id;
        
        return rec_count > 0;
    END is_record_in_tbl;

    /* первая загрузка в META */
    procedure meta_first_fill   
    IS   
    BEGIN   
        insert into meta_increment
        select 'FACT_TRANSACTIONS', DEFAULT_MIN_DATE, DEFAULT_MIN_DATE from dual
        where (select count(*) from meta_increment
                where table_name='FACT_TRANSACTIONS') = 0;
        commit;       
    END meta_first_fill;
     
    /* Обновление мета-данных */
    procedure update_meta   
    IS  
    BEGIN   
        update meta_increment 
        set previous_max_tran_dt = max_tran_dt,
        max_tran_dt = (select max(tr_date) from stg_transactions)
        where (select count(*) from stg_transactions) > 0; -- проверка на случай, когда при пустом stg дергаем etl, тогда в мету записываются null в поля даты и перестает работать
        
        commit;    
    END update_meta;
    
    /* Очистка STG */
    procedure clean_stage   
    IS   
    BEGIN   
        delete from stg_transactions;
        
        commit;       
    END clean_stage;
    
    /* Забираем STG */
    procedure insert_into_stage   
    IS   
    BEGIN   
        insert into stg_transactions
        select *
        from src_transactions st
        where st.tr_date > (
                select max(max_tran_dt) from meta_increment --max для защиты запроса от дублей
                where table_name='FACT_TRANSACTIONS'
                ); 

        commit;       
    END insert_into_stage;
    
    /* Вставка записи в dim_terminals_hist */
    procedure insert_into_dim_terminals_hist(term_row IN dim_terminals_hist%ROWTYPE)
    IS
    BEGIN
        insert into dim_terminals_hist
                values term_row;
        commit;
    END insert_into_dim_terminals_hist;
    
    /* Проверяем есть ли запись с таким id  таблице терминалов */
    function is_new_terminal_id(terminal_id_in IN dim_terminals_hist.terminal_id%TYPE)
    return BOOLEAN
    IS
    BEGIN
        return NOT is_record_in_tbl('dim_terminals_hist', 'terminal_id', terminal_id_in); -- NOT т.к. новая запись, если ее нет в таблице
    END is_new_terminal_id;
    
    /* Проверяем изменилась ли запись с таким id в таблице терминалов
    TRUE - данные обновились
    FALSE - данные не обновлялись*/
    function was_terminal_data_update(terminal_rec_in IN dim_terminals_hist%ROWTYPE)
    return BOOLEAN
    IS
    change_flag number;
    BEGIN
        select count(*) into change_flag 
        from dim_terminals_hist
        where terminal_id = terminal_rec_in.terminal_id
        and terminal_type = terminal_rec_in.terminal_type
        and terminal_city = terminal_rec_in.terminal_city
        and terminal_address = terminal_rec_in.terminal_address
        and end_dt = DEFAULT_MAX_DATE; -- ищем изменения в последней версии
        
        return change_flag = 0;
    END was_terminal_data_update;
    
    /* Загрузка данных из STG в dim_terminals_hist */
    procedure load_data_into_dim_terminals
    IS
    cursor stg_terminals_cur IS 
        select st.terminal_id
                , st.terminal_type
                , st.terminal_city
                , st.terminal_address
                , st.tr_date start_dt
                , DEFAULT_MAX_DATE end_dt
        from stg_transactions st
        order by start_dt; -- чтобы проверять в порядке увеличения даты транзакции
    BEGIN   
        for rec in stg_terminals_cur loop
            
            if is_new_terminal_id(rec.terminal_id) then -- если нет такой записи, вставляем
                insert_into_dim_terminals_hist(rec);            
            else --если есть, проверим были ли изменения
                if was_terminal_data_update(rec) then -- запись изменилась
                    -- update текущей записи - делаем ее исторической
                    update dim_terminals_hist
                    set end_dt = rec.start_dt - ONE_SECOND_INTERVAL -- чтобы не было разночтения при определении принадлежности к интервалу вычтем 1 сек из end_dt
                    where terminal_id = rec.terminal_id
                    and end_dt = DEFAULT_MAX_DATE; -- апдейтим текущую (возможны еще предыдущие версии - их не трогаем)
                    
                    -- insert новой версии записи
                    insert_into_dim_terminals_hist(rec);
                end if;          
            end if;
    
        end loop;
    END load_data_into_dim_terminals;
    
    /* Вставка записи в dim_clients_hist */
    procedure insert_into_dim_clients_hist(client_row IN dim_clients_hist%ROWTYPE)
    IS
    BEGIN
        insert into dim_clients_hist
                values client_row;
        commit;
    END insert_into_dim_clients_hist;
    
    /* Проверяем есть ли запись с таким id  таблице клиентов */
    function is_new_client_id(client_id_in IN dim_clients_hist.client_id%TYPE)
    return BOOLEAN
    IS
    BEGIN
        return NOT is_record_in_tbl('dim_clients_hist', 'client_id', client_id_in); -- NOT т.к. новая запись, если ее нет в таблице
    END is_new_client_id;
    
    /* Проверяем изменилась ли запись с таким id в таблице клиентов
    TRUE - данные обновились
    FALSE - данные не обновлялись*/
    function was_client_data_update(client_rec_in IN dim_clients_hist%ROWTYPE)
    return BOOLEAN
    IS
    change_flag number;
    BEGIN
        select count(*) into change_flag 
        from dim_clients_hist
        where client_id = client_rec_in.client_id
        and last_name = client_rec_in.last_name
        and first_name = client_rec_in.first_name
        and patronymic = client_rec_in.patronymic
        and date_of_birth = client_rec_in.date_of_birth
        and passport_num = client_rec_in.passport_num
        and passport_valid_to = client_rec_in.passport_valid_to
        and phone = client_rec_in.phone
        and end_dt = DEFAULT_MAX_DATE; -- ищем изменения в последней версии
        
        return change_flag = 0;
    END was_client_data_update;
    
    /* Загрузка данных из STG в dim_clients_hist */
    procedure load_data_into_dim_clients
    IS
    cursor stg_clients_cur IS 
        select st.client_id
                , st.last_name
                , st.first_name
                , st.patronymic
                , st.date_of_birth
                , st.passport_num
                , st.passport_valid_to
                , st.phone
                , st.tr_date start_dt
                , DEFAULT_MAX_DATE end_dt
        from stg_transactions st
        order by start_dt; -- чтобы проверять в порядке увеличения даты транзакции     
    BEGIN   
        for rec in stg_clients_cur loop
            
            if is_new_client_id(rec.client_id) then -- если нет такой записи, вставляем
                insert_into_dim_clients_hist(rec);            
            else --если есть, проверим были ли изменения
                if was_client_data_update(rec) then -- запись изменилась
                    -- update текущей записи - делаем ее исторической
                    update dim_clients_hist
                    set end_dt = rec.start_dt - ONE_SECOND_INTERVAL
                    where client_id = rec.client_id
                    and end_dt = DEFAULT_MAX_DATE; -- апдейтим текущую (возможны еще предыдущие версии - их не трогаем)
                    
                    -- insert новой версии записи
                    insert_into_dim_clients_hist(rec);
                end if;  
            end if;
    
        end loop;
    END load_data_into_dim_clients;
    
    /* Вставка записи в dim_accounts_hist */
    procedure insert_into_dim_accounts_hist(acc_row IN dim_accounts_hist%ROWTYPE)
    IS
    BEGIN
        insert into dim_accounts_hist
                values acc_row;
        commit;
    END insert_into_dim_accounts_hist;
    
    /* Проверяем есть ли запись с таким id  таблице счетов */
    function is_new_acc_num(account_num_in IN dim_accounts_hist.account_num%TYPE)
    return BOOLEAN
    IS
    BEGIN
        return NOT is_record_in_tbl('dim_accounts_hist', 'account_num', account_num_in); -- NOT т.к. новая запись, если ее нет в таблице
    END is_new_acc_num;
    
    /* Проверяем изменилась ли запись с таким id в таблице счетов
    TRUE - данные обновились
    FALSE - данные не обновлялись*/
    function was_acc_data_update(acc_rec_in IN dim_accounts_hist%ROWTYPE)
    return BOOLEAN
    IS
    change_flag number;
    BEGIN
        select count(*) into change_flag 
        from dim_accounts_hist
        where account_num = acc_rec_in.account_num
        and valid_to = acc_rec_in.valid_to
        and client_id = acc_rec_in.client_id
        and end_dt = DEFAULT_MAX_DATE; -- ищем изменения в последней версии

        return change_flag = 0;
    END was_acc_data_update;
    
    /* Загрузка данных из STG в dim_accounts_hist */
    procedure load_data_into_dim_accounts
    IS  
     cursor stg_accounts_cur IS 
        select st.account_num
                , st.account_valid_to valid_to
                , st.client_id
                , st.tr_date start_dt
                , DEFAULT_MAX_DATE end_dt
        from stg_transactions st
        order by start_dt; -- чтобы проверять в порядке увеличения даты транзакции     
    BEGIN   
        for rec in stg_accounts_cur loop

            if is_new_acc_num(rec.account_num) then -- если нет такой записи, вставляем
                insert_into_dim_accounts_hist(rec);            
            else --если есть, проверим были ли изменения
                if was_acc_data_update(rec) then -- запись изменилась
                    -- update текущей записи - делаем ее исторической
                    update dim_accounts_hist
                    set end_dt = rec.start_dt - ONE_SECOND_INTERVAL
                    where account_num = rec.account_num
                    and end_dt = DEFAULT_MAX_DATE; -- апдейтим текущую (возможны еще предыдущие версии - их не трогаем)
                    
                    -- insert новой версии записи
                    insert_into_dim_accounts_hist(rec);
                end if;              
            end if;
    
        end loop;
    END load_data_into_dim_accounts;
    
    /* Вставка записи в dim_cards_hist */
    procedure insert_into_dim_cards_hist(card_row IN dim_cards_hist%ROWTYPE)
    IS
    BEGIN
        insert into dim_cards_hist
                values card_row;
        commit;
    END insert_into_dim_cards_hist;
    
    /* Проверяем есть ли запись с таким id таблице карт */
    function is_new_card_num(card_num_in IN dim_cards_hist.card_num%TYPE)
    return BOOLEAN
    IS
    BEGIN
        return NOT is_record_in_tbl('dim_cards_hist', 'card_num', card_num_in); -- NOT т.к. новая запись, если ее нет в таблице
    END is_new_card_num;
    
    /* Проверяем изменилась ли запись с таким id в таблице карт
    TRUE - данные обновились
    FALSE - данные не обновлялись*/
    function was_card_data_update(card_rec_in IN dim_cards_hist%ROWTYPE)
    return BOOLEAN
    IS
    change_flag number;
    BEGIN
        select count(*) into change_flag 
        from dim_cards_hist
        where card_num = card_rec_in.card_num
        and account_num = card_rec_in.account_num
        and end_dt = DEFAULT_MAX_DATE; -- ищем изменения в последней версии

        return change_flag = 0;
    END was_card_data_update;
    
    /* Загрузка данных из STG в dim_cards_hist */
    procedure load_data_into_dim_cards
    IS 
    cursor stg_cards_cur IS 
        select st.card_num
                , st.account_num
                , st.tr_date start_dt
                , DEFAULT_MAX_DATE end_dt
        from stg_transactions st
        order by start_dt; -- чтобы проверять в порядке увеличения даты транзакции     
    BEGIN   
        for rec in stg_cards_cur loop

            if is_new_card_num(rec.card_num) then -- если нет такой записи, вставляем
                insert_into_dim_cards_hist(rec);            
            else --если есть, проверим были ли изменения
                if was_card_data_update(rec) then -- запись изменилась
                    -- update текущей записи - делаем ее исторической
                    update dim_cards_hist
                    set end_dt = rec.start_dt - ONE_SECOND_INTERVAL
                    where card_num = rec.card_num
                    and end_dt = DEFAULT_MAX_DATE; -- апдейтим текущую (возможны еще предыдущие версии - их не трогаем)
                    
                    -- insert новой версии записи
                    insert_into_dim_cards_hist(rec);
                end if;              
            end if;
    
        end loop;
    END load_data_into_dim_cards;
    
    /* Загрузка данных из STG в fact_transactions 
    Тут загрузка в таблицу фактов без SCD - поэтому просто Insert новых без усложнения логики*/
    procedure load_data_into_fact_trans
    IS
    BEGIN   
        insert into fact_transactions
        select st.trans_id
                , st.tr_date trans_date
                , st.card_num
                , st.oper_type
                , st.amount
                , st.oper_result
                , st.terminal_id
        from stg_transactions st
        left join fact_transactions fact
        on st.trans_id = fact.trans_id
        where fact.trans_id is null;
        
        commit;
    END load_data_into_fact_trans;
    
    /* процедура загрузки сразу всех таблиц */
    procedure load_data_into_all_tbls
    IS
    BEGIN
        load_data_into_dim_terminals();
        load_data_into_dim_clients();
        load_data_into_dim_accounts();
        load_data_into_dim_cards();
        load_data_into_fact_trans();
    END load_data_into_all_tbls;

END etl_process;
/

/* Пакет с реализацией функционала поиска мошеннических действий*/
CREATE OR REPLACE PACKAGE fraud_transactions_processing 
IS
DEFAULT_MAX_DATE CONSTANT timestamp := to_timestamp('31.12.9999 23:59:59', 'DD.MM.YYYY HH24:MI:SS');
ONE_HOUR_INTERVAL CONSTANT INTERVAL DAY TO SECOND := '0 01:00:00';
TWENTY_MINUTES_INTERVAL CONSTANT INTERVAL DAY TO SECOND := '0 00:20:00';
FR_EXPIRED_PASS_TYPE CONSTANT report.fraud_type%type := 'Совершение операции при просроченном паспорте';
FR_EXPIRED_ACC_TYPE CONSTANT report.fraud_type%type := 'Совершение операции при недействующем договоре';
FR_DIFF_CITIES_TYPE CONSTANT report.fraud_type%type := 'Совершение операции в разных городах в течение 1 часа';
FR_SELECT_AMOUNT_TYPE CONSTANT report.fraud_type%type := 'Попытка подбора сумм';

procedure expired_passport_oper;
procedure expired_account_oper;
procedure oper_in_different_cities;
procedure oper_with_select_amount;
function get_fio(last_name IN dim_clients_hist.last_name%TYPE, first_name IN dim_clients_hist.first_name%TYPE, patronymic IN dim_clients_hist.patronymic%TYPE) return report.fio%TYPE;
END fraud_transactions_processing;
/

CREATE OR REPLACE PACKAGE BODY fraud_transactions_processing 
IS
    /*Получаем ФИО из Фамилии, имени и отчества*/
    function get_fio(last_name IN dim_clients_hist.last_name%TYPE, first_name IN dim_clients_hist.first_name%TYPE, patronymic IN dim_clients_hist.patronymic%TYPE)
    return report.fio%TYPE
    IS
    BEGIN
        return last_name ||' ' || first_name || ' ' || patronymic;
    END get_fio;
    
    /* процедура поиска операций с просроченным паспортом */
    procedure expired_passport_oper   
    IS   
    BEGIN   
        insert into report(fraud_dt, passport, fio, phone, fraud_type, report_dt)
        select ft.trans_date
            , dclh.passport_num
            , get_fio( dclh.last_name, dclh.first_name, dclh.patronymic) as fio
            , dclh.phone
            , FR_EXPIRED_PASS_TYPE
            , current_timestamp 
        from fact_transactions ft
        inner join dim_cards_hist dch on ft.card_num = dch.card_num and dch.end_dt = DEFAULT_MAX_DATE -- для последнего актуального измерения
        inner join dim_accounts_hist dah on dch.account_num = dah.account_num and dah.end_dt = DEFAULT_MAX_DATE
        inner join dim_clients_hist dclh on dah.client_id = dclh.client_id and dclh.end_dt = DEFAULT_MAX_DATE
        where ft.trans_date > dclh.passport_valid_to
        and ft.trans_date > (select max(previous_max_tran_dt) 
                             from meta_increment 
                             where table_name='FACT_TRANSACTIONS'); -- строим по последнему инкременту
        
        commit;       
    END expired_passport_oper;
    
    /* процедура поиска операций с недействующим договором */
    procedure expired_account_oper   
    IS   
    BEGIN   
        insert into report(fraud_dt, passport, fio, phone, fraud_type, report_dt)
        select ft.trans_date
            , dclh.passport_num
            , get_fio( dclh.last_name, dclh.first_name, dclh.patronymic) as fio
            , dclh.phone
            , FR_EXPIRED_ACC_TYPE
            , current_timestamp 
        from fact_transactions ft
        inner join dim_cards_hist dch on ft.card_num = dch.card_num and dch.end_dt = DEFAULT_MAX_DATE -- для последнего актуального измерения
        inner join dim_accounts_hist dah on dch.account_num = dah.account_num and dah.end_dt = DEFAULT_MAX_DATE
        inner join dim_clients_hist dclh on dah.client_id = dclh.client_id and dclh.end_dt = DEFAULT_MAX_DATE
        where ft.trans_date > dah.valid_to
        and ft.trans_date > (select max(previous_max_tran_dt) 
                             from meta_increment 
                             where table_name='FACT_TRANSACTIONS'); -- строим по последнему инкременту
        
        commit;       
    END expired_account_oper;
    
    /* процедура поиска операций, совершенных в разных городах в течение 1 часа 
    Ищем именно по карте не по клиенту*/
    procedure oper_in_different_cities   
    IS   
    BEGIN   
        insert into report(fraud_dt, passport, fio, phone, fraud_type, report_dt)
        select t.trans_date, t.passport_num, t.fio, t.phone, FR_DIFF_CITIES_TYPE, current_timestamp 
        from (
            select ft.trans_date
                , dclh.passport_num
                , get_fio( dclh.last_name, dclh.first_name, dclh.patronymic) as fio
                , dclh.phone
                , dth.terminal_city
                , (ft.trans_date - lag(ft.trans_date) over(partition by ft.card_num order by ft.trans_date)) as diff_btwn_opers
                , lag(dth.terminal_city) over(partition by ft.card_num order by ft.trans_date) as prev_oper_term_city
            from fact_transactions ft
            inner join dim_cards_hist dch on ft.card_num = dch.card_num and dch.end_dt = DEFAULT_MAX_DATE -- для последнего актуального измерения
            inner join dim_accounts_hist dah on dch.account_num = dah.account_num and dah.end_dt = DEFAULT_MAX_DATE
            inner join dim_clients_hist dclh on dah.client_id = dclh.client_id and dclh.end_dt = DEFAULT_MAX_DATE
            inner join dim_terminals_hist dth on ft.terminal_id = dth.terminal_id and dth.end_dt = DEFAULT_MAX_DATE
            where ft.trans_date > (select max(previous_max_tran_dt) - ONE_HOUR_INTERVAL 
                                   from meta_increment
                                   where table_name='FACT_TRANSACTIONS') -- строим по времени препоследнего инкремента -1 час (на случай если операция на стыке суток)
        ) t
        where diff_btwn_opers < ONE_HOUR_INTERVAL
        and terminal_city != prev_oper_term_city;
        
        commit;       
    END oper_in_different_cities;
    
    /* процедура поиска операций, с попыткой подбора сумм. В течение 20 минут проходит более 3х операций со следующим шаблоном – каждая последующая меньше предыдущей, 
    при этом отклонены все кроме последней. Последняя операция (успешная) в такой цепочке считается мошеннической*/
    procedure oper_with_select_amount   
    IS   
    BEGIN   
        insert into report(fraud_dt, passport, fio, phone, fraud_type, report_dt)
        select t.trans_date, t.passport_num, t.fio, t.phone, FR_SELECT_AMOUNT_TYPE, current_timestamp 
        from (
            select ft.trans_date
                , dclh.passport_num
                , get_fio( dclh.last_name, dclh.first_name, dclh.patronymic) as fio
                , dth.terminal_city
                , dclh.phone
                ,case -- нам достаточно идти по окну в 4 операции (по условию более 3 операций). Три отказа, 4я успешно:
                    when lag(ft.oper_result, 3) over(partition by ft.card_num order by ft.trans_date) = 'Отказ' 
                        and lag(ft.oper_result, 2) over(partition by ft.card_num order by ft.trans_date) = 'Отказ' 
                        and lag(ft.oper_result, 1) over(partition by ft.card_num order by ft.trans_date) = 'Отказ'
                        and ft.oper_result = 'Успешно' 
                        -- каждая последующая сумма меньше предыдущей:
                        and (lag(ft.amount, 2) over(partition by ft.card_num order by ft.trans_date) - lag(ft.amount, 3) over(partition by ft.card_num order by ft.trans_date)) < 0
                        and (lag(ft.amount, 1) over(partition by ft.card_num order by ft.trans_date) - lag(ft.amount, 2) over(partition by ft.card_num order by ft.trans_date)) < 0
                        and (ft.amount - lag(ft.amount, 1) over(partition by ft.card_num order by ft.trans_date)) < 0
                        -- операции в течение 20 мин:
                        and (ft.trans_date - lag(ft.trans_date, 3) over(partition by ft.card_num order by ft.trans_date)) < TWENTY_MINUTES_INTERVAL
                    then 1 -- все условия выполняются, операция мошенническая
                    else 0
                end fraud_flag
            from fact_transactions ft
            inner join dim_cards_hist dch on ft.card_num = dch.card_num and dch.end_dt = DEFAULT_MAX_DATE -- для последнего актуального измерения
            inner join dim_accounts_hist dah on dch.account_num = dah.account_num and dah.end_dt = DEFAULT_MAX_DATE
            inner join dim_clients_hist dclh on dah.client_id = dclh.client_id and dclh.end_dt = DEFAULT_MAX_DATE
            inner join dim_terminals_hist dth on ft.terminal_id = dth.terminal_id and dth.end_dt = DEFAULT_MAX_DATE
            where ft.trans_date > (select max(previous_max_tran_dt) - TWENTY_MINUTES_INTERVAL 
                                   from meta_increment
                                   where table_name='FACT_TRANSACTIONS') -- строим по времени предпоследнего инкремента -20 мин (на случай если операция на стыке суток)
        ) t
        where fraud_flag = 1;         
        
        commit;       
    END oper_with_select_amount;
    
END fraud_transactions_processing;
/
