# ⚙️ Installation & Setup Guide - Music Store DWH


מדריך זה מפרט את השלבים הנדרשים להקמת הסביבה והרצת הפרויקט במחשב המקומי שלכם.


## 1. דרישות קדם (Prerequisites)

* **Python 3.x**: וודאו שמותקנת אצלכם גרסה עדכנית של פייתון.
* **PostgreSQL Database**: הפרויקט פותח והורץ על גבי PostgreSQL (Supabase).
* **SQL Editor**: מומלץ להשתמש ב-DBeaver לניהול מסד הנתונים.

## 2. התקנת ספריות פייתון
פתחו את הטרמינל והריצו את הפקודה הבאה להתקנת הספריות הנדרשות:
```bash
pip install pandas numpy sqlalchemy psycopg2 requests matplotlib seaborn

3. הקמת בסיס הנתונים (Database Setup)
התחברו לשרת ה-PostgreSQL שלכם.

צרו סכמה חדשה בשם dwh.

הריצו את הסקריפט המלא הנמצא בתיקייה: SQL_Scripts/01_DWH_Build.sql.


4. הגדרת והרצת ה-Python Analysis
פתחו את הקובץ Music_Store_Analysis.ipynb הנמצא בתיקיית Python_Analysis.

עדכנו את משתנה ה-DB_URI עם פרטי הגישה האישיים שלכם: DB_URI = "postgresql://user:password@host:port/dbname"

הריצו את כל התאים (Run All) כדי לבצע את תהליך ה-ETL והפקת הגרפים

5. הרצת שאילתות אנליטיות
לאחר שהנתונים נטענו, ניתן להריץ את השאילתות העסקיות (Q1-Q5) הנמצאות בתיקיית Analysis_Queries/02_Business_Insights.sql..
