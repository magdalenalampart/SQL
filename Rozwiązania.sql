-- Zadanie 1 a)

Select
    count(*) as Liczba_Dyskow_Z_Supra
From
    oe.product_descriptions
Where
    translated_description like '%Supra%';
    
Select 
    Substr(translated_description,Instr(translated_description,'Supra'),6) as Supra,
    count(Substr(translated_description,Instr(translated_description,'Supra'),6)) as Iloœæ_dysków
From
    oe.product_descriptions
Where 
    translated_description like '%Supra%'
Group by
    Supra
Order by Supra desc;
    
-- Zadanie 1 b)

Select
    Substr(cust_email,instr(cust_email,'@')) as Email,
    count(Substr(cust_email,instr(cust_email,'@'))) as Iloœæ
From
    OE.customers
Group by
    Email
Order by 
    Iloœæ desc;

-- Zadanie 1 c)

Select
    distinct(income_level) as kategoria,
    case 
        when income_level like '%Below%' then null
        else substr(income_level,4,instr(income_level,','))
        end poziom_min,
    case
        when income_level like '%above' then null
        else trim(substr(income_level,-7))
        end poziom_max
From
   OE.customers
Order by income_level;

-- Zadanie 2 a)

Select
    d.department_name as Stanowisko,
    round(avg(e.salary),2) as Œrednia_pensja
From 
    hr.departments d
Join 
    hr.employees e On d.department_id = e.department_id
Group by
    Stanowisko
Having Stanowisko in ('Sales','Shipping','Finance');

-- Zadanie 2 b)

Select
    j.job_title as Zawód,
    count(e.employee_id) as Iloœæ_Pracowników,
    avg(e.salary) as Œrednia_Pensja
From
    hr.employees e
Join
    hr.jobs j On e.job_id=j.job_id
Group by
    Zawód
Having
    Iloœæ_Pracowników >= 5
Order by
    Iloœæ_Pracowników desc;
    
-- Zadanie 3 a)

Select
    p.promo_name,
    to_char(min(o.order_date),'dd-mm-yyyy') as rozpoczêcie_promocji,
    to_char(max(o.order_date), 'dd-mm-yyyy') as zakoñczenie_promocji
From
    oe.orders o
Join oe.promotions p on o.promotion_id=p.promo_id
Where 
    promotion_id is not null
Group by 
    promo_name;
    
--Zadanie 3 b)

Select
    p.promo_name as nazwa_promocji,
    to_char(o.order_date, 'dd-mm-yyyy') as data_zamówienia,
    sum(o.order_total) as kwota_zamówienia
From
    oe.orders o
Join oe.promotions p on oe.o.promotion_id=oe.p.promo_id
Where 
    promotion_id is not null
Group by
    data_zamówienia,
    promo_name
Order by
    promo_name, 
    to_date(data_zamówienia, 'dd-mm-yyyy');
    
-- Zadanie 3 c)

Select
    p.promo_name as nazwa_promocji,
    c.cust_first_name || ' ' || c.cust_last_name as klient,
    o.order_date as data
From
    oe.orders o
Join oe.promotions p on oe.o.promotion_id=oe.p.promo_id
Join oe.customers c using (customer_id)
Where order_date =any
    (
    Select
        min(order_date) as pierwsza_data_zamówienia
    From
         oe.orders
    Join oe.promotions on promotion_id=promo_id
    Where
        promotion_id is not null
    Group by 
        promo_name
    );
     
-- Zadanie 4

Select
    sum(o.order_total) as Kwota_Sprzeda¿y,
    c.nls_territory as Kraj,
    to_date(last_day(trunc(o.order_date)), 'dd-mm-yyyy') as Miesiac
From
    oe.orders o
Join
    oe.customers c On o.customer_id = c.customer_id
Where
    order_status !=1 And order_status !=0
Group by
    Kraj, Miesiac
Order by
    Kraj, Miesiac;
    
-- Zadanie 5 a)

Select
    coun.country_name as Kraj,
    cust.cust_gender as Plec,
    sum(sal.amount_sold) as Suma_Sprzeda¿y,
    rank() over (partition by cust.cust_gender order by sum(sal.amount_sold) desc) as Ranking
From
    sh.sales sal
Join sh.customers cust using (cust_id)
Join sh.countries coun using (country_id)
Group by
    Kraj, Plec
Order by
    Plec, Suma_Sprzeda¿y desc;
    
-- Zadanie 5 b)

Select
    *
From
    (Select
        coun.country_name as Kraj,
        cust.cust_gender as Plec,
        sum(sal.amount_sold) as Suma_Sprzeda¿y,
        rank() over (partition by cust.cust_gender order by sum(sal.amount_sold) desc) as Ranking
    From
        sh.sales sal
    Join sh.customers cust using (cust_id)
    Join sh.countries coun using (country_id)
    Group by
        Kraj, Plec
    Order by
        Plec, Suma_Sprzeda¿y desc)
Where
    Ranking <= 3;
    