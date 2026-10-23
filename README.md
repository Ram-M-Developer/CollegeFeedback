# College Feedback Management System

A production-ready, full-stack **College Feedback Management System** built with **Java Servlets, JSP, JDBC, MySQL, Maven, Bootstrap 5, and Chart.js**.

---

## 🌟 Key Features

### 🎓 1. Student Module
- **Registration & Login**: Secure account creation with duplicate checks for register numbers and email addresses.
- **Dynamic Feedback Form**: Cascading dynamic dropdowns (Department $\rightarrow$ Faculty $\rightarrow$ Subject) via AJAX.
- **Interactive 1–5 Star Rating**: Intuitive visual star selector with rating descriptions (*1 = Very Poor* to *5 = Excellent*).
- **Duplicate Protection**: Prevents multiple feedback submissions for the same student and faculty.
- **Feedback History**: Track past submissions and dates from the student dashboard.

### 👨‍🏫 2. Faculty Module
- **Faculty Portal Login**: Dedicated login for academic staff members.
- **Performance Overview**: View individual overall average feedback ratings ($1.0 - 5.0$).
- **Student Review Stream**: Access student comments and detailed course reviews.

### 🛡️ 3. Administrator Module
- **Executive Dashboard**: Key Performance Indicators (KPI Cards) showing Total Students, Total Faculty, Total Feedbacks, and Overall Average Rating.
- **Chart.js Visual Analytics**:
  - 🍩 **Rating Distribution Doughnut Chart** (1–5 Star counts)
  - 📊 **Faculty Performance Bar Chart** (Average score per faculty member)
  - 🏛️ **Department Performance Bar Chart**
  - 📚 **Subject Performance Breakdown Chart**
- **Student CRUD**: Create, view, search/filter, update, and delete student accounts.
- **Faculty CRUD**: Add, edit, search/filter, and remove faculty members.
- **Feedback Log Review**: Advanced multi-criteria filters (Department, Faculty, Rating 1–5, Date Range).
- **Institutional Reports & Printing**: Aggregated score matrices with one-click print/export capabilities (`window.print()`).

---

## 🛠️ Technology Stack

| Component | Technology / Library |
| :--- | :--- |
| **Backend Language** | Java (JDK 11 / 17 compatible) |
| **Web Framework** | Java Servlets 4.0 & JSP (Java EE / Jakarta EE standard) |
| **Data Access & DB** | JDBC, MySQL 8.0+, PreparedStatement |
| **Security** | BCrypt (`jbcrypt` 0.4), Session Authentication Filter |
| **Build System** | Apache Maven |
| **Frontend Framework**| Bootstrap 5, FontAwesome 6, Custom Vanilla CSS |
| **Data Visualization**| Chart.js (Doughnut & Bar charts via JSON API) |
| **Servlet Container** | Apache Tomcat 9.x / 10.x |

---

## 🔑 Test Login Credentials

| Role | Username / Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` (or `admin@college.edu`) | `admin123` | Full System Control & Analytics |
| **Faculty** | `robert.smith@college.edu` | `faculty123` | View Ratings & Student Reviews |
| **Student** | `student@gmail.com` | `student123` | Submit Feedback & View History |

*(Note: Passwords are automatically verified using BCrypt hashes stored in MySQL).*

---

## 🗄️ Database Setup (MySQL)

1. Open MySQL Workbench or MySQL Command Line Client.
2. Run the provided SQL script located at `database/college_feedback.sql`:

```bash
mysql -u root -p < database/college_feedback.sql
```

or copy and execute the script inside MySQL Workbench.

### Database Credentials Configuration
Database connection parameters are located in `src/main/webapp/WEB-INF/web.xml` and `com.collegefeedback.util.DBConnection.java`.

Default Settings:
- **URL**: `jdbc:mysql://localhost:3306/college_feedback?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC`
- **Username**: `root`
- **Password**: `root`

---

## 🚀 Building & Running the Project

### Step 1: Maven Build
Run the following command in the project root directory:

```bash
mvn clean package
```
This generates the WAR file `target/collegefeedback.war`.

### Step 2: Deploy to Apache Tomcat
1. Copy `target/collegefeedback.war` to the `webapps` directory of your Apache Tomcat server.
2. Start Apache Tomcat:
   - **Windows**: `bin/startup.bat`
   - **Linux/Mac**: `bin/startup.sh`
3. Access the application in your browser at:
   `http://localhost:8080/collegefeedback/`

---

## 📁 Project Directory Structure

```
collegefeedback/
│
├── database/
│   └── college_feedback.sql       # MySQL schema and initial sample dataset
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── collegefeedback/
│       │           ├── controller/  # Java Servlets
│       │           │   ├── AdminServlet.java
│       │           │   ├── FacultyServlet.java
│       │           │   ├── FeedbackServlet.java
│       │           │   ├── LoginServlet.java
│       │           │   ├── LogoutServlet.java
│       │           │   ├── ReportServlet.java
│       │           │   ├── StudentRegisterServlet.java
│       │           │   └── StudentServlet.java
│       │           │
│       │           ├── dao/         # Data Access Objects (JDBC)
│       │           │   ├── AdminDAO.java
│       │           │   ├── FacultyDAO.java
│       │           │   ├── FeedbackDAO.java
│       │           │   └── StudentDAO.java
│       │           │
│       │           ├── filter/      # Authentication & Security Filters
│       │           │   └── AuthenticationFilter.java
│       │           │
│       │           ├── model/       # Data Models (DTOs / Entities)
│       │           │   ├── Admin.java
│       │           │   ├── Faculty.java
│       │           │   ├── Feedback.java
│       │           │   ├── FeedbackAnalysis.java
│       │           │   └── Student.java
│       │           │
│       │           └── util/        # Utilities (DB & Security)
│       │               ├── DBConnection.java
│       │               └── PasswordUtil.java
│       │
│       └── webapp/                  # Frontend Web Assets & JSPs
│           ├── index.jsp            # Landing Page
│           ├── login.jsp            # Multi-role Login View
│           ├── register.jsp         # Student Registration View
│           │
│           ├── student/             # Student Module JSPs
│           │   ├── dashboard.jsp
│           │   ├── feedback.jsp
│           │   └── profile.jsp
│           │
│           ├── admin/               # Admin Dashboard & Management JSPs
│           │   ├── dashboard.jsp
│           │   ├── faculty.jsp
│           │   ├── feedback.jsp
│           │   ├── profile.jsp
│           │   ├── reports.jsp
│           │   └── students.jsp
│           │
│           ├── faculty/             # Faculty Portal JSPs
│           │   ├── dashboard.jsp
│           │   └── profile.jsp
│           │
│           ├── css/
│           │   └── style.css        # Custom Styling & Theme
│           │
│           ├── js/
│           │   └── script.js        # Chart.js & Dynamic Interactivity
│           │
│           └── WEB-INF/
│               └── web.xml          # Deployment Descriptor
│
└── pom.xml                          # Maven Configuration
```

---

## 🔮 Future Enhancements
- Email Notification integration for new feedback submissions.
- PDF export generation using iText or JasperReports library.
- Multi-college branch & semester support.
