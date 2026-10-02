import "dart:ui";
import "package:flutter/material.dart";

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

// Data Models
class ChatContact {
  final String id;
  final String name;
  final String handle;
  final String avatarUrl;
  final String status;
  final bool isOnline;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isGroup;
  final bool isPinned;

  ChatContact({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.status,
    required this.isOnline,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.isGroup = false,
    this.isPinned = false,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final String? replyTo;
  final String? attachmentType; // 'image', 'audio', null
  final String? reaction;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
    this.replyTo,
    this.attachmentType,
    this.reaction,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    String? time,
    bool? isRead,
    String? replyTo,
    String? attachmentType,
    String? reaction,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      replyTo: replyTo ?? this.replyTo,
      attachmentType: attachmentType ?? this.attachmentType,
      reaction: reaction ?? this.reaction,
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
  String _selectedCategory = "All";
  String _searchQuery = "";
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // Active call modal state
  bool _isCallActive = false;
  bool _isCallMuted = false;
  bool _isSpeakerOn = true;
  String _callingContactName = "";

  // Currently selected contact
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
      lastMessage: "Alex: We just merged the WASM Flutter 3.29 update!",
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
          text: "Hey! Have you seen the updated dark glass interface for niooo?",
          isMe: false,
          time: "10:38 AM",
        ),
        ChatMessage(
          id: "m2",
          text: "Yes! The frosted glass blur and cyan accents look phenomenal.",
          isMe: true,
          time: "10:39 AM",
          isRead: true,
        ),
        ChatMessage(
          id: "m3",
          text: "Voice notes with real-time waveform visualization are so smooth.",
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
          text: "We just merged the WASM Flutter 3.29 update!",
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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

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
      _messageController.clear();
    });

