import "dart:ui";
import "package:flutter/material.dart";

class FluidGlassBottomBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const FluidGlassBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  State<FluidGlassBottomBar> createState() => _FluidGlassBottomBarState();
}

class _FluidGlassBottomBarState extends State<FluidGlassBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  double _currentPosition = 0.0;
  bool _isDragging = false;

  final List<_NavItemData> _items = const [
    _NavItemData(
      index: 0,
      label: "Chats",
      outlineIcon: Icons.chat_outlined,
      filledIcon: Icons.chat,
      badgeCount: 7,
    ),
    _NavItemData(
      index: 1,
      label: "Calls",
      outlineIcon: Icons.call_outlined,
      filledIcon: Icons.call,
      badgeCount: 0,
    ),
    _NavItemData(
      index: 2,
      label: "Updates",
      outlineIcon: Icons.sync_outlined,
      filledIcon: Icons.motion_photos_on,
      badgeCount: 0,
    ),
    _NavItemData(
      index: 3,
      label: "Settings",
      outlineIcon: Icons.settings_outlined,
      filledIcon: Icons.settings,
      badgeCount: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.selectedIndex.toDouble();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void didUpdateWidget(FluidGlassBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex && !_isDragging) {
      _animateTo(widget.selectedIndex.toDouble());
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _animController.stop();
    _slideAnimation = Tween<double>(
      begin: _currentPosition,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    )..addListener(() {
        setState(() {
          _currentPosition = _slideAnimation.value;
        });
      });

    _animController.forward(from: 0.0);
  }

  void _handleDragStart(DragStartDetails details, double tabWidth) {
    _animController.stop();
    setState(() {
      _isDragging = true;
      _currentPosition = (details.localPosition.dx / tabWidth - 0.5).clamp(0.0, 3.0);
    });
  }

  void _handleDragUpdate(DragUpdateDetails details, double tabWidth) {
    setState(() {
      _currentPosition = (details.localPosition.dx / tabWidth - 0.5).clamp(0.0, 3.0);
    });
  }

  void _handleDragEnd(DragEndDetails details, double tabWidth) {
    final targetIndex = _currentPosition.round().clamp(0, 3);
    setState(() {
      _isDragging = false;
    });
    _animateTo(targetIndex.toDouble());
    widget.onTabSelected(targetIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          // 3D Elevated Floating Capsule
          decoration: BoxDecoration(
            color: const Color(0xFF1F2C34).withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.2,
            ),
            boxShadow: [
              // Deep bottom shadow for 3D elevation
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.65),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
              // Soft emerald ambient reflection
              BoxShadow(
                color: const Color(0xFF00A884).withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
              // Top specular light bevel
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(-1, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double totalWidth = constraints.maxWidth;
                    final double tabWidth = totalWidth / 4;
                    final double pillLeft = (_currentPosition * tabWidth).clamp(0.0, totalWidth - tabWidth);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: (details) => _handleDragStart(details, tabWidth),
                      onHorizontalDragUpdate: (details) => _handleDragUpdate(details, tabWidth),
                      onHorizontalDragEnd: (details) => _handleDragEnd(details, tabWidth),
                      child: SizedBox(
                        height: 54,
                        child: Stack(
                          children: [
                            // 3D Embossed Interactive Sliding Pill
                            Positioned(
                              left: pillLeft,
                              top: 2,
                              bottom: 2,
                              width: tabWidth,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  // WhatsApp 3D Emerald tactile gradient
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00A884).withValues(alpha: _isDragging ? 0.95 : 0.82),
                                      const Color(0xFF005C4B).withValues(alpha: _isDragging ? 0.95 : 0.85),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: const Color(0xFF25D366).withValues(alpha: _isDragging ? 0.9 : 0.65),
                                    width: 1.4,
                                  ),
                                  boxShadow: [
                                    // 3D tactile pill drop shadow
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF25D366).withValues(alpha: _isDragging ? 0.5 : 0.3),
                                      blurRadius: _isDragging ? 16 : 8,
                                      offset: const Offset(0, 2),
                                    ),
                                    // Top bevel highlight
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      blurRadius: 3,
                                      offset: const Offset(0, -1),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Foreground Items
                            Row(
                              children: _items.map((item) {
                                final double distance = (_currentPosition - item.index).abs();
                                final bool isHovered = distance < 0.5;

                                return Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _animateTo(item.index.toDouble());
                                      widget.onTabSelected(item.index);
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              AnimatedScale(
                                                scale: isHovered ? 1.15 : 1.0,
                                                duration: const Duration(milliseconds: 180),
                                                child: Icon(
                                                  isHovered ? item.filledIcon : item.outlineIcon,
                                                  color: isHovered
                                                      ? Colors.white
                                                      : const Color(0xFF8696A0),
                                                  size: 22,
                                                ),
                                              ),
                                              if (item.badgeCount > 0)
                                                Positioned(
                                                  top: -4,
                                                  right: -9,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF25D366),
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: const Color(0xFF111B21), width: 1.5),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(0xFF25D366).withValues(alpha: 0.6),
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Text(
                                                      "${item.badgeCount}",
                                                      style: const TextStyle(
                                                        color: Color(0xFF111B21),
                                                        fontSize: 9.5,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              item.label,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: isHovered
                                                    ? Colors.white
                                                    : const Color(0xFF8696A0),
                                                fontSize: 10.5,
                                                fontWeight: isHovered
                                                    ? FontWeight.bold
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final int index;
  final String label;
  final IconData outlineIcon;
  final IconData filledIcon;
  final int badgeCount;

  const _NavItemData({
    required this.index,
    required this.label,
    required this.outlineIcon,
    required this.filledIcon,
    this.badgeCount = 0,
  });
}
