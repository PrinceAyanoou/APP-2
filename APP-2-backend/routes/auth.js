const express = require('express');
const jwt = require('jsonwebtoken');
const authMiddleware = require('../middleware/authMiddleware');
const { createUser, getUserByEmail, verifyPassword } = require('../models/users');
const { createProfile } = require('../models/profiles');

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'app2-secret';

// Generate JWT token
const generateToken = (userId, email) => {
  return jwt.sign({ userId, email }, JWT_SECRET, { expiresIn: '30d' });
};

// POST /api/auth/signup
router.post('/signup', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, error: 'Email and password required' });
  }

  if (getUserByEmail(email)) {
    return res.status(409).json({ success: false, error: 'Email already exists' });
  }

  const user = createUser(email, password);
  createProfile(user.id); // Also create empty profile

  const token = generateToken(user.id, user.email);

  res.status(201).json({
    success: true,
    data: {
      token,
      user: { id: user.id, email: user.email }
    }
  });
});

// POST /api/auth/login
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, error: 'Email and password required' });
  }

  const user = getUserByEmail(email);
  if (!user) {
    return res.status(401).json({ success: false, error: 'Invalid email or password' });
  }

  if (!verifyPassword(password, user.passwordHash)) {
    return res.status(401).json({ success: false, error: 'Invalid email or password' });
  }

  const token = generateToken(user.id, user.email);

  res.json({
    success: true,
    data: {
      token,
      user: { id: user.id, email: user.email }
    }
  });
});

// GET /api/auth/me
router.get('/me', authMiddleware, (req, res) => {
  res.json({
    success: true,
    data: {
      id: req.user.id,
      email: req.user.email
    }
  });
});

module.exports = router;
