-- SRC -> STG -> DWH

begin
/*1 Первое заполнение META */
    etl_process.meta_first_fill();
    
/*2 очистка STG*/
    etl_process.clean_stage();    
    
/*3 stg запись в стэджинг*/
    etl_process.insert_into_stage();
    
/*4 укладка инсерт и апдейт записей в приемник */
    etl_process.load_data_into_all_tbls();
    
/* 5 обновление META */
    etl_process.update_meta();
end;
