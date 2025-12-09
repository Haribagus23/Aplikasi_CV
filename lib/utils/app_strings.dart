import 'package:flutter/material.dart';
import 'language_provider.dart';

class AppStrings {
  final bool isIndonesian;

  AppStrings(this.isIndonesian);

  static AppStrings of(BuildContext context) {
    return LanguageScope.of(context).strings;
  }

  // --- GENERAL ---
  String get downloadCv => isIndonesian ? "Unduh CV" : "Download CV";
  String get contactMe => isIndonesian ? "Hubungi Saya" : "Contact Me";
  String get basedIn => isIndonesian
      ? "Berbasis di Brebes, Jawa Tengah"
      : "Based in Brebes, Central Java";
  String get btnClose => isIndonesian ? "Tutup" : "Close";

  // --- NAV BAR ---
  String get navHome => isIndonesian ? "Beranda" : "Home";
  String get navAbout => isIndonesian ? "Tentang" : "About";
  String get navSkills => isIndonesian ? "Keahlian" : "Skills";
  String get navExperience => isIndonesian ? "Pengalaman" : "Experience";
  String get navServices => isIndonesian ? "Layanan" : "Services";
  String get navProjects => isIndonesian ? "Proyek" : "Projects";
  String get navContact => isIndonesian ? "Kontak" : "Contact";

  // --- GET STARTED SECTION ---
  String get hello => isIndonesian ? "Halo, Saya Hari" : "Hi, I'm Hari";
  String get iBuild => isIndonesian ? "Saya membangun " : "I build ";
  String get typeMobile => isIndonesian ? "Aplikasi Mobile" : "Mobile Apps";
  String get typeWeb => isIndonesian ? "Sistem Web" : "Web Systems";
  String get typeExp => isIndonesian ? "Solusi Digital" : "Digital Solutions";
  String get scrollExplore =>
      isIndonesian ? "GULIR UNTUK JELAJAH" : "SCROLL TO EXPLORE";

  // --- ABOUT SECTION ---
  String get aboutTitle => isIndonesian ? "Tentang Saya" : "About Me";
  String get aboutSubtitle =>
      isIndonesian ? "Kenali saya lebih dekat" : "Get to know me better";
  String get aboutBio => isIndonesian
      ? "Seorang lulusan D3 Teknik Komputer (sedang menunggu wisuda) dengan minat di bidang administrasi, teknologi informasi, dan pengembangan web. Memiliki pengalaman sebagai staf administrasi serta keahlian dalam pengelolaan data, Microsoft Office, pemrograman dasar, dan pembuatan aplikasi web."
      : "A D3 Computer Engineering graduate (awaiting graduation) with interests in administration, information technology, and web development. Experienced as an administration staff with skills in data management, Microsoft Office, basic programming, and web application development.";
  String get statYears =>
      isIndonesian ? "Tahun\nPengalaman" : "Years of\nExperience";
  String get statProjects =>
      isIndonesian ? "Proyek\nSelesai" : "Projects\nCompleted";
  String get statClients => isIndonesian ? "Klien\nSenang" : "Happy\nClients";
  String get quoteText => isIndonesian
      ? "Satu-satunya cara untuk melakukan pekerjaan hebat adalah dengan mencintai apa yang Anda lakukan."
      : "The only way to do great work is to love what you do.";

  String get aboutRole => isIndonesian ? "Pengembang Web" : "Web Developer";
  String get statCoffee => isIndonesian ? "Kopi" : "Coffee";

  // --- SKILLS SECTION ---
  String get skillsTitle =>
      isIndonesian ? "Keahlian & Sertifikasi" : "Skills & Certifications";
  String get skillsSubtitle => isIndonesian
      ? "Kemampuan teknis dan pencapaian saya"
      : "My technical proficiency and achievements";
  String get tabCertifications =>
      isIndonesian ? "Sertifikasi" : "Certifications";
  String get tabSkills => isIndonesian ? "Keahlian Teknis" : "Technical Skills";

