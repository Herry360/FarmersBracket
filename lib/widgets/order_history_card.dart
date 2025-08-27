import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'order_action_buttons.dart';
import '../screens/order_history_screen.dart' show Order, OrderStatus;

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onTrack;
  final VoidCallback? onReorder;
  final bool showStatus;
  final bool showActions;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onCancel,
    this.onTrack,
    this.onReorder,
    this.showStatus = true,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(order.status);
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with order number and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id.substring(0, 8)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showStatus)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status.name.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoSection(context, dateFormat, timeFormat),
              const SizedBox(height: 8),
              if (order.items.isNotEmpty) _buildProductPreview(context),
              const SizedBox(height: 12),
              _buildTotalAmountSection(context),
              if (showActions) const SizedBox(height: 8),
              if (showActions) _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, DateFormat dateFormat, DateFormat timeFormat) {
    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          text: '${dateFormat.format(order.date)} • ${timeFormat.format(order.date)}',
          context: context,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          icon: Icons.shopping_bag_outlined,
          text: '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
          context: context,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProductPreview(BuildContext context) {
    final firstItem = order.items.first;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: '', // No imageUrl in OrderItem
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 40,
              height: 40,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (context, url, error) => Container(
              width: 40,
              height: 40,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.shopping_bag,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstItem.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${firstItem.quantity} × R${firstItem.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
            ],
         ),
        ),
        if (order.items.length > 1)
          Text(
            '+${order.items.length - 1} more',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
      ],
    );
  }

  Widget _buildTotalAmountSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'R${order.total.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return OrderActionButtons(
      onReorder: onReorder,
      onCancel: onCancel,
      onTrack: onTrack,
      canCancel: order.status == OrderStatus.pending,
      canTrack: order.status == OrderStatus.pending,
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.orange;
    }
    // unreachable
  }
}
