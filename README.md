# ✨ **RAM Cleaner – Automated Memory Optimization for Windows**

*A lightweight Windows utility that frees standby memory automatically every 15 minutes.*

---

<p align="center">
  <img src="https://img.shields.io/badge/Windows-10%2F11-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/PowerShell-Automation-purple?style=for-the-badge">
  <img src="https://img.shields.io/badge/VBS-Background%20Runner-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge">
</p>

---

## 🚀 **Overview**

This project is a **fully automated RAM cleaning utility** for Windows, inspired by ASUS’ memory optimization tools.
It uses:

* **PowerShell** (core logic)
* **VBS** (to run the script hidden in the background)
* **Task Scheduler XML** (so it auto-runs every 15 minutes)
* **EmptyStandbyList.exe** (to flush standby memory safely)

The script logs memory usage before and after cleanup and silently runs without interrupting the user.

---

## 🧠 **What It Does**

✔ Frees **standby** RAM using `EmptyStandbyList.exe`
✔ Logs timestamps, before/after memory stats
✔ Runs automatically on schedule
✔ Completely silent via VBS wrapper
✔ Low CPU usage and zero user interaction
✔ Ideal for systems that accumulate RAM usage over time

---

## 📁 **Project Structure**

```
Scripts/
│
├── FreeRAM.ps1             → Main PowerShell script (actual RAM cleaner)
├── FreeRAM_Hidden.vbs      → Runs the PS script with no window
├── EmptyStandbyList.exe    → Executable used to clear Standby RAM
├── Free up memory usage.xml → Windows Task Scheduler import file (15-min loop)
└── readme.txt              → Local usage notes
```

---

## ⚙️ **How It Works (Technical Breakdown)**

### **1. PowerShell Script (`FreeRAM.ps1`)**

* Reads current memory stats via WMI (`Win32_OperatingSystem`)
* Calls `EmptyStandbyList.exe workingsets`
* Calls `EmptyStandbyList.exe standbylist`
* Logs results to:

  ```
  C:\Scripts\FreeRAM_Log.txt
  ```

### **2. VBS Launcher (`FreeRAM_Hidden.vbs`)**

Runs PowerShell invisibly:

```vbscript
CreateObject("Wscript.Shell").Run "powershell -windowstyle hidden -File ""C:\Scripts\FreeRAM.ps1""", 0
```

### **3. Task Scheduler XML**

* Runs every **15 minutes**
* Runs hidden (because it launches the VBS)
* Works even after reboot

---

## 🔧 **Installation Guide**

### **STEP 1 — Copy Files**

Copy the entire `Scripts` folder into:

```
C:\Scripts
```

*(You may choose another folder, but then edit paths inside the .ps1 and .xml.)*

---

### **STEP 2 — Allow PowerShell Scripts**

Run PowerShell as Admin:

```powershell
Set-ExecutionPolicy RemoteSigned
```

---

### **STEP 3 — Register the Scheduled Task**

1. Open **Task Scheduler**
2. Click **Import Task...**
3. Select:

   ```
   Free up memory usage.xml
   ```
4. Confirm
5. Make sure the task is **Enabled**

---

### **STEP 4 — Set the Correct User Account (Important)**

After importing the task, you’ll see a random SID value under *“When running the task, use the following user account:”*.

To change this to the correct user:

1. Click **Change User or Group…**

2. You’ll see a window like this:

<img width="1387" height="567" alt="Screenshot 2025-11-19 105036" src="https://github.com/user-attachments/assets/d4cf6a11-f58a-4fdc-b770-d9db2d0a01bb" />

3. In the field labeled **Enter the object name to select**, type your Windows username.

   * Example: `RaneKun`

4. Click **Check Names**

   * If the username is valid, Windows will underline it and correct it automatically.

5. Click **OK** to confirm

6. Now your task will run under the correct user account

💡 **Tip:**
If you don’t know your exact username, open PowerShell and run:

```powershell
whoami
```

Use whatever appears *after* the backslash.

---


## ▶️ **Manual Run (Optional)**

If you want to run it instantly:

```powershell
powershell -File "C:\Scripts\FreeRAM.ps1"
```

Or simply run:

```
FreeRAM_Hidden.vbs
```

---

## 📝 **Logs**

All logs are stored at:

```
C:\Scripts\FreeRAM_Log.txt
```

You’ll see entries like:

```
2025-11-18 19:41:33 | Freed: 1.4GB | Before: 10.1GB free -> After: 11.5GB free | Total: 15.5GB
2025-11-19 10:43:55 | Freed: 5.3GB | Before: 4.1GB free -> After: 9.4GB free | Total: 15.5GB
2025-11-19 10:56:33 | Freed: 5.7GB | Before: 4GB free -> After: 9.7GB free | Total: 15.5GB
2025-11-19 11:11:33 | Freed: 3.6GB | Before: 5.5GB free -> After: 9.1GB free | Total: 15.5GB
2025-11-19 11:26:33 | Freed: 2.7GB | Before: 7.2GB free -> After: 9.9GB free | Total: 15.5GB
```

---

## 🖥️ **Why Use This?**

If your system builds up:

* Standby cache
* Game leftovers
* Chrome’s aggressive RAM allocations

…this tool can keep your system smooth **without any annoying pop-ups or manual cleanup**.

---

🏅 Credits

This project uses EmptyStandbyList.exe created by Stefan Pejcic.
You can find the original project here:
👉 https://github.com/stefanpejcic/EmptyStandbyList

All rights to the executable belong to its original author.

---

## 📄 **License**

This project is licensed under the **MIT License**.

---
