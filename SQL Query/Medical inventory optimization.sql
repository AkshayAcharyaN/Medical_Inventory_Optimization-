											---Medical Inventory Optimization--- 
										
---Business Problem: Bounce rate is increasing significantly leading to patient dissatifaction.
---Business Objective: Minimize bounce rate.
---Business Constraint: Minimize Inventory cost.
---Business Success Criteria: Reduce bounce rate by at leat 30%.
---Economic Sucess Criteria: Increase revenue by at leat 20lacs INR by reducing bounce rate.


---Created table to import data from csv file 
CREATE TABLE train (Typesofsales varchar, Patient_ID bigint, Specialisation varchar, Dept varchar, Dateofbill date, Quantity int, ReturnQuantity int, Final_Cost decimal, Final_Sales decimal, RtnMRP decimal, Formulation varchar, DrugName varchar, SubCat varchar, SubCat1 varchar); 
SELECT * FROM train;

--- data imported successfully 

--- Let's Findout number of rows
SELECT COUNT(*) AS num_rows FROM train;
---O/P (There are 14218 rows)


--- Let's Findout number of columns 
SELECT COUNT(*) AS num_cols
FROM information_schema.columns 
WHERE TABLE_NAME = 'train';
---O/P (There are 14 columns)


--- Top 5 rows 
SELECT * FROM train LIMIT 5;


--- Here we get information about columns 
SELECT * FROM information_schema.columns
WHERE table_name = 'train';


--- By considering Dept we made AVG Quantity and SUM of Total Cost
SELECT Dept, AVG(Quantity) AS avg_quantity, SUM(Final_Cost) AS total_cost
FROM train
GROUP BY Dept; 


--- Selecting Distinct values from each column
SELECT DISTINCT Typesofsales AS Typesofsales, Dept AS Dep, SubCat AS Catgeory, Quantity AS QTY, ReturnQuantity AS Returned 
FROM train
ORDER BY ReturnQuantity;
--- By Considering above query we can say that highest return happend in Dpet 1.


--- Finding Mean 
SELECT AVG(returnquantity) FROM train;
--- Mean is about 0.2387

--- Finding Variance 
SELECT VARIANCE(returnquantity) FROM train;
---Variance is about 0.8173


--- Finding standard devation 
SELECT STDDEV(returnquantity) FROM train;
--- Standard devation is about 0.90


--- Finding Null Values with respect to Typesofsales.
SELECT COUNT (*) FROM train WHERE Typesofsales ISNULL or Typesofsales ='';
--- There are 0 Null Values in column


--- Finding Null Values with respect to dept.
SELECT COUNT (*) FROM train WHERE dept ISNULL or dept ='';
--- There are 0 Null Values in column


--- Finding Null Values with respect to drugname.
SELECT COUNT (*) FROM train WHERE drugname ISNULL or drugname ='';
--- There are 1668 Null Values in column
--- So we have to remove Null value in drugname column rather than imputation beacause we can't do any of the opertion to imputation the null values
DELETE FROM train
WHERE drugname IS NULL;
--- Removed All null values present in the drug column


--- Fiding Null Values with respect to subcat 
SELECT COUNT (*) FROM train WHERE subcat ISNULL OR subcat ='';
--- There are 0 null values in column

--- Finding Null Values with respect to Subcat1
SELECT COUNT(*) FROM train WHERE Subcat1 ISNULL OR Subcat1 = '';
--- There are 24 null values are in column
--- so we have remove null values in subcat1 column rather than imputation 
DELETE FROM train 
WHERE subcat1 IS NULL;
--- Removed all null values are removed 


--- Finding correlation 
SELECT CORR(final_cost, final_sales) AS correlation
FROM train; 
--- fianl_cost and final_sales values are correlated with 0.89


--- to find Avg of return quantity 
SELECT AVG (returnquantity) FROM train;
--- 23% of medicaine is returnd to store


--- Lets see on which dept we have highest Return 
SELECT dept, AVG(returnquantity) AS Avg_retun_qty
FROM train
GROUP BY dept
--- Department 1 has high return 


--- lets see which dep has more return 
SELECT dept, count(*) AS dept
FROM train
GROUP BY dept
HAVING COUNT(*) > 1
ORDER BY count(*) DESC;
--- Department 1 have highest return of 11156.
--- Most of Bounce rate is happpening from Department 1


---Lets see which drug has returned more 
SELECT drugname, typesofsales, returnquantity,subcat
FROM train
GROUP BY  drugname, typesofsales, returnquantity,subcat
ORDER BY returnquantity DESC;
--- N-ACETYLCYSTEINE 1000MG/5ML INJ drug is got high return of 20.
--- By N-ACETYLCYSTEINE 1000MG/5ML INJ drug Medical is causing high bounce rate so we have to focus on this drug to reduce bounce rate 


--- Lets see which subcat has more number of return 
SELECT subcat, typesofsales,SUM(returnquantity) AS TOTALRETRUN
FROM train
GROUP BY subcat, typesofsales,returnquantity
ORDER BY TOTALRETRUN DESC;
--- INJECTIONS category has more number for return 
--- The above drug is belongs to INJECTION category so we have to focus on INJECTION category to reduce bounce rate.


--- Lets see sales 
SELECT subcat, typesofsales, COUNT (returnquantity), SUM(final_sales) AS totalsales, SUM(RtnMRP) AS MRP, SUM(final_sales) - SUM(RtnMRP) AS difference, (typesofsales='Return') AS RETURNn
FROM train
GROUP BY subcat,typesofsales,returnquantity
ORDER BY difference DESC;
--- As we see that High nuber of return is happened from INJECTION and it casues Huge loss in medical.
--- Allthough from INJECTIONS subcat got highest sale of 1832545.760, so it is better to fouces on INJECTION category. If we minimize the return from this subcat we can maske heighest profite from this category.

COPY (SELECT Typesofsales, Patient_ID,Specialisation, Dept,Dateofbill,Quantity,ReturnQuantity,Final_Cost,Final_Sales,RtnMRP,Formulation,DrugName,SubCat,SubCat1 FROM train) TO 'D:\360DigiTMG\INNODATAICS PROJECT\Projectfinaldata\cleaned_data.csv' CSV HEADER;



