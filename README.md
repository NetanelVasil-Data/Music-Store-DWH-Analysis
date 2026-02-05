# Music-Store-DWH-Analysis
📊 Music Store Data Warehouse & Business Intelligence
פרויקט זה מדגים בניית מחסן נתונים (DWH) מקצה לקצה ב-PostgreSQL, הכולל תהליכי ETL, הגדרת קשרי גומלין (Constraints) וביצוע שאילתות ניתוח עסקי מורכבות.

🏗️ Architecture: Star Schema
בניתי מודל נתונים המבוסס על Star Schema המאפשר ביצועי שאילתות אופטימליים לצרכי BI.

Table NameTypeKey Features & TransformationsDim_TrackDimensionדה-נורמליזציה של ז'אנרים, אמנים ואלבומים. כולל חישוב משך שיר בפורמט קריא.Dim_CustomerDimensionניקוי נתוני שמות (INITCAP) וחילוץ דומיין מייל לניתוח שיווקי.Dim_EmployeeDimensionהעשרת נתוני עובדים עם תקציב מחלקתי , חישוב ותק בשנים והגדרת דגל is_manager.Dim_PlaylistDimensionמיפוי קשרים בין שירים לרשימות השמעה , כולל הוספת שמות פלייליסטים טקסטואליים.Fact_InvoiceFactריכוז עסקאות ברמת המאקרו הכולל מפתחות זרים ללקוחות ומטבעות.Fact_InvoiceLineFact פירוט ברמת שורת הזמנה וחישוב מחיר כולל (total_price) לכל שורה.
