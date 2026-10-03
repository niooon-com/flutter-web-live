import "package:flutter/material.dart";
import "../models/chat_models.dart";
import "../widgets/glass_container.dart";

class CallsPage extends StatelessWidget {
  final Function(String, bool) onStartCall;

  const CallsPage({
    super.key,
    required this.onStartCall,
  });

  @override
  Widget build(BuildContext context) {
    final callLogs = [
      CallLog(
        id: "c1",
        name: "Sophia Carter",
        avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
        time: "Today, 10:15 AM",
        isVideo: true,
        isMissed: false,
        isOutgoing: false,
      ),
      CallLog(
        id: "c2",
        name: "David Vance",
        avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        time: "Yesterday, 8:40 PM",
        isVideo: false,
        isMissed: true,
        isOutgoing: false,
      ),
      CallLog(
        id: "c3",
        name: "Elena Rostova",
        avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
        time: "Oct 1, 4:20 PM",
        isVideo: true,
        isMissed: false,
        isOutgoing: true,
      ),
      CallLog(
        id: "c4",
        name: "Marcus Thorne",
        avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150",
        time: "Sep 29, 11:05 AM",
        isVideo: false,
        isMissed: false,
        isOutgoing: true,
      ),
    ];

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
                  "Calls",
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
                    "ENCRYPTED",
                    style: TextStyle(
                      color: Color(0xFF25D366),
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // 3D Elevated Start Call Button
                GlassButton(
                  onTap: () => onStartCall("Sophia Carter", false),
                  borderRadius: 14,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_call, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text("New Call", style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Security banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF202C33),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock, color: Color(0xFF00A884), size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your personal calls are end-to-end encrypted. No one outside of this chat can hear them.",
                      style: TextStyle(color: Color(0xFF8696A0), fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Recent Calls List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 85),
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                final log = callLogs[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202C33).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(log.avatarUrl),
                    ),
                    title: Text(
                      log.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: log.isMissed ? const Color(0xFFEA0038) : const Color(0xFFE9EDEF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          log.isOutgoing ? Icons.call_made : Icons.call_received,
                          size: 14,
                          color: log.isMissed
                              ? const Color(0xFFEA0038)
                              : (log.isOutgoing ? const Color(0xFF25D366) : const Color(0xFF00A884)),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            log.time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF8696A0), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 3D Call Buttons
                        GlassIconButton(
                          icon: Icons.call,
                          tooltip: "Voice Call",
                          size: 36,
                          color: const Color(0xFF00A884),
                          onTap: () => onStartCall(log.name, false),
                        ),
                        const SizedBox(width: 8),
                        GlassIconButton(
                          icon: Icons.videocam,
                          tooltip: "Video Call",
                          size: 36,
                          color: const Color(0xFF00A884),
                          onTap: () => onStartCall(log.name, true),
                        ),
                      ],
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
}
