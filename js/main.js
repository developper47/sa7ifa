// ============================================================
// main.js — Shared layout: header, footer, article cards
// Updated for the new editorial design with dynamic sections
// ============================================================

import { getCurrentUser, signOut } from './auth.js?v=3.1';
import { getSections } from './sections.js?v=3.1';
import { readingTime } from './posts.js?v=3.1';

// ---- Utility: Eastern Arabic numerals ----
function toArabicNumerals(str) {
  return String(str);
}

// ---- Arabic Gregorian month names (Algerian/Maghrebi style) ----
const GREGORIAN_MONTHS_AR = [
  'جانفي', 'فيفري', 'مارس', 'أفريل', 'ماي', 'جوان',
  'جويلية', 'أوت', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
];

function formatArabicDate(dateStr) {
  const d = dateStr ? new Date(dateStr) : new Date();
  const day = toArabicNumerals(d.getDate());
  const month = GREGORIAN_MONTHS_AR[d.getMonth()];
  const year = toArabicNumerals(d.getFullYear());
  return `${day} ${month} ${year}`;
}

function formatArabicDateFull(dateStr) {
  const d = dateStr ? new Date(dateStr) : new Date();
  const days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
  const dayName = days[d.getDay()];
  return `${dayName}، ${formatArabicDate(dateStr)}`;
}

function formatHijriDate() {
  try {
    const d = new Date();
    const parts = new Intl.DateTimeFormat('ar-SA-u-ca-islamic', {
      day: 'numeric', month: 'long', year: 'numeric'
    }).formatToParts(d);
    let result = '';
    parts.forEach(p => { if (p.type !== 'literal' || p.value !== ',') result += p.value; });
    const easternToWestern = {
      '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
      '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9'
    };
    return result.trim().replace(/[٠-٩]/g, match => easternToWestern[match]) + ' هـ';
  } catch (e) {
    return '24 محرم 1448 هـ';
  }
}

// ---- View Counter ----
export function incrementViewCount(postId) {
  const key = `views_${postId}`;
  const count = parseInt(localStorage.getItem(key) || '0') + 1;
  localStorage.setItem(key, count);
  return count;
}
export function getViewCount(postId) {
  return parseInt(localStorage.getItem(`views_${postId}`) || '0');
}

// ---- Favorites ----
function getFavorites() {
  try { return JSON.parse(localStorage.getItem('sa7ifa_favorites') || '[]'); } catch { return []; }
}
export function toggleFavorite(postId) {
  const favs = getFavorites();
  const idx = favs.indexOf(postId);
  if (idx > -1) { favs.splice(idx, 1); } else { favs.push(postId); }
  localStorage.setItem('sa7ifa_favorites', JSON.stringify(favs));
  return idx === -1; // returns true if added
}
export function isFavorite(postId) {
  return getFavorites().includes(postId);
}
export function getFavoritePosts() {
  return getFavorites();
}

/**
 * Render the site header with dynamic section navigation.
 */
