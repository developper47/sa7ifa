/**
 * articles.js — Supabase Article CRUD & Filtering
 * Transitioned from LocalStorage to Supabase DB.
 */

import { supabase } from './supabase.js?v=3.7';

export const CATEGORIES = [
  { id: 'ideas', name: 'فكر', color: 'var(--cat-ideas)', cssClass: 'cat-ideas' },
  { id: 'economy', name: 'اقتصاد', color: 'var(--cat-economy)', cssClass: 'cat-economy' },
  { id: 'tech', name: 'تكنولوجيا', color: 'var(--cat-tech)', cssClass: 'cat-tech' },
  { id: 'history', name: 'تاريخ', color: 'var(--cat-history)', cssClass: 'cat-history' }
];

export function getCategoryById(id) {
  return CATEGORIES.find(c => c.id === id) || CATEGORIES[0];
}

/**
 * Get published articles, optionally filtered.
 */
export async function getArticles(filter = {}) {
  let query = supabase
    .from('articles')
    .select('*')
    .order('created_at', { ascending: false });

  // Default: only published
  const status = filter.status || 'published';
  if (status !== 'all') {
    query = query.eq('status', status);
  }

  if (filter.category) {
    query = query.eq('category', filter.category);
  }

  if (filter.author_id) {
    query = query.eq('author_id', filter.author_id);
  }

  if (filter.limit) {
    query = query.limit(filter.limit);
  }

  const { data, error } = await query;
  if (error) console.error("Error fetching articles:", error.message);
  return data || [];
}

/**
 * Get individual article by ID
 */
export async function getArticle(id) {
  const { data, error } = await supabase
    .from('articles')
    .select('*')
    .eq('id', id)
    .single();

  if (error) console.error("Error fetching article:", error.message);
  return data;
}

/**
 * Create or update an article
 */
export async function saveArticle(article) {
  const isNew = !article.id;
  
  if (isNew) {
    // Insert new article
    const { data, error } = await supabase
      .from('articles')
      .insert([article])
      .select();
    
    if (error) throw error;
    return data[0];
  } else {
    // Update existing article
    const { data, error } = await supabase
      .from('articles')
      .update({
        ...article,
        updated_at: new Date().toISOString()
      })
      .eq('id', article.id)
      .select();

    if (error) throw error;
    return data[0];
  }
}

/**
 * Delete an article (Admin only or Author if not published)
 */
export async function deleteArticle(id) {
  const { error } = await supabase
    .from('articles')
    .delete()
    .eq('id', id);

  if (error) throw error;
}

/**
 * Admin moderation: approve or reject an article
 */
export async function moderateArticle(id, newStatus) {
  const { data, error } = await supabase
    .from('articles')
    .update({ status: newStatus })
    .eq('id', id)
    .select();

  if (error) throw error;
  return data[0];
}

/**
 * Format article creation date.
 */
export function formatDate(dateString) {
  const d = new Date(dateString);
  const months = ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];
  return `${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear()}`;
}
