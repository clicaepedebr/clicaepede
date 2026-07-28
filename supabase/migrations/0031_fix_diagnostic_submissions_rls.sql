-- Allow public diagnostic form submissions while keeping RLS enabled.
-- The /diagnostico page is a public lead-generation flow, so inserts must be
-- accepted from the Supabase anon role. Existing access policies for reading or
-- updating submissions are intentionally left unchanged.

DO $$
BEGIN
  IF to_regclass('public.diagnostic_submissions') IS NOT NULL THEN
    ALTER TABLE public.diagnostic_submissions ENABLE ROW LEVEL SECURITY;

    GRANT INSERT ON public.diagnostic_submissions TO anon;
    GRANT USAGE ON SCHEMA public TO anon;

    DROP POLICY IF EXISTS "Allow public diagnostic submissions" ON public.diagnostic_submissions;

    CREATE POLICY "Allow public diagnostic submissions"
      ON public.diagnostic_submissions
      FOR INSERT
      TO anon
      WITH CHECK (true);
  END IF;
END $$;
