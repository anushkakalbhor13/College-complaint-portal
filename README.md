# College Complaint Portal — Java (Spring Boot + JDBC + MySQL) + Static Frontend

This repository has been migrated from PHP to a modern split architecture:
- Backend: Java Spring Boot with JDBC and MySQL, JWT-based authentication, Flyway DB migrations
- Frontend: Static HTML/CSS/JS ready for Vercel

See MIGRATION.md for a high-level overview.

## ✨ Key Features

### 🎙️ **Audio/Video Complaints**
- **Voice Recording**: Submit complaints using voice recordings
- **Video Evidence**: Attach video recordings for visual evidence
- **File Upload**: Support for documents, images, audio, and video files
- **Drag & Drop**: Modern file upload with drag-and-drop interface

### 🧠 **Sentiment Analysis & Mood Tagging**
- **Automatic Analysis**: AI-powered sentiment analysis of complaint text
- **Mood Detection**: Color-coded mood indicators (very negative to very positive)
- **Priority Suggestions**: Automatic priority assignment based on sentiment and urgency
- **Issue Classification**: Automatic detection of complaint categories

### 🎨 **Modern Responsive UI**
- **Bootstrap 5**: Latest responsive framework
- **Mobile-First**: Optimized for all device sizes
- **Glass Morphism**: Modern design with backdrop blur effects
- **Dark/Light Themes**: Customizable appearance
- **Smooth Animations**: Enhanced user experience with CSS transitions

### 🔐 **Enhanced Security**
- **Environment Configuration**: Secure configuration management
- **SQL Injection Protection**: Prepared statements throughout
- **File Upload Security**: Restricted file types and sizes
- **Session Management**: Secure session handling
- **CSRF Protection**: Cross-site request forgery prevention

### 📊 **Dynamic Dashboards**
- **Real-time Statistics**: Live complaint counts and status updates
- **Interactive Charts**: Visual representation of complaint trends
- **Status Tracking**: Complete complaint lifecycle management
- **Priority Management**: Automatic and manual priority assignment

### 🚀 **Advanced Features**
- **Multi-role System**: Students, Officials, and Administrators
- **Complaint Lifecycle**: Complete tracking from submission to resolution
- **Notification System**: Real-time alerts and updates
- **Search & Filter**: Advanced complaint search functionality
- **Export Options**: PDF and Excel report generation

## 🛠️ Installation & Setup

### Prerequisites
- **PHP 7.4** or higher
- **MySQL 8.0** or higher
- **Apache/Nginx** web server
- **Composer** (optional, for dependencies)

### Quick Start

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/college-complaint-portal.git
   cd college-complaint-portal
   ```

2. **Database Setup**
   ```bash
   # Create database
   mysql -u root -p -e \"CREATE DATABASE college_complaint_portal;\"
   
   # Import schema
   mysql -u root -p college_complaint_portal < database_schema.sql
   ```

3. **Environment Configuration**
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit configuration
   nano .env
   ```

4. **File Permissions**
   ```bash
   # Set upload directory permissions
   chmod 755 uploads/
   chmod 755 uploads/complaints/
   ```

5. **Web Server Configuration**
   - Point document root to the project directory
   - Ensure mod_rewrite is enabled (Apache)
   - Configure virtual host if needed

### Environment Variables

Edit `.env` file with your configuration:

```env
# Database Configuration
DB_HOST=localhost
DB_USERNAME=your_db_user
DB_PASSWORD=your_db_password
DB_NAME=college_complaint_portal

# Application Settings
APP_NAME=\"Your College Complaint Portal\"
APP_URL=http://localhost
APP_ENV=production
DEBUG=false

# Email Configuration (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
```

## 📁 Project Structure

```
college-complaint-portal/
├── assets/                     # CSS, JS, and media files
│   ├── styles.css             # Enhanced responsive styles
│   └── script.js              # Modern JavaScript functionality
├── config/                     # Configuration files
│   └── config.php             # Environment configuration loader
├── includes/                   # PHP classes and utilities
│   └── SentimentAnalyzer.php  # Sentiment analysis engine
├── uploads/                    # File upload directory
│   ├── complaints/            # Complaint attachments
│   └── .htaccess             # Security restrictions
├── .vscode/                   # VS Code settings
├── src/                       # Java source files (legacy)
├── target/                    # Compiled Java files (legacy)
├── .env.example              # Environment template
├── .gitignore               # Git ignore rules
├── database_schema.sql      # Complete database schema
├── db_connect.php          # Secure database connection
├── index.php              # Main landing page
├── submit_complaint.php   # Basic complaint submission
├── submit_complaint_enhanced.php  # Advanced complaint form
├── user_dashboard.php     # User dashboard
├── student_login.php      # Student authentication
├── admin_login.php       # Admin authentication
├── official_login.php    # Official authentication
└── README.md            # This file
```

## 🚀 Features Breakdown

### User Roles & Permissions

