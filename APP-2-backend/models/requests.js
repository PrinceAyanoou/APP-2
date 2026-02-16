// In-memory internship requests storage
const internshipRequests = {};
let nextRequestId = 1;

const generateRequestId = () => {
  return `req_${nextRequestId++}`;
};

const createRequest = (userId, title, type) => {
  const id = generateRequestId();
  internshipRequests[id] = {
    id,
    userId,
    title,
    type, // 'academic' or 'professional'
    status: 'En cours',
    createdAt: new Date(),
    updatedAt: new Date()
  };
  return internshipRequests[id];
};

const getRequestById = (id) => {
  return internshipRequests[id];
};

const getRequestsByUserId = (userId) => {
  return Object.values(internshipRequests).filter(req => req.userId === userId);
};

const updateRequest = (id, data) => {
  if (!internshipRequests[id]) {
    return null;
  }
  const allowedFields = ['status'];
  allowedFields.forEach(field => {
    if (data[field] !== undefined) {
      internshipRequests[id][field] = data[field];
    }
  });
  internshipRequests[id].updatedAt = new Date();
  return internshipRequests[id];
};

module.exports = {
  internshipRequests,
  createRequest,
  getRequestById,
  getRequestsByUserId,
  updateRequest
};
