-- ==========================================
-- New Editorial Seed Data for Fikr Magazine
-- ==========================================

DO $$ 
DECLARE 
    v_user_id UUID;
    v_user_name TEXT;
    v_ideas_id UUID;
    v_economy_id UUID;
    v_tech_id UUID;
    v_history_id UUID;
BEGIN
    -- 1. Get the first user
    SELECT id, name INTO v_user_id, v_user_name FROM public.profiles LIMIT 1;
    IF v_user_id IS NULL THEN
        RAISE NOTICE 'No users found. Please register on the site first.';
        RETURN;
    END IF;

    -- 2. Setup Site Settings
    INSERT INTO public.site_settings (id, site_name, default_post_image_url)
    VALUES (1, 'الصحيفة', 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=1200&q=80')
    ON CONFLICT (id) DO UPDATE SET default_post_image_url = EXCLUDED.default_post_image_url;

    -- 3. Insert Sections
    INSERT INTO public.sections (name_ar, name_en, slug, description, icon, color, display_order)
    VALUES 
    ('فكر', 'Ideas', 'ideas', 'حوارات فكرية وفلسفية وتحليلات معمقة للأفكار والتحولات الثقافية', '💡', '#8e44ad', 1),
    ('اقتصاد', 'Economy', 'economy', 'تقارير وتحليلات مالية واقتصادية تغطي العالم العربي والأسواق الدولية', '📊', '#2c3e50', 2),
    ('تكنولوجيا', 'Technology', 'tech', 'تغطية شاملة للثورة الرقمية وتأثير التقنيات الناشئة على الإنسان والمجتمع', '💻', '#2980b9', 3),
    ('تاريخ', 'History', 'history', 'دراسات وبحوث تاريخية تسلط الضوء على الهوية والتراث والحضارة العربية', '📜', '#d35400', 4)
    ON CONFLICT (slug) DO UPDATE SET 
        name_ar = EXCLUDED.name_ar,
        name_en = EXCLUDED.name_en,
        description = EXCLUDED.description,
        icon = EXCLUDED.icon,
        color = EXCLUDED.color,
        display_order = EXCLUDED.display_order;

    -- Get Section IDs
    SELECT id INTO v_ideas_id FROM public.sections WHERE slug = 'ideas';
    SELECT id INTO v_economy_id FROM public.sections WHERE slug = 'economy';
    SELECT id INTO v_tech_id FROM public.sections WHERE slug = 'tech';
    SELECT id INTO v_history_id FROM public.sections WHERE slug = 'history';

    -- 4. Insert Sample Posts
    INSERT INTO public.posts (title, slug, excerpt, content, section_id, featured_image_url, author_id, author_name, status, is_featured, published_at)
    VALUES 
    (
      'بنية العقل العربي المعاصر: قراءة في فكر محمد عابد الجابري',
      'structure-of-arab-reason-jabri',
      'تحليل نقدي لإسهامات الفيلسوف المغربي محمد عابد الجابري في نقد وتفكيك العقل العربي ومصادره المعرفية.',
      '<p>يعد محمد عابد الجابري من أبرز الفلاسفة العرب المعاصرين الذين قاربوا مسألة التراث والحداثة بمشرط النقد المعرفي. في مشروعه الضخم "نقد العقل العربي"، سعى الجابري إلى تتبع النظم المعرفية التي حكمت الثقافة العربية وحصرها في ثلاثة نظم رئيسية: البيان، والعرفان، والبرهان.</p><p>ويرى الجابري أن تجديد الفكر العربي المعاصر لا يمكن أن يتم عبر القطيعة التامة مع التراث، بل من خلال إعادة قراءته ونقده من الداخل لاستئناف العقلانية البرهانية التي تمثلت قديماً في الرشدية الأندلسية.</p>',
      v_ideas_id,
      'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=1200&q=80',
      v_user_id,
      v_user_name,
      'published',
      true,
      NOW()
    ),
    (
      'مستقبل التكامل الاقتصادي العربي في ظل التحولات الجيوسياسية',
      'future-of-arab-economic-integration',
      'دراسة تحليلية حول فرص التبادل التجاري وتحديات سلاسل التوريد في المنطقة العربية في ظل تغيرات القوى الدولية.',
      '<p>تواجه المنطقة العربية تحديات اقتصادية غير مسبوقة تفرض ضرورة إعادة النظر في آليات التكامل الاقتصادي الإقليمي. لم تعد الاتفاقيات التقليدية كافية لمواجهة تقلبات سلاسل التوريد العالمية وأزمات الطاقة والغذاء المتلاحقة.</p><p>يتطلب المستقبل تعزيز الشراكات في مجالات الطاقة المتجددة، وتسهيل التدفق الحر لرؤوس الأموال، وتحديث البنية التحتية اللوجستية التي تربط المشرق بالمغرب العربي، مع التركيز على بناء قواعد صناعية إقليمية متكاملة.</p>',
      v_economy_id,
      'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=1200&q=80',
      v_user_id,
      v_user_name,
      'published',
      false,
      NOW() - INTERVAL '1 day'
    ),
    (
      'أخلاقيات الذكاء الاصطناعي في الفضاء الرقمي العربي',
      'ethics-of-ai-arab-digital-space',
      'تساؤلات فلسفية وتقنية حول حدود التدخل البشري والمسؤولية القانونية للأنظمة الذكية وتأثيرها على الهوية المجتمعية.',
      '<p>لم يعد الذكاء الاصطناعي مجرد تقنية جديدة، بل أصبح قوة فاعلة تشكل معالم وجودنا الإنساني والرقمي. وفي حين تتسابق المؤسسات العربية لتبني حلول الذكاء الاصطناعي لزيادة الكفاءة، تبرز قضايا أخلاقية بالغة التعقيد حول الخصوصية، والتحيز الخوارزمي، وحماية الهوية الثقافية.</p><h3>التأثير الاجتماعي</h3><p>يتطلب هذا التحول الرقمي بناء أطر أخلاقية تتوافق مع القيم والمبادئ العربية والإسلامية للتعامل مع تحديات الذكاء التوليدي والتشغيل الذاتي.</p>',
      v_tech_id,
      'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=1200&q=80',
      v_user_id,
      v_user_name,
      'published',
      false,
      NOW() - INTERVAL '2 days'
    ),
    (
      'نشأة الصحافة العربية ودورها في النهضة الفكرية',
      'rise-of-arab-press-intellectual-renaissance',
      'قراءة تاريخية في بدايات الصحافة المكتوبة في مصر وبلاد الشام وكيف ساهمت في تشكيل الوعي الجمعي العربي في القرن التاسع عشر.',
      '<p>شهد القرن التاسع عشر ولادة الصحافة العربية كأداة رئيسية من أدوات التنوير والنهضة الفكرية والاجتماعية. فمنذ صدور صحيفة "الوقائع المصرية" وتأسيس مطبعة بولاق، تحولت الصحافة إلى منبر للنقاش الفكري العام.</p><p>ولم يقتصر دور الدوريات والمجلات الرائدة مثل "المقتطف" و"الهلال" على نقل الأخبار، بل كانت ساحات للسجالات العلمية والأدبية، وساهمت بشكل جوهري في تطوير اللغة العربية وتبسيط أساليبها لتواكب العصر الحديث.</p>',
      v_history_id,
      'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=1200&q=80',
      v_user_id,
      v_user_name,
      'published',
      false,
      NOW() - INTERVAL '3 days'
    );

    RAISE NOTICE 'تم تحديث البيانات التجريبية بنجاح!';
END $$;