export async function renderHeader() {
  // Dynamically load FontAwesome for authentic vintage icons
  if (!document.querySelector('link[href*="font-awesome"]')) {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css';
    document.head.appendChild(link);
  }

  let user = null;
  let sections = [];
  
  try {
    const data = await Promise.all([
      getCurrentUser().catch(() => null),
      getSections().catch(() => [])
    ]);
    user = data[0];
    sections = data[1] || [];
  } catch (err) {
    console.error("Header data fetch failed:", err.message);
  }

  const currentPage = window.location.pathname.split('/').pop() || 'index.html';

  const sectionLinks = sections.filter(s => s.slug !== 'home').map(s => {
    const href = `category.html?section=${s.slug}`;
    const isActive = currentPage === 'category.html' &&
      new URLSearchParams(window.location.search).get('section') === s.slug ? 'active' : '';
    return `<li><a href="${href}" class="${isActive}" data-section="${s.slug}">${s.name_ar}</a></li>`;
  }).join('');

  const isHome = (currentPage === 'index.html' || currentPage === '');

  let userActionsHTML;
  if (user) {
    const favCount = getFavorites().length;
    userActionsHTML = `
      <div class="user-menu">
        <div class="user-avatar-nav" id="userMenuToggle" title="${user.name}">${user.name.charAt(0)}</div>
        <div class="user-dropdown" id="userDropdown">
          <div class="dropdown-header">
            <strong>${user.name}</strong>
            <small>${user.email || ''}</small>
          </div>
          <a href="dashboard.html" class="dropdown-item">✏ لوحة التحكم</a>
          <a href="favorites.html" class="dropdown-item">♡ المفضلة ${favCount > 0 ? `<span class="fav-badge">${toArabicNumerals(favCount)}</span>` : ''}</a>
          ${user.role === 'admin' ? '<a href="dashboard.html#sections" class="dropdown-item">■ إدارة الأقسام</a>' : ''}
          <button class="dropdown-item logout-btn" id="logoutBtn">← تسجيل الخروج</button>
        </div>
      </div>
    `;
  } else {
    userActionsHTML = `
      <a href="login.html" class="btn btn-outline">دخول</a>
      <a href="login.html#signup" class="btn btn-primary">إنشاء حساب</a>
    `;
  }

  const today = formatArabicDateFull();
  const hijriDate = formatHijriDate();

  const headerHTML = `
    <header class="site-header" id="siteHeader">
      <div class="broadsheet-double-line" style="margin-top: 0.5rem;"></div>

      <!-- Broadsheet Parallel Line Navigation -->
      <nav class="main-nav-broadsheet">
        <div class="container main-nav-container" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
          <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="القائمة" style="display: none; flex-direction: column; gap: 5px; background: none; border: none; cursor: pointer; padding: 6px;">
            <span style="background: #2b2b2b; display: block; width: 24px; height: 2px; border-radius: 2px;"></span>
            <span style="background: #2b2b2b; display: block; width: 24px; height: 2px; border-radius: 2px;"></span>
            <span style="background: #2b2b2b; display: block; width: 24px; height: 2px; border-radius: 2px;"></span>
          </button>
          
          <ul class="nav-links-broadsheet" id="navLinks" style="display: flex; gap: 1.5rem; list-style: none; margin: 0; padding: 0; flex-grow: 1; justify-content: center;">
            <li><a href="index.html" ${isHome ? 'class="active"' : ''}>الرئيسية</a></li>
            ${sectionLinks}
            <li><a href="index.html?tools=true" id="navbarToolsBtn" style="display: flex; align-items: center; gap: 5px;"><i class="fa-solid fa-sliders"></i> أدوات</a></li>
            <li><a href="about.html" ${currentPage === 'about.html' ? 'class="active"' : ''}>عن الصحيفة</a></li>
          </ul>

          <div class="utility-actions" style="display: flex; gap: 1rem; align-items: center; margin-right: auto; margin-left: 0;">
            <form id="navSearchForm" style="display: flex; align-items: center; background: #FAF7F0; border: 1px solid #8B7E74; border-radius: 3px; padding: 2px 6px; font-family: 'Cairo', sans-serif; font-size: 0.75rem; direction: rtl; margin-left: 1rem;">
              <input type="text" id="navSearchInput" placeholder="بحث في المقالات..." style="border: none; background: none; outline: none; font-size: 0.75rem; font-family: inherit; color: #2B2B2B; width: 130px; padding: 0 4px;">
              <button type="submit" style="background: none; border: none; cursor: pointer; color: #8B7E74; padding: 0 4px; font-size: 0.8rem;"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
            ${userActionsHTML}
          </div>
        </div>
      </nav>

      <div class="broadsheet-double-line"></div>
    </header>

    <!-- Mobile Side Menu -->
    <div class="mobile-overlay" id="mobileOverlay"></div>
    <div class="mobile-menu" id="mobileMenu">
      <div class="mobile-menu-header">
        <h2 style="font-family: var(--font-serif); color: var(--paper); margin: 0;">الصحيفة</h2>
        <button class="mobile-close-btn" id="mobileCloseBtn">&times;</button>
      </div>
      <div style="padding: 1rem 1.5rem;">
        <form id="mobileNavSearchForm" style="display: flex; align-items: center; background: #FAF7F0; border: 1px solid #8B7E74; border-radius: 4px; padding: 6px 12px; font-family: 'Cairo', sans-serif; font-size: 0.85rem; direction: rtl; width: 100%; box-sizing: border-box;">
          <input type="text" id="mobileNavSearchInput" placeholder="بحث في المقالات..." style="border: none; background: none; outline: none; font-size: 0.85rem; font-family: inherit; color: #2B2B2B; width: 100%; padding: 0 4px;">
          <button type="submit" style="background: none; border: none; cursor: pointer; color: #8B7E74; padding: 0 4px; font-size: 0.95rem;"><i class="fa-solid fa-magnifying-glass"></i></button>
        </form>
      </div>
      <ul class="mobile-nav-links">
        <li><a href="index.html">الرئيسية</a></li>
        ${sections.filter(s => s.slug !== 'home').map(s => `<li><a href="category.html?section=${s.slug}">${s.name_ar}</a></li>`).join('')}
        <li><a href="index.html?tools=true" id="mobileNavbarToolsBtn" class="mobile-nav-tools-link" style="display: flex; align-items: center; gap: 8px;"><i class="fa-solid fa-sliders"></i> أدوات</a></li>
        <li><a href="about.html">عن الصحيفة</a></li>
      </ul>
      <div class="mobile-menu-footer">
        ${user
          ? `<a href="dashboard.html" class="btn btn-primary" style="width:100%">✏ لوحة التحكم</a>
             <button class="btn btn-outline logout-btn" style="width:100%;margin-top:0.5rem">تسجيل الخروج</button>`
          : `<a href="login.html" class="btn btn-primary" style="width:100%">تسجيل الدخول</a>`
        }
      </div>
    </div>
  `;

  document.body.insertAdjacentHTML('afterbegin', headerHTML);

  // ---- Sticky Shrink on Scroll ----
  const masthead = document.getElementById('mastheadMain');
  const header = document.getElementById('siteHeader');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 80) {
      header.classList.add('header--scrolled');
      if (masthead) masthead.classList.add('masthead--compact');
    } else {
      header.classList.remove('header--scrolled');
      if (masthead) masthead.classList.remove('masthead--compact');
    }
  }, { passive: true });

  // Mobile menu
  const mobileMenuBtn = document.getElementById('mobileMenuBtn');
  const mobileOverlay = document.getElementById('mobileOverlay');
  const mobileCloseBtn = document.getElementById('mobileCloseBtn');
  const mobileMenu = document.getElementById('mobileMenu');

  const openMobileMenu = () => {
    mobileMenu.classList.add('open');
    mobileOverlay.classList.add('open');
    document.body.style.overflow = 'hidden';
  };
  const closeMobileMenu = () => {
    mobileMenu.classList.remove('open');
    mobileOverlay.classList.remove('open');
    document.body.style.overflow = '';
  };

  mobileMenuBtn?.addEventListener('click', openMobileMenu);
  mobileOverlay?.addEventListener('click', closeMobileMenu);
  mobileCloseBtn?.addEventListener('click', closeMobileMenu);

  // User dropdown
  const userMenuToggle = document.getElementById('userMenuToggle');
  const userDropdown = document.getElementById('userDropdown');
  if (userMenuToggle && userDropdown) {
    userMenuToggle.addEventListener('click', (e) => {
      e.stopPropagation();
      userDropdown.classList.toggle('open');
    });
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.user-menu')) userDropdown.classList.remove('open');
    });
  }

  // Logout
  document.querySelectorAll('.logout-btn').forEach(btn => {
    btn.onclick = async (e) => {
      e.preventDefault();
      await signOut();
      window.location.href = 'index.html';
    };
  });

  // Tools toggle event listeners
  const toggleTools = (e) => {
    const isHomePage = window.location.pathname.endsWith('index.html') || 
                       window.location.pathname.endsWith('/') || 
                       window.location.pathname === '';
    
    if (isHomePage) {
      e.preventDefault();
      const ctrlBar = document.querySelector('.nws-ctrl-bar');
      if (ctrlBar) {
        ctrlBar.classList.toggle('open');
      }
      closeMobileMenu();
    }
  };

  document.getElementById('navbarToolsBtn')?.addEventListener('click', toggleTools);
  document.getElementById('mobileNavbarToolsBtn')?.addEventListener('click', toggleTools);

  // Search form submit handlers
  const handleSearchSubmit = (query) => {
    if (query) {
      window.location.href = `category.html?search=${encodeURIComponent(query)}`;
    }
  };

  document.getElementById('navSearchForm')?.addEventListener('submit', (e) => {
    e.preventDefault();
    const query = document.getElementById('navSearchInput').value.trim();
    handleSearchSubmit(query);
  });

  document.getElementById('mobileNavSearchForm')?.addEventListener('submit', (e) => {
    e.preventDefault();
    const query = document.getElementById('mobileNavSearchInput').value.trim();
    handleSearchSubmit(query);
  });
}

