import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chat_bubble.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  ChatMessage(this.text, this.isUser, this.time);
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  int? _conversationId;

  final List<String> _quickQuestions = [
    'كيف ألغي حجزي؟',
    'ما هي طرق الدفع المتاحة؟',
    'هل يمكن تعديل تاريخ الرحلة؟',
    'أين أجد سجل حجوزاتي؟',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      'مرحبًا بك! 👋 أنا مساعدك الذكي في رحلاتي. كيف يمكنني مساعدتك اليوم؟',
      false,
      DateTime.now(),
    ));
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isTyping = true);
    try {
      final history = await ApiService.getChatHistory();
      if (history.isNotEmpty) {
        final activeConv = history.first;
        final conversationId = activeConv['id'] as int;
        
        final List<dynamic> msgs = activeConv['messages'] is String 
            ? jsonDecode(activeConv['messages']) 
            : activeConv['messages'];
        final List<ChatMessage> loadedMessages = [];
        
        for (var m in msgs) {
          final content = m['content'] as String;
          final role = m['role'] as String;
          final isUser = role == 'user';
          
          DateTime time = DateTime.now();
          if (m['timestamp'] != null) {
            try {
              time = DateTime.parse(m['timestamp']);
            } catch (_) {}
          }
          loadedMessages.add(ChatMessage(content, isUser, time));
        }
        
        if (!mounted) return;
        setState(() {
          _conversationId = conversationId;
          _messages.clear();
          _messages.addAll(loadedMessages);
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Failed to load chat history: $e');
    } finally {
      if (mounted) {
        setState(() => _isTyping = false);
      }
    }
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? quickText]) async {
    final text = (quickText ?? _controller.text).trim();
    if (text.isEmpty) return;

    final user = await SessionService.getUser();

    setState(() {
      _messages.add(ChatMessage(text, true, DateTime.now()));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await ApiService.sendChatMessage(
        message: text,
        userId: user?.id,
        conversationId: _conversationId,
      );
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(response.reply, false, DateTime.now()));
        _conversationId = response.conversationId;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage('تعذر الاتصال بالخادم، حاول مرة أخرى.', false, DateTime.now()));
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F5),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مساعد رحلاتي الذكي', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    _StatusDot(),
                    SizedBox(width: 5),
                    Text('متصل الآن', style: TextStyle(fontSize: 11, color: AppColors.success)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'محادثة جديدة',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _messages.clear();
                _conversationId = null;
                _messages.add(ChatMessage(
                  'مرحبًا من جديد! كيف أقدر أساعدك؟ 😊',
                  false,
                  DateTime.now(),
                ));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) return const TypingBubble();
                final msg = _messages[index];
                return ChatBubble(text: msg.text, isUser: msg.isUser, time: _formatTime(msg.time));
              },
            ),
          ),

          // اقتراحات أسئلة سريعة
          if (_messages.length <= 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _quickQuestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final q = _quickQuestions[index];
                    return ActionChip(
                      label: Text(q, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.border),
                      onPressed: () => _sendMessage(q),
                    );
                  },
                ),
              ),
            ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_outlined, color: AppColors.textGrey),
                    onPressed: () {},
                    tooltip: 'إرفاق ملف',
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
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

class _StatusDot extends StatefulWidget {
  const _StatusDot();

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        width: 7, height: 7,
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.5 + _controller.value * 0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
