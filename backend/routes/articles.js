const express = require('express');
const router = express.Router();
const { getAllArticles, getArticleById, createArticle } = require('../controllers/articleController');
const auth = require('../middleware/auth');

router.get('/', auth, getAllArticles);
router.get('/:id', auth, getArticleById);
router.post('/', createArticle);

module.exports = router;