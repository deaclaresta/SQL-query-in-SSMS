use OOVEO_Salon
select* from MsTreatment
select* from MsStaff
select * from HeaderSalonServices


--No 1
--Display Maximum Price (obtained from the maximum price of all treatment), 
--Minimum Price (obtained from minimum price of all treatment), and
--Average Price (obtained by rounding the average value of Price in 2 decimal format). 
--Using (max, min, cast, round, and avg)

select MAX(Price) as 'Maximum Price',
		MIN(Price) as 'Minimum Price',
		cast(ROUND(AVG(Price),0) AS DECIMAL(10,2)) as 'Average Price'
from MsTreatment


--No 2
--Display StaffPosition, Gender (obtained from first character of staff’s gender), 
--and Average Salary (obtained by adding ‘Rp.’ in front of the average of 
--StaffSalary in 2 decimal format).
--Using (left, cast, avg, and group by)


SELECT StaffPosition, 
		left(StaffGender,1) as 'Gender',
		'Rp.'+ cast(cast(ROUND(AVG(StaffSalary),0) as decimal (10,2)) as varchar) as 'Average Salary'
From MsStaff
Group by StaffPosition , StaffGender 


--No 3
--Display TransactionDate (obtained from TransactionDate in ‘Mon dd,yyyy’ 
--format), and Total Transaction per Day (obtained from the total number of 
--transaction). Using (convert, count, and group by)

select Convert(varchar,TransactionDate,107) as 'Transaction Date',
	Count( TransactionDate) as 'Total Transaction per Day'
from HeaderSalonServices
group by TransactionDate



--No 4
--Display CustomerGender (obtained from customer’s gender in uppercase format),
--and Total Transaction (obtained from the total number of transaction).
--Using ( upper, count, and group by)

select UPPER(CustomerGender) as 'Customer Gender',
	Count(TransactionId) as 'Total Transaction'
from MsCustomer as C
	join HeaderSalonServices as hss
	on c.CustomerId = hss.CustomerId
group by CustomerGender




--No 5
--Display TreatmentTypeName, and Total Transaction (obtained from the total
--number of transaction). Then sort the data in descending format based on the 
--total of transaction. Using ( count, group by, and order by)


select TreatmentTypeName,
	Count(TransactionID) as 'Total Transaction'
from MsTreatmentType as mtt
join MsTreatment as mt
on mtt.TreatmentTypeId=mt.TreatmentTypeId
join DetailSalonServices as dss
on mt.TreatmentId=dss.TreatmentId
group by TreatmentTypeName
order by COUNT(TransactionID) desc




--No 6
--Display Date (obtained from TransactionDate in ‘dd mon yyyy’ format),
--Revenue per Day (obtained by adding ‘Rp. ’ in front of the total of price) 
--for every transaction which Revenue Per Day is between 1000000 and 5000000.
--Using (convert, cast, sum, group by, and having)

SELECT
    convert(varchar,TransactionDate, 107) AS 'Date',
    'Rp. '+cast( cast(SUM(Price) as decimal(11,2)) as varchar) AS 'Revenue per Day'
FROM
    HeaderSalonServices as hss
	join DetailSalonServices as dss
	on hss.TransactionId=dss.TransactionId
	join MsTreatment as mt
	on dss.TreatmentId=mt.TreatmentId
GROUP BY TransactionDate
HAVING
    SUM(Price) BETWEEN 1000000 AND 5000000


--NO 7
--Display ID (obtained by replacing ‘TT0’ in TreatmentTypeID with 
--‘Treatment Type’), TreatmentTypeName, and Total Treatment per Type
--(obtained from the total number of treatment and ended with ‘ Treatment ’)
--for treatment type that consists of more than 5 treatments. Then sort the 
--data in descending format based on Total Treatment per Type.
--Using (replace, cast, count, group by, having, and order by)

select replace(mt.TreatmentTypeId,'TT0','Treatment Type ') as 'ID',
	TreatmentTypeName,
	cast(Count(mt.TreatmentTypeId) as varchar) +' Treatment' as'Total Treatment per Type'
from MsTreatmentType as mtt
	join MsTreatment as mt
	on mtt.TreatmentTypeId=mt.TreatmentTypeId
group by mt.TreatmentTypeId, TreatmentTypeName
having count(mt.TreatmentTypeId)>5
order by Count(mt.TreatmentTypeId) desc




--No 8
--Display TransactionDate, CustomerName, and TotalPrice (obtained from the 
--total amount of price) for every transaction that happened after 20th day.
--Then order the data based on TransactionDate in ascending format.
--Using (sum, day, group by, and order by)

select TransactionDate,
	CustomerName,
	sum(Price)as 'Total Price'
from HeaderSalonServices as hss
	join MsCustomer as mc
	on hss.CustomerId=mc.CustomerId
	join DetailSalonServices as dss
	on dss.TransactionId=hss.TransactionId
	join MsTreatment as mt
	on mt.TreatmentId=dss.TreatmentId
WHERE
    DAY(TransactionDate) > 20
group by TransactionDate,CustomerName
order by TransactionDate asc
