const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const { getProfile, updateProfile } = require('../models/profiles');

const router = express.Router();

// GET /api/profile
router.get('/', authMiddleware, (req, res) => {
  const profile = getProfile(req.userId);

  res.json({
    success: true,
    data: profile
  });
});

// PUT /api/profile
router.put('/', authMiddleware, (req, res) => {
  const profile = updateProfile(req.userId, req.body);

  res.json({
    success: true,
    data: profile
  });
});

module.exports = router;
