Write-Host 'Fixing Dart errors...'

# products_provider.dart line 140
\lib/widgets/order_card.dart = 'lib/providers/products_provider.dart'
(Get-Content \lib/widgets/order_card.dart) | ForEach-Object { if (\.ReadCount -eq 140) { '        // Remove unnecessary null check' } else { \ } } | Set-Content \lib/widgets/order_card.dart

# products_provider.dart lines 197-198
\lib/widgets/order_card.dart = 'lib/providers/products_provider.dart'
(Get-Content \lib/widgets/order_card.dart) | ForEach-Object { 
    if (\.ReadCount -eq 197 -or \.ReadCount -eq 198) { \ -replace '\?\?.*', '' } else { \ }
} | Set-Content \lib/widgets/order_card.dart

# order_history_card.dart lines 224-225
\lib/widgets/order_card.dart = 'lib/widgets/order_history_card.dart'
(Get-Content \lib/widgets/order_card.dart) | ForEach-Object {
    if (\.ReadCount -eq 224) {
        \ -replace '== OrderStatus\.delivered', '== OrderStatus.delivered.toString()'
    } elseif (\.ReadCount -eq 225) {
        \ -replace '== OrderStatus\.cancelled', '== OrderStatus.cancelled.toString()'
    } else { \ }
} | Set-Content \lib/widgets/order_card.dart

Write-Host 'Fixes applied. Run lutter analyze to check remaining issues.'