    // Auto scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate smart reply from contact after 1 second
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final replies = [
          "Got it! That looks super clean on niooo.",
          "Awesome! The glassmorphism effect is so responsive.",
          "Perfect! Love the instant delivery tick.",
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_chatScrollController.hasClients) {
            _chatScrollController.animateTo(
              _chatScrollController.position.maxScrollExtent + 80,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _startCall(String contactName, bool isVideo) {
    setState(() {
      _isCallActive = true;
      _callingContactName = contactName;
      _isCallMuted = false;
      _isSpeakerOn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

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

          // Main App Container
          SafeArea(
            child: Row(
              children: [
                // Glass Left Navigation Rail
                _buildGlassNavRail(),

                // Chat List Column
                Expanded(
                  flex: isDesktop ? 4 : 10,
                  child: _buildChatListSection(),
                ),

                // Active Conversation Section (on Desktop/Tablet)
                if (isDesktop)
                  Expanded(
                    flex: 7,
                    child: _buildConversationSection(),
                  ),
              ],
            ),
          ),

          // Calling Modal Overlay
          if (_isCallActive) _buildActiveCallOverlay(),
        ],
      ),
    );
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

              // Nav Icons
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

  // Middle/Left Chat List Section
  Widget _buildChatListSection() {
    final filteredContacts = _contacts.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedCategory == "Unread") return c.unreadCount > 0;
      if (_selectedCategory == "Groups") return c.isGroup;
      if (_selectedCategory == "Direct") return !c.isGroup;
      return true;
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1526).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title & Action
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                child: Row(
                  children: [
                    const Text(
                      "niooo",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
                      ),
                      child: const Text(
                        "PRO",
                        style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // New Chat Glass Button
                    _glassIconButton(
                      icon: Icons.edit_note,
                      tooltip: "New Chat",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Search conversations, people...",
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Colors.white54, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Stories / Status Row (WhatsApp / Telegram style)
              _buildStoriesRow(),

              const SizedBox(height: 12),

              // Filter Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _categoryChip("All"),
                      _categoryChip("Unread"),
                      _categoryChip("Direct"),
                      _categoryChip("Groups"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Chat List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    final isSelected = contact.id == _activeContact.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00E5FF).withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.3))
                            : Border.all(color: Colors.transparent),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _activeContact = contact;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(contact.avatarUrl),
                            ),
                            if (contact.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF090D16), width: 2.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.6),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                contact.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              contact.time,
                              style: TextStyle(
                                color: contact.unreadCount > 0 ? const Color(0xFF00E5FF) : Colors.white38,
                                fontSize: 11,
                                fontWeight: contact.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  contact.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white70 : Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (contact.unreadCount > 0)
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${contact.unreadCount}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stories row on top of chat list
  Widget _buildStoriesRow() {
    return SizedBox(
      height: 78,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // My status add button
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150",
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E5FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.black, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text("My Story", style: TextStyle(color: Colors.white60, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 14),

          // Other stories
          for (var i = 0; i < 4; i++) ...[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF), Color(0xFFFF2A85)],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF090D16),
                    ),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(_contacts[i].avatarUrl),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _contacts[i].name.split(" ")[0],
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }

  Widget _categoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00E5FF).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E5FF).withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00E5FF) : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Right Full Glass Conversation View
  Widget _buildConversationSection() {
    final messages = _conversations[_activeContact.id] ?? [];

    return Container(
      margin: const EdgeInsets.fromLTRB(6, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            children: [
              // Top Chat Header
              _buildConversationHeader(),

              const Divider(height: 1, color: Colors.white10),

              // Chat Messages Stream
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),

              // Bottom Glass Input Bar
              _buildGlassInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  // Header of the active chat
  Widget _buildConversationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white.withValues(alpha: 0.03),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(_activeContact.avatarUrl),
              ),
              if (_activeContact.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0F172A), width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _activeContact.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _activeContact.status,
                  style: TextStyle(
                    color: _activeContact.isOnline ? const Color(0xFF00E5FF) : Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Glass Action Buttons (Audio call, Video call, Options)
          _glassIconButton(
            icon: Icons.phone_outlined,
            tooltip: "Voice Call",
            onTap: () => _startCall(_activeContact.name, false),
          ),
          const SizedBox(width: 8),
          _glassIconButton(
            icon: Icons.videocam_outlined,
            tooltip: "Video Call",
            onTap: () => _startCall(_activeContact.name, true),
          ),
          const SizedBox(width: 8),
          _glassIconButton(
            icon: Icons.more_vert,
            tooltip: "More Options",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Chat Bubble
  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          // Sent: Radiant modern gradient; Received: Translucent frosted glass
          gradient: msg.isMe
              ? const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: msg.isMe ? null : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isMe ? 18 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 18),
          ),
          border: Border.all(
            color: msg.isMe
                ? const Color(0xFF38BDF8).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Audio message waveform preview
                  if (msg.attachmentType == "audio") ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00E5FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                for (var bar in [14, 22, 10, 26, 18, 12, 28, 20, 16, 24, 8, 18])
                                  Container(
                                    width: 3,
                                    height: bar.toDouble(),
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text("0:24 • Voice Note", style: TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Text content
                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Bottom info: Timestamp + Ticks + Reaction
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (msg.reaction != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg.reaction!, style: const TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        msg.time,
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                      if (msg.isMe) ...[
                        const SizedBox(width: 5),
                        Icon(
                          Icons.done_all,
                          size: 15,
                          color: msg.isRead ? const Color(0xFF38BDF8) : Colors.white38,
                        ),
                      ],
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

  // Bottom Glass Input Bar
  Widget _buildGlassInputBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // Emoji Button
          _glassIconButton(
            icon: Icons.sentiment_satisfied_alt_outlined,
            tooltip: "Emoji",
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Attachment Button
          _glassIconButton(
            icon: Icons.attach_file,
            tooltip: "Attach Document/Media",
            onTap: () {},
          ),
          const SizedBox(width: 10),

          // Text Field Container
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Center(
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Write a message in niooo...",
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Voice Note / Mic Button
          _glassIconButton(
            icon: Icons.mic_none,
            tooltip: "Voice Note",
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Glowing Glass Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Active Calling Overlay (Glass Dialog)
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

                  // Call Control Buttons
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
                      // End Call
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

  // Reusable Glass Icon Button
  Widget _glassIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }
}
