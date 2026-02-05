-- יצירת סכמת ה-DWH במידה ולא קיימת
CREATE SCHEMA IF NOT EXISTS dwh;

-- 1. ממד לקוחות: כולל ניקוי שמות וחילוץ דומיין
CREATE TABLE dwh.Dim_customer AS
SELECT
    customerid,
    INITCAP(firstname) AS firstname,
    INITCAP(lastname) AS lastname, 
    email,
    SUBSTRING(email FROM '@(.*)') AS domain, 
    city,
    country
FROM stg.customer;

-- 2. ממד עובדים: כולל ותק, היררכיה ותקציב מחלקתי
CREATE TABLE dwh.Dim_employee AS
WITH managers AS (
    SELECT DISTINCT reportsto FROM stg.employee WHERE reportsto IS NOT NULL 
)
SELECT 
    e.employeeid,
    e.firstname,
    e.lastname,
    b.department_name, 
    b.budget,
    EXTRACT(YEAR FROM AGE(NOW(), e.hiredate)) AS years_of_seniority, 
    CASE WHEN m.reportsto IS NOT NULL THEN 1 ELSE 0 END AS is_manager 
FROM stg.employee e
LEFT JOIN stg.department_budget b ON e.departmentid = b.department_id 
LEFT JOIN managers m ON e.employeeid = m.reportsto;

-- 3. ממד שירים: טבלה רחבה הכוללת ז'אנרים ופורמט זמן
CREATE TABLE dwh.Dim_track AS
SELECT
    t.trackid,
    t.name AS track_name, 
    al.album_title, 
    ar.artist_name, 
    g.genre_name,
    m.media_type_name, 
    t.milliseconds / 1000.0 AS duration_seconds, 
    FLOOR(t.milliseconds / 60000) || ':' || LPAD(FLOOR((t.milliseconds % 60000) / 1000)::text, 2, '0') AS duration_formatted [cite: 38, 39]
FROM stg.track t
LEFT JOIN stg.album al ON t.albumid = al.albumid
LEFT JOIN stg.artist ar ON al.artistid = ar.artistid
LEFT JOIN stg.mediatype m ON t.mediatypeid = m.mediatypeid
LEFT JOIN stg.genre g ON t.genreid = g.genreid;

-- 4. טבלת עובדות: שורות הזמנה עם מחיר סופי
CREATE TABLE dwh.Fact_invoiceline AS
SELECT
    *,
    (unitprice * quantity) AS total_price 
FROM stg.invoiceline;
