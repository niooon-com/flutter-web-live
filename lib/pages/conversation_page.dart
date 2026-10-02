import "dart:ui";
import "package:flutter/material.dart";
import "../models/chat_models.dart";
import "../widgets/glass_container.dart";

class ConversationPage extends StatefulWidget {
  final ChatContact contact;
  final List<ChatMessage> messages;
  final Function(String) onSendMessage;
  final Function(String, bool) onStartCall;
  final VoidCallback onBack;

  const ConversationPage({
    super.key,
    required this.contact,
    required this.messages,
    required this.onSendMessage,
    required this.onStartCall,
    required this.onBack,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showAttachmentMenu = false;

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    widget.onSendMessage(text);
    _textController.clear();
    setState(() => _showAttachmentMenu = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      borderRadius: 20,
      child: Column(
        children: [
          // Conversation Header
          _buildHeader(),

          const Divider(height: 1, color: Colors.white10),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Attachment popup menu if open
          if (_showAttachmentMenu) _buildAttachmentMenu(),

          // Glass Input Bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.white.withValues(alpha: 0.03),
      child: Row(
        children: [
          // Prominent Back Button to exit chat and show bottom navigation
          GlassIconButton(
            icon: Icons.arrow_back_ios_new,
            tooltip: "Back to Chats",
            size: 36,
            onTap: widget.onBack,
          ),
          const SizedBox(width: 8),

          // Avatar + Online indicator
          Stack(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundImage: NetworkImage(widget.contact.avatarUrl),
              ),
              if (widget.contact.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0F172A), width: 1.8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),

          // Name & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.contact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  widget.contact.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.contact.isOnline ? const Color(0xFF00E5FF) : Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Header Call Actions
          GlassIconButton(
            icon: Icons.phone_outlined,
            tooltip: "Voice Call",
            size: 34,
            onTap: () => widget.onStartCall(widget.contact.name, false),
          ),
          const SizedBox(width: 6),
          GlassIconButton(
            icon: Icons.videocam_outlined,
            tooltip: "Video Call",
            size: 34,
            onTap: () => widget.onStartCall(widget.contact.name, true),
          ),
          const SizedBox(width: 6),
          GlassIconButton(
            icon: Icons.more_vert,
            tooltip: "Options",
            size: 34,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.76;

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth.clamp(200.0, 420.0)),
        decoration: BoxDecoration(
          gradient: msg.isMe
              ? const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: msg.isMe ? null : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 16),
          ),
          border: Border.all(
            color: msg.isMe
                ? const Color(0xFF38BDF8).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Audio message waveform preview
                  if (msg.attachmentType == "audio") ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00E5FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.black, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var bar in [12, 18, 8, 22, 16, 10, 24, 16, 14, 20])
                                    Container(
                                      width: 2.5,
                                      height: bar.toDouble(),
                                      margin: const EdgeInsets.symmetric(horizontal: 1.2),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text("0:24 • Voice Note", style: TextStyle(color: Colors.white54, fontSize: 10.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],

                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (msg.reaction != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(msg.reaction!, style: const TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        msg.time,
                        style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                      ),
                      if (msg.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
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

  Widget _buildAttachmentMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _attachItem(Icons.image, "Photos", const Color(0xFF00E5FF)),
          _attachItem(Icons.insert_drive_file, "Document", const Color(0xFF7C4DFF)),
          _attachItem(Icons.mic, "Audio", const Color(0xFF10B981)),
          _attachItem(Icons.location_on, "Location", const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _attachItem(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() => _showAttachmentMenu = false);
        widget.onSendMessage("Sent attachment: $label");
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          border: const Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            GlassIconButton(
              icon: Icons.sentiment_satisfied_alt_outlined,
              tooltip: "Emoji",
              size: 36,
              onTap: () {},
            ),
            const SizedBox(width: 6),
            GlassIconButton(
              icon: Icons.attach_file,
              tooltip: "Attachment",
              size: 36,
              onTap: () => setState(() => _showAttachmentMenu = !_showAttachmentMenu),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Center(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _handleSend(),
                    style: const TextStyle(color: Colors.white, fontSize: 13.5),
                    decoration: const InputDecoration(
                      hintText: "Message niooo...",
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 13.5),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GlassIconButton(
              icon: Icons.mic_none,
              tooltip: "Voice Note",
              size: 36,
              onTap: () {
                widget.onSendMessage("🎤 Voice message (0:15)");
              },
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF0284C7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.send_rounded, color: Colors.white, size: 19),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