/**
 * Get neutral, newspaper-appropriate icon for a section slug
 */
function getNeutralIcon(slug) {
  const icons = {
    ideas: '◈',
    economy: '◉',
    politics: '◎',
    health: '✚',
    tech: '◆',
    default: '▸'
  };
  return icons[slug] || icons.default;
}

/**
 * Render the site footer with dynamic sections.
 */
export async function renderFooter() {
  let sections = [];
  try {
    sections = await getSections();
  } catch (err) {
    console.warn("Footer data fetch failed:", err.message);
  }

  const footerHTML = `
    <footer>
      <div class="footer-rule"></div>
      <div class="container footer-content">
        <div class="footer-grid">
          <div class="footer-col footer-brand">
            <div class="footer-logo">
              <img src="LOGO.png" alt="الصحيفة" class="footer-logo-img" style="height: 40px; object-fit: contain;">
            </div>
            <p class="footer-tagline">منصة عربية مستقلة تُعنى بالتحليل الفكري والاقتصادي والاجتماعي.</p>
          </div>
          <div class="footer-col">
            <h4>الأقسام</h4>
            <ul>
              ${sections.filter(s => s.slug !== 'home').map(s => `<li><a href="category.html?section=${s.slug}">${s.name_ar}</a></li>`).join('')}
            </ul>
          </div>
          <div class="footer-col">
            <h4>الصحيفة</h4>
            <ul>
              <li><a href="about.html">عن الصحيفة</a></li>
              <li><a href="dashboard.html">كتابة مقال</a></li>
              <li><a href="login.html">تسجيل الدخول</a></li>
            </ul>
          </div>
        </div>
        <div class="footer-bottom">
          <div class="footer-bottom-rule"></div>
          <p>© ${toArabicNumerals(new Date().getFullYear())} الصحيفة — جميع الحقوق محفوظة</p>
        </div>
      </div>
    </footer>
  `;

  document.body.insertAdjacentHTML('beforeend', footerHTML);
}