  List<Map<String, Object>> get certifications => [
    {
      "provider": "Dicoding",
      "courses": [
        isIndonesian
            ? "Belajar Dasar Artificial Intelligence"
            : "Learn Basic Artificial Intelligence",
        isIndonesian
            ? "Belajar Dasar Pemrograman Web"
            : "Learn Basic Web Programming",
        isIndonesian
            ? "Belajar Dasar Git & GitHub"
            : "Learn Basic Git & GitHub",
      ],
    },
    {
      "provider": "BISA AI",
      "courses": ["Basic Excel", "Excel for Analytics", "Excel Optimization"],
    },
    {
      "provider": "Alibaba Cloud",
      "courses": ["Alibaba Cloud Certified Developer (ACD)"],
    },
    {
      "provider": isIndonesian ? "Platform Lain" : "Other Platforms",
      "courses": [
        isIndonesian ? "Pemrograman PHP Dasar" : "Basic PHP Programming",
        "Laravel Fundamentals",
        "Tailwind CSS",
        isIndonesian
            ? "Dasar-dasar Cybersecurity"
            : "Cybersecurity Fundamentals",
        isIndonesian
            ? "Pengembangan Web (Front-End)"
            : "Web Development (Front-End)",
      ],
    },
  ];

  String get txtUsrPrefix => "USR"; // Universal but can be localized if needed

  Map<String, List<Map<String, dynamic>>> get skillsData => {
    (isIndonesian ? "Pengembangan Web" : "Web Development"): [
      {"name": "HTML", "val": 0.95},
      {"name": "CSS", "val": 0.90},
      {"name": "JS", "val": 0.75},
      {"name": "PHP", "val": 0.92},
      {"name": "Laravel", "val": 0.85},
      {"name": "MySQL", "val": 0.90},
    ],
    "Frontend": [
      {"name": "UI/UX", "val": 0.80},
      {"name": "Bootstrap", "val": 0.85},
      {"name": "Responsive", "val": 0.90},
      {"name": "Animation", "val": 0.75},
      {"name": "Figma", "val": 0.70},
    ],
    "Backend": [
      {"name": "Rest API", "val": 0.70},
      {"name": "Linux", "val": 0.80},
      {"name": "Windows", "val": 0.65},
      {"name": "Docker", "val": 0.60},
      {"name": "Security", "val": 0.75},
    ],
    (isIndonesian ? "Alat" : "Tools"): [
      {"name": "VS Code", "val": 0.95},
      {"name": "Excel", "val": 0.85},
      {"name": "Git", "val": 0.80},
      {"name": "Node.js", "val": 0.60},
      {"name": "Postman", "val": 0.85},
    ],
    (isIndonesian ? "Soft Skill" : "Soft Skills"): [
      {"name": isIndonesian ? "Logika" : "Logic", "val": 0.90},
      {"name": isIndonesian ? "Adaptasi" : "Adapt", "val": 0.95},
      {"name": isIndonesian ? "Waktu" : "Time", "val": 0.80},
      {"name": isIndonesian ? "Komunikasi" : "Comm", "val": 0.85},
      {"name": isIndonesian ? "Tim" : "Team", "val": 0.88},
    ],
  };

  // --- EXPERIENCE SECTION ---
  String get expTitle => isIndonesian ? "Pengalaman" : "Experience";
  String get expSubtitle => isIndonesian
      ? "Perjalanan profesional dan pendidikan saya."
      : "My professional journey and education history.";

  // Experience Items
  // 1. PT Osaga Mas Utama
  String get expRole1 => isIndonesian ? "Admin" : "Admin";
  String get expComp1 => "PT Osaga Mas Utama, Brebes";
  String get expDesc1 => isIndonesian
      ? "Januari 2024 – Juli 2024. Input data karyawan. Membantu HRD dan dukungan administrasi dalam proses produksi."
      : "January 2024 – July 2024. Input employee data. Assisted HRD and provided administrative support in the production process.";

  // 2. RS Amanah Mahmudah Sitanggal
  String get expRole2 => isIndonesian ? "Satuan Pengamanan" : "Security Guard";
  String get expComp2 => "RS Amanah Mahmudah Sitanggal, Brebes";
  String get expDesc2 => isIndonesian
      ? "September 2021 – Agustus 2022. Menjaga keamanan lingkungan rumah sakit. Mengatur lalu lintas internal. Membantu pengunjung dan pasien."
      : "September 2021 – August 2022. Maintained hospital environment security. Managed internal traffic. Assisted visitors and patients.";

  // 3. Politeknik Harapan Bersama Tegal
  String get expRole3 =>
      isIndonesian ? "D3 Teknik Komputer" : "D3 Computer Engineering";
  String get expComp3 => "Politeknik Harapan Bersama Tegal";
  String get expDesc3 => isIndonesian
      ? "2022 – 2025. Fokus pada pengembangan web dan jaringan komputer."
      : "2022 – 2025. Focused on web development and computer networking.";

