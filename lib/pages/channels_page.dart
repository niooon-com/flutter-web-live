import "package:flutter/material.dart";
import "../models/chat_models.dart";
import "../widgets/glass_container.dart";

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  final List<ChannelItem> _channels = [
    ChannelItem(
      id: "ch1",
      title: "niooo Official News",
      handle: "@niooo_news",
      avatarUrl: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=150",
      subscribers: "128.4K subscribers",
      description: "Official product release announcements and feature updates for niooo ecosystem.",
      latestPost: "🚀 Version 2.0 is live! Enjoy pure dark glassmorphism, instant sync, and ultra-fast compilation.",
      postTime: "2 hours ago",
      isVerified: true,
      isJoined: true,
    ),
    ChannelItem(
      id: "ch2",
      title: "Flutter & Dart Global Devs",
      handle: "@flutter_global",
      avatarUrl: "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=150",
      subscribers: "54.2K subscribers",
      description: "Community of Flutter and Dart developers sharing widgets, packages and architectures.",
      latestPost: "Check out the new CanvasKit WASM rendering improvements on Flutter 3.29.",
      postTime: "5 hours ago",
      isVerified: true,
      isJoined: false,
    ),
    ChannelItem(
      id: "ch3",
      title: "Glassmorphism & UI Innovations",
      handle: "@glass_ui_design",
      avatarUrl: "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=150",
      subscribers: "38.9K subscribers",
      description: "Inspiring dark mode frosted glass UI mockups, animations, and design tokens.",
      latestPost: "BackdropFilter with sigmaX: 20 gives the most realistic modern liquid glass texture.",
      postTime: "Yesterday",
      isVerified: false,
      isJoined: true,
    ),
    ChannelItem(
      id: "ch4",
      title: "CyberSecurity & Crypto",
      handle: "@niooo_security",
      avatarUrl: "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=150",
      subscribers: "19.5K subscribers",
      description: "Audits, cryptography standards, and zero-trust protocol updates.",
      latestPost: "niooo utilizes AES-256 GCM combined with Signal Protocol double-ratchet algorithms.",
      postTime: "2 days ago",
      isVerified: true,
      isJoined: false,
    ),
  ];

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
                  "Channels & Communities",
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
                    color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF7C4DFF).withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    "DISCOVER",
                    style: TextStyle(
                      color: Color(0xFFB388FF),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                GlassIconButton(
                  icon: Icons.search,
                  tooltip: "Explore Channels",
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Channels List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _channels.length,
              itemBuilder: (context, index) {
                final ch = _channels[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(ch.avatarUrl),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      ch.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (ch.isVerified) ...[
                                      const SizedBox(width: 5),
                                      const Icon(Icons.verified, color: Color(0xFF00E5FF), size: 16),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${ch.handle} • ${ch.subscribers}",
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // Join / Joined Glass Button
                          GlassButton(
                            onTap: () {
                              setState(() {
                                _channels[index] = ChannelItem(
                                  id: ch.id,
                                  title: ch.title,
                                  handle: ch.handle,
                                  avatarUrl: ch.avatarUrl,
                                  subscribers: ch.subscribers,
                                  description: ch.description,
                                  latestPost: ch.latestPost,
                                  postTime: ch.postTime,
                                  isVerified: ch.isVerified,
                                  isJoined: !ch.isJoined,
                                );
                              });
                            },
                            gradient: ch.isJoined
                                ? null
                                : const LinearGradient(
                                    colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                                  ),
                            color: ch.isJoined ? Colors.white.withValues(alpha: 0.08) : null,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            borderRadius: 14,
                            child: Text(
                              ch.isJoined ? "Joined" : "Join",
                              style: TextStyle(
                                color: ch.isJoined ? Colors.white70 : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ch.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.campaign_outlined, color: Color(0xFF00E5FF), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ch.latestPost,
                                    style: const TextStyle(color: Colors.white, fontSize: 12.5),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ch.postTime,
                                    style: const TextStyle(color: Colors.white38, fontSize: 10.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
