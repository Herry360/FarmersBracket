import 'package:flutter/material.dart';

class OrderActionButtons extends StatelessWidget {
  final VoidCallback? onReorder;
  final VoidCallback? onCancel;
  final VoidCallback? onTrack;
  final bool canCancel;
  final bool canTrack;

  const OrderActionButtons({
    super.key,
    this.onReorder,
    this.onCancel,
    this.onTrack,
    this.canCancel = false,
    this.canTrack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onReorder != null)
          Expanded(
            child: OutlinedButton(
              onPressed: onReorder,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Text(
                'Reorder',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        if (onCancel != null && canCancel)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        if (onTrack != null && canTrack)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: onTrack,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Track',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}