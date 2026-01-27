import 'package:flutter_riverpod/flutter_riverpod.dart';

class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});
}

class QuoteService {
  final List<Quote> _quotes = const [
    Quote(
        text: "The only way to do great work is to love what you do.",
        author: "Steve Jobs"),
    Quote(
        text: "Believe you can and you're halfway there.",
        author: "Theodore Roosevelt"),
    Quote(
        text:
            "Your time is limited, don't waste it living someone else's life.",
        author: "Steve Jobs"),
    Quote(
        text:
            "Success is not final, failure is not fatal: it is the courage to continue that counts.",
        author: "Winston Churchill"),
    Quote(
        text:
            "It does not matter how slowly you go as long as you do not stop.",
        author: "Confucius"),
    Quote(
        text: "Everything you've ever wanted is on the other side of fear.",
        author: "George Addair"),
    Quote(text: "Success fails to those who dare AND act.", author: "Unknown"),
    Quote(
        text:
            "You are never too old to set another goal or to dream a new dream.",
        author: "C.S. Lewis"),
    Quote(
        text:
            "The future belongs to those who believe in the beauty of their dreams.",
        author: "Eleanor Roosevelt"),
    Quote(
        text: "Don't watch the clock; do what it does. Keep going.",
        author: "Sam Levenson"),
    Quote(text: "Quality is not an act, it is a habit.", author: "Aristotle"),
    Quote(
        text:
            "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
        author: "Aristotle"),
    Quote(
        text: "The secret of getting ahead is getting started.",
        author: "Mark Twain"),
    Quote(
        text: "Small daily improvements over time lead to stunning results.",
        author: "Robin Sharma"),
    Quote(
        text:
            "What you get by achieving your goals is not as important as what you become by achieving your goals.",
        author: "Zig Ziglar"),
    Quote(
        text:
            "Motivation is what gets you started. Habit is what keeps you going.",
        author: "Jim Ryun"),
    Quote(
        text: "First we make our habits, then our habits make us.",
        author: "John Dryden"),
    Quote(
        text:
            "Discipline is choosing between what you want now and what you want most.",
        author: "Abraham Lincoln"),
    Quote(
        text:
            "The difference between who you are and who you want to be is what you do.",
        author: "Unknown"),
    Quote(
        text:
            "Success is the sum of small efforts, repeated day in and day out.",
        author: "Robert Collier"),
  ];

  /// Get a random quote based on the current day
  Quote getDailyQuote() {
    final dayOfYear = int.parse(
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}");
    final index = dayOfYear % _quotes.length;
    return _quotes[index];
  }
}

final quoteServiceProvider = Provider<QuoteService>((ref) {
  return QuoteService();
});

final dailyQuoteProvider = Provider<Quote>((ref) {
  final service = ref.watch(quoteServiceProvider);
  return service.getDailyQuote();
});
