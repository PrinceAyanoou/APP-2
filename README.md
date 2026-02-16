# APP-2 — Application de gestion de demandes de stage

Un prototype full‑stack (frontend Flutter + backend Express) pour gérer des demandes de stage — conçu comme MVP pour développement et démonstration.

---

## ✅ Fonctionnalités clés
- Inscription / connexion (JWT)
- Profil utilisateur (sections : personnel, académique, professionnel)
- Indicateur de complétude du profil (100% requis pour postuler)
- Gestion des demandes de stage (créer, lister, voir statut)
- Données persistées en mémoire côté serveur (MVP)

---

## 🛠️ Stack technique
- Frontend : Flutter (Material 3) — Web + mobile-ready
- Backend : Node.js + Express (REST API)
- Auth : JWT (Bearer)
- Stockage : en mémoire (simple, pour MVP)

---

## 🚀 Démarrage rapide (dev — Windows)
1) Backend
```powershell
cd c:\APP-2-backend
npm install
npm start
# -> API disponible sur http://localhost:5000
```

2) Frontend
```powershell
cd c:\APP-2
flutter pub get
flutter run -d chrome
```

Configuration importante
- `API_BASE_URL` (frontend) : `lib/services/api.dart` → `http://localhost:5000/api`

---

## 📌 Endpoints API (résumé)
- POST `/api/auth/signup` — body: `{ email, password }`
- POST `/api/auth/login` — body: `{ email, password }` (retourne token)
- GET `/api/auth/me` — header `Authorization: Bearer <token>`
- GET/PUT `/api/profile` — profil utilisateur
- GET/POST `/api/requests` — lister / créer demandes
- GET/PUT `/api/requests/:id` — détail / mise à jour

Exemple cURL — signup
```bash
curl -X POST http://localhost:5000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'
```

---

## 🔎 Développement & architecture (où regarder)
- Frontend : `lib/` — pages UI (`lib/pages/`), modèles (`lib/models/`), client HTTP (`lib/services/api.dart`)
- Backend : `c:\APP-2-backend` — `server.js`, `routes/`, `models/`, `middleware/`
- État global (frontend) : `AppState` via `AppStateScope` (InheritedNotifier)

---

## ⚠️ Limitations (MVP)
- Mot de passe : hashing simplifié (remplacer par `bcrypt` en prod)
- Données : stockage en mémoire — perte au redémarrage
- Auth : JWT sans refresh/expiation (à améliorer pour production)

---

## 🧰 Débogage rapide
- Erreur "Failed to fetch" : vérifier que le backend `http://localhost:5000` est démarré.
- 401 Unauthorized : vérifier le header `Authorization` et la validité du token.
- Port occupé : `netstat -ano | findstr :5000` puis `taskkill /PID <pid> /F` (Windows).

---

## 📈 Roadmap / prochaines étapes
- Persister les données (MongoDB / PostgreSQL)
- Hasher les mots de passe avec `bcrypt`
- Ajouter expiration + refresh tokens
- Tests unitaires & e2e, CI/CD
- UI/UX polishing, validations avancées

---

## Contribuer
1. Fork → branche feature → PR
2. Écrire tests pour nouvelles fonctionnalités
3. Documenter les changements dans ce README

---

## Licence


---

Ce fichier a été redigé avec l'aide d'une IA


