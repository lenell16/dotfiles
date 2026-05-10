# HM prepends sessionPath onto PATH that already contains same dirs (path_helper,
# Cursor, etc.) → duplicates. Deduplicate after all other shellInit; first win.
{ lib, ... }:
{
  programs.fish.shellInit = lib.mkAfter ''
    set -l _dedup
    for _p in $PATH
      if test -n "$_p"; and not contains -- $_p $_dedup
        set -a _dedup $_p
      end
    end
    set -gx PATH $_dedup
  '';
}
