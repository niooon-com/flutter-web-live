import "dart:ui";
import "package:flutter/material.dart";

import "models/chat_models.dart";
import "pages/chats_page.dart";
import "pages/conversation_page.dart";
import "pages/calls_page.dart";
import "pages/channels_page.dart";
import "pages/settings_page.dart";
import "widgets/fluid_glass_bottom_bar.dart";

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
        scaffoldBackgroundColor: const Color(0xFF0B141A),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00A884),
          secondary: const Color(0xFF25D366),
          surface: const Color(0xFF111B21).withValues(alpha: 0.8),
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
  int _activeNavIndex = 0; // 0: Chats, 1: Calls, 2: Updates, 3: Settings
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
      lastMessage: "The new WhatsApp 3D dark mode looks super premium! ✨",
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
      lastMessage: "Alex: 3D embossed buttons and emerald glass live!",
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
      lastMessage: "🚀 niooo v2.5: WhatsApp Dark Mode & 3D Glass UI",
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
          text: "Hey! Have you seen the new WhatsApp dark mode on niooo?",
          isMe: false,
          time: "10:38 AM",
        ),
        ChatMessage(
          id: "m2",
          text: "Yes! The emerald glass bubbles and 3D floating buttons look incredible.",
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
          text: "The new WhatsApp 3D dark mode looks super premium! ✨",
          isMe: false,
          time: "10:42 AM",
          reaction: "💚",
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
          text: "Alex: 3D embossed buttons and emerald glass live!",
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
          text: "🚀 niooo v2.5: WhatsApp Dark Mode & 3D Glass UI",
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
          "Super sleek! That 3D raised button feels tangible.",
          "The WhatsApp dark emerald colors are so comfortable on the eyes.",
          "Loved the drag-to-select fluid navigation!",
          "💚 End-to-end encrypted and lightning fast.",
        ];
        final replyText = replies[DateTime.now().second % replies.length];

        setState(() {
          _conversations[_activeContact.id]!.add(
            ChatMessage(
              id: "reply_${DateTime.now().millisecondsSinceEpoch}",
              text: replyText,
              isMe: false,
              time: "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
              reaction: "✨",
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
          // WhatsApp dark ambient emerald glows
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 480,
              height: 480,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00A884).withValues(alpha: 0.12),
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
                    const Color(0xFF005C4B).withValues(alpha: 0.16),
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

  // Modern Interactive Sliding Fluid Glass Bottom Navigation Bar
  Widget _buildGlassBottomNavBar() {
    return FluidGlassBottomBar(
      selectedIndex: _activeNavIndex,
      onTabSelected: (index) {
        setState(() {
          _activeNavIndex = index;
          _isChatOpen = false;
        });
      },
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
                  color: const Color(0xFF1F2C34).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: const Color(0xFF00A884).withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
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
                          width: 102,
                          height: 102,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.5), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00A884).withValues(alpha: 0.35),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 44,
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
                        color: Color(0xFFE9EDEF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "WhatsApp Encrypted HD Call • 00:38",
                      style: TextStyle(color: Color(0xFF25D366), fontSize: 12),
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
                              color: const Color(0xFFEA0038),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEA0038).withValues(alpha: 0.5),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
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
          color: isActive ? Colors.white : const Color(0xFF202C33),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.15),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF111B21) : const Color(0xFFE9EDEF),
          size: 22,
        ),
      ),
    );
  }
}
