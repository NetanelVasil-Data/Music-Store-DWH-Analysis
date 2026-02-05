-- יצירת סכמת ה-DWH
CREATE SCHEMA IF NOT EXISTS dwh;

-- 1. ממד לקוחות: ניקוי שמות וחילוץ דומיין 
CREATE TABLE dwh.dim_customer AS
SELECT
    customerid,
    INITCAP(firstname) AS firstname,
    INITCAP(lastname) AS lastname,
    email,
    SUBSTRING(email FROM '@(.*)') AS domain,
    city,
    country,
    supportrepid
FROM stg.customer;

-- 2. ממד עובדים: חישוב ותק, זיהוי מנהלים ותקציב מחלקתי 
CREATE TABLE dwh.dim_employee AS
WITH managers AS (
    SELECT DISTINCT reportsto FROM stg.employee WHERE reportsto IS NOT NULL
)
SELECT 
    e.*,
    b.department_name,
    b.budget,
    EXTRACT(YEAR FROM AGE(NOW(), e.hiredate)) AS years_of_employment,
    CASE WHEN m.reportsto IS NOT NULL THEN 1 ELSE 0 END AS is_manager
FROM stg.employee e
LEFT JOIN stg.department_budget b ON e.departmentid = b.department_id
LEFT JOIN managers m ON e.employeeid = m.reportsto;

-- 3. ממד שירים: דה-נורמליזציה מלאה ופורמט זמן 
CREATE TABLE dwh.dim_track AS
SELECT
    t.trackid,
    t.name AS track_name,
    al.album_title,
    ar.artist_name,
    g.genre_name,
    m.media_type_name,
    t.milliseconds / 1000.0 AS duration_seconds,
    FLOOR(t.milliseconds / 60000) || ':' || LPAD(FLOOR((t.milliseconds % 60000) / 1000)::text, 2, '0') AS duration_formatted
FROM stg.track t
LEFT JOIN stg.album al ON t.albumid = al.albumid
LEFT JOIN stg.artist ar ON al.artistid = ar.artistid
LEFT JOIN stg.mediatype m ON t.mediatypeid = m.mediatypeid
LEFT JOIN stg.genre g ON t.genreid = g.genreid;

-- 4. ממד פלייליסטים 
CREATE TABLE dwh.dim_playlist AS
SELECT pt.*, p.name AS playlist_name
FROM stg.playlisttrack pt
LEFT JOIN stg.playlist p ON pt.playlistid = p.playlistid;

-- 5. טבלת עובדות: הזמנות - כולל שיוך עובד (supportrepid) 
CREATE TABLE dwh.fact_invoice AS
SELECT 
    i.*, 
    c.supportrepid, -- הבאת העובד לטבלת העובדות לטובת המודל
    i.invoicedate::DATE AS invoice_date_only
FROM stg.invoice i
JOIN stg.customer c ON i.customerid = c.customerid;

-- 6. טבלת עובדות: שורות הזמנה וחישוב מחיר סופי 
CREATE TABLE dwh.fact_invoiceline AS
SELECT *, (unitprice * quantity) AS total_price FROM stg.invoiceline;

-- הגדרת מפתחות וקשרים (Constraints) 
ALTER TABLE dwh.dim_customer ADD PRIMARY KEY (customerid);
ALTER TABLE dwh.dim_employee ADD PRIMARY KEY (employeeid);
ALTER TABLE dwh.dim_track ADD PRIMARY KEY (trackid);
ALTER TABLE dwh.fact_invoice ADD PRIMARY KEY (invoiceid);

ALTER TABLE dwh.fact_invoice ADD CONSTRAINT fk_inv_cust FOREIGN KEY (customerid) REFERENCES dwh.dim_customer(customerid);
ALTER TABLE dwh.fact_invoice ADD CONSTRAINT fk_inv_emp FOREIGN KEY (supportrepid) REFERENCES dwh.dim_employee(employeeid);
ALTER TABLE dwh.fact_invoiceline ADD CONSTRAINT fk_line_inv FOREIGN KEY (invoiceid) REFERENCES dwh.fact_invoice(invoiceid);
ALTER TABLE dwh.fact_invoiceline ADD CONSTRAINT fk_line_track FOREIGN KEY (trackid) REFERENCES dwh.dim_track(trackid);
