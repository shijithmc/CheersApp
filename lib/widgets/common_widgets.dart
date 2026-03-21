import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.statusColor(status),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status[0].toUpperCase() + status.substring(1),
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: selected ? AppTheme.primary : const Color(0xFFDDDDDD)),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionText!, style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final String location;
  final int points;
  final VoidCallback? onProfile;
  final VoidCallback? onPoints;
  final VoidCallback? onLocation;
  final Widget? leading;

  const TopBar({
    super.key,
    this.location = 'Kozhikode',
    this.points = 789,
    this.onProfile,
    this.onPoints,
    this.onLocation,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.topBarBg,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16, bottom: 12),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 4)],
          GestureDetector(
            onTap: onLocation,
            child: Row(children: [
              const Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text(location, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              const Text('▾', style: TextStyle(color: Colors.white60, fontSize: 10)),
            ]),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPoints,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(50)),
              child: Row(children: [
                Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Center(child: Text('🎁', style: TextStyle(fontSize: 12))),
                ),
                const SizedBox(width: 5),
                Text('$points', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC0392B),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
            ),
          ),
        ],
      ),
    );
  }
}

class CheersNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CheersNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          _navItem(0, Icons.home_outlined, Icons.home, 'Home'),
          _navItem(1, Icons.work_outline, Icons.work, 'Jobs'),
          _centerFab(),
          _navItem(3, Icons.notifications_outlined, Icons.notifications, 'Notification'),
          _navItem(4, Icons.event_outlined, Icons.event, 'Events'),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final active = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(active ? activeIcon : icon, size: 22, color: active ? AppTheme.primary : const Color(0xFF999999)),
                if (index == 3)
                  Positioned(
                    top: -2, right: -8,
                    child: Container(
                      width: 15, height: 15,
                      decoration: BoxDecoration(color: AppTheme.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                      child: const Center(child: Text('2', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: active ? AppTheme.primary : const Color(0xFF999999), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _centerFab() {
    final active = currentIndex == 2;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: active ? AppTheme.primaryDark : AppTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.55), blurRadius: 14, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 24),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Text('Discover', style: TextStyle(fontSize: 10, color: active ? AppTheme.primary : const Color(0xFF999999), fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
