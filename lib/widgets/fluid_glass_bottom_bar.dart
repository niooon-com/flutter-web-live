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
      outlineIcon: Icons.chat_bubble_outline,
      filledIcon: Icons.chat_bubble,
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
      label: "Channels",
      outlineIcon: Icons.tag,
      filledIcon: Icons.tag,
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
          constraints: const BoxConstraints(maxWidth: 520),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
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
                        height: 52,
                        child: Stack(
                          children: [
                            // Interactive Fluid Sliding Pill
                            Positioned(
                              left: pillLeft,
                              top: 2,
                              bottom: 2,
                              width: tabWidth,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF00E5FF).withValues(alpha: _isDragging ? 0.35 : 0.22),
                                      const Color(0xFF7C4DFF).withValues(alpha: _isDragging ? 0.35 : 0.22),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFF00E5FF).withValues(alpha: _isDragging ? 0.8 : 0.5),
                                    width: 1.3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF).withValues(alpha: _isDragging ? 0.4 : 0.2),
                                      blurRadius: _isDragging ? 16 : 10,
                                      spreadRadius: _isDragging ? 2 : 0,
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
                                                scale: isHovered ? 1.12 : 1.0,
                                                duration: const Duration(milliseconds: 180),
                                                child: Icon(
                                                  isHovered ? item.filledIcon : item.outlineIcon,
                                                  color: isHovered
                                                      ? const Color(0xFF00E5FF)
                                                      : Colors.white54,
                                                  size: 21,
                                                ),
                                              ),
                                              if (item.badgeCount > 0)
                                                Positioned(
                                                  top: -4,
                                                  right: -8,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1.2),
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                                                      ),
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Text(
                                                      "${item.badgeCount}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold,
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
                                                    : Colors.white54,
                                                fontSize: 10.5,
                                                fontWeight: isHovered
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
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
