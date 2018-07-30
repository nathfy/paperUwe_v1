DECLARE @nowDate datetime
SET @nowDate = getdate()

SELECT 
[invoices].[customerId] as customerId
,sum([invoices].[amount]) as amountTotal
,sum(case when invoiceType = 1 then [invoices].[amount] else 0 end) as salesTotal
,sum(case when invoiceType = 2 then [invoices].[amount] else 0 end) as annualTotal
,sum(
    case when invoiceType = 3 AND invoiceProducts = 'Truancy Call' 
    then [invoices].[amount] else 0 end
) as monthlyTotalProduct1
,sum(
    case when invoiceType = 3 AND invoiceProducts = 'Call Parents' 
    then [invoices].[amount] else 0 end
) as monthlyTotalProduct2
,sum(
    case when invoiceType = 5 then [invoices].[amount] else 0 end
) as extraItemsTotal
,DATEDIFF(
    MONTH, min([invoiceDate]), isnull(cancelledDate, @nowDate)
) as monthsSinceStarted
,avg(daysToPay) as avgDaysToPay -- note if -1 then no payment date recorded yet
,sum([creditedAmount]) as creditedAmount
,isCancelled
,hasProduct1
,hasProduct2
,hasProduct3
,hasProduct4
,hasProduct5
,hasProduct6
,hasProduct7
,hasProduct8
,hasProduct9
,hasProduct10
,hasProduct11
,hasProduct12
,isnull([administrativeArea],'none') as administrativeArea
,isnull([SubCountryArea],'none') as [subCountryArea]
,isnull(invoices.[Country],min(invoices.[country])) as [country]
,min([invoiceDate]) as firstInvoiceDate
FROM 
	[invoices] as invoices
inner join
	[OrgHasSaleOverProducts] as sales
ON
	sales.school_Id = invoices.customerId
group by
	[invoices].customerId
	,isCancelled
	,hasProduct1
	,hasProduct2
	,hasProduct3
	,hasProduct4
	,hasProduct5
	,hasProduct6
	,hasProduct7
	,hasProduct8
	,hasProduct9
	,hasProduct10
	,hasProduct11
	,hasProduct12
	,[administrativeArea]
	,[SubCountryArea]
	,invoices.[Country]
	,cancelledDate
order by 
	[invoices].customerId
desc