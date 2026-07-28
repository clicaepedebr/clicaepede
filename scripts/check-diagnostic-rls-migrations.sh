#!/usr/bin/env bash
set -euo pipefail

migrations=(
  supabase/migrations/0031_fix_diagnostic_submissions_rls.sql
  supabase/migrations/0032_remove_public_diagnostic_access.sql
)

for migration in "${migrations[@]}"; do
  test -f "$migration"
  rg -q 'ENABLE ROW LEVEL SECURITY' "$migration"
  rg -q 'REVOKE ALL ON TABLE public\.diagnostic_submissions FROM anon' "$migration"
  rg -q 'REVOKE ALL ON TABLE public\.diagnostic_submissions FROM authenticated' "$migration"
  if rg -q 'GRANT (INSERT|SELECT|UPDATE|DELETE).* TO (anon|authenticated)|WITH CHECK \(true\)' "$migration"; then
    echo "unsafe public diagnostic access found in $migration" >&2
    exit 1
  fi
done

echo 'Diagnostic RLS migrations keep browser roles blocked.'
