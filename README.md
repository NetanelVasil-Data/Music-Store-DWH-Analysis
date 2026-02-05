# Music-Store-DWH-Analysis
📊 Music Store Data Warehouse & Business Intelligence
פרויקט זה מדגים בניית מחסן נתונים (DWH) מקצה לקצה ב-PostgreSQL, הכולל תהליכי ETL, הגדרת קשרי גומלין (Constraints) וביצוע שאילתות ניתוח עסקי מורכבות.

🏗️ Architecture: Star Schema
בניתי מודל נתונים המבוסס על Star Schema המאפשר ביצועי שאילתות אופטימליים לצרכי BI.
Table NameTypeKey Features & TransformationsDim_TrackDimension[cite_start]דה-נורמליזציה הכוללת שילוב של ז'אנרים, אמנים ואלבומים. [cite_start]שינוי שמות עמודות לבהירות וחישוב משך שיר בפורמט MM:SS.Dim_CustomerDimension[cite_start]טיוב נתונים הכולל האחדת פורמט שמות (Capitalization) [cite_start]וחילוץ דומיין האימייל לניתוח שיווקי.Dim_EmployeeDimension[cite_start]העשרת נתוני עובדים עם תקציב מחלקתי [cite_start], חישוב ותק בשנים [cite_start]והגדרת דגל is_manager לזיהוי היררכיה.Dim_PlaylistDimension (Bridge)[cite_start]מיפוי קשרים בין שירים לרשימות השמעה [cite_start], כולל הוספת שמות פלייליסטים טקסטואליים.Fact_InvoiceFact[cite_start]ריכוז עסקאות ברמת המאקרו הכולל מפתחות זרים ללקוחות ומטבעות (מט"ח).Fact_InvoiceLineFact[cite_start]פירוט פריטי הזמנה (Granularity) הכולל חישוב אוטומטי של מחיר סופי לשורה.
