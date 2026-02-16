// In-memory profile storage
const profiles = {};

const createProfile = (userId) => {
  profiles[userId] = {
    userId,
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    university: '',
    degree: '',
    gradYear: '',
    company: '',
    position: '',
    createdAt: new Date(),
    updatedAt: new Date()
  };
  return profiles[userId];
};

const getProfile = (userId) => {
  if (!profiles[userId]) {
    createProfile(userId);
  }
  return profiles[userId];
};

const updateProfile = (userId, data) => {
  if (!profiles[userId]) {
    createProfile(userId);
  }
  const allowedFields = ['firstName', 'lastName', 'email', 'phone', 'university', 'degree', 'gradYear', 'company', 'position'];
  allowedFields.forEach(field => {
    if (data[field] !== undefined) {
      profiles[userId][field] = data[field];
    }
  });
  profiles[userId].updatedAt = new Date();
  return profiles[userId];
};

module.exports = {
  profiles,
  createProfile,
  getProfile,
  updateProfile
};
