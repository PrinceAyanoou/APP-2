const express = require('express');
const authMiddleware = require('../middleware/authMiddleware');
const { createRequest, getRequestById, getRequestsByUserId, updateRequest } = require('../models/requests');

const router = express.Router();

// POST /api/requests - Create new internship request
router.post('/', authMiddleware, (req, res) => {
  const { title, type } = req.body;

  if (!title || !type) {
    return res.status(400).json({ success: false, error: 'Title and type required' });
  }

  if (!['academic', 'professional'].includes(type)) {
    return res.status(400).json({ success: false, error: 'Type must be "academic" or "professional"' });
  }

  const request = createRequest(req.userId, title, type);

  res.status(201).json({
    success: true,
    data: request
  });
});

// GET /api/requests - Get all requests for current user
router.get('/', authMiddleware, (req, res) => {
  const requests = getRequestsByUserId(req.userId);

  res.json({
    success: true,
    data: requests
  });
});

// GET /api/requests/:id - Get request detail
router.get('/:id', authMiddleware, (req, res) => {
  const request = getRequestById(req.params.id);

  if (!request) {
    return res.status(404).json({ success: false, error: 'Request not found' });
  }

  // Check ownership
  if (request.userId !== req.userId) {
    return res.status(403).json({ success: false, error: 'Unauthorized' });
  }

  res.json({
    success: true,
    data: request
  });
});

// PUT /api/requests/:id - Update request status
router.put('/:id', authMiddleware, (req, res) => {
  const request = getRequestById(req.params.id);

  if (!request) {
    return res.status(404).json({ success: false, error: 'Request not found' });
  }

  // Check ownership
  if (request.userId !== req.userId) {
    return res.status(403).json({ success: false, error: 'Unauthorized' });
  }

  const updatedRequest = updateRequest(req.params.id, req.body);

  res.json({
    success: true,
    data: updatedRequest
  });
});

module.exports = router;
