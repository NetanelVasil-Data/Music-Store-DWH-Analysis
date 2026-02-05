# Music-Store-DWH-Analysis
📊 Music Store Data Warehouse & Business Intelligence

פרויקט זה מדגים בניית מחסן נתונים (DWH) מקצה לקצה ב-PostgreSQL, הכולל תהליכי ETL, הגדרת קשרי גומלין (Constraints) וביצוע שאילתות ניתוח עסקי מורכבות.


💿 Dimensions (טבלאות ממד)
Dim_Track

תיאור: ישות אחת "רחבה" הכוללת את כל המידע על השיר.   

לוגיקה: דה-נורמליזציה של ז'אנרים, אמנים ואלבומים. שינוי שמות עמודות (track_name, artist_name) לבהירות וחישוב משך שיר בפורמט קריא (MM:SS) .   

Dim_Customer


תיאור: נתוני לקוחות מנוקים ומעושרים.   



לוגיקה: האחדת פורמט שמות (Capitalization) באמצעות INITCAP וחילוץ דומיין האימייל לניתוח שיווקי.   

Dim_Employee



תיאור: נתוני עובדים והיררכיה ארגונית.   


לוגיקה: העשרת נתונים עם תקציב מחלקתי , חישוב ותק בשנים והגדרת דגל is_manager לזיהוי מנהלים בארגון.   

Dim_Playlist



תיאור: מיפוי שירים לרשימות השמעה.   



לוגיקה: חיבור בין קוד הפלייליסט לשמו הטקסטואלי לצורך דוחות.   

💰 Facts (טבלאות עובדות)
Fact_Invoice



תיאור: תיעוד עסקאות ברמת המאקרו (ראש הזמנה).   



קשרים: הגדרת מפתחות זרים (FK) ללקוחות ולטבלת המטבעות לצורך המרות שער.   

Fact_InvoiceLine



תיאור: פירוט הפריטים שנרכשו בכל הזמנה (Granularity ברמת השיר). 



🔍 Key Business Insights (SQL Analysis)

הפרויקט עונה על שאלות עסקיות קריטיות באמצעות SQL מתקדם (CTEs, Window Functions):


ניתוח צמיחה: חישוב אחוזי גדילה בהכנסות של עובדים משנה לשנה באמצעות LAG.   


פילוח מדינות: זיהוי 5 המדינות המובילות בהכנסות תוך המרת מטבע לשקל (ILS).   


ביצועי מוצרים: סיווג שירים לפי נפח מכירות (0, 1-5, 6-10, 10+).



לוגיקה: חישוב אוטומטי של מחיר סופי לכל שורה (total_price).
