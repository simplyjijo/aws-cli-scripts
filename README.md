# AWS CLI Scripts for S3 Glacier Management

This repository contains a collection of AWS CLI scripts for managing S3 Glacier and related workflows. The scripts are categorized by platform (Mac and Windows) and task (restore, copy, list, etc.) to streamline operations such as:

- Restoring files or folders from Glacier
- Checking restore status
- Copying restored files to a temporary bucket
- Listing storage class distributions

All scripts are tested and designed for automation and troubleshooting of S3 archival workflows.

---

## 📁 Repository Structure




---

## 🛠 Requirements

- AWS CLI installed and configured (`aws configure`)
- Valid permissions to access and restore S3 Glacier objects
- Shell environment (Terminal on Mac or Command Prompt on Windows)

---

## 🧪 Script Overview

### mac/
- **restore_folder.sh**: Bulk restore all objects in a given folder.
- **restore_count.sh**: Count how many files are restored vs. pending.
- **copy_restored_objects.sh**: Copy only restored/standard-class files to a temp bucket.
- **list_storage_class.sh**: List storage class per file and summarize.
- **check_single_file_restore.sh**: Check restore status of one specific file.

### windows/
- **restore_objects.cmd**: Bulk restore all objects in a folder.
- **restore_count.cmd**: Count restore status across a folder.
- **copy_restored_objects.cmd**: Copy all restored/accessible files to temp bucket.
- **list_storage_class.cmd**: Scan and count each storage class type.
- **check_single_file_restore.cmd**: Check restore state of one file.

---

## 🔒 Notes

- No credentials are stored in this repository.
- Scripts use environment-safe practices (`setlocal`, `$VAR` or `%VAR%`).
- Always verify bucket and prefix before running destructive operations.

---

## 📜 License

Not licensed for public reuse. Internal use only.

---

## 🤝 Contributions

This is a closed internal tool. Pull requests are not open.

---

## 🧼 Maintainer Checklist

- [ ] Keep scripts updated with AWS CLI changes
- [ ] Run `shellcheck` or `bat` linters before pushing
- [ ] Test scripts in non-prod buckets when updating
