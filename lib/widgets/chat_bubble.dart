import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String? time;

  const ChatBubble({super.key, required this.text, required this.isUser, this.time});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      builder: (context, val, child) => Opacity(
        opacity: val,
        child: Transform.translate(offset: Offset(0, (1 - val) * 10), child: child),
      ),
      child: Align(
        alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(18),
                  topLeft: const Radius.circular(18),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                ),
                border: isUser ? null : Border.all(color: AppColors.border),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Text(text, style: TextStyle(color: isUser ? Colors.white : AppColors.textDark, height: 1.6, fontSize: 14)),
            ),
            if (time != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(time!, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
              ),
          ],
        ),
      ),
    );
  }
}

class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key});

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = List.generate(3, (i) {
    final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    Future.delayed(Duration(milliseconds: i * 150), () {
      if (mounted) c.repeat(reverse: true);
    });
    return c;
  });

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _controllers[i],
              builder: (context, child) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.35 + _controllers[i].value * 0.65),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
