-- Zadanie 1

Create table ZADANIE_1 as
Select
    to_number(regexp_substr(tekst, '\d+')) as ID,
    regexp_substr(tekst, '\d+\s\w+') as DZIEN,
    to_number(regexp_substr(tekst, '\d+\s',1,2)) as ROK,
    replace(regexp_substr(tekst, '[a-zA-Z]+\D*',1,2), ' K-', '') as SKOCZNIA,
    to_number(regexp_substr(tekst, '\d+',1,4)) as PUNKT_K,
    to_number(replace(regexp_substr(tekst, 'HS-\d+'), 'HS-', '')) as HILL_SIZE,
    to_number(regexp_substr(tekst, '\d+,\d')) as SKOK_1,
    to_number(replace(regexp_substr(tekst, '\d+,\d\sm',1,2), ' m', '')) as skok_2,
    to_number(replace(regexp_substr(tekst, '\d+,\d\sp'), ' p', '')) as NOTA,
    to_number(replace(regexp_substr(tekst, 'pkt\s\d'), 'pkt ', '')) as LOKATA,
    to_number(regexp_substr(tekst, '\d+,\d+',1,4)) as STRATA,
    regexp_substr(tekst, '\w+\s\w+\Z') as ZWYCIEZCA
From
    dw.skoki;
    
-- Zadanie 2

Create materialized view ZADANIE_2 as
Select
    time_id as DATA,
    calendar_week_number as NR_TYGODNIA,
    calendar_month_number as NR_MIESIACA,
    count(quantity_sold) as LICZBA_ZAMOWIEN,
    round(sum(amount_sold),2) as SUMA_ZAMOWIEN_DZIEN,
    sum(round(sum(amount_sold),2)) over(partition by calendar_week_number) as SUMA_ZAMOWIEN_TYDZIEN,
    rank() over(partition by calendar_month_number order by round(sum(amount_sold),2) desc) as RANKING_ZAMOWIEN_MIESIAC    
From
    sh.sales
Left join sh.times using (time_id)
Where
    time_id between date '2000-01-03' and date '2000-12-31'
Group by
    DATA, NR_TYGODNIA, NR_MIESIACA
Order by NR_MIESIACA, SUMA_ZAMOWIEN_DZIEN DESC;

Create unique index ZADANIE_2_IDX on ZADANIE_2(DATA);