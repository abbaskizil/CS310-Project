import 'package:flutter/material.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final now = DateTime.now();
    setState(() {
      _messages.add(
        ChatMessage(
          text: "Welcome to the AthleTech AI coach.\n\nHow can I help you?",
          isUser: false,
          time: _formatTime(now),
        ),
      );
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final now = DateTime.now();
      final userMessage = _messageController.text;

      setState(() {
        _messages.add(
          ChatMessage(
            text: userMessage,
            isUser: true,
            time: _formatTime(now),
          ),
        );
        _messageController.clear();
      });

      fetchApiResponse(userMessage).then((apiResponse) {
        final responseTime = DateTime.now();
        setState(() {
          _messages.add(
            ChatMessage(
              text: apiResponse,
              isUser: false,
              time: _formatTime(responseTime),
            ),
          );
        });
      });
    }
  }

  Future<String> fetchApiResponse(String userMessage) async {
    final url = Uri.parse("https://api.kluster.ai/v1/chat/completions");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer 439fae59-866f-42b9-ac8e-6749c831ea53", // ← Buraya kendi API key’ini yaz
        },
        body: json.encode({
          "model": "klusterai/Meta-Llama-3.1-8B-Instruct-Turbo",
          "messages": [
            {
              "role": "user",
              "content": userMessage + " keep it short",
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["choices"][0]["message"]["content"] ?? "No response.";
      } else {
        return "Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Failed to reach server: $e";
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/coach.png'),
                radius: 20,
              ),
              const SizedBox(width: 12),
              const Text('AthleTech Coach'),
            ],
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: AppPaddings.all12,
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages.reversed.toList()[index];
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: "Message...",
                border: InputBorder.none,
                contentPadding: AppPaddings.onlyLeft12,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final String time;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isUser ? AppColors.send : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
                bottomLeft: Radius.circular(isUser ? 12.0 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 12.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(color: isUser ? Colors.white : Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
