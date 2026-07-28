-- The diagnostic flow must write through a trusted server-side function.
-- Do not grant the public Data API direct access to personal diagnostic data.
DO $$
BEGIN
  IF to_regclass('public.diagnostic_submissions') IS NOT NULL THEN
    ALTER TABLE public.diagnostic_submissions ENABLE ROW LEVEL SECURITY;

    REVOKE ALL ON TABLE public.diagnostic_submissions FROM anon;
    REVOKE ALL ON TABLE public.diagnostic_submissions FROM authenticated;

    DROP POLICY IF EXISTS "Allow public diagnostic submissions"
      ON public.diagnostic_submissions;
  END IF;
END $$;
