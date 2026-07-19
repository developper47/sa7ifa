// ============================================================
// main.js — Shared layout: header, footer, article cards
// Updated for the new editorial design with dynamic sections
// ============================================================

import { getCurrentUser, signOut } from './auth.js?v=3.1';
import { getSections } from './sections.js?v=3.1';
import { readingTime } from './posts.js?v=3.1';

// ---- Utility: Eastern Arabic numerals ----
function toArabicNumerals(str) {
  return String(str).replace(/[0-9]/g, d => '٠١٢٣٤٥٦٧٨٩'[d]);
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
    return result.trim() + ' هـ';
  } catch (e) {
    return '٢٤ محرم ١٤٤٨ هـ';
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

  const sectionLinks = sections.map(s => {
    const href = `category.html?section=${s.slug}`;
    const isActive = currentPage === 'category.html' &&
      new URLSearchParams(window.location.search).get('section') === s.slug ? 'active' : '';
    // Use neutral, non-AI icons
    const neutralIcon = getNeutralIcon(s.slug);
    return `<li><a href="${href}" class="${isActive}" data-section="${s.slug}">${neutralIcon} ${s.name_ar}</a></li>`;
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
      <!-- Utility bar at top for auth buttons -->
      <div class="utility-top-bar">
        <div class="container utility-inner">
          <div class="utility-actions">
            ${userActionsHTML}
          </div>
        </div>
      </div>

      <!-- Main majestic broadsheet masthead -->
      <div class="masthead-main" id="mastheadMain">
        <div class="container masthead-grid">
          <!-- Right Column Metadata -->
          <div class="masthead-meta-box masthead-meta-box--right">
            <div class="meta-item">مرحبا بك</div>
            <div class="meta-item">جريدة مستقلة للفكر الحر</div>
            <div class="meta-item">تأسست عام ${toArabicNumerals(2026)} م</div>
          </div>

          <!-- Center Logo -->
          <a href="index.html" class="masthead-logo-container">
            <h1 class="broadsheet-logo-title">الصحيفة</h1>
            <span class="logo-subtitle">منبر الكلمة الحرة والفكر المستنير</span>
          </a>

          <!-- Left Column Metadata -->
          <div class="masthead-meta-box masthead-meta-box--left">
            <div class="meta-item">${today}</div>
            <div class="meta-item">${hijriDate}</div>
            <div class="meta-item">العدد الأول • إصدار تجريبي</div>
          </div>
        </div>
      </div>

      <div class="broadsheet-double-line"></div>

      <!-- Broadsheet Parallel Line Navigation -->
      <nav class="main-nav-broadsheet">
        <div class="container">
          <ul class="nav-links-broadsheet" id="navLinks">
            <li><a href="index.html" ${isHome ? 'class="active"' : ''}>الرئيسية</a></li>
            ${sectionLinks}
            <li><a href="about.html" ${currentPage === 'about.html' ? 'class="active"' : ''}>عن الصحيفة</a></li>
          </ul>
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
      <ul class="mobile-nav-links">
        <li><a href="index.html">الرئيسية</a></li>
        ${sections.map(s => `<li><a href="category.html?section=${s.slug}">${getNeutralIcon(s.slug)} ${s.name_ar}</a></li>`).join('')}
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
      masthead.classList.add('masthead--compact');
    } else {
      header.classList.remove('header--scrolled');
      masthead.classList.remove('masthead--compact');
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
              <span style="font-family: var(--font-serif); font-size: 2rem; color: var(--paper);">الصحيفة</span>
            </div>
            <p class="footer-tagline">منصة عربية مستقلة تُعنى بالتحليل الفكري والاقتصادي والاجتماعي.</p>
          </div>
          <div class="footer-col">
            <h4>الأقسام</h4>
            <ul>
              ${sections.map(s => `<li><a href="category.html?section=${s.slug}">${s.name_ar}</a></li>`).join('')}
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
