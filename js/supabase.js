// ============================================================
// supabase.js — Offline LocalStorage-based Supabase Mock Client
// Resolves DNS/connection issues by running fully in-browser.
// ============================================================

const SECTIONS_SEED = [
  {
    id: "s1",
    name_ar: "فكر",
    name_en: "Ideas",
    slug: "ideas",
    description: "حوارات فكرية وفلسفية وتحليلات معمقة للأفكار والتحولات الثقافية",
    icon: "💡",
    color: "#8e44ad",
    display_order: 1,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  },
  {
    id: "s2",
    name_ar: "اقتصاد",
    name_en: "Economy",
    slug: "economy",
    description: "تقارير وتحليلات مالية واقتصادية تغطي العالم العربي والأسواق الدولية",
    icon: "📊",
    color: "#2c3e50",
    display_order: 2,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  },
  {
    id: "s3",
    name_ar: "سياسة",
    name_en: "Politics",
    slug: "politics",
    description: "تحليلات سياسية معمقة وتغطية للشؤون الدولية والعربية",
    icon: "🏛️",
    color: "#c0392b",
    display_order: 3,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  },
  {
    id: "s4",
    name_ar: "صحة",
    name_en: "Health",
    slug: "health",
    description: "أخبار وإرشادات طبية وصحية لسلامة الفرد والمجتمع",
    icon: "🩺",
    color: "#27ae60",
    display_order: 4,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  },
  {
    id: "s5",
    name_ar: "تكنولوجيا",
    name_en: "Technology",
    slug: "tech",
    description: "تغطية شاملة للثورة الرقمية وتأثير التقنيات الناشئة على الإنسان والمجتمع",
    icon: "💻",
    color: "#2980b9",
    display_order: 5,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  }
];