  // 4. MAN 1 Brebes
  String get expRole4 => isIndonesian ? "Jurusan MIPA" : "Science Major (MIPA)";
  String get expComp4 => "MAN 1 Brebes";
  String get expDesc4 => isIndonesian
      ? "2019 – 2021. Pendidikan Menengah Atas."
      : "2019 – 2021. Senior High School.";

  // --- SERVICES SECTION ---
  String get servicesTitle => isIndonesian ? "Layanan Saya" : "My Services";
  String get servicesSubtitle => isIndonesian
      ? "Apa yang bisa saya lakukan untuk Anda"
      : "What I can do for you";
  String get startFrom => isIndonesian ? "Mulai dari" : "Starting from";
  String get orderNow => isIndonesian ? "Pesan Sekarang" : "Order Now";

  // Service Items
  String get srvMobileTitle =>
      isIndonesian ? "Pengembangan Aplikasi Mobile" : "Mobile App Development";
  String get srvMobileDesc => isIndonesian
      ? "Aplikasi mobile lintas platform performa tinggi dengan Flutter."
      : "High-performance, cross-platform mobile applications built with Flutter.";
  String get srvWebTitle =>
      isIndonesian ? "Pengembangan Web" : "Web Development";
  String get srvWebDesc => isIndonesian
      ? "Website modern, responsif, dan ramah SEO."
      : "Modern, responsive, and SEO-friendly websites tailored to your brand.";
  String get srvAiTitle =>
      isIndonesian ? "Administrasi & Data" : "Admin & Data";
  String get srvAiDesc => isIndonesian
      ? "Penginputan data, pengelolaan dokumen, dan administrasi perkantoran."
      : "Data entry, document management, and office administration.";

  String get expDate1 =>
      isIndonesian ? "Jan 2024 - Jul 2024" : "Jan 2024 - Jul 2024";
  String get expDate2 =>
      isIndonesian ? "Sep 2021 - Agu 2022" : "Sep 2021 - Aug 2022";
  String get expDate3 => "2022 - 2025";
  String get expDate4 => "2019 - 2021";

  String get btnOrder =>
      isIndonesian ? "EKSEKUSI_PROTOKOL [PESAN]" : "EXECUTE_PROTOCOL [ORDER]";

  List<String> get srvMobileFeatures => isIndonesian
      ? [
          "Dukungan iOS & Android",
          "Desain UI/UX Kustom",
          "Integrasi API",
          "Publikasi App Store",
        ]
      : [
          "iOS & Android Support",
          "Custom UI/UX Design",
          "API Integration",
          "App Store Submission",
        ];

  List<String> get srvWebFeatures => isIndonesian
      ? ["Desain Responsif", "Integrasi CMS", "Optimasi SEO", "Performa Cepat"]
      : [
          "Responsive Design",
          "CMS Integration",
          "SEO Optimization",
          "Fast Performance",
        ];

  List<String> get srvAiFeatures => isIndonesian
      ? [
          "Integrasi Chatbot",
          "Analisis Data",
          "Model Machine Learning",
          "Skrip Otomasi",
        ]
      : [
          "Chatbot Integration",
          "Data Analysis",
          "Machine Learning Models",
          "Automation Scripts",
        ];

  // --- PROJECTS SECTION ---
  String get projTitle => isIndonesian
      ? "Proyek Unggulan"
      : "Featured Projects"; // Or just Projects
  String get projSubtitle =>
      isIndonesian ? "Beberapa karya terbaik saya" : "Some of my best work";
  String get viewProject => isIndonesian ? "Lihat Detail" : "View Details";
  String get projAbout =>
      isIndonesian ? "Tentang proyek ini" : "About this project";
  String get projTech => isIndonesian ? "Teknologi" : "Technologies";
  String get btnOpenProject => isIndonesian ? "Buka Proyek" : "Open Project";

  // Categories
  String get catAll => isIndonesian ? "SEMUA" : "ALL";
  String get catMobile => isIndonesian ? "MOBILE" : "MOBILE";
  String get catWeb => isIndonesian ? "WEB" : "WEB";
  String get catAi => isIndonesian ? "LAINNYA" : "OTHERS";

