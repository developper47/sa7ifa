/**
 * posts.js — Supabase Posts CRUD, Filtering & Image Fallback
 * Replaces articles.js for the new editorial schema.
 */

import { supabase } from './supabase.js?v=3.7';

// Default fallback image if post has no featured image and site_settings is empty
const HARD_FALLBACK_IMAGE = 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=1200&q=80';

let _defaultImageCache = null;

/**
 * Get default image from site_settings or hard fallback.
 */
export async function getDefaultImage() {
  if (_defaultImageCache) return _defaultImageCache;
  const { data } = await supabase
    .from('site_settings')
    .select('default_post_image_url')
    .maybeSingle();
  _defaultImageCache = data?.default_post_image_url || HARD_FALLBACK_IMAGE;
  return _defaultImageCache;
}

/**
 * Normalize a post: ensure featured_image_url is always set.
 */
export async function normalizePost(post) {
  if (!post) return null;
  if (!post.featured_image_url) {
    post.featured_image_url = await getDefaultImage();
  }
  return post;
}

/**
 * Get posts with optional filtering.
 */
export async function getPosts(filter = {}) {
  let query = supabase
    .from('posts')
    .select(`
      *,
      sections (id, name_ar, name_en, slug, color, icon)
    `)
    .order('published_at', { ascending: false, nullsFirst: false })
    .order('created_at', { ascending: false });

  const status = filter.status || 'published';
  if (status !== 'all') {
    query = query.eq('status', status);
  }

  if (filter.section_id) {
    query = query.eq('section_id', filter.section_id);
  }

  if (filter.section_slug) {
    query = query.eq('sections.slug', filter.section_slug);
  }

  if (filter.author_id) {
    query = query.eq('author_id', filter.author_id);
  }

  if (filter.is_featured !== undefined) {
    query = query.eq('is_featured', filter.is_featured);
  }

  if (filter.limit) {
    query = query.limit(filter.limit);
  }

  const { data, error } = await query;
  if (error) {
    console.error('Error fetching posts:', error.message);
    return [];
  }

  const defaultImg = await getDefaultImage();
  return (data || []).map(p => ({
    ...p,
    featured_image_url: p.featured_image_url || defaultImg
  }));
}

/**
 * Get a single post by ID.
 */
export async function getPost(id) {
  const { data, error } = await supabase
    .from('posts')
    .select(`*, sections (id, name_ar, name_en, slug, color, icon)`)
    .eq('id', id)
    .maybeSingle();

  if (error) {
    console.error('Error fetching post:', error.message);
    return null;
  }
  return normalizePost(data);
}

/**
 * Get a single post by slug.
 */
export async function getPostBySlug(slug) {
  const { data, error } = await supabase
    .from('posts')
    .select(`*, sections (id, name_ar, name_en, slug, color, icon)`)
    .eq('slug', slug)
    .maybeSingle();

  if (error) return null;
  return normalizePost(data);
}

/**
 * Save (create or update) a post.
 * Automatically assigns the default image if none is provided.
 */
export async function savePost(post) {
  const defaultImg = await getDefaultImage();
  const payload = {
    ...post,
    featured_image_url: post.featured_image_url || defaultImg,
    updated_at: new Date().toISOString()
  };

  // Ensure ID is not sent as null if creating a new post
  if (!payload.id) delete payload.id;

  // Auto-generate slug if not provided
  if (!payload.slug && payload.title) {
    payload.slug = generateSlug(payload.title) + '-' + Date.now().toString(36);
  }

  if (!post.id) {
    const { data, error } = await supabase
      .from('posts')
      .insert([payload])
      .select();
    if (error) throw error;
    return data[0];
  } else {
    const { data, error } = await supabase
      .from('posts')
      .update(payload)
      .eq('id', post.id)
      .select();
    if (error) throw error;
    return data[0];
  }
}

/**
 * Delete a post by ID.
 */
export async function deletePost(id) {
  const { error } = await supabase.from('posts').delete().eq('id', id);
  if (error) throw error;
}

/**
 * Admin moderation: change post status.
 */
export async function moderatePost(id, newStatus) {
  const payload = { status: newStatus, updated_at: new Date().toISOString() };
  if (newStatus === 'published') {
    payload.published_at = new Date().toISOString();
  }
  const { data, error } = await supabase
    .from('posts')
    .update(payload)
    .eq('id', id)
    .select();
  if (error) throw error;
  return data[0];
}

/**
 * Toggle featured status for a post.
 */
export async function toggleFeatured(id, isFeatured) {
  const { data, error } = await supabase
    .from('posts')
    .update({ is_featured: isFeatured })
    .eq('id', id)
    .select();
  if (error) throw error;
  return data[0];
}

/**
 * Calculate estimated reading time in minutes.
 */
export function readingTime(content) {
  const words = (content || '').replace(/<[^>]+>/g, '').split(/\s+/).length;
  return Math.max(1, Math.ceil(words / 200));
}

/**
 * Format date in Arabic locale with Maghrebi month names and Arabic numerals.
 */
const GREGORIAN_MONTHS_AR = [
  'جانفي', 'فيفري', 'مارس', 'أفريل', 'ماي', 'جوان',
  'جويلية', 'أوت', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
];
function toArabicNumerals(str) {
  return String(str);
}
export function formatDate(dateString) {
  if (!dateString) return '';
  const d = new Date(dateString);
  const day = toArabicNumerals(d.getDate());
  const month = GREGORIAN_MONTHS_AR[d.getMonth()];
  const year = toArabicNumerals(d.getFullYear());
  return `${day} ${month} ${year}`;
}

/**
 * Generate URL-safe slug from Arabic or English text.
 */
export function generateSlug(text) {
  return text
    .trim()
    .toLowerCase()
    .replace(/[\u0600-\u06FF\s]+/g, '-') // Arabic to dashes
    .replace(/[^a-z0-9-]/g, '')
    .replace(/-+/g, '-')
    .slice(0, 60);
}

/**
 * Status display helper (Arabic labels).
 */
export function statusLabel(status) {
  const map = {
    draft: { label: 'مسودة', css: 'status-draft' },
    pending: { label: 'بانتظار المراجعة', css: 'status-pending' },
    needs_revision: { label: 'يحتاج مراجعة', css: 'status-revision' },
    published: { label: 'منشور', css: 'status-published' },
    rejected: { label: 'مرفوض', css: 'status-rejected' },
    archived: { label: 'مؤرشف', css: 'status-archived' }
  };
  return map[status] || { label: status, css: '' };
}
