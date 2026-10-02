import "dart:ui";
import "package:flutter/material.dart";

import "models/chat_models.dart";
import "pages/chats_page.dart";
import "pages/conversation_page.dart";
import "pages/calls_page.dart";
import "pages/channels_page.dart";
import "pages/settings_page.dart";

void main() {
  runApp(const NioooApp());
}

class NioooApp extends StatelessWidget {
  const NioooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "niooo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00E5FF),
          secondary: const Color(0xFF7C4DFF),
          surface: const Color(0xFF131B2E).withValues(alpha: 0.6),
        ),
        fontFamily: "Roboto",
        useMaterial3: true,
      ),
      home: const NioooMainScreen(),
    );
  }
}

class NioooMainScreen extends StatefulWidget {
  const NioooMainScreen({super.key});

  @override
  State<NioooMainScreen> createState() => _NioooMainScreenState();
}

class _NioooMainScreenState extends State<NioooMainScreen> {
  int _activeNavIndex = 0; // 0: Chats, 1: Calls, 2: Channels, 3: Settings
  bool _isChatOpen = false; // When true, hides the bottom navigation bar!

  // Active call overlay state
  bool _isCallActive = false;
  bool _isCallMuted = false;
  bool _isSpeakerOn = true;
  String _callingContactName = "";

  late ChatContact _activeContact;

  final List<ChatContact> _contacts = [
    ChatContact(
      id: "1",
      name: "Sophia Carter",
      handle: "@sophia",
      avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
      status: "online",
      isOnline: true,
      lastMessage: "The new bottom glass navigation looks amazing! 🔥",
      time: "10:42 AM",
      unreadCount: 2,
      isPinned: true,
    ),
    ChatContact(
      id: "2",
      name: "Flutter & AI Innovators",
      handle: "@flutter_ai_global",
      avatarUrl: "https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=150",
      status: "3,420 members • 182 online",
      isOnline: true,
      lastMessage: "Alex: Zero overflow responsive layouts configured!",
      time: "10:35 AM",
      unreadCount: 5,
      isGroup: true,
      isPinned: true,
    ),
    ChatContact(
      id: "3",
      name: "David Vance",
      handle: "@vance_dev",
      avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
      status: "typing...",
      isOnline: true,
      lastMessage: "Check out the soundwave audio player component.",
      time: "10:14 AM",
      unreadCount: 0,
    ),
    ChatContact(
      id: "4",
      name: "Elena Rostova",
      handle: "@elena_design",
      avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
      status: "last seen 15m ago",
      isOnline: false,
      lastMessage: "Loved the translucent glass buttons on dark mode!",
      time: "9:50 AM",
      unreadCount: 0,
    ),
    ChatContact(
      id: "5",
      name: "niooo Official Announcement",
      handle: "@niooo_news",
      avatarUrl: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=150",
      status: "Verified Channel",
      isOnline: true,
      lastMessage: "🚀 niooo v2.0 Released: Real-time End-to-End Encrypted Chat",
      time: "Yesterday",
      unreadCount: 0,
      isGroup: true,
    ),
    ChatContact(
      id: "6",
      name: "Marcus Thorne",
      handle: "@mthorne",
      avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150",
      status: "last seen 2h ago",
      isOnline: false,
      lastMessage: "Voice note received",
      time: "Yesterday",
      unreadCount: 0,
    ),
  ];

  late Map<String, List<ChatMessage>> _conversations;

  @override
  void initState() {
    super.initState();
    _activeContact = _contacts[0];

    _conversations = {
      "1": [
        ChatMessage(
          id: "m1",
          text: "Hey! Have you seen the new bottom navigation bar on niooo?",
          isMe: false,
          time: "10:38 AM",
        ),
        ChatMessage(
          id: "m2",
          text: "Yes! When inside chat it hides automatically to give maximum screen space.",
          isMe: true,
          time: "10:39 AM",
          isRead: true,
        ),
        ChatMessage(
          id: "m3",
          text: "Voice note with real-time waveform visualization is super responsive.",
          isMe: false,
          time: "10:40 AM",
          attachmentType: "audio",
        ),
        ChatMessage(
          id: "m4",
          text: "The new bottom glass navigation looks amazing! 🔥",
          isMe: false,
          time: "10:42 AM",
          reaction: "🔥",
        ),
      ],
      "2": [
        ChatMessage(
          id: "g1",
          text: "Welcome to Flutter & AI Innovators community!",
          isMe: false,
          time: "9:00 AM",
        ),
        ChatMessage(
          id: "g2",
          text: "Alex: Zero overflow responsive layouts configured!",
          isMe: false,
          time: "10:35 AM",
        ),
      ],
      "3": [
        ChatMessage(
          id: "d1",
          text: "Testing out the new glass input bar.",
          isMe: false,
          time: "10:10 AM",
        ),
        ChatMessage(
          id: "d2",
          text: "Check out the soundwave audio player component.",
          isMe: false,
          time: "10:14 AM",
        ),
      ],
      "4": [
        ChatMessage(
          id: "e1",
          text: "Loved the translucent glass buttons on dark mode!",
          isMe: false,
          time: "9:50 AM",
        ),
      ],
      "5": [
        ChatMessage(
          id: "c1",
          text: "🚀 niooo v2.0 Released: Real-time End-to-End Encrypted Chat",
          isMe: false,
          time: "Yesterday",
        ),
      ],
      "6": [
        ChatMessage(
          id: "m61",
          text: "Voice note received",
          isMe: false,
          time: "Yesterday",
          attachmentType: "audio",
        ),
      ],
    };
  }

