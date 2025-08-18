# Barber Booking App – UX Specification

---

## ⚠️ הערה חשובה
הטקסט בעברית נועד להבנה כללית בלבד.  
**אין להשתמש בגרסה בעברית כהוראות פיתוח. הפיתוח יתבצע על פי המפרט באנגלית בהמשך הקובץ.**

---

## גרסה בעברית (לקריאה בלבד)

### מסך הבית
- לוגו למעלה.  
- כפתור מרכזי: "קבע תור".  
- רשימת "התורים שלך" (עד שניים קדימה).  
  - ליד כל תור מופיע כפתור ביטול (X).  
  - לחיצה עליו → חלון אישור → "ביטול תור" → חזרה למסך הבית עם הודעה למטה:  
    *"התור שלך ל־{תאריך ושעה} בוטל."*  
- כפתור קטן למנהל (בתחתית ימין).

### שעות פעילות ולוח זמנים
- ימי השבוע: ראשון עד שבת.  
- שעות עבודה: 09:00–19:00, בקפיצות של 30 דקות.  
- כל שירות תופס משבצת של 30 דקות.

### בחירת שירות
- אין מסך נפרד לבחירת שירות.  
- בחירת השירות מתבצעת בתוך מסך האישור באמצעות בורר עם שלוש אפשרויות: תספורת / מכונה / זקן.  
- המחיר מוצג בהתאם לשירות שנבחר.

### מסך לוח זמנים שבועי
- טבלה עם **7 טורים (ראשון–שבת)**.  
- כל טור מחולק למשבצות של חצי שעה בין 09:00 ל־19:00.  
- משבצת ירוקה = פנויה.  
- משבצת אפורה = תפוסה.  
- משבצת כתומה = תור של המשתמש (לא לחיצה).  
- ניתן לעבור שבוע קדימה/אחורה עם חצים.  
- לחיצה על ירוק → מסך אישור.

### מסך אישור תור
- מציג את השירות (לבחירה במקום), מחיר, תאריך, שעה ושם הלקוח.  
- השם ניתן לעריכה רק אם לוחצים על אייקון עיפרון (ואז מופיע וי לאישור).  
- כפתורי פעולה:  
  - **אישור** → שמירת התור + חזרה לבית עם הודעה למטה:  
    *"התור שלך נקבע ל־{תאריך ושעה}."*  
  - **ביטול** → חזרה לבית בלי לשמור.

### צד מנהל
- כניסה דרך כפתור קטן במסך הבית.  
- לוח ניהול: צפייה בתורים, הוספת משבצות פנויות, חסימת משבצות, ביטול תורים.

---

## English Specification (for development)

### General Principles
- Mobile app built with **Flutter**.  
- Optimized for iOS (iPhone 16 simulator) and Android.  
- Backend + Supabase database will be added **after frontend is finalized**.  

### Operating Hours
- Week: Sunday → Saturday  
- Working hours: 09:00–19:00, 30-minute increments  
- All services occupy one 30-minute slot

### 1. Home Screen
- Logo at the top.  
- Main button: **“Book Appointment”**.  
- Section: **“Your Upcoming Appointments”** (up to 2).  
  - Each appointment has a **Cancel button (X)** → confirmation popup → cancel → return to Home + message at bottom:  
    > *“Your appointment on {date, time} was canceled.”*  
- Manager login button at bottom-right.  

### 2. Service Selection
- No standalone Service Selection screen.  
- Service is selected on the Confirmation Screen via a segmented control with: Haircut / Machine / Beard.  
- Price is shown according to the selected service.

### 3. Weekly Schedule
- Grid: **7 columns (Sun–Sat)**.  
- Rows = half-hour slots between 09:00 and 19:00.  
- Green = available.  
- Grey = unavailable.  
- Orange = client’s existing booking (not clickable).  
- Arrows (< >) to move between weeks.  
- Clicking a green slot → Confirmation Screen.  

### 4. Confirmation Screen
- Shows: service selector (Haircut / Machine / Beard), price, date, time, client’s name.  
- Name editable only via pencil icon + checkmark.  
- **Actions**:  
  - Confirm → Save appointment → Return to Home + message:  
    > *“Your appointment is set for {date, time}.”*  
  - Cancel → Return to Home without booking.  

### 5. Manager Side
- Login from Home screen (small button).  
- Manager Dashboard:  
  - View all appointments.  
  - Add available slots.  
  - Block/unblock slots.  
  - Cancel appointments (notifying client).  

---

## Flowchart

```mermaid
flowchart TD

Home[Home Screen] --> |"Book Appointment"| Schedule[Weekly Schedule]
Home --> |"Cancel Appointment (X)"| CancelPopup[Confirm Cancel Popup] --> Home

Schedule --> |"Select Green Slot"| Confirmation[Confirmation Screen]

Confirmation --> |"Confirm"| Home
Confirmation --> |"Cancel"| Home

Home --> |"Manager Login"| ManagerDashboard[Manager Dashboard]

---

## Changelog

- 2025-08-18: Defined operating hours as 09:00–19:00 with 30-minute slots; removed standalone Service Selection screen and moved service selection to the Confirmation Screen (Hebrew + English updated).