| Feature | Student | Official | Admin |
|---------|---------|----------|-------|
| Submit Complaints | ✅ | ❌ | ✅ |
| View Own Complaints | ✅ | ❌ | ✅ |
| Track Status | ✅ | ❌ | ✅ |
| Assign Complaints | ❌ | ✅ | ✅ |
| Update Status | ❌ | ✅ | ✅ |
| View All Complaints | ❌ | ✅ | ✅ |
| Generate Reports | ❌ | ✅ | ✅ |
| Manage Users | ❌ | ❌ | ✅ |
| System Settings | ❌ | ❌ | ✅ |

### Complaint Status Flow

```
Pending → Assigned → In Progress → Resolved → Closed
    ↓         ↓           ↓          ↓        ↑
 Withdrawn  Escalated   Returned   Reopened  ←
```

### File Upload Support

| Type | Formats | Max Size |
|------|---------|----------|
| Images | JPG, PNG, GIF | 5MB |
| Documents | PDF, DOC, DOCX | 5MB |
| Audio | MP3, WAV, OGG, M4A | 5MB |
| Video | MP4, WEBM, OGG | 5MB |

## 🎯 Usage Guide

### For Students

1. **Register/Login**: Create account or login with credentials
2. **Submit Complaint**: Use enhanced form with audio/video support
3. **Track Progress**: Monitor complaint status in dashboard
4. **Provide Feedback**: Rate resolution quality

### For Officials

1. **Login**: Access official dashboard
2. **Review Complaints**: View assigned complaints with sentiment analysis
3. **Update Status**: Progress complaints through workflow
4. **Communicate**: Add notes and updates for students

### For Administrators

1. **System Overview**: Monitor all complaints and statistics
2. **User Management**: Create and manage user accounts
3. **Assign Officials**: Route complaints to appropriate departments
4. **Generate Reports**: Export data for analysis

## 🛡️ Security Features

- **Input Validation**: All user inputs are sanitized and validated
- **SQL Injection Protection**: Prepared statements used throughout
- **File Upload Security**: Restricted file types and virus scanning
- **Session Security**: Secure session configuration with timeouts
- **Environment Configuration**: Sensitive data stored in environment variables
- **Access Control**: Role-based permissions and authentication

## 📊 Dashboard Features

### Student Dashboard
- Personal complaint statistics
- Recent complaints with status
- Quick action buttons
- Mood indicators for complaints

### Official Dashboard
- Assigned complaints queue
- Priority-based sorting
- Sentiment analysis insights
- Status update tools

### Admin Dashboard
- System-wide statistics
- User management interface
- Complaint trends and analytics
- System health monitoring

## 🔧 Customization

### Themes
The system supports custom themes through CSS variables:

```css
:root {
    --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    --border-radius: 15px;
    --box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}
```

### Sentiment Analysis
Customize sentiment detection by modifying word lists in `includes/SentimentAnalyzer.php`:

```php
private $urgentWords = [
    'urgent', 'emergency', 'critical', 'severe'
    // Add your custom urgent keywords
];
```

## 🧪 Testing

### Manual Testing Checklist

- [ ] User registration and login
- [ ] Complaint submission (text, audio, video)
- [ ] File upload functionality
- [ ] Sentiment analysis accuracy
- [ ] Responsive design on mobile devices
- [ ] Role-based access control
- [ ] Dashboard statistics updates
- [ ] Email notifications

### Automated Testing (Future Implementation)

```bash
# Unit tests
php vendor/bin/phpunit tests/

# Integration tests
php vendor/bin/phpunit tests/Integration/

# End-to-end tests
npm run cypress:run
```

## 🚀 Deployment

### Production Checklist

- [ ] Set `DEBUG=false` in `.env`
- [ ] Configure SSL certificate
- [ ] Set up database backups
- [ ] Configure email settings
- [ ] Test file upload limits
- [ ] Implement monitoring
- [ ] Set up log rotation

### Docker Deployment (Optional)

```dockerfile
FROM php:8.1-apache
COPY . /var/www/html/
RUN docker-php-ext-install mysqli pdo pdo_mysql
EXPOSE 80
```

## 📈 Performance Optimization

- **Database Indexing**: Proper indexes on frequently queried columns
- **File Compression**: Automatic image compression for uploads
- **Caching**: Session-based caching for dashboard data
- **CDN Integration**: External CDN for static assets
- **Code Minification**: Compressed CSS and JavaScript files

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🔗 Links

- **Live Demo**: [https://demo.complaint-portal.com](https://demo.complaint-portal.com)
- **Documentation**: [https://docs.complaint-portal.com](https://docs.complaint-portal.com)
- **Support**: [https://support.complaint-portal.com](https://support.complaint-portal.com)

## 👥 Team

- **Lead Developer**: [Your Name]
- **UI/UX Designer**: [Designer Name]
- **Database Architect**: [DB Developer Name]
- **Security Consultant**: [Security Expert Name]

## 📞 Support

For support, email support@complaint-portal.com or join our Slack channel.

## 🎉 Acknowledgments

- Bootstrap team for the responsive framework
- Font Awesome for the beautiful icons
- PHP community for excellent documentation
- College administration for project requirements

---

**Made with ❤️ for better college complaint management**

![Footer](https://img.shields.io/badge/Build-Passing-green) ![License](https://img.shields.io/badge/License-MIT-blue) ![Version](https://img.shields.io/badge/Version-2.0-orange)