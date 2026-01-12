# 📅 Day Planner App

A minimal, distraction-free **daily planning app** built using **Flutter**. The app helps users plan their day, manage tasks with time slots, and build consistency using an automatic daily reset mechanism.

This project is designed as a **real-world learning app** focusing on product thinking, clean UI, and practical Flutter concepts.

---

## 🚀 Features

* ➕ **Add Tasks** with:

  * Description
  * Start & End time (30‑minute intervals)
  * Category (Productivity, Study, Health, etc.)

* 📋 **Task List View**

  * Clean, readable layout
  * Automatically sorted by start time

* ⏰ **Daily Auto Reset at 9:00 PM**

  * Clears old tasks once per day
  * Automatically adds a default **“Plan Your Day”** task (9:00–9:15 PM)

* 🖐️ **Long‑Press Actions**

  * Long‑press any task to:

    * 🗑️ Delete task
    * ✏️ Edit task 

* 💾 **Persistent Storage**

  * Uses `SharedPreferences`
  * Tasks remain saved across app restarts

* 🌙 **Dark Mode UI**

  * Minimal, distraction‑free design

---

## 🧠 App Philosophy

This app is intentionally simple:

* No unnecessary animations
* No social distractions
* Focused on **daily intent & execution**

The goal is not just task tracking, but **building discipline and planning habits**.

---

## 🛠️ Tech Stack

* **Flutter** (UI & app logic)
* **Dart**
* **SharedPreferences** (local storage)
* **ValueNotifier** (lightweight state management)

---

## 📂 Project Structure

```text
lib/
│── main.dart          # App entry point
│── start_page.dart    # Home screen & task list
│── add_task.dart      # Add task screen
│── task_data.dart     # Task model & storage logic
```

---

## ▶️ How It Works

### Task Flow

1. User adds a task using **Add Task** screen
2. Task is saved locally using `SharedPreferences`
3. Tasks are automatically sorted by start time
4. Long‑press on a task shows Edit/Delete options

### Daily Reset Logic

* On app launch:

  * Checks last reset time
  * If current time is past **9:00 PM** and reset hasn’t happened today:

    * Clears tasks
    * Adds **Plan Your Day** task

---

## 🧪 Future Improvements

* 🔔 Notifications for task start/end
* 📊 Weekly productivity insights
* 🧠 AI‑based planning suggestions
* ☁️ Cloud sync (Firebase)

---

## 👨‍💻 Author

Built by a student developer learning **Flutter, product thinking, and app development** with a long‑term goal of building impactful tech products.

---

## 📜 License
This project is for **learning and personal use**. Feel free to fork and experiment.

---

> *"Plan the day, don’t let the day plan you."*