/**
 * Render a post card in the classic editorial newspaper style.
 * Section posts use float-image (newspaper inline) style.
 */
export function renderPostCard(post, variant = 'default') {
  const section = post.sections;
  const sectionName = section?.name_ar || 'عام';
  const sectionSlug = section?.slug || '';
  const sectionColor = section?.color || '#1a1a1a';
  const rtime = readingTime(post.content);
  const dateStr = formatArabicDate(post.published_at || post.created_at);
  const initial = post.author_name ? post.author_name.charAt(0) : '؟';
  const img = post.featured_image_url || 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80';
  const views = toArabicNumerals(getViewCount(post.id));

  if (variant === 'featured') {
    return `
      <article class="post-card post-card--featured">
        <a href="article.html?id=${post.id}" class="post-card__img-link">
          <div class="post-card__img-wrap">
            <img src="${img}" alt="${post.title}" loading="lazy">
            <div class="post-card__img-overlay"></div>
            <span class="post-card__section" style="background:${sectionColor}">${sectionName}</span>
          </div>
          <span class="post-card__image-caption">تصوير الأرشيف الصحفي • لقطة متعلقة بالخبر الرئيسي</span>
        </a>
        <div class="post-card__body">
          <h2 class="post-card__title post-card__title--lg">
            <a href="article.html?id=${post.id}">${post.title}</a>
          </h2>
          <p class="post-card__excerpt">${post.excerpt}</p>
          <div class="post-card__meta">
            <span class="post-card__author">${initial} ${post.author_name}</span>
            <span class="post-card__sep">·</span>
            <time>${dateStr}</time>
            <span class="post-card__sep">·</span>
            <span>${toArabicNumerals(rtime)} د قراءة</span>
            <span class="post-card__sep">·</span>
            <span class="view-count" title="عدد المشاهدات">◎ ${views}</span>
          </div>
        </div>
      </article>
    `;
  }

  // Newspaper inline-image style for section cards
  return `
    <article class="post-card post-card--newspaper">
      <div class="post-card__newspaper-inner">
        <a href="article.html?id=${post.id}" class="post-card__newspaper-img">
          <img src="${img}" alt="${post.title}" loading="lazy">
          <span class="post-card__image-caption">الأرشيف • ${sectionName}</span>
        </a>
        <div class="post-card__body">
          <span class="post-card__section" style="color:${sectionColor}; font-size:0.75rem; font-weight:700; display:block; margin-bottom:0.3rem;">${sectionName}</span>
          <h3 class="post-card__title">
            <a href="article.html?id=${post.id}">${post.title}</a>
          </h3>
          <p class="post-card__excerpt post-card__excerpt--sm">${post.excerpt}</p>
          <div class="post-card__meta">
            <time>${dateStr}</time>
            <span class="post-card__sep">·</span>
            <span>${toArabicNumerals(rtime)} د</span>
            <span class="post-card__sep">·</span>
            <span class="view-count">◎ ${views}</span>
          </div>
        </div>
      </div>
    </article>
  `;
}

