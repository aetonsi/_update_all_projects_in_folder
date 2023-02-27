# \_update_all_projects_in_folder

Simple powershell script to update all svn / git working directories in a given root folder.

It runs `git pull`, `git submodule update` and `svn update` for any child directory containing an `.svn` or `.git` folder.

# Usage

In `powershell`:

```powershell
# to trigger folder browser dialog
.\_update_all_projects_in_folder.ps1
# or specifying a folder
.\_update_all_projects_in_folder.ps1 -dir c:\somefolder
```

In Windows `cmd`:

```batch
rem to trigger folder browser dialog
_update_all_projects_in_folder
rem or specifying a folder
_update_all_projects_in_folder -dir c:\somefolder
```

In Linux shell:

```bash
# to trigger folder browser dialog
./_update_all_projects_in_folder.sh
# or directly
./_update_all_projects_in_folder.ps1
# as always you can specify a folder
./_update_all_projects_in_folder.ps1 -dir /somefolder
```

In Windows Explorer, just double click `_update_all_projects_in_folder.cmd`. It will trigger the folder browser dialog.
