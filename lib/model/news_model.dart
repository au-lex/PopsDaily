import 'package:flutter/material.dart';

class NewsArticle {
  final String title;
  final String description;
  final String body;
  final String source;
  final String sourceInitial;
  final Color sourceColor;
  final String timeAgo;
  final String views;
  final String comments;
  final String image;
  final String category;
  final bool isBookmarked; 

  const NewsArticle({
    required this.title,
    required this.description,
    required this.body,
    required this.source,
    required this.sourceInitial,
    required this.sourceColor,
    required this.timeAgo,
    required this.views,
    required this.comments,
    required this.image,
    required this.category,
    this.isBookmarked = false,
  });
}