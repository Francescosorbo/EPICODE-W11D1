/*1.Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria.
 Quali considerazioni/ragionamenti è necessario che tu faccia?*/
SELECT 
    COUNT(dimproduct.ProductKey) AS NumeroRighe,
    COUNT(DISTINCT dimproduct.ProductKey) AS NumeroRigheSenzaRipetizioni
FROM
    dimproduct;
 
/*2.Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.*/

select distinct concat(salesordernumber,' - ', salesorderlinenumber)
from factresellersales;

/*3.Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.*/
SELECT factresellersales.orderdate, COUNT(distinct factresellersales.SalesOrderNumber) as ordini
FROM factresellersales
WHERE factresellersales.orderdate>='2020-01-01'
group by factresellersales.orderdate;



/*4.Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity)
 e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020.
 Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita.
 I campi in output devono essere parlanti!*/
 
 select dimproduct.englishproductname as nomeprodotto, sum(FactResellerSales.SalesAmount)as fatturatototale, 
 sum(FactResellerSales.OrderQuantity)as quantitàtotalevenduta, avg(FactResellerSales.UnitPrice)as prezzomediovendita
 from FactResellerSales join dimproduct on  FactResellerSales.productkey=dimproduct.productkey
 where factresellersales.orderdate > 2020-01-01
 group by nomeprodotto
 
 
 
 /*5.Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity)
 per Categoria prodotto (DimProductCategory).Il result set deve esporre pertanto il nome della categoria prodotto,
 il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!*/
 
 select DimProductCategory.englishproductcategoryname as categoriaprodotto, sum(FactResellerSales.SalesAmount) as fatturatototale, 
 sum(FactResellerSales.OrderQuantity) as quantitàvenduta
 from FactResellerSales 
 join dimproduct on factresellersales.productkey=dimproduct.productkey 
 join dimproductsubcategory on dimproduct.productsubcategorykey=dimproductsubcategory.productsubcategorykey 
 join dimproductcategory on dimproductsubcategory.productcategorykey=dimproductcategory.productcategorykey
 group by categoriaprodotto
 
 
 
 
/*6.Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020.
 Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K.*/  
 
 select DimGeography.City as citta,sum(FactResellerSales.SalesAmount)as fatturatototale
 from FactResellerSales 
 join dimsalesterritory on factresellersales.salesterritorykey=dimsalesterritory.salesterritorykey
 join dimgeography on dimsalesterritory.salesterritorykey=dimgeography.salesterritorykey 
 where factresellersales.orderdate > 2020-01-01 
 group by citta
 having fatturatototale>60000
 /*Inizialmente i problemi avuti per rappresentare il fatturato maggiore di 60mila era perchè la condizione della colonna 
 calcolata (fatturatototale) non viene accettata dal WHERE , va quindi aggiunto l'HAVING dopo il group by */
 