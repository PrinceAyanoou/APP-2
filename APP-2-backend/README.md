# APP-2 Backend API

Express.js backend (MVP) pour l'application APP-2 — gestion des utilisateurs, profils et demandes de stage.

Résumé rapide
- Serveur REST simple (port 5000)
- Auth: JWT (Bearer)
- Stockage: en mémoire (reset au redémarrage) — idéal pour tests locaux

Démarrage local
1. Ouvrir un terminal dans `c:\APP-2-backend`
2. npm install
3. npm start

Le serveur écoute par défaut sur: http://localhost:5000

Endpoints principaux (résumé)
- Auth: POST `/api/auth/signup`, POST `/api/auth/login`, GET `/api/auth/me`
- Profile: GET/PUT `/api/profile`
- Requests: POST `/api/requests`, GET `/api/requests`, GET/PUT `/api/requests/:id`

Format des réponses
- JSON `{ success: boolean, data?: any, error?: string }`

Intégration frontend
- Le frontend Flutter utilise `http://localhost:5000/api` (voir `lib/services/api.dart`)
- En dev le serveur accepte les requêtes cross-origin (CORS permissif)

Exemples rapides (cURL)
```bash
# créer un compte
curl -X POST http://localhost:5000/api/auth/signup -H "Content-Type: application/json" -d '{"email":"user@example.com","password":"pass"}'

# se logger
curl -X POST http://localhost:5000/api/auth/login -H "Content-Type: application/json" -d '{"email":"user@example.com","password":"pass"}'

# récupérer profil (avec token)
curl -H "Authorization: Bearer <TOKEN>" http://localhost:5000/api/profile
```

Dépannage courant
- Erreur `EADDRINUSE` au démarrage : un autre process utilise le port 5000.
  - Vérifier : `netstat -ano | findstr :5000`
  - Tuer le process : `taskkill /PID <pid> /F`
- Frontend affiche `Failed to fetch` : vérifier que le backend tourne et que l'URL dans `lib/services/api.dart` pointe bien sur `http://localhost:5000/api`.

Limitations & prochaines étapes
- Données en mémoire → ajouter une vraie base (Mongo/Postgres)
- JWT sans expiration pour MVP → ajouter expiration / refresh tokens
- Ajouter validation côté backend, tests unitaires et e2e

---
(c) APP-2 — Backend
