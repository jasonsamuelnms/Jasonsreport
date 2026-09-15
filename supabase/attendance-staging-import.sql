-- 1. Run this in Supabase SQL Editor.
-- 2. In Table Editor, upload Attendance_Log.csv into import_attendance_log.
-- 3. Run the migration section below after the upload succeeds.

create table if not exists public.import_attendance_log (
  "Record_ID" text,
  "Date" text,
  "Day" text,
  "Month" text,
  "Year" text,
  "Login_Time" text,
  "Logout_Time" text,
  "Worked_Minutes" text,
  "Permission_Start" text,
  "Permission_End" text,
  "Permission_Minutes" text,
  "Half_Day" text,
  "Present" text,
  "Late" text,
  "Late_Minutes" text,
  "Absent" text,
  "Remarks" text,
  "Created_At" text,
  "Updated_At" text
);

-- Run after the CSV import. This preserves IDs and converts dates, times and booleans.
insert into public.attendance_log (
  record_id, attendance_date, day, month, year, login_time, logout_time,
  worked_minutes, permission_start, permission_end, permission_minutes,
  half_day, present, late, late_minutes, absent, remarks, created_at, updated_at
)
select
  "Record_ID",
  to_date("Date", 'MM/DD/YYYY'),
  nullif("Day", ''),
  nullif("Month", '')::smallint,
  nullif("Year", '')::smallint,
  nullif("Login_Time", '')::time,
  nullif("Logout_Time", '')::time,
  coalesce(nullif("Worked_Minutes", '')::integer, 0),
  nullif("Permission_Start", '')::time,
  nullif("Permission_End", '')::time,
  coalesce(nullif("Permission_Minutes", '')::integer, 0),
  nullif("Half_Day", ''),
  coalesce(nullif("Present", '')::boolean, false),
  coalesce(nullif("Late", '')::boolean, false),
  coalesce(nullif("Late_Minutes", '')::integer, 0),
  coalesce(nullif("Absent", '')::boolean, false),
  nullif("Remarks", ''),
  coalesce(nullif("Created_At", '')::timestamp, now()),
  coalesce(nullif("Updated_At", '')::timestamp, now())
from public.import_attendance_log
on conflict (attendance_date) do update set
  record_id = excluded.record_id,
  login_time = excluded.login_time,
  logout_time = excluded.logout_time,
  worked_minutes = excluded.worked_minutes,
  permission_start = excluded.permission_start,
  permission_end = excluded.permission_end,
  permission_minutes = excluded.permission_minutes,
  half_day = excluded.half_day,
  present = excluded.present,
  late = excluded.late,
  late_minutes = excluded.late_minutes,
  absent = excluded.absent,
  remarks = excluded.remarks,
  updated_at = excluded.updated_at;
