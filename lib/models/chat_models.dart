class ChatContact {
  final String id;
  final String name;
  final String handle;
  final String avatarUrl;
  final String status;
  final bool isOnline;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isGroup;
  final bool isPinned;

  ChatContact({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.status,
    required this.isOnline,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.isGroup = false,
    this.isPinned = false,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final String? replyTo;
  final String? attachmentType; // 'audio', 'image', null
  final String? reaction;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
    this.replyTo,
    this.attachmentType,
    this.reaction,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    String? time,
    bool? isRead,
    String? replyTo,
    String? attachmentType,
    String? reaction,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      replyTo: replyTo ?? this.replyTo,
      attachmentType: attachmentType ?? this.attachmentType,
      reaction: reaction ?? this.reaction,
    );
  }
}

class CallLog {
  final String id;
  final String name;
  final String avatarUrl;
  final String time;
  final bool isVideo;
  final bool isMissed;
  final bool isOutgoing;

  CallLog({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.time,
    required this.isVideo,
    required this.isMissed,
    required this.isOutgoing,
  });
}

class ChannelItem {
  final String id;
  final String title;
  final String handle;
  final String avatarUrl;
  final String subscribers;
  final String description;
  final String latestPost;
  final String postTime;
  final bool isVerified;
  final bool isJoined;

  ChannelItem({
    required this.id,
    required this.title,
    required this.handle,
    required this.avatarUrl,
    required this.subscribers,
    required this.description,
    required this.latestPost,
    required this.postTime,
    this.isVerified = true,
    this.isJoined = false,
  });
}
