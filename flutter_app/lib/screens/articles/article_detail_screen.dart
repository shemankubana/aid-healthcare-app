import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/article.dart';
import 'package:intl/intl.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: article.imageUrl != null
                  ? Image.network(
                      article.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: AppColors.primaryBlue);
                      },
                    )
                  : Container(color: AppColors.primaryBlue),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.black,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        article.author,
                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('MMM d, yyyy').format(article.publishedDate),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    article.content,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          article.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: article.isLiked ? Colors.red : AppColors.black,
                        ),
                        onPressed: () {},
                      ),
                      Text('${article.likesCount} likes'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}