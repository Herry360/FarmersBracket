import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

enum CustomBottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomBottomBarVariant variant;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
  });

  static final List<_BottomBarItem> _items = [
    const _BottomBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/customer-home-screen',
    ),
    const _BottomBarItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Browse',
      route: '/product-listing-screen',
    ),
    const _BottomBarItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
      route: '/shopping-cart-screen',
    ),
    const _BottomBarItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Messages',
      route: '/messages-screen',
    ),
  ];

  Widget _buildFloatingBottomBarItem(
    BuildContext context,
    ColorScheme colorScheme,
    _BottomBarItem item,
    bool isSelected,
    int index,
  ) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        }
        if (ModalRoute.of(context)?.settings.name != item.route) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            item.route,
            (route) => false,
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withAlpha((0.1 * 255).toInt())
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Minimal bottom bar: only shows icons, no labels, no badge
  Widget _buildMinimalBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () {
                  if (onTap != null) {
                    onTap!(index);
                  }
                  if (ModalRoute.of(context)?.settings.name != item.route) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      item.route,
                      (route) => false,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;

                  return _buildFloatingBottomBarItem(
                    context,
                    colorScheme,
                    item,
                    isSelected,
                    index,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardBottomBar(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, WidgetRef ref) {
    // Example cart count, replace with your actual cart provider logic
    const cartCount = 2;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.1 * 255).toInt()),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = index == currentIndex;
            Widget iconWidget = Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            );
            // Show badge for cart
            if (item.label == 'Cart' && cartCount > 0) {
              iconWidget = Stack(
                children: [
                  iconWidget,
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '$cartCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }
            return Expanded(
              child: InkWell(
                onTap: () {
                  if (onTap != null) {
                    onTap!(index);
                  }
                  if (ModalRoute.of(context)?.settings.name != item.route) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      item.route,
                      (route) => false,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      iconWidget,
                      if (showLabels)
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomBottomBarVariant.standard:
        return _buildStandardBottomBar(context, theme, colorScheme, ref);
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme, colorScheme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme, colorScheme);
    }
  }
}