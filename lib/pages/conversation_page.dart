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
      borderRadius: 22,
      backgroundColor: const Color(0xFF0B141A).withValues(alpha: 0.92),
      child: Column(
        children: [
          // WhatsApp 3D Conversation Header
          _buildHeader(),

          const Divider(height: 1, color: Color(0xFF222D34)),

          // Messages List with WhatsApp Dark Background
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // Subtle WhatsApp dark pattern background tint
                color: const Color(0xFF0B141A).withValues(alpha: 0.6),
              ),
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
          ),

          // Attachment popup menu if open
          if (_showAttachmentMenu) _buildAttachmentMenu(),

          // WhatsApp 3D Elevated Glass Input Bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: const Color(0xFF1F2C34).withValues(alpha: 0.9),
      child: Row(
        children: [
          // Prominent 3D Raised Back Button
          GlassIconButton(
            icon: Icons.arrow_back,
            tooltip: "Back to Chats",
            size: 38,
            onTap: widget.onBack,
          ),
          const SizedBox(width: 8),

          // Avatar + Online indicator
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.contact.avatarUrl),
              ),
              if (widget.contact.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1F2C34), width: 2),
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
                    color: Color(0xFFE9EDEF),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  widget.contact.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.contact.isOnline ? const Color(0xFF25D366) : const Color(0xFF8696A0),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // 3D Header Call Actions
          GlassIconButton(
            icon: Icons.videocam,
            tooltip: "Video Call",
            size: 36,
            color: const Color(0xFF00A884),
            onTap: () => widget.onStartCall(widget.contact.name, true),
          ),
          const SizedBox(width: 6),
          GlassIconButton(
            icon: Icons.call,
            tooltip: "Voice Call",
            size: 36,
            color: const Color(0xFF00A884),
            onTap: () => widget.onStartCall(widget.contact.name, false),
          ),
          const SizedBox(width: 6),
          GlassIconButton(
            icon: Icons.more_vert,
            tooltip: "Options",
            size: 36,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.76;

    // Official WhatsApp Dark Bubble Colors:
    // Outgoing: #005C4B
    // Incoming: #202C33
    final Color bubbleColor = msg.isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33);

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: maxBubbleWidth.clamp(200.0, 420.0)),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isMe ? 16 : 3),
            bottomRight: Radius.circular(msg.isMe ? 3 : 16),
          ),
          border: Border.all(
            color: msg.isMe
                ? const Color(0xFF00A884).withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.0,
          ),
          boxShadow: [
            // 3D tactile elevation for bubbles
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            if (msg.isMe)
              BoxShadow(
                color: const Color(0xFF00A884).withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // WhatsApp Voice note player with 3D button
                  if (msg.attachmentType == "audio") ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A884),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow, color: Color(0xFF111B21), size: 22),
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
                                        color: const Color(0xFF25D366),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text("0:24 • Voice Note", style: TextStyle(color: Color(0xFF8696A0), fontSize: 10.5)),
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
                      color: Color(0xFFE9EDEF),
                      fontSize: 14.5,
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
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(msg.reaction!, style: const TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        msg.time,
                        style: const TextStyle(color: Color(0xFF8696A0), fontSize: 10.5),
                      ),
                      if (msg.isMe) ...[
                        const SizedBox(width: 4),
                        // WhatsApp Sky-Blue Double Ticks (#53BDEB)
                        Icon(
                          Icons.done_all,
                          size: 15,
                          color: msg.isRead ? const Color(0xFF53BDEB) : const Color(0xFF8696A0),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2C34).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _attachItem(Icons.image, "Gallery", const Color(0xFF00A884)),
          _attachItem(Icons.insert_drive_file, "Document", const Color(0xFF7C4DFF)),
          _attachItem(Icons.headset, "Audio", const Color(0xFFF59E0B)),
          _attachItem(Icons.location_on, "Location", const Color(0xFF10B981)),
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 11)),
        ],
      ),
    );
  }

  // WhatsApp 3D Elevated Glass Input Bar
  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: const BoxDecoration(
          color: Color(0xFF111B21),
          border: Border(top: BorderSide(color: Color(0xFF222D34))),
        ),
        child: Row(
          children: [
            // Emoji 3D button
            GlassIconButton(
              icon: Icons.sentiment_satisfied_alt_outlined,
              tooltip: "Emoji",
              size: 38,
              onTap: () {},
            ),
            const SizedBox(width: 6),
            // Attachment 3D button
            GlassIconButton(
              icon: Icons.attach_file,
              tooltip: "Attach",
              size: 38,
              onTap: () => setState(() => _showAttachmentMenu = !_showAttachmentMenu),
            ),
            const SizedBox(width: 8),

            // WhatsApp 3D Elevated Text Input Box
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF202C33),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _handleSend(),
                    style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Message...",
                      hintStyle: TextStyle(color: Color(0xFF8696A0), fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 3D Mic button
            GlassIconButton(
              icon: Icons.mic,
              tooltip: "Voice Message",
              size: 38,
              color: const Color(0xFF00A884),
              onTap: () {
                widget.onSendMessage("🎤 Voice message (0:15)");
              },
            ),
            const SizedBox(width: 6),

            // WhatsApp 3D Raised Emerald Send Button
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A884), Color(0xFF008069)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.2),
                  boxShadow: [
                    // 3D tactile elevation
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
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
      ),
    );
  }
}