  // Project Items (Sample 1)
  String get proj1Title => "Smart Inventory System";
  String get proj1Desc => isIndonesian
      ? "Dashboard manajemen inventaris berbasis web yang komprehensif dengan pelacakan real-time."
      : "Comprehensive web-based inventory management dashboard with real-time tracking.";
  String get proj1FullDesc => isIndonesian
      ? "Sistem manajemen inventaris yang tangguh dirancang untuk gudang bervolume tinggi. Fitur termasuk pelacakan stok real-time, pemesanan ulang otomatis, dan dashboard analitik terperinci. Dibangun dengan antarmuka web responsif untuk aksesibilitas di berbagai perangkat."
      : "A robust inventory management system designed for high-volume warehouses. Features include real-time stock tracking, automated reordering, and detailed analytics dashboards. Built with a responsive web interface for accessibility across devices.";

  // Project Items (Sample 2)
  String get proj2Title => "E-Commerce Mobile App";
  String get proj2Desc => isIndonesian
      ? "Pengalaman belanja mobile modern dengan checkout mulus dan penemuan produk."
      : "Modern mobile shopping experience with seamless checkout and product discovery.";
  String get proj2FullDesc => isIndonesian
      ? "Aplikasi mobile e-commerce kaya fitur. Termasuk feed beranda yang dipersonalisasi, pemfilteran produk tingkat lanjut, sistem keranjang aman, dan integrasi berbagai gateway pembayaran. UI dioptimalkan untuk konversi dan retensi pengguna."
      : "A feature-rich e-commerce mobile application. It includes a personalized home feed, advanced product filtering, a secure cart system, and multiple payment gateway integrations. The UI is optimized for conversion and user retention.";

  // ... (I will add generic getters for other projects to save space if they are placeholders, or just map them directly in the UI if they are too many. For now, I'll add the keys for the ones in the file)

  String get proj3Title => "Academic Portal";
  String get proj3Desc => isIndonesian
      ? "Gerbang digital untuk mahasiswa dan dosen."
      : "Digital gateway for university students and faculty to manage academic activities.";
  String get proj3FullDesc => isIndonesian
      ? "Portal akademik terintegrasi yang memungkinkan mahasiswa melihat nilai, mendaftar kursus, dan mengakses materi pembelajaran."
      : "An integrated academic portal that allows students to view grades, register for courses, and access learning materials.";

  String get proj4Title => "Secure Auth System";
  String get proj4Desc => isIndonesian
      ? "Alur otentikasi mobile keamanan tinggi."
      : "High-security mobile authentication flow with biometric integration.";
  String get proj4FullDesc => isIndonesian
      ? "Modul otentikasi mandiri untuk aplikasi mobile yang menampilkan login, registrasi, dan biometrik."
      : "A standalone authentication module for mobile apps featuring login, registration, password recovery, and biometric unlock.";

  String get proj5Title => "Frontend Architecture";
  String get proj5Desc => isIndonesian
      ? "Showcase pengembangan frontend modern."
      : "Modern frontend development showcase highlighting component-based design.";
  String get proj5FullDesc => isIndonesian
      ? "Demonstrasi prinsip arsitektur frontend modern menggunakan teknologi web terbaru."
      : "A demonstration of modern frontend architecture principles. This project showcases reusable components, state management patterns, and performance optimization techniques.";

  String get proj6Title => "Java Enterprise Solution";
  String get proj6Desc => isIndonesian
      ? "Sistem backend skalabel untuk ERP."
      : "Scalable backend system for enterprise resource planning.";
  String get proj6FullDesc => isIndonesian
      ? "Solusi backend yang dibangun dengan Java untuk menangani logika perusahaan yang kompleks."
      : "A backend solution built with Java for handling complex enterprise logic. It supports high-concurrency transactions, extensive logging, and integration with legacy systems.";

  // --- CONTACT SECTION ---
  String get contactTitle => isIndonesian ? "Hubungi Saya" : "Get In Touch";
  String get contactSubtitle => isIndonesian
      ? "Punya proyek atau sekadar ingin menyapa? Saya selalu terbuka untuk mendiskusikan ide dan peluang baru."
      : "Have a project in mind or just want to say hi? I'm always open to discussing new ideas and opportunities.";
  String get labelName => isIndonesian ? "Nama" : "Name";
  String get labelEmail => isIndonesian ? "Email" : "Email";
  String get labelMessage => isIndonesian ? "Pesan" : "Message";
  String get btnSend => isIndonesian ? "Kirim Pesan" : "Send Message";
  String get orConnect =>
      isIndonesian ? "Atau terhubung lewat" : "Or connect via";

