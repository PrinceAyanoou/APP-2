// In-memory user storage (password hashed with simple hash for MVP)
const users = {};
let nextUserId = 1;

const hashPassword = (password) => {
  // Simple hash for MVP (NOT secure for production)
  return Buffer.from(password).toString('base64');
};

const verifyPassword = (password, hash) => {
  return hashPassword(password) === hash;
};

const generateUserId = () => {
  return `user_${nextUserId++}`;
};

const createUser = (email, password) => {
  const id = generateUserId();
  users[id] = {
    id,
    email,
    passwordHash: hashPassword(password),
    createdAt: new Date()
  };
  return users[id];
};

const getUserByEmail = (email) => {
  return Object.values(users).find(u => u.email === email);
};

const getUserById = (id) => {
  return users[id];
};

module.exports = {
  users,
  createUser,
  getUserByEmail,
  getUserById,
  verifyPassword,
  hashPassword
};
