-- ==========================================
-- New Editorial Seed Data for Fikr Magazine
-- ==========================================

DO $$ 
DECLARE 
    v_user_id UUID;
    v_user_name TEXT;
    v_economy_id UUID;
    v_society_id UUID;
    v_news_id UUID;
    v_ideas_id UUID;
BEGIN
    -- 1. Get the first user
    SELECT id, name INTO v_user_id, v_user_name FROM public.profiles LIMIT 1;
    IF v_user_id IS NULL THEN
        RAISE NOTICE 'No users found. Please register on the site first.';
        RETURN;
    END IF;

    -- 2. Setup Site Settings
    INSERT INTO public.site_settings (id, site_name, default_post_image_url)
    VALUES (1, 'مجلة فكر', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=1200&q=80')
    ON CONFLICT (id) DO UPDATE SET default_post_image_url = EXCLUDED.default_post_image_url;

    -- 3. Insert Sections
    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order)
    VALUES 
    ('اقتصاد', 'Economy', 'economy', 'تحليلات وتقارير اقتصادية معمقة', '📊', '#2c3e50', 1),
    ('مجتمع', 'Society', 'society', 'قضايا وتحولات اجتماعية', '👥', '#27ae60', 2),
    ('أخبار', 'News', 'news', 'تغطية إخبارية شاملة', '📰', '#c0392b', 3),
    ('فكر وأيديولوجيا', 'Ideas', 'ideas', 'حوارات فكرية وفلسفية', '💡', '#8e44ad', 4)
    ON CONFLICT (slug) DO NOTHING;

    -- Get Section IDs
    SELECT id INTO v_economy_id FROM public.sections WHERE slug = 'economy';
    SELECT id INTO v_society_id FROM public.sections WHERE slug = 'society';
    SELECT id INTO v_news_id FROM public.sections WHERE slug = 'news';
    SELECT id INTO v_ideas_id FROM public.sections WHERE slug = 'ideas';

    -- 4. Insert Sample Posts
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at)
    VALUES 
    (
      'مستقبل التكامل الاقتصادي العربي في ظل التحولات الجيوسياسية',
      'future-of-arab-economic-integration',
      'دراسة تحليلية حول فرص التبادل التجاري وتحديات سلاسل التوريد في المنطقة العربية.',
      '<p>تواجه المنطقة العربية تحديات اقتصادية غير مسبوقة تفرض ضرورة إعادة النظر في آليات التكامل الاقتصادي...</p>',
      v_economy_id,
      'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=1200&q=80',
      v_user_id,
      v_user_name,
      'published',
      true,
      NOW()
    ),
    (
      'أخلاقيات الذكاء الاصطناعي: هل نحن مستعدون للعصر الرقمي الجديد؟',
      'ethics-of-ai-digital-age',
      'تساؤلات فلسفية حول حدود التدخل البشري والمسؤولية القانونية للأنظمة الذكية.',
      '<p>لم يعد الذكاء الاصطناعي مجرد تقنية جديدة، بل أصبح قوة فاعلة تشكل معالم وجودنا الإنساني...</p>',
      v_ideas_id,
      null, -- This will test the fallback image
      v_user_id,
      v_user_name,
      'published',
      false,
      NOW() - INTERVAL '1 day'
    ),
    (
      'تحولات الأسرة العربية في القرن الحادي والعشرين',
      'transformation-of-arab-family',
      'كيف أثرت العولمة ووسائل التواصل الاجتماعي على الروابط الأسرية التقليدية؟',
      '<p>تشهد الأسرة العربية تحولات جذرية في بنيتها ووظائفها نتيجة التفاعل المستمر مع قيم الحداثة...</p>',
      v_society_id,
      'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=1200&q=80',
      v_user_id,
      v_user_name,
      'published',
      false,
      NOW() - INTERVAL '2 days'
    );

    RAISE NOTICE 'تم تحديث البيانات التجريبية بنجاح!';
END $$;
