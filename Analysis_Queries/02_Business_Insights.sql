/*******************************************************************************
שאילתות ניתוח עסקי (Business Intelligence Queries)
קובץ זה מדגים שימוש ב-Window Functions, CTEs וביצוע אגרגציות מורכבות.
*******************************************************************************/

-- 1. ניתוח פלייליסטים: זיהוי הפלייליסטים הגדולים והקטנים ביותר וממוצע שירים 
WITH playlist_stats AS (
    SELECT 
        playlist_name, 
        COUNT(trackid) AS track_count
    FROM dwh.Dim_playlist
    GROUP BY playlist_name
)
SELECT 
    playlist_name, 
    track_count::text,
    CASE 
        WHEN track_count = (SELECT MAX(track_count) FROM playlist_stats) THEN 'הפלייליסט הגדול ביותר'
        WHEN track_count = (SELECT MIN(track_count) FROM playlist_stats) THEN 'הפלייליסט הקטן ביותר'
    END AS category
FROM playlist_stats
WHERE track_count = (SELECT MAX(track_count) FROM playlist_stats)
   OR track_count = (SELECT MIN(track_count) FROM playlist_stats)
UNION ALL
SELECT '--- ממוצע כללי ---', ROUND(AVG(track_count), 2)::text, 'סטטיסטיקה'
FROM playlist_stats;


-- 2. פילוח שירים לפי נפח מכירות (Sales Buckets) 
SELECT 
    CASE 
        WHEN sales_volume = 0 THEN '0'
        WHEN sales_volume BETWEEN 1 AND 5 THEN '1-5'
        WHEN sales_volume BETWEEN 6 AND 10 THEN '6-10'
        ELSE '10+'
    END AS sales_group,
    COUNT(*) AS number_of_songs
FROM (
    SELECT 
        t.trackid, 
        COALESCE(SUM(fl.quantity), 0) AS sales_volume
    FROM dwh.Dim_track t
    LEFT JOIN dwh.Fact_invoiceline fl ON t.trackid = fl.trackid
    GROUP BY t.trackid
) subquery
GROUP BY sales_group
ORDER BY sales_group;


-- 3א .ביצועי מדינות בשקלים (ILS): המרת הכנסות לפי שער חליפין 
WITH country_performance AS (
    SELECT 
        c.country,
        SUM(i.total * curr.rate) AS total_revenue_ils
    FROM dwh.Fact_invoice i
    JOIN dwh.Dim_customer c ON i.customerid = c.customerid
    JOIN stg."Dim_currency" curr ON i.invoicedate = curr.date
    GROUP BY c.country
)
(SELECT country, ROUND(total_revenue_ils::numeric, 2) AS total_ils, 'Top 5' AS category
 FROM country_performance ORDER BY total_revenue_ils DESC LIMIT 5)
UNION ALL
(SELECT country, ROUND(total_revenue_ils::numeric, 2) AS total_ils, 'Bottom 5' AS category
 FROM country_performance ORDER BY total_revenue_ils ASC LIMIT 5)
ORDER BY category DESC, total_ils DESC;


-- 3ב. ]התפלגות ז'אנרים לפי מדינה: חישוב אחוז ההכנסות מכל ז'אנר בכל מדינה 
WITH genre_country_sales AS (
    SELECT 
        c.country,
        t.genre_name,
        SUM(fl.total_price) AS genre_revenue
    FROM dwh.Fact_invoiceline fl
    JOIN dwh.Fact_invoice i ON fl.invoiceid = i.invoiceid
    JOIN dwh.Dim_customer c ON i.customerid = c.customerid
    JOIN dwh.Dim_track t ON fl.trackid = t.trackid
    GROUP BY c.country, t.genre_name
)
SELECT 
    country,
    genre_name,
    ROUND(genre_revenue, 2) AS genre_revenue,
    ROUND((genre_revenue / SUM(genre_revenue) OVER(PARTITION BY country)) * 100, 2) AS percentage_of_country_sales
FROM genre_country_sales
ORDER BY country, percentage_of_country_sales DESC;


-- 4. ניתוח דמוגרפי: קיבוץ מדינות קטנות לקטגוריית "Other" וחישוב ממוצעים ללקוח 
WITH country_stats AS (
    SELECT 
        c.country,
        COUNT(DISTINCT c.customerid) AS customer_count,
        COUNT(i.invoiceid) AS total_invoices,
        SUM(i.total) AS total_revenue
    FROM dwh.Fact_invoice i
    JOIN dwh.Dim_customer c ON i.customerid = c.customerid
    GROUP BY c.country
),
country_grouping AS (
    SELECT 
        CASE WHEN customer_count = 1 THEN 'Other' ELSE country END AS final_country,
        customer_count, total_invoices, total_revenue
    FROM country_stats
)
SELECT 
    final_country AS country,
    SUM(customer_count) AS total_customers,
    ROUND(SUM(total_invoices)::numeric / SUM(customer_count), 2) AS avg_orders_per_customer,
    ROUND(SUM(total_revenue)::numeric / SUM(customer_count), 2) AS avg_revenue_per_customer_usd
FROM country_grouping
GROUP BY final_country
ORDER BY total_customers DESC;


]-- 5. ביצועי עובדים: ותק וצמיחה שנתית באחוזים באמצעות LAG 
WITH employee_yearly_stats AS (
    SELECT 
        e.employeeid,
        e.firstname || ' ' || e.lastname AS employee_name,
        e.years_of_seniority,
        EXTRACT(YEAR FROM i.invoicedate) AS sales_year,
        SUM(i.total) AS total_revenue
    FROM dwh.Dim_employee e
    JOIN dwh.Dim_customer c ON e.employeeid = c.supportrepid
    JOIN dwh.Fact_invoice i ON c.customerid = i.customerid
    GROUP BY 1, 2, 3, 4
),
growth_calc AS (
    SELECT *, LAG(total_revenue) OVER (PARTITION BY employeeid ORDER BY sales_year) AS prev_year_revenue
    FROM employee_yearly_stats
)
SELECT 
    employee_name, years_of_seniority, sales_year, ROUND(total_revenue::numeric, 2) AS yearly_revenue,
    CASE 
        WHEN prev_year_revenue IS NULL THEN NULL
        ELSE ROUND(((total_revenue - prev_year_revenue) / prev_year_revenue * 100)::numeric, 2)
    END AS revenue_growth_percent
FROM growth_calc
ORDER BY employee_name, sales_year;


-- 6. שירים פופולריים: הצגת שירים שנרכשו יותר מפעם אחת באותו חודש ומדינה 
SELECT 
    TO_CHAR(i.invoicedate, 'YYYY-MM') AS sale_month,
    c.country,
    t.track_name,
    COUNT(fl.trackid) AS units_sold
FROM dwh.Fact_invoiceline fl
JOIN dwh.Fact_invoice i ON fl.invoiceid = i.invoiceid
JOIN dwh.Dim_customer c ON i.customerid = c.customerid
JOIN dwh.Dim_track t ON fl.trackid = t.trackid
GROUP BY 1, 2, 3
HAVING COUNT(fl.trackid) > 1
ORDER BY units_sold DESC, sale_month DESC;
