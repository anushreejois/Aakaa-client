import jwt from 'jsonwebtoken';

const auth = (req, res, next) => {
  try {
    const authHeader = req.header('Authorization');
    
    if (!authHeader) {
      return res.status(401).json({
        status: 'error',
        message: 'No authorization token, access denied.'
      });
    }

    const token = authHeader.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({
        status: 'error',
        message: 'Authorization token is malformed, access denied.'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'aakaa_super_secret_jwt_key_2026');
    
    req.userId = decoded.id;
    next();
  } catch (err) {
    res.status(401).json({
      status: 'error',
      message: 'Token verification failed, authorization denied.'
    });
  }
};

export default auth;
