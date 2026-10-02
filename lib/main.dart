import "dart:ui";
import "package:flutter/material.dart";

import "models/chat_models.dart";
import "widgets/glass_container.dart";
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
  bool _mobileShowChatDetail = false;

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
      lastMessage: "The new niooo glassmorphism UI looks unbelievable! 🔥",
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
      lastMessage: "Alex: We just merged the modular pages architecture!",
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
          text: "Hey! Have you seen the modular glass pages on niooo?",
          isMe: false,
          time: "10:38 AM",
        ),
        ChatMessage(
          id: "m2",
          text: "Yes! Each page is in its own separate file with frosted glass aesthetics.",
          isMe: true,
          time: "10:39 AM",
          isRead: true,
        ),
        ChatMessage(
          id: "m3",
          text: "Voice note with real-time audio soundwave is super responsive.",
          isMe: false,
          time: "10:40 AM",
          attachmentType: "audio",
        ),
        ChatMessage(
          id: "m4",
          text: "The new niooo glassmorphism UI looks unbelievable! 🔥",
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
          text: "Alex: We just merged the modular pages architecture!",
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

    // Auto-reply
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final replies = [
          "Got it! That looks super clean on niooo.",
          "Awesome! The glassmorphism effect is so responsive.",
          "Perfect! Love the modular architecture.",
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
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      body: Stack(
        children: [
          // Background ambient gradient glow
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
                    const Color(0xFF00E5FF).withValues(alpha: 0.15),
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
                    const Color(0xFF7C4DFF).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Row(
              children: [
                // Glass Left Navigation Rail
                _buildGlassNavRail(),

                // Dynamic Body Content
                Expanded(
                  child: _buildBodyContent(isDesktop),
                ),
              ],
            ),
          ),

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

    // Default: Chats
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            flex: 4,
            child: ChatsPage(
              contacts: _contacts,
              activeContact: _activeContact,
              onSelectContact: (contact) {
                setState(() => _activeContact = contact);
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
            ),
          ),
        ],
      );
    } else {
      // Mobile adaptive view
      if (_mobileShowChatDetail) {
        return ConversationPage(
          contact: _activeContact,
          messages: _conversations[_activeContact.id] ?? [],
          onSendMessage: _handleSendMessage,
          onStartCall: _startCall,
          onBack: () => setState(() => _mobileShowChatDetail = false),
        );
      } else {
        return ChatsPage(
          contacts: _contacts,
          activeContact: _activeContact,
          onSelectContact: (contact) {
            setState(() {
              _activeContact = contact;
              _mobileShowChatDetail = true;
            });
          },
        );
      }
    }
  }

  // Left Slim Glass Navigation Rail
  Widget _buildGlassNavRail() {
    return Container(
      width: 72,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF10172A).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Column(
            children: [
              const SizedBox(height: 18),
              // niooo brand logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "n",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      fontFamily: "monospace",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Nav Buttons
              _navButton(0, Icons.chat_bubble_outline, Icons.chat_bubble, "Chats"),
              const SizedBox(height: 16),
              _navButton(1, Icons.call_outlined, Icons.call, "Calls"),
              const SizedBox(height: 16),
              _navButton(2, Icons.tag, Icons.tag, "Channels"),
              const SizedBox(height: 16),
              _navButton(3, Icons.settings_outlined, Icons.settings, "Settings"),

              const Spacer(),

              // User profile avatar in rail
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(int index, IconData outlineIcon, IconData filledIcon, String tooltip) {
    final isSelected = _activeNavIndex == index;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeNavIndex = index;
            _mobileShowChatDetail = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00E5FF).withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.5), width: 1.2)
                : Border.all(color: Colors.transparent),
          ),
          child: Icon(
            isSelected ? filledIcon : outlineIcon,
            color: isSelected ? const Color(0xFF00E5FF) : Colors.white60,
            size: 24,
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
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF10172A).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                    blurRadius: 32,
                    spreadRadius: 4,
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
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4), width: 3),
                        ),
                      ),
                      CircleAvatar(
                        radius: 46,
                        backgroundImage: NetworkImage(_activeContact.avatarUrl),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _callingContactName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "niooo Encrypted HD Call • 00:38",
                    style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13),
                  ),
                  const SizedBox(height: 36),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _callCircleButton(
                        icon: _isCallMuted ? Icons.mic_off : Icons.mic,
                        isActive: _isCallMuted,
                        onTap: () => setState(() => _isCallMuted = !_isCallMuted),
                      ),
                      const SizedBox(width: 20),
                      _callCircleButton(
                        icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                        isActive: _isSpeakerOn,
                        onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => setState(() => _isCallActive = false),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 28),
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
    );
  }

  Widget _callCircleButton({required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