const POSTS_SEED = [
  {
    id: "p1",
    title: "بنية العقل العربي المعاصر: قراءة في فكر محمد عابد الجابري",
    slug: "structure-of-arab-reason-jabri",
    excerpt: "تحليل نقدي لإسهامات الفيلسوف المغربي محمد عابد الجابري في نقد وتفكيك العقل العربي ومصادره المعرفية.",
    content: "<p><span class=\"lettrine\">يعد</span> محمد عابد الجابري من أبرز الفلاسفة العرب المعاصرين الذين قاربوا مسألة التراث والحداثة بمشرط النقد المعرفي. في مشروعه الضخم \"نقد العقل العربي\"، سعى الجابري إلى تتبع النظم المعرفية التي حكمت الثقافة العربية وحصرها في ثلاثة نظم رئيسية: البيان، والعرفان، والبرهان. ويرى الجابري أن تجديد الفكر العربي المعاصر لا يمكن أن يتم عبر القطيعة التامة مع التراث، بل من خلال إعادة قراءته ونقده من الداخل لاستئناف العقلانية البرهانية التي تمثلت قديماً في الرشدية الأندلسية.</p>",
    section_id: "s1",
    featured_image_url: "https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=1200&q=80",
    author_id: "00000000-0000-0000-0000-000000000000",
    author_name: "رئيس التحرير",
    status: "published",
    is_featured: true,
    published_at: new Date().toISOString(),
    created_at: new Date().toISOString()
  },
  {
    id: "p2",
    title: "آفاق التكامل الاقتصادي العربي في ظل التحولات الجيوسياسية الراهنة",
    slug: "future-of-arab-economic-integration",
    excerpt: "دراسة تحليلية حول فرص التبادل التجاري وتحديات سلاسل التوريد في المنطقة العربية في ظل تغيرات القوى الدولية.",
    content: "<p><span class=\"lettrine\">تواجه</span> المنطقة العربية تحديات اقتصادية غير مسبوقة تفرض ضرورة إعادة النظر في آليات التكامل الاقتصادي الإقليمي. لم تعد الاتفاقيات التقليدية كافية لمواجهة تقلبات سلاسل التوريد العالمية وأزمات الطاقة والغذاء المتلاحقة. يتطلب المستقبل تعزيز الشراكات في مجالات الطاقة المتجددة، وتسهيل التدفق الحر لرؤوس الأموال، وتحديث البنية التحتية اللوجستية التي تربط المشرق بالمغرب العربي، مع التركيز على بناء قواعد صناعية إقليمية متكاملة.</p>",
    section_id: "s2",
    featured_image_url: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=1200&q=80",
    author_id: "00000000-0000-0000-0000-000000000000",
    author_name: "رئيس التحرير",
    status: "published",
    is_featured: false,
    published_at: new Date(Date.now() - 24*3600*1000).toISOString(),
    created_at: new Date(Date.now() - 24*3600*1000).toISOString()
  },
  {
    id: "p3",
    title: "السياسة الدولية في مهب الريح: تشكل موازين قوى جديدة",
    slug: "international-politics-new-powers",
    excerpt: "تحليل للتغيرات المتسارعة في السياسة العالمية وصعود الأقطاب المتعددة وتأثير ذلك على استقرار الشرق الأوسط.",
    content: "<p><span class=\"lettrine\">تشهد</span> الساحة الدولية تحولات بنيوية متسارعة تعيد صياغة النظام العالمي الذي ساد منذ عقود. إن صعود قوى اقتصادية وعسكرية جديدة وتنامي التحالفات الإقليمية ينبئ بولادة نظام متعدد الأقطاب أكثر تعقيداً. وفي هذا السياق، تواجه دول الشرق الأوسط تحديات وفرصاً تتطلب سياسات خارجية مرنة ترتكز على التوازن الإستراتيجي وحماية المصالح القومية والتنموية.</p>",
    section_id: "s3",
    featured_image_url: "https://images.unsplash.com/photo-1541872703-74c5e44368f9?w=1200&q=80",
    author_id: "00000000-0000-0000-0000-000000000000",
    author_name: "رئيس التحرير",
    status: "published",
    is_featured: false,
    published_at: new Date(Date.now() - 2 * 24*3600*1000).toISOString(),
    created_at: new Date(Date.now() - 2 * 24*3600*1000).toISOString()
  },
  {
    id: "p4",
    title: "الرعاية الصحية الأولية: حجر الأساس لمستقبل طبي مستدام",
    slug: "primary-healthcare-sustainable-future",
    excerpt: "تقرير شامل عن دور الطب الوقائي وأهمية الاستثمار في المراكز الطبية المحلية للحد من انتشار الأمراض المزمنة.",
    content: "<p><span class=\"lettrine\">تمثل</span> الرعاية الصحية الأولية اللبنة الأساسية في بناء نظام صحي عادل ومستدام. تشير الدراسات الطبية إلى أن التركيز على الطب الوقائي والفحص المبكر للأمراض المزمنة يسهم بشكل مباشر في خفض تكاليف العلاج وتحسين جودة حياة المواطنين. إن تطوير المراكز الطبية المحلية وتأهيل الكوادر البشرية في مجالات الرعاية الصحية يعد استثماراً وطنياً لا غنى عنه.</p>",
    section_id: "s4",
    featured_image_url: "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=1200&q=80",
    author_id: "00000000-0000-0000-0000-000000000000",
    author_name: "رئيس التحرير",
    status: "published",
    is_featured: false,
    published_at: new Date(Date.now() - 3 * 24*3600*1000).toISOString(),
    created_at: new Date(Date.now() - 3 * 24*3600*1000).toISOString()
  },
  {
    id: "p5",
    title: "الذكاء الاصطناعي التوليدي: هل نحن أمام ثورة معرفية جديدة؟",
    slug: "ethics-of-ai-arab-digital-space",
    excerpt: "تساؤلات فلسفية وتقنية حول حدود الذكاء الاصطناعي، والمسؤولية الأخلاقية للأنظمة الذكية، وتأثيرها على الهوية المجتمعية.",
    content: "<p><span class=\"lettrine\">لم</span> يعد الذكاء الاصطناعي مجرد تقنية جديدة، بل أصبح قوة فاعلة تشكل معالم وجودنا الإنساني والرقمي. وفي حين تتسابق المؤسسات العربية لتبني حلول الذكاء الاصطناعي لزيادة الكفاءة، تبرز قضايا أخلاقية بالغة التعقيد حول الخصوصية، والتحيز الخوارزمي، وحماية الهوية الثقافية. يتطلب هذا التحول الرقمي بناء أطر أخلاقية تتوافق مع القيم والمبادئ للتعامل مع تحديات الذكاء التوليدي والتشغيل الذاتي.</p>",
    section_id: "s5",
    featured_image_url: "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=1200&q=80",
    author_id: "00000000-0000-0000-0000-000000000000",
    author_name: "رئيس التحرير",
    status: "published",
    is_featured: false,
    published_at: new Date(Date.now() - 4 * 24*3600*1000).toISOString(),
    created_at: new Date(Date.now() - 4 * 24*3600*1000).toISOString()
  }
];

const SETTINGS_SEED = [
  {
    id: 1,
    site_name: "الصحيفة",
    default_post_image_url: "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=1200&q=80"
  }
];

const MOCK_SESSION_KEY = 'sa7ifa_mock_session';

