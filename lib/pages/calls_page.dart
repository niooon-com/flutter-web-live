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
                  "Calls",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    "HD ENCRYPTED",
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                GlassButton(
                  onTap: () => onStartCall("Sophia Carter", false),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF0284C7)],
                  ),
                  borderRadius: 14,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_call, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text("New Call", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Security banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock_outline, color: Color(0xFF00E5FF), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your calls on niooo are secured with end-to-end encryption. No third party can listen in.",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Recent Calls List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: callLogs.length,
              itemBuilder: (context, index) {
                final log = callLogs[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(log.avatarUrl),
                    ),
                    title: Text(
                      log.name,
                      style: TextStyle(
                        color: log.isMissed ? const Color(0xFFEF4444) : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          log.isOutgoing ? Icons.call_made : Icons.call_received,
                          size: 14,
                          color: log.isMissed
                              ? const Color(0xFFEF4444)
                              : (log.isOutgoing ? const Color(0xFF00E5FF) : const Color(0xFF10B981)),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          log.time,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GlassIconButton(
                          icon: Icons.phone_outlined,
                          tooltip: "Voice Call",
                          size: 36,
                          onTap: () => onStartCall(log.name, false),
                        ),
                        const SizedBox(width: 8),
                        GlassIconButton(
                          icon: Icons.videocam_outlined,
                          tooltip: "Video Call",
                          size: 36,
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
