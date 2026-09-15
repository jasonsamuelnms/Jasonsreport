-- Run once in Supabase SQL Editor after your first magic-link sign-in.
-- Replace YOUR_APPROVED_EMAIL with the exact email address you will use.

create policy "owner manages projects" on public.projects
for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL');

create policy "owner manages attendance" on public.attendance_log
for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL');

create policy "owner manages compensation" on public.compensation_log
for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL');

create policy "owner manages holiday settings" on public.holiday_settings
for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL');

create policy "owner manages government holidays" on public.tn_government_holidays
for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL');

create policy "owner manages daily reports" on public.daily_reports
for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_APPROVED_EMAIL');
