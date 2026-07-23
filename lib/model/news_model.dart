import 'package:flutter/material.dart';

class NewsArticle {
  final int id;
  final String title;
  final String description;
  final String body;
  final String image;
  final String source;
  final String sourceInitial;
  final Color sourceColor;
  final String timeAgo;
  final String views;
  final String category;
  final String comments;
  final String link; 

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    required this.image,
    required this.source,
    required this.sourceInitial,
    required this.sourceColor,
    required this.timeAgo,
    required this.views,
    required this.category,
    required this.comments,
    this.link = '',
  });
}