class SupabaseQueryBuilder {
  constructor(table) {
    this.table = table;
    this.filters = [];
    this.orders = [];
    this.limitVal = null;
    this.selectFields = '*';
    this.isSingle = false;
    this.isMaybeSingle = false;
    this.isInsert = false;
    this.isUpdate = false;
    this.isDelete = false;
    this.payload = null;
  }

  select(fields = '*') {
    this.selectFields = fields;
    return this;
  }

  insert(data) {
    this.isInsert = true;
    this.payload = data;
    return this;
  }

  update(data) {
    this.isUpdate = true;
    this.payload = data;
    return this;
  }

  delete() {
    this.isDelete = true;
    return this;
  }

  eq(field, val) {
    this.filters.push({ type: 'eq', field, val });
    return this;
  }

  order(field, options = {}) {
    this.orders.push({ field, options });
    return this;
  }

  limit(val) {
    this.limitVal = val;
    return this;
  }

  single() {
    this.isSingle = true;
    return this;
  }

  maybeSingle() {
    this.isMaybeSingle = true;
    return this;
  }

  async then(onfulfilled, onrejected) {
    try {
      const result = await this.execute();
      return onfulfilled(result);
    } catch (err) {
      if (onrejected) return onrejected(err);
      throw err;
    }
  }

  async execute() {
    let data = JSON.parse(localStorage.getItem(`sa7ifa_db_${this.table}`));
    
    // Seed initial data if table is null or empty
    if (!data || data.length === 0) {
      if (this.table === 'sections') {
        data = SECTIONS_SEED;
        localStorage.setItem(`sa7ifa_db_${this.table}`, JSON.stringify(data));
      } else if (this.table === 'posts' || this.table === 'articles') {
        data = POSTS_SEED;
        localStorage.setItem(`sa7ifa_db_${this.table}`, JSON.stringify(data));
      } else if (this.table === 'site_settings') {
        data = SETTINGS_SEED;
        localStorage.setItem(`sa7ifa_db_${this.table}`, JSON.stringify(data));
      } else {
        data = [];
      }
    }

    if (this.isInsert) {
      const newItems = Array.isArray(this.payload) ? this.payload : [this.payload];
      newItems.forEach(item => {
        if (!item.id) {
          item.id = crypto.randomUUID ? crypto.randomUUID() : 'id_' + Math.random().toString(36).substr(2, 9);
        }
        if (!item.created_at) {
          item.created_at = new Date().toISOString();
        }
        data.push(item);
      });
      localStorage.setItem(`sa7ifa_db_${this.table}`, JSON.stringify(data));
      return { data: newItems, error: null };
    }

    if (this.isUpdate) {
      data = data.map(item => {
        let match = true;
        this.filters.forEach(f => {
          if (f.type === 'eq' && item[f.field] !== f.val) {
            match = false;
          }
        });
        if (match) {
          return { ...item, ...this.payload, updated_at: new Date().toISOString() };
        }
        return item;
      });
      localStorage.setItem(`sa7ifa_db_${this.table}`, JSON.stringify(data));
      const updated = data.filter(item => {
        let match = true;
        this.filters.forEach(f => {
          if (f.type === 'eq' && item[f.field] !== f.val) {
            match = false;
          }
        });
        return match;
      });
      return { data: updated, error: null };
    }

    if (this.isDelete) {
      data = data.filter(item => {
        let match = true;
        this.filters.forEach(f => {
          if (f.type === 'eq' && item[f.field] === f.val) {
            match = false;
          }
        });
        return match;
      });
      localStorage.setItem(`sa7ifa_db_${this.table}`, JSON.stringify(data));
      return { data: null, error: null };
    }

    // SELECT
    let result = [...data];

    // Apply filters
    this.filters.forEach(f => {
      if (f.type === 'eq') {
        if (f.field === 'sections.slug') {
          const sections = JSON.parse(localStorage.getItem('sa7ifa_db_sections')) || SECTIONS_SEED;
          result = result.filter(item => {
            const sec = sections.find(s => s.id === item.section_id);
            return sec && sec.slug === f.val;
          });
        } else if (f.field === 'article_id' || f.field === 'post_id') {
          result = result.filter(item => item.article_id === f.val || item.post_id === f.val);
        } else {
          result = result.filter(item => item[f.field] === f.val);
        }
      }
    });

    // Apply sorting
    this.orders.forEach(o => {
      const field = o.field;
      const asc = o.options.ascending !== false;
      result.sort((a, b) => {
        let valA = a[field];
        let valB = b[field];
        if (valA === undefined || valA === null) return asc ? -1 : 1;
        if (valB === undefined || valB === null) return asc ? 1 : -1;
        
        if (typeof valA === 'string') {
          return asc ? valA.localeCompare(valB) : valB.localeCompare(valA);
        }
        return asc ? (valA - valB) : (valB - valA);
      });
    });

    // Relations: join with section
    if (this.table === 'posts' || this.table === 'articles') {
      const sections = JSON.parse(localStorage.getItem('sa7ifa_db_sections')) || SECTIONS_SEED;
      result = result.map(item => {
        const sec = sections.find(s => s.id === item.section_id);
        return {
          ...item,
          sections: sec || null
        };
      });
    }

    // Limit
    if (this.limitVal !== null) {
      result = result.slice(0, this.limitVal);
    }

    if (this.isSingle || this.isMaybeSingle) {
      if (result.length === 0) {
        return { data: null, error: this.isSingle ? new Error('Row not found') : null };
      }
      return { data: result[0], error: null };
    }

    return { data: result, error: null };
  }
}

