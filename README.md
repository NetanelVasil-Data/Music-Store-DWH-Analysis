# Music-Store-DWH-Analysis
📊 Music Store Data Warehouse & Business Intelligence
פרויקט זה מדגים בניית מחסן נתונים (DWH) מקצה לקצה ב-PostgreSQL, הכולל תהליכי ETL, הגדרת קשרי גומלין (Constraints) וביצוע שאילתות ניתוח עסקי מורכבות.

🏗️ Architecture: Star Schema
בניתי מודל נתונים המבוסס על Star Schema המאפשר ביצועי שאילתות אופטימליים לצרכי BI.
Table Name	Type	Key Features & Transformations
Dim_Track	Dimension	
[cite_start]דה-נורמליזציה של ז'אנרים, אמנים ואלבומים. [cite_start]כולל שינוי שמות עמודות וחישוב משך שיר בפורמט MM:SS.   

Dim_Customer	Dimension	
[cite_start]ניקוי נתוני שמות (INITCAP) [cite_start]וחילוץ דומיין מייל לניתוח שיווקי.   

Dim_Employee	Dimension	
[cite_start]העשרת נתוני עובדים עם תקציב מחלקתי [cite_start], חישוב ותק בשנים [cite_start]והגדרת דגל is_manager.   

Dim_Playlist	Dimension	
[cite_start]מיפוי קשרים בין שירים לרשימות השמעה [cite_start], כולל הוספת שמות פלייליסטים טקסטואליים.   

Fact_Invoice	Fact	
[cite_start]ריכוז עסקאות ברמת המאקרו הכולל מפתחות זרים ללקוחות ומטבעות.   

Fact_InvoiceLine	Fact	
[cite_start]פירוט ברמת שורת הזמנה [cite_start]וחישוב מחיר כולל (total_price) לכל שורה.
