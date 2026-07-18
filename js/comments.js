/**
 * comments.js — Supabase Threaded Comment System
 * Transitioned from LocalStorage to Supabase DB.
 */

import { supabase } from './supabase.js?v=3.1';

/**
 * Get comments for an article, structured as a tree.
 */
export async function getComments(articleId) {
  const { data: all, error } = await supabase
    .from('comments')
    .select('*')
    .eq('article_id', articleId)
    .order('created_at', { ascending: true });

  if (error) {
    console.error("Error fetching comments:", error.message);
    return [];
  }

  // Build tree
  const map = {};
  const roots = [];
  all.forEach(c => { map[c.id] = { ...c, replies: [] }; });
  all.forEach(c => {
    if (c.parent_id && map[c.parent_id]) {
      map[c.parent_id].replies.push(map[c.id]);
    } else {
      roots.push(map[c.id]);
    }
  });

  // Sort roots newest first
  roots.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
  return roots;
}

/**
 * Add a comment (or reply if parent_id is provided).
 */
export async function addComment(articleId, authorId, authorName, content, parentId = null) {
  const { data, error } = await supabase
    .from('comments')
    .insert([{
      article_id: articleId,
      author_id: authorId,
      author_name: authorName,
      content,
      parent_id: parentId
    }])
    .select();

  if (error) throw error;
  return data[0];
}

/**
 * Render comments tree as HTML string.
 */
export function renderCommentsHTML(comments, currentUser) {
  if (!comments || comments.length === 0) {
    return '<p class="no-comments">لا توجد تعليقات بعد. كن أول من يعلّق!</p>';
  }

  function renderSingle(comment, depth) {
    const initial = comment.author_name ? comment.author_name.charAt(0) : '؟';
    const timeAgo = getTimeAgo(comment.created_at);
    const replyBtn = currentUser
      ? `<button class="reply-btn" data-comment-id="${comment.id}" data-author="${comment.author_name}">↩ ردّ</button>`
      : '';

    let html = `
      <div class="comment" style="margin-right: ${depth * 2}rem;" data-id="${comment.id}">
        <div class="comment-header">
          <div class="comment-avatar">${initial}</div>
          <div class="comment-author">${comment.author_name}</div>
          <div class="comment-date">${timeAgo}</div>
        </div>
        <div class="comment-body">${escapeHtml(comment.content)}</div>
        <div class="comment-actions">${replyBtn}</div>
    `;

    if (comment.replies && comment.replies.length > 0) {
      html += '<div class="comment-replies">';
      comment.replies.forEach(r => { html += renderSingle(r, depth + 1); });
      html += '</div>';
    }

    html += '</div>';
    return html;
  }

  return comments.map(c => renderSingle(c, 0)).join('');
}

function getTimeAgo(dateString) {
  const diff = Date.now() - new Date(dateString).getTime();
  const minutes = Math.floor(diff / 60000);
  if (minutes < 1) return 'الآن';
  if (minutes < 60) return `منذ ${minutes} دقيقة`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `منذ ${hours} ساعة`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `منذ ${days} يوم`;
  const months = Math.floor(days / 30);
  return `منذ ${months} شهر`;
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
