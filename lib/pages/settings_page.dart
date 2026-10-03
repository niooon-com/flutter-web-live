import "package:flutter/material.dart";
import "../widgets/glass_container.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _twoStepAuth = true;
  bool _notifications = true;
  bool _soundEnabled = true;
  bool _readReceipts = true;
  String _selectedTheme = "WhatsApp Dark";

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      backgroundColor: const Color(0xFF111B21).withValues(alpha: 0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with WhatsApp aesthetic
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
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
                    "PREFERENCES",
                    style: TextStyle(
                      color: Color(0xFF25D366),
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Settings Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 85),
              children: [
                // 3D Elevated Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202C33),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: const Color(0xFF00A884).withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF25D366), Color(0xFF00A884)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00A884).withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150",
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00A884),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF111B21), width: 1.5),
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Rayhan",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFFE9EDEF),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "@rayhan_niooo",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xFF25D366), fontSize: 12),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Available • Using niooo WhatsApp 3D ✨",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xFF8696A0), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      GlassIconButton(
                        icon: Icons.qr_code,
                        tooltip: "QR Code",
                        size: 38,
                        color: const Color(0xFF00A884),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Section: Privacy & Security
                _sectionTitle("PRIVACY & SECURITY"),
                _settingsCard([
                  _switchTile(
                    icon: Icons.lock,
                    iconColor: const Color(0xFF00A884),
                    title: "End-to-End Encryption",
                    subtitle: "All chats encrypted via Signal Protocol",
                    value: true,
                    onChanged: null,
                  ),
                  const Divider(height: 1, color: Color(0xFF222D34)),
                  _switchTile(
                    icon: Icons.security,
                    iconColor: const Color(0xFF25D366),
                    title: "Two-Step Verification",
                    subtitle: "Extra PIN required when registering phone",
                    value: _twoStepAuth,
                    onChanged: (val) => setState(() => _twoStepAuth = val),
                  ),
                  const Divider(height: 1, color: Color(0xFF222D34)),
                  _switchTile(
                    icon: Icons.done_all,
                    iconColor: const Color(0xFF53BDEB), // WhatsApp blue ticks
                    title: "Read Receipts (Blue Ticks)",
                    subtitle: "Let contacts know when you read messages",
                    value: _readReceipts,
                    onChanged: (val) => setState(() => _readReceipts = val),
                  ),
                ]),

                const SizedBox(height: 18),

                // Section: Appearance & 3D Glass Themes
                _sectionTitle("APPEARANCE & THEMES"),
                _settingsCard([
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Active Theme Style",
                          style: TextStyle(color: Color(0xFFE9EDEF), fontWeight: FontWeight.w600, fontSize: 13.5),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _themeChip("WhatsApp Dark"),
                              const SizedBox(width: 8),
                              _themeChip("Emerald Glass 3D"),
                              const SizedBox(width: 8),
                              _themeChip("OLED Deep Black"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),

                const SizedBox(height: 18),

                // Section: Notifications & Sounds
                _sectionTitle("NOTIFICATIONS & SOUNDS"),
                _settingsCard([
                  _switchTile(
                    icon: Icons.notifications,
                    iconColor: const Color(0xFF25D366),
                    title: "Message Notifications",
                    subtitle: "Show preview and tone for incoming chats",
                    value: _notifications,
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                  const Divider(height: 1, color: Color(0xFF222D34)),
                  _switchTile(
                    icon: Icons.volume_up,
                    iconColor: const Color(0xFF00A884),
                    title: "Conversation Tones",
                    subtitle: "Play sounds for outgoing and incoming messages",
                    value: _soundEnabled,
                    onChanged: (val) => setState(() => _soundEnabled = val),
                  ),
                ]),

                const SizedBox(height: 18),

                // Section: About niooo
                _sectionTitle("ABOUT"),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202C33),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF25D366), Color(0xFF00A884)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00A884).withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "n",
                            style: TextStyle(
                              color: Color(0xFF111B21),
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontFamily: "monospace",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "niooo WhatsApp Edition 2.5",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xFFE9EDEF), fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Dark Mode • 3D Tactile Glass • Flutter 3.29",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xFF8696A0), fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF25D366),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF202C33),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 19),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Color(0xFF8696A0), fontSize: 11.5),
      ),
      trailing: Transform.scale(
        scale: 0.85,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF25D366),
          activeTrackColor: const Color(0xFF00A884).withValues(alpha: 0.4),
        ),
      ),
    );
  }

  // 3D Elevated Theme Selection Chip
  Widget _themeChip(String label) {
    final isSelected = _selectedTheme == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00A884).withValues(alpha: 0.3)
              : const Color(0xFF111B21),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF25D366)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF25D366).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF25D366) : const Color(0xFF8696A0),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
