import "package:flutter/material.dart";
import "../models/chat_models.dart";
import "../widgets/glass_container.dart";

class ChatsPage extends StatefulWidget {
  final List<ChatContact> contacts;
  final ChatContact activeContact;
  final Function(ChatContact) onSelectContact;

  const ChatsPage({
    super.key,
    required this.contacts,
    required this.activeContact,
    required this.onSelectContact,
  });

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  String _selectedCategory = "All";
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredContacts = widget.contacts.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedCategory == "Unread") return c.unreadCount > 0;
      if (_selectedCategory == "Groups") return c.isGroup;
      if (_selectedCategory == "Direct") return !c.isGroup;
      return true;
    }).toList();

    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Logo & New Chat action
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
                    "CHAT",
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                GlassIconButton(
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
                  hintText: "Search chats, messages, channels...",
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.white54, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Stories Row (WhatsApp / Telegram style)
          _buildStoriesRow(),

          const SizedBox(height: 12),

          // Category Chips
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

          // Chat List Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                final isSelected = contact.id == widget.activeContact.id;

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
                    onTap: () => widget.onSelectContact(contact),
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
    );
  }

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

          // Stories from contacts
          for (var i = 0; i < widget.contacts.length && i < 4; i++) ...[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
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
                      backgroundImage: NetworkImage(widget.contacts[i].avatarUrl),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.contacts[i].name.split(" ")[0],
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
}
