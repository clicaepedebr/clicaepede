-- Correct installations where migration 0031 was already applied before it was
-- hardened. service_role bypasses RLS and remains available only to trusted
-- server-side code; browser roles retain no table privileges or policies.
DO $$
BEGIN
  IF to_regclass('public.diagnostic_submissions') IS NOT NULL THEN
    ALTER TABLE public.diagnostic_submissions ENABLE ROW LEVEL SECURITY;

    DROP POLICY IF EXISTS "Allow public diagnostic submissions"
      ON public.diagnostic_submissions;

    REVOKE ALL ON TABLE public.diagnostic_submissions FROM anon;
    REVOKE ALL ON TABLE public.diagnostic_submissions FROM authenticated;
  END IF;
END $$;
