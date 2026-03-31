# 📚 HomeLibrary

iOS application for managing a personal book library, built with SwiftUI and Core Data.  
The app allows users to organize, search, and manage their book collection with persistent storage and data portability.

---

## 🚀 Features

- Add, edit, and delete books
- Organize books with structured data
- Search, filter, and sort books
- Persistent storage using Core Data
- Import and export library data (CSV, JSON)
- Clean and responsive UI built with SwiftUI

---

## 🛠 Tech Stack

- **Language:** Swift  
- **UI:** SwiftUI (+ UIKit where needed)  
- **Architecture:** MVVM  
- **Persistence:** Core Data  
- **Tools:** Xcode, Git  

---

## 🏗 Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

- **View** – SwiftUI views responsible for UI rendering  
- **ViewModel** – handles business logic and state management  
- **Model** – Core Data entities and data structures  

The data layer is separated to ensure:
- maintainability  
- scalability  
- clear separation of concerns  

---

## 💾 Data Management

- Implemented **Core Data** with relationships between entities  
- Supports persistent storage of the entire library  
- Provides **data export/import (CSV, JSON)** for backup and portability  

---

## 🔍 Key Highlights

- Designed scalable architecture using MVVM  
- Implemented efficient data querying (search & filtering)  
- Focused on clean code and maintainability  
- Built as a product-style application rather than a demo  

---

## 📸 Screenshots

### My Library
<img width="1179" height="2556" alt="image" src="https://github.com/user-attachments/assets/b61fa143-cfa3-4d39-b9cc-ce13251dce71" />

### Add/Edit Book
<img width="1179" height="2556" alt="image" src="https://github.com/user-attachments/assets/ac92084c-1825-42c9-8409-4a885ad0a869" />

### Categories
<img width="1179" height="2556" alt="image" src="https://github.com/user-attachments/assets/4dddc6fa-1c2f-4f44-8200-69d3b0cbf820" />

### Overview
<img width="1179" height="2556" alt="image" src="https://github.com/user-attachments/assets/0280a866-bb6b-4180-987a-8770b5160913" />

---

## 📦 Getting Started

1. Clone the repository:
```bash
git clone https://github.com/4reta1l/HomeLibrary.git
2. Open in Xcode
open HomeLibrary.xcodeproj
3. Run the app on simulator or device
