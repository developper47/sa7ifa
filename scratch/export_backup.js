const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// Target Admin User UUID in Supabase
const REAL_ADMIN_ID = '544110c4-ff50-457d-bb37-7dd0e884a709';

// Regex for checking valid UUID
const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

async function run() {
  console.log('=== Démarrage de l\'importation des données ===');

  // 1. Lire la configuration de Supabase
  const configPath = path.join(__dirname, '../js/config.js');
  if (!fs.existsSync(configPath)) {
    console.error(`Erreur: Le fichier config.js est introuvable à l'emplacement : ${configPath}`);
    process.exit(1);
  }

  const configContent = fs.readFileSync(configPath, 'utf8');
  const urlMatch = configContent.match(/export\s+const\s+SUPABASE_URL\s*=\s*["']([^"']+)["']/);
  const keyMatch = configContent.match(/export\s+const\s+SUPABASE_ANON_KEY\s*=\s*["']([^"']+)["']/);

  if (!urlMatch || !keyMatch) {
    console.error('Erreur: Impossible d\'extraire les clés de connexion dans js/config.js');
    process.exit(1);
  }

  const supabaseUrl = urlMatch[1].trim().replace(/\/rest\/v1\/?$/, '').replace(/\/$/, '');
  const supabaseKey = keyMatch[1];
  console.log(`Connexion à Supabase : ${supabaseUrl}`);

  // 2. Charger les données du fichier de sauvegarde
  const backupPath = path.join(__dirname, '../sa7ifa_backup_2026-08-16.json');
  if (!fs.existsSync(backupPath)) {
    console.error(`Erreur: Fichier de sauvegarde introuvable : ${backupPath}`);
    process.exit(1);
  }

  const backupData = JSON.parse(fs.readFileSync(backupPath, 'utf8'));
  const rawPosts = backupData.posts || [];
  console.log(`Chargé ${rawPosts.length} articles depuis la sauvegarde.`);

  // 3. Normaliser les articles pour Supabase
  const normalizedPosts = rawPosts.map((post) => {
    const p = { ...post };

    // Mapper l'ID auteur mock vers l'ID réel de Supabase
    if (p.author_id === '00000000-0000-0000-0000-000000000000') {
      p.author_id = REAL_ADMIN_ID;
    }

    // Gérer l'UUID du post
    if (!p.id || !UUID_REGEX.test(p.id)) {
      p.id = crypto.randomUUID();
    }

    // Assurer la présence des dates et champs optionnels requis
    p.updated_at = p.updated_at || p.created_at || new Date().toISOString();
    p.created_at = p.created_at || new Date().toISOString();
    p.category = p.category || null;

    return p;
  });

  // Pour éviter l'erreur PGRST102 "All object keys must match",
  // collecter toutes les clés uniques existantes sur tous les objets,
  // et s'assurer que chaque objet possède toutes les clés (avec valeur par défaut null).
  const allKeys = new Set();
  normalizedPosts.forEach(p => Object.keys(p).forEach(k => allKeys.add(k)));

  normalizedPosts.forEach(p => {
    allKeys.forEach(k => {
      if (p[k] === undefined) {
        p[k] = null;
      }
    });
  });

  const headers = {
    'apikey': supabaseKey,
    'Authorization': `Bearer ${supabaseKey}`,
    'Content-Type': 'application/json'
  };

  // 4. Supprimer les articles existants
  console.log('Suppression des anciens articles sur Supabase...');
  const deleteRes = await fetch(`${supabaseUrl}/rest/v1/posts?id=not.is.null`, {
    method: 'DELETE',
    headers: headers
  });

  if (!deleteRes.ok) {
    const errorText = await deleteRes.text();
    console.error('Erreur lors de la suppression des anciens articles :', errorText);
    process.exit(1);
  }
  console.log('Anciens articles supprimés avec succès.');

  // 5. Insérer les nouveaux articles
  console.log('Insertion des nouveaux articles normalisés...');
  const insertRes = await fetch(`${supabaseUrl}/rest/v1/posts`, {
    method: 'POST',
    headers: {
      ...headers,
      'Prefer': 'return=representation'
    },
    body: JSON.stringify(normalizedPosts)
  });

  if (!insertRes.ok) {
    const errorText = await insertRes.text();
    console.error('Erreur lors de l\'insertion des articles :', errorText);
    process.exit(1);
  }

  const insertedData = await insertRes.json();
  console.log(`Succès! ${insertedData.length} articles ont été importés avec succès.`);
  console.log('=== Importation terminée avec succès ===');
}

run().catch(console.error);
