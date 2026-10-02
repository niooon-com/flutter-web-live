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
  String _selectedTheme = "Dark Glass";

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    "PREFERENCES",
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 10,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              children: [
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 34,
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
                              decoration: const BoxDecoration(
                                color: Color(0xFF00E5FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.black, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Rayhan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "@rayhan_niooo",
                              style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Hey there! I am using niooo ✨",
                              style: TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      GlassIconButton(
                        icon: Icons.edit,
                        tooltip: "Edit Profile",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section: Privacy & Security
                _sectionTitle("PRIVACY & SECURITY"),
                _settingsCard([
                  _switchTile(
                    icon: Icons.lock_outline,
                    iconColor: const Color(0xFF00E5FF),
                    title: "End-to-End Encryption",
                    subtitle: "All messages & calls encrypted via Signal Protocol",
                    value: true,
                    onChanged: null, // Always locked on
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  _switchTile(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF10B981),
                    title: "Two-Step Verification",
                    subtitle: "Extra passcode required when logging in",
                    value: _twoStepAuth,
                    onChanged: (val) => setState(() => _twoStepAuth = val),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  _switchTile(
                    icon: Icons.done_all,
                    iconColor: const Color(0xFF38BDF8),
                    title: "Read Receipts (Double Blue Ticks)",
                    subtitle: "Let contacts know when you read their messages",
                    value: _readReceipts,
                    onChanged: (val) => setState(() => _readReceipts = val),
                  ),
                ]),

                const SizedBox(height: 24),

                // Section: Appearance & Glass Themes
                _sectionTitle("APPEARANCE & THEMES"),
                _settingsCard([
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Active Glass Theme",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _themeChip("Dark Glass"),
                            const SizedBox(width: 8),
                            _themeChip("Radiant Cyan"),
                            const SizedBox(width: 8),
                            _themeChip("Midnight OLED"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // Section: Notifications & Sounds
                _sectionTitle("NOTIFICATIONS & SOUNDS"),
                _settingsCard([
                  _switchTile(
                    icon: Icons.notifications_active_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    title: "Push Notifications",
                    subtitle: "Receive live alerts for new chats and calls",
                    value: _notifications,
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  _switchTile(
                    icon: Icons.volume_up_outlined,
                    iconColor: const Color(0xFFEC4899),
                    title: "In-App Audio Sounds",
                    subtitle: "Play sound effect on sending and receiving messages",
                    value: _soundEnabled,
                    onChanged: (val) => setState(() => _soundEnabled = val),
                  ),
                ]),

                const SizedBox(height: 24),

                // Section: About niooo
                _sectionTitle("ABOUT"),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "n",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontFamily: "monospace",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "niooo for Web & Mobile",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Version 2.0.0 (Build 37018) • Flutter Web WASM",
                              style: TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF00E5FF),
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
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF00E5FF),
      ),
    );
  }

  Widget _themeChip(String label) {
    final isSelected = _selectedTheme == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00E5FF).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E5FF) : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00E5FF) : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