/**
 * Render a compact list-style post row.
 */
export function renderPostRow(post) {
  const section = post.sections;
  const sectionName = section?.name_ar || '';
  const sectionColor = section?.color || '#1a1a1a';
  const dateStr = formatArabicDate(post.published_at || post.created_at);
  const img = post.featured_image_url;

  return `
    <div class="post-row">
      <a href="article.html?id=${post.id}" class="post-row__img-link">
        <img src="${img}" alt="${post.title}" loading="lazy">
      </a>
      <div class="post-row__body">
        <span class="post-row__section" style="color:${sectionColor}">${sectionName}</span>
        <h4 class="post-row__title"><a href="article.html?id=${post.id}">${post.title}</a></h4>
        <time class="post-row__date">${dateStr}</time>
      </div>
    </div>
  `;
}

/**
 * Share article on Facebook.
 */
export function shareOnFacebook(url, title) {
  const fbUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}&t=${encodeURIComponent(title)}`;
  window.open(fbUrl, '_blank', 'width=600,height=450,scrollbars=yes');
}

/**
 * Show a toast notification.
 */
export function showToast(msg, type = 'success') {
  const existing = document.getElementById('fikr-toast');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.id = 'fikr-toast';
  toast.className = `fikr-toast fikr-toast--${type}`;
  toast.textContent = msg;
  document.body.appendChild(toast);
  setTimeout(() => toast.classList.add('fikr-toast--show'), 10);
  setTimeout(() => { toast.classList.remove('fikr-toast--show'); setTimeout(() => toast.remove(), 400); }, 3500);
}

export { formatArabicDate, formatArabicDateFull, toArabicNumerals };
