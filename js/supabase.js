// ============================================================
// supabase.js — Offline LocalStorage-based Supabase Mock Client
// Resolves DNS/connection issues by running fully in-browser.
// ============================================================

import { SUPABASE_URL as configUrl, SUPABASE_ANON_KEY as configKey } from './config.js?v=3.5';

const localUrl = localStorage.getItem('sa7ifa_supabase_url') || '';
const localKey = localStorage.getItem('sa7ifa_supabase_key') || '';

const supabaseUrl = configUrl || localUrl;
const supabaseKey = configKey || localKey;

let supabaseClient = null;

if (supabaseUrl && supabaseKey) {
  try {
    if (window.supabase) {
      supabaseClient = window.supabase.createClient(supabaseUrl, supabaseKey);
    } else {
      const module = await import('https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm');
      supabaseClient = module.createClient(supabaseUrl, supabaseKey);
    }
    console.log("Using real Supabase database:", supabaseUrl);
  } catch (err) {
    console.error("Failed to initialize real Supabase client:", err);
  }
}

const SECTIONS_SEED = [
  {
    id: "home",
    name_ar: "الصفحة الرئيسية",
    name_en: "Home",
    slug: "home",
    description: "الصفحة الرئيسية للجريدة",
    icon: "📰",
    color: "#8b1a1a",
    display_order: 0,
    is_active: true,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  },
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
  },
  // ── فكر ──────────────────────────────────────────────
  { id:"p6", title:"الثقافة العربية في مواجهة العولمة: هوية أم انفتاح؟", slug:"arabic-culture-globalization", excerpt:"تستوقفنا مسألة الهوية الثقافية العربية في خضم موجات العولمة المتلاحقة التي تعيد تشكيل الوعي الجمعي.", content:"<p>يعيش العالم العربي تحولات جذرية في بنيته الثقافية، بين من يرى في الانفتاح فرصة لإثراء الهوية وتحديثها دون المساس بجوهرها، وبين من يحذر من الذوبان الثقافي وضياع الخصوصية الحضارية. تبقى المعادلة صعبة تستدعي تفكيراً هادئاً ورصيناً بعيداً عن الانفعال والإقصاء.</p>", section_id:"s1", featured_image_url:"https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"د. ليلى مصطفى", status:"published", is_featured:false, published_at:new Date(Date.now()-5*86400000).toISOString(), created_at:new Date(Date.now()-5*86400000).toISOString() },
  { id:"p7", title:"النقد الأدبي العربي بين المنهج الغربي والأصالة", slug:"arabic-literary-criticism", excerpt:"هل يمكن للنقد الأدبي أن ينهل من المناهج الغربية دون أن يُغرّب النص العربي ويُجرّده من روحه؟ إشكالية تشغل الدراسات الأدبية.", content:"<p>شكّل مفهوم المنهج النقدي إشكالية مركزية في الدراسات الأدبية العربية الحديثة. فمنذ انفتح النقد العربي على المدارس الغربية كالبنيوية والتفكيكية وما بعد الاستعمارية، بات السؤال قائماً: أين تقع الهوية النقدية العربية في هذا الزخم من المناهج الوافدة؟</p>", section_id:"s1", featured_image_url:"https://images.unsplash.com/photo-1524995997946-a1172ddbc0bf?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"أ. كمال الدين", status:"published", is_featured:false, published_at:new Date(Date.now()-6*86400000).toISOString(), created_at:new Date(Date.now()-6*86400000).toISOString() },
  { id:"p8", title:"فلسفة الزمن عند ابن رشد: قراءة في الأصول", slug:"ibn-rushd-time-philosophy", excerpt:"يعود هذا المقال إلى تراث ابن رشد ليستجلي نظريته في الزمن والحركة الكونية ومدى تقاطعها مع الفيزياء الحديثة.", content:"<p>يُعدّ ابن رشد من أكثر الفلاسفة العرب تأثيراً في الفكر الغربي الوسيط، غير أن منظومته الفلسفية الخاصة بالزمن والحركة والكون لا تزال تستحق المزيد من الدراسة والتمحيص.</p>", section_id:"s1", featured_image_url:"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"د. نور الإسلام", status:"published", is_featured:false, published_at:new Date(Date.now()-7*86400000).toISOString(), created_at:new Date(Date.now()-7*86400000).toISOString() },
  // ── اقتصاد ───────────────────────────────────────────
  { id:"p9", title:"التضخم والمواطن العربي: ضغوط المعيشة ومعادلة الحلول", slug:"inflation-arab-citizen", excerpt:"يرصد هذا التقرير تداعيات موجة التضخم العالمية على دخل الأسرة العربية ويقترح سياسات لحماية القدرة الشرائية.", content:"<p>باتت موجة التضخم التي تعصف بالاقتصادات العالمية حقيقة يومية يعيشها المواطن العربي في كل تفصيل من تفاصيل حياته. من فاتورة الغذاء إلى تكاليف السكن والنقل، تتآكل القدرة الشرائية للطبقة الوسطى في صمت مقلق.</p>", section_id:"s2", featured_image_url:"https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"سمر حمدان", status:"published", is_featured:false, published_at:new Date(Date.now()-5*86400000).toISOString(), created_at:new Date(Date.now()-5*86400000).toISOString() },
  { id:"p10", title:"الريادة والابتكار: نماذج ناجحة من بيئة العمل العربية", slug:"arab-startups-success", excerpt:"تجارب ريادية ملهمة نبتت في البيئة العربية وصمدت في وجه التحديات لتصبح نماذج جديرة بالاستلهام.", content:"<p>تكشف التقارير الاقتصادية عن قفزات ملحوظة في عدد الشركات الناشئة العربية التي نجحت في جذب استثمارات دولية ضخمة. وتحتل قطاعات التجارة الإلكترونية والتقنية المالية الصدارة في هذه الطفرة الريادية الواعدة.</p>", section_id:"s2", featured_image_url:"https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"فارس النجار", status:"published", is_featured:false, published_at:new Date(Date.now()-6*86400000).toISOString(), created_at:new Date(Date.now()-6*86400000).toISOString() },
  { id:"p11", title:"الاقتصاد الأخضر: فرص الطاقة المتجددة في المنطقة العربية", slug:"green-economy-arab", excerpt:"تزخر المنطقة بالطاقة الشمسية وطاقة الرياح، فهل يمكن تحويل هذا الإرث الطبيعي إلى محرك للتنمية الاقتصادية؟", content:"<p>تمتلك الدول العربية من الإمكانات الطبيعية ما يجعلها بين أكثر مناطق العالم قدرة على قيادة التحول نحو الاقتصاد الأخضر. فالصحاري الواسعة الغنية بالإشعاع الشمسي والسواحل الممتدة تمثل ثروة طبيعية هائلة.</p>", section_id:"s2", featured_image_url:"https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"ياسمين طلعت", status:"published", is_featured:false, published_at:new Date(Date.now()-7*86400000).toISOString(), created_at:new Date(Date.now()-7*86400000).toISOString() },
  // ── سياسة ─────────────────────────────────────────────
  { id:"p12", title:"الانتخابات والديمقراطية في العالم العربي: واقع وآفاق", slug:"elections-democracy-arab", excerpt:"دراسة مقارنة للمسارات الديمقراطية في عدد من الدول العربية والعوامل المؤثرة في جودة العملية الانتخابية.", content:"<p>تتباين التجارب الديمقراطية في العالم العربي تبايناً كبيراً؛ بين من اجتازت عتبة الانتقال الديمقراطي بخطوات ثابتة وإن متعثرة، وبين من لا تزال تتلمس طريقها وسط إكراهات بنيوية عميقة.</p>", section_id:"s3", featured_image_url:"https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"علاء منصور", status:"published", is_featured:false, published_at:new Date(Date.now()-5*86400000).toISOString(), created_at:new Date(Date.now()-5*86400000).toISOString() },
  { id:"p13", title:"الجيوسياسة الإقليمية: محاور التوافق والصراع", slug:"regional-geopolitics", excerpt:"خريطة التحالفات الإقليمية تتشكل من جديد في ظل تغير موازين القوى وتقاطع مصالح متباينة في ملفات الأمن والطاقة.", content:"<p>تتشكل الجغرافيا السياسية الإقليمية من جديد في ضوء التقلبات المتسارعة التي تشهدها المنطقة. إن التنافس بين القوى الإقليمية والدولية على ملفات الطاقة والممرات التجارية يُعيد رسم خرائط التحالف والصراع.</p>", section_id:"s3", featured_image_url:"https://images.unsplash.com/photo-1575320181282-9afab399332c?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"هند الشامي", status:"published", is_featured:false, published_at:new Date(Date.now()-6*86400000).toISOString(), created_at:new Date(Date.now()-6*86400000).toISOString() },
  { id:"p14", title:"حوكمة المدن الكبرى: تحديات الإدارة المحلية في العالم العربي", slug:"arab-city-governance", excerpt:"تعاني المدن العربية الكبرى من ضغوط التحضر السريع، فأين تقع مسؤولية الحوكمة المحلية في تحسين جودة حياة المواطن؟", content:"<p>تتفاقم تحديات الحوكمة الحضرية في ظل التوسع الديموغرافي المتسارع وضغوط الهجرة الداخلية. إن ضمان الخدمات الأساسية وتوزيع عادل للموارد باتا مطالب لا يمكن للإدارات المحلية تجاوزها.</p>", section_id:"s3", featured_image_url:"https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"رامي الخليل", status:"published", is_featured:false, published_at:new Date(Date.now()-7*86400000).toISOString(), created_at:new Date(Date.now()-7*86400000).toISOString() },
  // ── صحة ──────────────────────────────────────────────
  { id:"p15", title:"الصحة النفسية في الوطن العربي: كسر صمت الوصمة", slug:"mental-health-arab-stigma", excerpt:"لا تزال الاضطرابات النفسية محاطة بالوصمة الاجتماعية في كثير من المجتمعات العربية مما يُقلل من فرص طلب المساعدة.", content:"<p>تكشف الإحصاءات أن نحو 30٪ من العرب يعانون شكلاً من أشكال الاضطرابات النفسية، غير أن قرابة 80٪ منهم لا يلتمسون أي مساعدة متخصصة. يُشكّل الخوف من الوصمة الاجتماعية عقبة رئيسية.</p>", section_id:"s4", featured_image_url:"https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"د. منار الجميل", status:"published", is_featured:false, published_at:new Date(Date.now()-5*86400000).toISOString(), created_at:new Date(Date.now()-5*86400000).toISOString() },
  { id:"p16", title:"الغذاء والسرطان: ماذا تقول الدراسات الحديثة؟", slug:"food-cancer-research", excerpt:"تزخر الأبحاث الطبية الحديثة بمعطيات جديدة حول العلاقة بين النظام الغذائي وخطر الإصابة بالسرطان.", content:"<p>بات من الثابت علمياً أن نمط الغذاء يلعب دوراً محورياً في تنظيم المخاطر الصحية. فالأغذية الغنية بمضادات الأكسدة والألياف تمثل درعاً وقائية طبيعية تشير إليها دراسات نُشرت في أرقى المجلات الطبية.</p>", section_id:"s4", featured_image_url:"https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"د. سلوى حميدان", status:"published", is_featured:false, published_at:new Date(Date.now()-6*86400000).toISOString(), created_at:new Date(Date.now()-6*86400000).toISOString() },
  { id:"p17", title:"الوقاية من السكري: دليل عملي للأسرة العربية", slug:"diabetes-prevention-guide", excerpt:"ينتشر داء السكري بمعدلات مقلقة في العالم العربي. نقدم دليلاً علمياً بسيطاً حول أساليب الوقاية والتغذية السليمة.", content:"<p>يُعدّ داء السكري من أكثر الأمراض المزمنة انتشاراً في المجتمعات العربية، إذ تشير تقارير منظمة الصحة العالمية إلى أن 1 من كل 6 بالغين مصاب أو في خطر مرتفع للإصابة. الغذاء الصحي والنشاط البدني يقلصان هذه المخاطر.</p>", section_id:"s4", featured_image_url:"https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"صحة ورياضة", status:"published", is_featured:false, published_at:new Date(Date.now()-7*86400000).toISOString(), created_at:new Date(Date.now()-7*86400000).toISOString() },
  // ── تكنولوجيا ─────────────────────────────────────────
  { id:"p18", title:"أمن المعلومات في عصر الهجمات الإلكترونية المتطورة", slug:"infosec-cyberattacks", excerpt:"تتصاعد الهجمات السيبرانية استهدافاً للبنى التحتية الحيوية، وتعاظم التهديدات يستلزم تحديثاً جذرياً لاستراتيجيات الأمن الرقمي.", content:"<p>تكشف التقارير الدولية عن تصاعد حاد في عدد الهجمات الإلكترونية الموجهة ضد البنى التحتية للدول العربية. يتراوح الاستهداف بين شبكات الطاقة والقطاعات المالية وصولاً إلى منظومات البيانات الحكومية.</p>", section_id:"s5", featured_image_url:"https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"م. طارق السعيد", status:"published", is_featured:false, published_at:new Date(Date.now()-5*86400000).toISOString(), created_at:new Date(Date.now()-5*86400000).toISOString() },
  { id:"p19", title:"الميتافيرس: بين الوعد الرقمي وتحديات الواقع", slug:"metaverse-promise-reality", excerpt:"هل يملك الميتافيرس القدرة على إحداث نقلة نوعية في طرق العمل والتعليم والترفيه، أم أنه مجرد موضة عابرة؟", content:"<p>منذ أن أعادت شركة فيسبوك تسمية نفسها بـ 'ميتا' إعلاناً عن توجهها نحو عالم افتراضي شامل، صار الميتافيرس حديث كل التقنيين والمستثمرين. غير أن التساؤلات تبقى قائمة حول الجدوى الفعلية لهذه البيئات الرقمية.</p>", section_id:"s5", featured_image_url:"https://images.unsplash.com/photo-1633356122102-3fe601e05bd2?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"نور الهدى", status:"published", is_featured:false, published_at:new Date(Date.now()-6*86400000).toISOString(), created_at:new Date(Date.now()-6*86400000).toISOString() },
  { id:"p20", title:"البلوك تشين والعملات الرقمية: قراءة في المشهد العربي", slug:"blockchain-crypto-arab", excerpt:"شهدت المنطقة العربية اهتماماً متزايداً بتقنية البلوك تشين والعملات الرقمية. نستعرض واقع التبني والفرص والتحديات التنظيمية.", content:"<p>تتبنى عدة دول عربية تقنية البلوك تشين في قطاعات الخدمات الحكومية والمالية والعقارية، بينما تتباين المواقف التنظيمية من العملات الرقمية بين التشجيع الحذر والتقييد الصريح.</p>", section_id:"s5", featured_image_url:"https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=800&q=80", author_id:"00000000-0000-0000-0000-000000000000", author_name:"أحمد الزهراني", status:"published", is_featured:false, published_at:new Date(Date.now()-7*86400000).toISOString(), created_at:new Date(Date.now()-7*86400000).toISOString() }
];


const SETTINGS_SEED = [
  {
    id: 1,
    site_name: "الصحيفة",
    default_post_image_url: "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=1200&q=80",
    weather_temp: "28",
    weather_desc: "صحو دافئ مع رياح شرقية خفيفة",
    exchange_rates: "الليرة الذهبية: 450 قرشاً | الريال المجيدي: 22 قرشاً | الجنيه الاسترليني: 110 قروش",
    quote_text: "إن صحيفتنا هذه ليست مجرد ناقل للأخبار، بل هي منبر للأحرار وسجل لتاريخ الأمة الحقيقي.",
    quote_author: "أديب إسحاق"
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
    const SEED_VERSION = 'v5'; // bump this when POSTS_SEED or SECTIONS_SEED change
    const storedVersion = localStorage.getItem('sa7ifa_seed_version');

    // Re-seed if version mismatch (preserving user-created posts)
    if (storedVersion !== SEED_VERSION) {
      // Save any user-created posts (those not in the seed set)
      const seedIds = new Set(POSTS_SEED.map(p => p.id));
      const existingPosts = JSON.parse(localStorage.getItem('sa7ifa_db_posts')) || [];
      const userPosts = existingPosts.filter(p => !seedIds.has(p.id));

      // Reset default tables
      localStorage.setItem('sa7ifa_db_sections', JSON.stringify(SECTIONS_SEED));
      localStorage.setItem('sa7ifa_db_posts', JSON.stringify([...POSTS_SEED, ...userPosts]));
      localStorage.setItem('sa7ifa_db_site_settings', JSON.stringify(SETTINGS_SEED));
      localStorage.setItem('sa7ifa_seed_version', SEED_VERSION);
    }

    // Self-healing migration for existing databases to ensure "home" section exists
    try {
      let currentSections = JSON.parse(localStorage.getItem('sa7ifa_db_sections')) || [];
      if (currentSections.length > 0 && !currentSections.some(s => s.slug === 'home')) {
        currentSections.unshift({
          id: "home",
          name_ar: "الصفحة الرئيسية",
          name_en: "Home",
          slug: "home",
          description: "الصفحة الرئيسية للجريدة",
          icon: "📰",
          color: "#8b1a1a",
          display_order: 0,
          is_active: true,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        });
        localStorage.setItem('sa7ifa_db_sections', JSON.stringify(currentSections));
      }
    } catch (e) {
      console.error(e);
    }

    // Self-healing migration for existing databases to ensure site settings columns exist
    try {
      let currentSettings = JSON.parse(localStorage.getItem('sa7ifa_db_site_settings')) || [];
      if (currentSettings.length > 0 && currentSettings[0] && !currentSettings[0].weather_temp) {
        currentSettings[0].weather_temp = "28";
        currentSettings[0].weather_desc = "صحو دافئ مع رياح شرقية خفيفة";
        currentSettings[0].exchange_rates = "الليرة الذهبية: 450 قرشاً | الريال المجيدي: 22 قرشاً | الجنيه الاسترليني: 110 قروش";
        currentSettings[0].quote_text = "إن صحيفتنا هذه ليست مجرد ناقل للأخبار، بل هي منبر للأحرار وسجل لتاريخ الأمة الحقيقي.";
        currentSettings[0].quote_author = "أديب إسحاق";
        localStorage.setItem('sa7ifa_db_site_settings', JSON.stringify(currentSettings));
      }
    } catch (e) {
      console.error(e);
    }

    let data = JSON.parse(localStorage.getItem(`sa7ifa_db_${this.table}`));

        // Seed initial data if table is still null or empty (e.g. other tables)
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
      } else if (this.table === 'profiles') {
        data = [
          {
            id: '00000000-0000-0000-0000-000000000000',
            name: 'مدير الصحيفة',
            email: 'developper47@gmail.com',
            role: 'admin',
            is_validated: true,
            created_at: new Date().toISOString()
          },
          {
            id: 'usr_j1',
            name: 'أحمد الصحفي',
            email: 'ahmed@sa7ifa.com',
            role: 'journalist',
            is_validated: false,
            created_at: new Date().toISOString()
          },
          {
            id: 'usr_j2',
            name: 'سارة الكاتبة',
            email: 'sara@sa7ifa.com',
            role: 'journalist',
            is_validated: true,
            created_at: new Date().toISOString()
          },
          {
            id: 'usr_r1',
            name: 'خالد القارئ',
            email: 'khaled@sa7ifa.com',
            role: 'reader',
            is_validated: true,
            created_at: new Date().toISOString()
          }
        ];
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

function getSeedUsers() {
  let users = JSON.parse(localStorage.getItem('sa7ifa_users'));
  if (!users || users.length === 0) {
    users = [
      {
        id: '00000000-0000-0000-0000-000000000000',
        email: 'developper47@gmail.com',
        password: 'admin123',
        user_metadata: { full_name: 'مدير الصحيفة', role: 'admin' },
        role: 'admin'
      },
      {
        id: 'usr_j1',
        email: 'ahmed@sa7ifa.com',
        password: '123456',
        user_metadata: { full_name: 'أحمد الصحفي', role: 'journalist' },
        role: 'journalist'
      },
      {
        id: 'usr_j2',
        email: 'sara@sa7ifa.com',
        password: '123456',
        user_metadata: { full_name: 'سارة الكاتبة', role: 'journalist' },
        role: 'journalist'
      },
      {
        id: 'usr_r1',
        email: 'khaled@sa7ifa.com',
        password: '123456',
        user_metadata: { full_name: 'خالد القارئ', role: 'reader' },
        role: 'reader'
      }
    ];
    localStorage.setItem('sa7ifa_users', JSON.stringify(users));
  }
  return users;
}

const mockAuth = {
  async signUp({ email, password, options }) {
    const users = getSeedUsers();
    if (users.some(u => u.email === email)) {
      return { data: { user: null }, error: new Error('User already exists') };
    }
    const name = options?.data?.full_name || 'مستخدم جديد';
    const role = options?.data?.role || 'reader';
    const user = {
      id: crypto.randomUUID ? crypto.randomUUID() : 'usr_' + Math.random().toString(36).substr(2, 9),
      email,
      user_metadata: { full_name: name, role: role },
      role: email === 'developper47@gmail.com' ? 'admin' : role
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
      is_validated: user.role === 'admin' || user.role === 'reader' ? true : false,
      created_at: new Date().toISOString()
    });
    localStorage.setItem('sa7ifa_db_profiles', JSON.stringify(profiles));

    localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(user));
    return { data: { user }, error: null };
  },

  async signInWithPassword({ email, password }) {
    const users = getSeedUsers();
    if (email === 'developper47@gmail.com' && password === 'admin123') {
      const mockAdmin = {
        id: '00000000-0000-0000-0000-000000000000',
        email: 'developper47@gmail.com',
        user_metadata: { full_name: 'مدير الصحيفة', role: 'admin' },
        role: 'admin'
      };
      localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(mockAdmin));
      return { data: { user: mockAdmin }, error: null };
    }

    const found = users.find(u => u.email === email && u.password === password);
    if (!found) {
      return { data: { user: null }, error: new Error('البريد الإلكتروني أو كلمة المرور غير صحيحة') };
    }
    
    // Fetch validation status from profile to see if user is a validated journalist
    const profiles = JSON.parse(localStorage.getItem('sa7ifa_db_profiles')) || [];
    const prof = profiles.find(p => p.id === found.id);
    const mockUser = {
      ...found,
      is_validated: prof ? prof.is_validated : true
    };
    
    localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(mockUser));
    return { data: { user: mockUser }, error: null };
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
    
    const users = JSON.parse(localStorage.getItem('sa7ifa_users')) || [];
    const idx = users.findIndex(u => u.id === user.id);
    
    if (idx !== -1) {
      if (data?.full_name) {
        user.user_metadata = { ...user.user_metadata, full_name: data.full_name };
        users[idx].user_metadata = user.user_metadata;
        
        const profiles = JSON.parse(localStorage.getItem('sa7ifa_db_profiles')) || [];
        const pIdx = profiles.findIndex(p => p.id === user.id);
        if (pIdx !== -1) {
          profiles[pIdx].name = data.full_name;
          localStorage.setItem('sa7ifa_db_profiles', JSON.stringify(profiles));
        }
      }
      
      if (password) {
        users[idx].password = password;
      }
      
      localStorage.setItem('sa7ifa_users', JSON.stringify(users));
      localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify(user));
    }
    return { data: { user }, error: null };
  }
};

const mockSupabase = {
  auth: mockAuth,
  from(table) {
    return new SupabaseQueryBuilder(table);
  }
};

export const supabase = supabaseClient || mockSupabase;
