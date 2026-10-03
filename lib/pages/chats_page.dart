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
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      backgroundColor: const Color(0xFF111B21).withValues(alpha: 0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with WhatsApp aesthetic & 3D New Chat button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                const Text(
                  "niooo",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: Color(0xFFE9EDEF),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A884).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00A884).withValues(alpha: 0.5)),
                  ),
                  child: const Text(
                    "CHATS",
                    style: TextStyle(
                      color: Color(0xFF25D366),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                // 3D Elevated Camera & New Chat buttons
                GlassIconButton(
                  icon: Icons.camera_alt_outlined,
                  tooltip: "Camera",
                  size: 38,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.edit_note_rounded,
                  tooltip: "New Chat",
                  size: 38,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // WhatsApp Dark Search Bar with 3D inset depth
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF202C33),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 13.5),
                decoration: const InputDecoration(
                  hintText: "Search or start new chat...",
                  hintStyle: TextStyle(color: Color(0xFF8696A0), fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF00A884), size: 19),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // WhatsApp Status Stories Row with emerald glow rings
          _buildStoriesRow(),

          const SizedBox(height: 10),

          // 3D Elevated Filter Category Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
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

          const SizedBox(height: 8),

          // Chat List Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 85),
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                final isSelected = contact.id == widget.activeContact.id;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF00A884).withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: const Color(0xFF00A884).withValues(alpha: 0.4), width: 1.2)
                        : Border.all(color: Colors.transparent),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF00A884).withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ListTile(
                    onTap: () => widget.onSelectContact(contact),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundImage: NetworkImage(contact.avatarUrl),
                        ),
                        if (contact.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF111B21), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF25D366).withValues(alpha: 0.6),
                                    blurRadius: 4,
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
                              color: const Color(0xFFE9EDEF),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact.time,
                          style: TextStyle(
                            color: contact.unreadCount > 0 ? const Color(0xFF25D366) : const Color(0xFF8696A0),
                            fontSize: 11,
                            fontWeight: contact.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFFE9EDEF) : const Color(0xFF8696A0),
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          if (contact.unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF25D366).withValues(alpha: 0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                "${contact.unreadCount}",
                                style: const TextStyle(
                                  color: Color(0xFF111B21),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
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
      height: 76,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          // WhatsApp My Status Add Button
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
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
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A884),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF111B21), width: 1.5),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const Text("My Status", style: TextStyle(color: Color(0xFF8696A0), fontSize: 10.5)),
            ],
          ),
          const SizedBox(width: 14),

          // Stories with WhatsApp green rings
          for (var i = 0; i < widget.contacts.length && i < 4; i++) ...[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF25D366), Color(0xFF00A884)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00A884).withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF111B21),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.contacts[i].avatarUrl),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: 52,
                  child: Text(
                    widget.contacts[i].name.split(" ")[0],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 10.5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }

  // 3D Elevated Filter Category Chip
  Widget _categoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00A884).withValues(alpha: 0.25)
              : const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF25D366).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.1,
          ),
          boxShadow: [
            // 3D tactile elevation
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF00A884).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF25D366) : const Color(0xFF8696A0),
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