  // Validation Messages
  String get msgSending =>
      isIndonesian ? "Membuka aplikasi email..." : "Opening email client...";
  String get msgFillName =>
      isIndonesian ? "Mohon masukkan nama Anda" : "Please enter your name";
  String get msgFillEmail => isIndonesian
      ? "Mohon masukkan email yang valid"
      : "Please enter a valid email";
  String get msgFillMessage =>
      isIndonesian ? "Mohon masukkan pesan" : "Please enter a message";

  // --- RATING SECTION ---
  String get ratingTitle => isIndonesian ? "// UMPAN BALIK" : "// FEEDBACK";
  String get ratingSubtitle => isIndonesian
      ? "// LOG_UMPAN_BALIK_DARI_JARINGAN"
      : "// FEEDBACK_LOGS_FROM_THE_NETWORK";
  String get ratingError => isIndonesian ? "// GALAT: " : "// ERROR: ";
  String get ratingNoData =>
      isIndonesian ? "// BELUM_ADA_TRANSMISI" : "// NO_TRANSMISSIONS_YET";
  String get btnInitiateTransmission => isIndonesian
      ? "BERIKAN {UMPAN BALIK}"
      : "INITIATE_TRANSMISSION {FEEDBACK}";
  String get ratingStatusVerified =>
      isIndonesian ? "STATUS: TERVERIFIKASI" : "STATUS: VERIFIED";

  // Dialog
  String get dialogTitle =>
      isIndonesian ? "// MULAI_TRANSMISI" : "// INITIATE_TRANSMISSION";
  String get labelIdentifier =>
      isIndonesian ? "IDENTITAS [NAMA]" : "IDENTIFIER [NAME]";
  String get labelSignalStrength =>
      isIndonesian ? "KEKUATAN_SINYAL [RATING]" : "SIGNAL_STRENGTH [RATING]";
  String get labelDataPacket =>
      isIndonesian ? "PAKET_DATA [PESAN]" : "DATA_PACKET [MESSAGE]";
  String get btnAbort => isIndonesian ? "BATALKAN" : "ABORT";
  String get btnTransmit => isIndonesian ? "TRANSMISIKAN" : "TRANSMIT";
  String get msgTransSuccess =>
      isIndonesian ? "// TRANSMISI BERHASIL" : "// TRANSMISSION SUCCESSFUL";
  String get msgTransFailed =>
      isIndonesian ? "// TRANSMISI GAGAL" : "// TRANSMISSION FAILED";
  String get errFieldRequired =>
      isIndonesian ? "// GALAT: KOLOM_WAJIB" : "// ERROR: FIELD_REQUIRED";

  // --- FLOATING NAV BAR ---
  String get navSystemReady =>
      isIndonesian ? "SISTEM_SIAP // NAV_V2.0" : "SYSTEM_READY // NAV_V2.0";
  String get navLightMode => isIndonesian ? "MODE_TERANG" : "LIGHT_MODE";
  String get navDarkMode => isIndonesian ? "MODE_GELAP" : "DARK_MODE";
  String get navEnglish => isIndonesian ? "INGGRIS" : "ENGLISH";
  String get navIndonesian => isIndonesian ? "INDONESIA" : "INDONESIA";

  // Short Nav Labels (HUD)
  String get navHomeShort => isIndonesian ? "BERANDA" : "HOME";
  String get navAboutShort => isIndonesian ? "TENTANG" : "ABOUT";
  String get navSkillsShort => isIndonesian ? "SKILL" : "SKILLS";
  String get navExpShort => isIndonesian ? "PENG" : "EXP";
  String get navServShort => isIndonesian ? "LAY" : "SERV";
  String get navProjShort => isIndonesian ? "PROY" : "PROJ";
  String get navTestiShort => isIndonesian ? "TESTI" : "TESTI";
  String get navContactShort => isIndonesian ? "KONTAK" : "CONTACT";