  void _handleSendMessage(String text) {
    final newMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
      isRead: false,
    );

    setState(() {
      _conversations[_activeContact.id] ??= [];
      _conversations[_activeContact.id]!.add(newMsg);
    });

    // Auto-reply simulation
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        final replies = [
          "Got it! That looks super clean on niooo.",
          "Awesome! The bottom navigation auto-hiding is so smooth.",
          "Perfect! No text or icon overflows anywhere.",
          "✨ Received loud and clear.",
        ];
        final replyText = replies[DateTime.now().second % replies.length];

        setState(() {
          _conversations[_activeContact.id]!.add(
            ChatMessage(
              id: "reply_${DateTime.now().millisecondsSinceEpoch}",
              text: replyText,
              isMe: false,
              time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
              reaction: "❤️",
            ),
          );
        });
      }
    });
  }

  void _startCall(String name, bool isVideo) {
    setState(() {
      _isCallActive = true;
      _callingContactName = name;
      _isCallMuted = false;
      _isSpeakerOn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 880;

    // HIDE BOTTOM NAVIGATION BAR WHEN INSIDE CHAT DETAIL
    final bool hideBottomNav = (_activeNavIndex == 0 && _isChatOpen);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background ambient gradient glow orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00E5FF).withValues(alpha: 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 550,
              height: 550,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7C4DFF).withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Screen Body
          SafeArea(
            child: _buildBodyContent(isDesktop),
          ),

          // Modern Frosted Glass Bottom Navigation Bar (Hidden when inside chat!)
          if (!hideBottomNav) _buildGlassBottomNavBar(),

          // Active Call Overlay Modal
          if (_isCallActive) _buildActiveCallOverlay(),
        ],
      ),
    );
  }

  Widget _buildBodyContent(bool isDesktop) {
    if (_activeNavIndex == 1) {
      return CallsPage(onStartCall: _startCall);
    } else if (_activeNavIndex == 2) {
      return const ChannelsPage();
    } else if (_activeNavIndex == 3) {
      return const SettingsPage();
    }

    // Default: Tab 0 (Chats)
    if (isDesktop) {
      // On desktop, if chat is open, user can see split view or full conversation with back button
      if (_isChatOpen) {
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: ChatsPage(
                contacts: _contacts,
                activeContact: _activeContact,
                onSelectContact: (contact) {
                  setState(() {
                    _activeContact = contact;
                    _isChatOpen = true;
                  });
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: ConversationPage(
                contact: _activeContact,
                messages: _conversations[_activeContact.id] ?? [],
                onSendMessage: _handleSendMessage,
                onStartCall: _startCall,
                onBack: () => setState(() => _isChatOpen = false),
              ),
            ),
          ],
        );
      } else {
        return ChatsPage(
          contacts: _contacts,
          activeContact: _activeContact,
          onSelectContact: (contact) {
            setState(() {
              _activeContact = contact;
              _isChatOpen = true;
            });
          },
        );
      }
    } else {
      // Mobile / Tablet view
      if (_isChatOpen) {
        return ConversationPage(
          contact: _activeContact,
          messages: _conversations[_activeContact.id] ?? [],
          onSendMessage: _handleSendMessage,
          onStartCall: _startCall,
          onBack: () => setState(() => _isChatOpen = false),
        );
      } else {
        return ChatsPage(
          contacts: _contacts,
          activeContact: _activeContact,
          onSelectContact: (contact) {
            setState(() {
              _activeContact = contact;
              _isChatOpen = true;
            });
          },
        );
      }
    }
  }

  // Modern Floating Frosted Glass Bottom Navigation Bar
  Widget _buildGlassBottomNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomNavItem(0, Icons.chat_bubble_outline, Icons.chat_bubble, "Chats", badgeCount: 7),
                  _bottomNavItem(1, Icons.call_outlined, Icons.call, "Calls"),
                  _bottomNavItem(2, Icons.tag, Icons.tag, "Channels"),
                  _bottomNavItem(3, Icons.settings_outlined, Icons.settings, "Settings"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(int index, IconData outlineIcon, IconData filledIcon, String label, {int badgeCount = 0}) {
    final isSelected = _activeNavIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeNavIndex = index;
            _isChatOpen = false;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00E5FF).withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.45), width: 1.1)
                : Border.all(color: Colors.transparent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? filledIcon : outlineIcon,
                    color: isSelected ? const Color(0xFF00E5FF) : Colors.white60,
                    size: 21,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -3,
                      right: -7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1.2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$badgeCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF00E5FF) : Colors.white54,
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Active Calling Overlay Modal
  Widget _buildActiveCallOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 360,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: const Color(0xFF10172A).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4), width: 3),
                          ),
                        ),
                        CircleAvatar(
                          radius: 42,
                          backgroundImage: NetworkImage(_activeContact.avatarUrl),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _callingContactName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "niooo Encrypted HD Call • 00:38",
                      style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _callCircleButton(
                          icon: _isCallMuted ? Icons.mic_off : Icons.mic,
                          isActive: _isCallMuted,
                          onTap: () => setState(() => _isCallMuted = !_isCallMuted),
                        ),
                        const SizedBox(width: 18),
                        _callCircleButton(
                          icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                          isActive: _isSpeakerOn,
                          onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () => setState(() => _isCallActive = false),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                                  blurRadius: 14,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.call_end, color: Colors.white, size: 26),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _callCircleButton({required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
