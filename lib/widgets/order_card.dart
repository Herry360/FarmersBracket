import 'package:farm_bracket/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'order_action_buttons.dart';

class OrderCard extends StatelessWidget {
  static const _cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const _cardPadding = EdgeInsets.all(16);
  static const _statusPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const _imageSize = 40.0;
  static const _iconSize = 16.0;
  static const _productPreviewHeight = 40.0;

  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onTrack;
  final VoidCallback? onReorder;
  final bool showStatus;
  final bool showActions;
  final bool showProductPreview;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final DateFormat _timeFormat = DateFormat('hh:mm a');

  OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onCancel,
    this.onTrack,
    this.onReorder,
    this.showStatus = true,
    this.showActions = true,
    this.showProductPreview = true,
  });

  bool get _canCancel {
    return onCancel != null && order.status == OrderStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor(order.status as OrderStatus);

    return Card(
      margin: _cardMargin,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode
              ? theme.colorScheme.outlineVariant
              : theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: _cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, statusColor),
              const SizedBox(height: 12),
              _buildOrderDate(context),
              const SizedBox(height: 8),
              _buildItemCount(context),
              if (showProductPreview) ...[
                const SizedBox(height: 8),
                if (order.items.isNotEmpty)
                  _buildProductPreview(context, order.items.first),
                const SizedBox(height: 12),
              ],
              _buildTotalAmount(context),
              if (showActions &&
                  (onCancel != null ||
                      onTrack != null ||
                      onReorder != null)) ...[
                const SizedBox(height: 8),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order #${order.id.substring(0, 8)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (showStatus)
          Container(
            padding: _statusPadding,
            decoration: BoxDecoration(
              color: statusColor.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _orderStatusToString(order.status as OrderStatus),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderDate(BuildContext context) {
    return _buildInfoRow(
      icon: Icons.calendar_today_outlined,
      text: '${_dateFormat.format(order.date)} • ${_timeFormat.format(order.date)}',
      context: context,
    );
  }

  Widget _buildItemCount(BuildContext context) {
    return _buildInfoRow(
      icon: Icons.shopping_bag_outlined,
      text: '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
      context: context,
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total', style: Theme.of(context).textTheme.bodyMedium),
        Text(
          'R${(order.total ?? 0).toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
          size: _iconSize,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildProductPreview(BuildContext context, OrderItem item) {
    return SizedBox(
      height: _productPreviewHeight,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl ?? '',
              width: _imageSize,
              height: _imageSize,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildImagePlaceholder(context),
              errorWidget: (context, url, error) => _buildImageError(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.quantity} × R${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(154),
                  ),
                ),
              ],
            ),
          ),
          if (order.items.length > 1)
            Text(
              '+${order.items.length - 1} more',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(154),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildImageError(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.shopping_bag,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return OrderActionButtons(
      onReorder: onReorder,
      onCancel: onCancel,
      onTrack: onTrack,
      canCancel: _canCancel,
      canTrack: onTrack != null && order.status == OrderStatus.pending,
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
  }

  String _orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.pending:
        return 'Pending';
    }
  }
}
