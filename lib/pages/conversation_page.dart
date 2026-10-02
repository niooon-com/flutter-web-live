import "dart:ui";
import "package:flutter/material.dart";
import "../models/chat_models.dart";
import "../widgets/glass_container.dart";

class ConversationPage extends StatefulWidget {
  final ChatContact contact;
  final List<ChatMessage> messages;
  final Function(String) onSendMessage;
  final Function(String, bool) onStartCall;
  final VoidCallback? onBack;

  const ConversationPage({
    super.key,
    required this.contact,
    required this.messages,
    required this.onSendMessage,
    required this.onStartCall,
    this.onBack,
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
      margin: const EdgeInsets.fromLTRB(6, 12, 14, 12),
      child: Column(
        children: [
          // Conversation Header
          _buildHeader(),

          const Divider(height: 1, color: Colors.white10),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white.withValues(alpha: 0.03),
      child: Row(
        children: [
          if (widget.onBack != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GlassIconButton(
                icon: Icons.arrow_back,
                tooltip: "Back to Chats",
                size: 36,
                onTap: widget.onBack!,
              ),
            ),
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(widget.contact.avatarUrl),
              ),
              if (widget.contact.isOnline)
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
                  widget.contact.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.contact.status,
                  style: TextStyle(
                    color: widget.contact.isOnline ? const Color(0xFF00E5FF) : Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GlassIconButton(
            icon: Icons.phone_outlined,
            tooltip: "Voice Call",
            onTap: () => widget.onStartCall(widget.contact.name, false),
          ),
          const SizedBox(width: 8),
          GlassIconButton(
            icon: Icons.videocam_outlined,
            tooltip: "Video Call",
            onTap: () => widget.onStartCall(widget.contact.name, true),
          ),
          const SizedBox(width: 8),
          GlassIconButton(
            icon: Icons.more_vert,
            tooltip: "More Options",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: const BoxConstraints(maxWidth: 420),
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

                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 6),

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

  Widget _buildAttachmentMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          GlassIconButton(
            icon: Icons.sentiment_satisfied_alt_outlined,
            tooltip: "Emoji",
            onTap: () {},
          ),
          const SizedBox(width: 8),
          GlassIconButton(
            icon: Icons.attach_file,
            tooltip: "Attachment",
            onTap: () => setState(() => _showAttachmentMenu = !_showAttachmentMenu),
          ),
          const SizedBox(width: 10),
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
                  controller: _textController,
                  onSubmitted: (_) => _handleSend(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Message niooo...",
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GlassIconButton(
            icon: Icons.mic_none,
            tooltip: "Voice Note",
            onTap: () {
              widget.onSendMessage("🎤 Voice message (0:15)");
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _handleSend,
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
}