const mockAuth = {
  async signUp({ email, password, options }) {
    const users = JSON.parse(localStorage.getItem('sa7ifa_users')) || [];
    if (users.some(u => u.email === email)) {
      return { data: { user: null }, error: new Error('User already exists') };
    }
    const name = options?.data?.full_name || 'مستخدم جديد';
    const user = {
      id: crypto.randomUUID ? crypto.randomUUID() : 'usr_' + Math.random().toString(36).substr(2, 9),
      email,
      user_metadata: { full_name: name },
      role: email === 'developper47@gmail.com' ? 'admin' : 'user'
    };
    users.push({ ...user, password });
    localStorage.setItem('sa7ifa_users', JSON.stringify(users));

    // Create profile
    const profiles = JSON.parse(localStorage.getItem('sa7ifa_db_profiles')) || [];
    profiles.push({
      id: user.id,
      name: name,
      email: email,
      role: user.role,
      created_at: new Date().toISOString()
    });
    localStorage.setItem('sa7ifa_db_profiles', JSON.stringify(profiles));

    localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(user));
    return { data: { user }, error: null };
  },

  async signInWithPassword({ email, password }) {
    if (email === 'developper47@gmail.com' && password === 'admin123') {
      const mockAdmin = {
        id: '00000000-0000-0000-0000-000000000000',
        email: 'developper47@gmail.com',
        user_metadata: { full_name: 'رئيس التحرير' },
        role: 'admin'
      };
      localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(mockAdmin));
      return { data: { user: mockAdmin }, error: null };
    }

    const users = JSON.parse(localStorage.getItem('sa7ifa_users')) || [];
    const found = users.find(u => u.email === email && u.password === password);
    if (!found) {
      return { data: { user: null }, error: new Error('خطأ في البريد الإلكتروني أو كلمة المرور') };
    }
    localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(found));
    return { data: { user: found }, error: null };
  },

  async signOut() {
    localStorage.removeItem(MOCK_SESSION_KEY);
    return { error: null };
  },

  async getUser() {
    const session = localStorage.getItem(MOCK_SESSION_KEY);
    if (!session) return { data: { user: null }, error: null };
    return { data: { user: JSON.parse(session) }, error: null };
  },

  async resetPasswordForEmail(email, options) {
    console.log(`Password reset link simulated for ${email}`);
    return { data: {}, error: null };
  },

  async updateUser({ password, data }) {
    const session = localStorage.getItem(MOCK_SESSION_KEY);
    if (!session) return { data: { user: null }, error: new Error('No active session') };
    const user = JSON.parse(session);
    if (data?.full_name) {
      user.user_metadata = { ...user.user_metadata, full_name: data.full_name };
      
      const users = JSON.parse(localStorage.getItem('sa7ifa_users')) || [];
      const idx = users.findIndex(u => u.id === user.id);
      if (idx !== -1) {
        users[idx].user_metadata = user.user_metadata;
        if (password) users[idx].password = password;
        localStorage.setItem('sa7ifa_users', JSON.stringify(users));
      }
      
      const profiles = JSON.parse(localStorage.getItem('sa7ifa_db_profiles')) || [];
      const pIdx = profiles.findIndex(p => p.id === user.id);
      if (pIdx !== -1) {
        profiles[pIdx].name = data.full_name;
        localStorage.setItem('sa7ifa_db_profiles', JSON.stringify(profiles));
      }
      localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(user));
    }
    return { data: { user }, error: null };
  }
};

export const supabase = {
  auth: mockAuth,
  from(table) {
    return new SupabaseQueryBuilder(table);
  }
};
