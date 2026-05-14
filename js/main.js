// ============================================================
// main.js — Shared layout: header, footer, article cards
// Updated for the new editorial design with dynamic sections
// ============================================================

import { getCurrentUser, signOut } from './auth.js';
import { getSections } from './sections.js';
import { readingTime } from './posts.js';

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
    return `<li><a href="${href}" class="${isActive}" data-section="${s.slug}">${s.icon || ''} ${s.name_ar}</a></li>`;
  }).join('');

  const isHome = (currentPage === 'index.html' || currentPage === '');

  let userActionsHTML;
  if (user) {
    userActionsHTML = `
      <div class="user-menu">
        <div class="user-avatar-nav" id="userMenuToggle" title="${user.name}">${user.name.charAt(0)}</div>
        <div class="user-dropdown" id="userDropdown">
          <div class="dropdown-header">
            <strong>${user.name}</strong>
            <small>${user.email || ''}</small>
          </div>
          <a href="dashboard.html" class="dropdown-item">✏️ لوحة التحكم</a>
          ${user.role === 'admin' ? '<a href="dashboard.html#sections" class="dropdown-item">🛡️ إدارة الأقسام</a>' : ''}
          <button class="dropdown-item logout-btn" id="logoutBtn">🚪 تسجيل الخروج</button>
        </div>
      </div>
    `;
  } else {
    userActionsHTML = `
      <a href="login.html" class="btn btn-outline">دخول</a>
      <a href="login.html#signup" class="btn btn-primary">إنشاء حساب</a>
    `;
  }

  const today = new Date().toLocaleDateString('ar-EG', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

  const headerHTML = `
    <header class="site-header">
      <div class="masthead-top">
        <div class="container masthead-inner">
          <div class="masthead-date">${today}</div>
          <a href="index.html" class="masthead-logo">
            <span class="logo-main">فِكر</span>
            <span class="logo-sub">مجلة عربية مستقلة</span>
          </a>
          <div class="masthead-actions">
            ${userActionsHTML}
          </div>
        </div>
      </div>
      <nav class="main-nav">
        <div class="container">
          <ul class="nav-links" id="navLinks">
            <li><a href="index.html" ${isHome ? 'class="active"' : ''}>الرئيسية</a></li>
            ${sectionLinks}
            <li><a href="about.html" ${currentPage === 'about.html' ? 'class="active"' : ''}>عن المجلة</a></li>
          </ul>
          <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="القائمة">
            <span></span><span></span><span></span>
          </button>
        </div>
      </nav>
    </header>

    <!-- Mobile Side Menu -->
    <div class="mobile-overlay" id="mobileOverlay"></div>
    <div class="mobile-menu" id="mobileMenu">
      <div class="mobile-menu-header">
        <span class="logo-main">فِكر</span>
        <button class="mobile-close-btn" id="mobileCloseBtn">&times;</button>
      </div>
      <ul class="mobile-nav-links">
        <li><a href="index.html">الرئيسية</a></li>
        ${sections.map(s => `<li><a href="category.html?section=${s.slug}">${s.icon || ''} ${s.name_ar}</a></li>`).join('')}
        <li><a href="about.html">عن المجلة</a></li>
      </ul>
      <div class="mobile-menu-footer">
        ${user
          ? `<a href="dashboard.html" class="btn btn-primary" style="width:100%">✏️ لوحة التحكم</a>
             <button class="btn btn-outline logout-btn" style="width:100%;margin-top:0.5rem">تسجيل الخروج</button>`
          : `<a href="login.html" class="btn btn-primary" style="width:100%">تسجيل الدخول</a>`
        }
      </div>
    </div>
  `;

  document.body.insertAdjacentHTML('afterbegin', headerHTML);

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
            <h3 class="footer-logo">فِكر</h3>
            <p class="footer-tagline">منصة عربية مستقلة تُعنى بالتحليل الفكري والاقتصادي والاجتماعي.</p>
          </div>
          <div class="footer-col">
            <h4>الأقسام</h4>
            <ul>
              ${sections.map(s => `<li><a href="category.html?section=${s.slug}">${s.name_ar}</a></li>`).join('')}
            </ul>
          </div>
          <div class="footer-col">
            <h4>المجلة</h4>
            <ul>
              <li><a href="about.html">عن المجلة</a></li>
              <li><a href="dashboard.html">كتابة مقال</a></li>
              <li><a href="login.html">تسجيل الدخول</a></li>
            </ul>
          </div>
        </div>
        <div class="footer-bottom">
          <div class="footer-bottom-rule"></div>
          <p>© ${new Date().getFullYear()} مجلة فِكر — جميع الحقوق محفوظة</p>
        </div>
      </div>
    </footer>
  `;

  document.body.insertAdjacentHTML('beforeend', footerHTML);
}

/**
 * Render a post card in the classic editorial newspaper style.
 */
export function renderPostCard(post, variant = 'default') {
  const section = post.sections;
  const sectionName = section?.name_ar || 'عام';
  const sectionSlug = section?.slug || '';
  const sectionColor = section?.color || '#1a1a1a';
  const rtime = readingTime(post.content);
  const dateStr = formatDateShort(post.published_at || post.created_at);
  const initial = post.author_name ? post.author_name.charAt(0) : '؟';
  const img = post.featured_image_url || 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80';

  if (variant === 'featured') {
    return `
      <article class="post-card post-card--featured">
        <a href="article.html?id=${post.id}" class="post-card__img-link">
          <div class="post-card__img-wrap">
            <img src="${img}" alt="${post.title}" loading="lazy">
            <div class="post-card__img-overlay"></div>
            <span class="post-card__section" style="background:${sectionColor}">${sectionName}</span>
          </div>
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
            <span>${rtime} د قراءة</span>
          </div>
        </div>
      </article>
    `;
  }

  return `
    <article class="post-card">
      <a href="article.html?id=${post.id}" class="post-card__img-link">
        <div class="post-card__img-wrap">
          <img src="${img}" alt="${post.title}" loading="lazy">
          <span class="post-card__section" style="background:${sectionColor}">${sectionName}</span>
        </div>
      </a>
      <div class="post-card__body">
        <h3 class="post-card__title">
          <a href="article.html?id=${post.id}">${post.title}</a>
        </h3>
        <p class="post-card__excerpt">${post.excerpt}</p>
        <div class="post-card__meta">
          <time>${dateStr}</time>
          <span class="post-card__sep">·</span>
          <span>${rtime} د</span>
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
  const dateStr = formatDateShort(post.published_at || post.created_at);
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

function formatDateShort(dateString) {
  if (!dateString) return '';
  return new Date(dateString).toLocaleDateString('ar-EG', { day: 'numeric', month: 'long', year: 'numeric' });
}
