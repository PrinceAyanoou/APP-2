# Dossier d'apprentissage — Backend (APP-2)

Ce document guide un.e débutant.e pas-à‑pas dans le code backend (Express.js). Chaque fichier est expliqué ligne par ligne, avec exemples, tests et exercices pratiques pour apprendre et étendre le serveur.

---

## Sommaire
1. Objectif pédagogique
2. Vue d'ensemble de l'architecture
3. Parcours d'une requête (login → protected route)
4. Explication détaillée des fichiers
   - `server.js`
   - `middleware/authMiddleware.js`
   - `models/users.js`, `profiles.js`, `requests.js`
   - `routes/auth.js`, `profile.js`, `requests.js`
5. Sécurité & améliorations immédiates (prioritaires)
6. Tests (exemples avec jest + supertest)
7. Exercices pratiques (pas-à‑pas)
8. Checklist pour la mise en production

---

## 1) Objectif pédagogique
À la fin de ce dossier, tu devras être capable de :
- Expliquer comment fonctionnent l'inscription, la génération JWT et la protection des routes.
- Remplacer le stockage en mémoire par une base (Mongo/Postgres).
- Ajouter du hachage sécurisé des mots de passe et des tests unitaires.

---

## 2) Vue d'ensemble
- Entrée unique : `server.js` (middleware global, CORS, bodyParser, routes).
- Auth: JWT, signé avec `JWT_SECRET` et renvoyé à l'utilisateur.
- Stockage actuel : objets JS en mémoire (`models/*.js`).
- Rendu simple : routes REST renvoient `{ success, data?, error? }`.

---

## 3) Parcours d'une requête (login -> accès protégé)
1. Client POST `/api/auth/login` avec email/password.
2. `routes/auth.js` vérifie l'utilisateur (`models/users.js`).
3. Si OK, `jwt.sign({ userId, email }, JWT_SECRET)` renvoie token.
4. Client inclut `Authorization: Bearer <token>` dans les requêtes suivantes.
5. `authMiddleware` vérifie le token, attache `req.userId`, et laisse passer vers la route protégée.

---

## 4) Explication détaillée des fichiers

### server.js
- `cors()` : en dev on autorise toutes les origines (facilite le test web). En production, restreindre l'origine.
- `bodyParser.json()` : parse les corps JSON en `req.body`.
- `app.use('/api/auth', authRoutes);` etc. — sépare la logique.
- Handler 404 et handler d'erreurs générique.

Extrait important :
```js
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ success: false, error: err.message || 'Internal server error' });
});
```

### middleware/authMiddleware.js
- Rôle : extraire le token depuis `Authorization` header, `jwt.verify(token, JWT_SECRET)`, attacher `req.userId`.
- Si le token est absent/invalid : renvoyer 401.

Points d'attention :
- Toujours protéger les routes sensibles avec ce middleware.
- Ajouter `expiresIn` au `jwt.sign()` pour limiter la validité.

### models/users.js
- Stocke les utilisateurs dans un objet `users` avec `id`, `email`, `passwordHash`.
- `hashPassword()` utilise `Buffer.from(password).toString('base64')` — **insecure** mais simple pour MVP.
- Remplacer par `bcrypt`: installer `bcrypt` et appeler `bcrypt.hash()` / `bcrypt.compare()`.

Extrait (création utilisateur) :
```js
const createUser = (email, password) => {
  const id = generateUserId();
  users[id] = { id, email, passwordHash: hashPassword(password), createdAt: new Date() };
  return users[id];
};
```

### models/profiles.js et requests.js
- `createProfile(userId)` initialise un profil vide.
- `getProfile(userId)` crée un profil par défaut si absent.
- `createRequest(userId, title, type)` génère `id` et stocke la requête.

Conseil : ces fonctions seront remplacées par équivalents DB (Mongoose models) lors de la migration.

### routes/auth.js
- `POST /signup` : vérifie unicité email, createUser(), createProfile(), génère token.
- `POST /login` : vérifie user + password, renvoie token.
- `GET /me` : protégé par `authMiddleware` et renvoie `req.user`

Extrait token :
```js
const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET);
```
Amélioration : `jwt.sign(..., { expiresIn: '15m' })`.

### routes/profile.js & requests.js
- `GET /` et `PUT /` pour le profil — protégé.
- `POST /api/requests` crée une nouvelle demande pour `req.userId`.
- `PUT /api/requests/:id` vérifie la propriété (ownership) avant modification.

---

## 5) Sécurité & améliorations prioritaires
1. Hasher les mots de passe avec `bcrypt` (ou `argon2`).
2. Ajouter `expiresIn` aux JWT et implémenter refresh tokens.
3. Valider l'entrée des routes (express-validator / Joi).
4. Limiter les tailles de payload et ajouter rate limiting (express-rate-limit).
5. Passer des logs structurés (`pino`/`winston`) et monitoring (Sentry).

Exemple rapide (bcrypt) :
```js
const bcrypt = require('bcrypt');
const hash = await bcrypt.hash(password, 10);
const ok = await bcrypt.compare(password, storedHash);
```

---

## 6) Tests (jest + supertest) — exemple
- Installer : `npm i -D jest supertest`.
- Exemple de test pour `POST /api/auth/signup` :
```js
const request = require('supertest');
const app = require('../server');

describe('auth', () => {
  it('signup + login flow', async () => {
    const res = await request(app).post('/api/auth/signup').send({ email:'a@a.com', password:'p' });
    expect(res.status).toBe(201);
    const login = await request(app).post('/api/auth/login').send({ email:'a@a.com', password:'p' });
    expect(login.body.success).toBe(true);
  });
});
```

---

## 7) Exercices pratiques (pas-à‑pas)
Exercice 1 — Hasher les mots de passe (30–45 min)
- Installer `bcrypt`.
- Remplacer `hashPassword()`/`verifyPassword()` dans `models/users.js`.
- Ajouter tests unitaires pour `createUser` et `verifyPassword`.

Exercice 2 — Remplacer le stockage par MongoDB (1–2h)
- Installer `mongoose`, créer `User`, `Profile`, `Request` schemas.
- Refactorer `models/*.js` pour appeler la DB au lieu des objets en mémoire.
- Mettre à jour routes et tests.

Exercice 3 — JWT expiration + refresh (45–60 min)
- Ajoute `expiresIn` pour le JWT.
- Implémente un endpoint `/api/auth/refresh` qui valide un refresh token stocké côté client.

---

## 8) Checklist production
- [ ] Migrate to persistent DB
- [ ] Password hashing (`bcrypt`)
- [ ] Token expiration + refresh
- [ ] Input validation
- [ ] Structured logging & monitoring
- [ ] HTTPS, helmet, CORS strict
- [ ] Containerization + CI/CD

---

Si tu veux, je peux implémenter **maintenant** un des exercices (par ex. `bcrypt` côté backend) et fournir les tests et la PR correspondante. Dites‑moi lequel et je le code directement.