  // --- SYSTEM BOOT SCREEN ---
  String get bootInitKernel => isIndonesian
      ? "> MENGINISIALISASI KERNEL..."
      : "> INITIALIZING KERNEL...";
  String get bootLoadModules =>
      isIndonesian ? "> MEMUAT MODUL INTI..." : "> LOADING CORE MODULES...";
  String get bootCpuOk =>
      isIndonesian ? "> [SUKSES] CPU: OK" : "> [SUCCESS] CPU: OK";
  String get bootMemOk =>
      isIndonesian ? "> [SUKSES] MEMORI: OK" : "> [SUCCESS] MEMORY: OK";
  String get bootNetSecure => isIndonesian
      ? "> [SUKSES] JARINGAN: AMAN"
      : "> [SUCCESS] NETWORK: SECURE";
  String get bootDecryptProfile => isIndonesian
      ? "> MENDEKRIPSI PROFIL PENGGUNA..."
      : "> DECRYPTING USER PROFILE...";
  String get bootFetchSkills => isIndonesian
      ? "> MENGAMBIL DATA KEAHLIAN..."
      : "> FETCHING SKILLS DATA...";
  String get bootFlutterDetected => isIndonesian
      ? "> [SUKSES] FLUTTER: TERDETEKSI"
      : "> [SUCCESS] FLUTTER: DETECTED";
  String get bootDartDetected => isIndonesian
      ? "> [SUKSES] DART: TERDETEKSI"
      : "> [SUCCESS] DART: DETECTED";
  String get bootFirebaseConnected => isIndonesian
      ? "> [SUKSES] FIREBASE: TERHUBUNG"
      : "> [SUCCESS] FIREBASE: CONNECTED";
  String get bootCalibrateUi => isIndonesian
      ? "> MENGKALIBRASI ANTARMUKA..."
      : "> CALIBRATING UI INTERFACE...";
  String get bootLoadAssets =>
      isIndonesian ? "> MEMUAT ASET..." : "> LOADING ASSETS...";
  String get bootWarnCreativity => isIndonesian
      ? "> [PERINGATAN] KREATIVITAS TINGGI TERDETEKSI"
      : "> [WARNING] HIGH CREATIVITY DETECTED";
  String get bootSystemReady =>
      isIndonesian ? "> SISTEM SIAP." : "> SYSTEM READY.";
  String get bootWaitInput => isIndonesian
      ? "> MENUNGGU INPUT PENGGUNA..."
      : "> WAITING FOR USER INPUT...";

  String get bootHeader => "SYSTEM_BOOT_V1.0"; // Universal
  String get bootSystemStatus =>
      isIndonesian ? "STATUS SISTEM:" : "SYSTEM STATUS:";
  String get bootAccessGranted =>
      isIndonesian ? "AKSES DITERIMA" : "ACCESS GRANTED";
  String get bootSecureConn =>
      isIndonesian ? "KONEKSI_AMAN" : "SECURE_CONNECTION";
  String get bootMemUsage => "MEM_USAGE: 42%"; // Universal

  // --- MISSING STRINGS ---
  List<String> get marqueeSkills => [
    "PHP",
    "HTML",
    "CSS",
    "Laravel",
    "Tailwind CSS",
    "Java",
    "Kotlin",
    "C++",
    isIndonesian ? "Jaringan" : "Networking",
    "Microsoft Office",
    isIndonesian ? "Pemecahan Masalah" : "Troubleshooting",
    "MySQL",
  ];

  String get txtAvailableModules =>
      isIndonesian ? "// MODUL_TERSEDIA" : "// AVAILABLE_MODULES";

  String get txtModuleId => isIndonesian ? "ID_MODUL" : "MODULE_ID";

  String get msgWhatsapp => isIndonesian
      ? "Halo Hari, saya tertarik dengan layanan"
      : "Hi Hari, I am interested in your service";

  String get txtCopyright => isIndonesian
      ? "© 2024 Hari Portfolio. Dibuat dengan Flutter."
      : "© 2024 Hari Portfolio. Built with Flutter.";

  String get txtEmailSubject =>
      isIndonesian ? "Kontak Portofolio dari" : "Portfolio Contact from";

  String get txtEmailBodyName => isIndonesian ? "Nama" : "Name";
  String get txtEmailBodyEmail => isIndonesian ? "Email" : "Email";
  String get txtEmailBodyMessage => isIndonesian ? "Pesan" : "Message";

  // --- SUCCESS DIALOG ---
  String get txtSuccessTitle =>
      isIndonesian ? "TRANSMISI BERHASIL" : "TRANSMISSION SUCCESSFUL";
  String get txtSuccessMessage => isIndonesian
      ? "Data paket Anda telah berhasil dikirim ke server pusat. Terima kasih atas kontribusi Anda."
      : "Your data packet has been successfully transmitted to the central server. Thank you for your contribution.";
  String get btnAcknowledge => isIndonesian ? "MENGERTI" : "ACKNOWLEDGE";
}
