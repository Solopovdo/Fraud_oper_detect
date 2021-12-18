/* Report generation */

BEGIN
    -- Совершение операции при просроченном паспорте
    fraud_transactions_processing.expired_passport_oper();
    
    -- Совершение операции при недействующем договоре
    fraud_transactions_processing.expired_account_oper();
    
    -- Совершение операции в разных городах в течение 1 часа
    fraud_transactions_processing.oper_in_different_cities();
    
    -- Операции с подбором сумм в течение 20мин
    fraud_transactions_processing.oper_with_select_amount();
END;