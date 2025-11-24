import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';

/// Pro pricing screen
class ProPricingScreen extends StatefulWidget {
  const ProPricingScreen({super.key});

  @override
  State<ProPricingScreen> createState() => _ProPricingScreenState();
}

class _ProPricingScreenState extends State<ProPricingScreen> {
  bool _isAnnual = true;

  String get _buttonLabel => _isAnnual ? 'Go Pro — \u00A390/year' : 'Go Pro — \u00A39/month';

  String get _savingsText => _isAnnual ? 'Save \u00A318 compared to monthly' : 'Flexible monthly billing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vector Pro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Vector', style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                  child: Text('PRO', style: AppTextStyles.captionMedium),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Advanced features for active users',
              style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _pricingCard(false)),
                const SizedBox(width: 16),
                Expanded(child: _pricingCard(true)),
              ],
            ),
            const SizedBox(height: 16),
            // Savings/billing info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isAnnual ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isAnnual ? AppColors.primary.withOpacity(0.3) : AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isAnnual ? Icons.savings_outlined : Icons.calendar_today_outlined,
                    size: 20,
                    color: _isAnnual ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(_savingsText, style: AppTextStyles.body2Medium.copyWith(color: _isAnnual ? AppColors.primary : AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ..._features.map((feature) => _featureItem(feature)),
            const SizedBox(height: 32),
            PrimaryButton(label: _buttonLabel, onPressed: () {}),
            const SizedBox(height: 16),
            Text(
              _isAnnual ? 'Billed annually at \u00A390. Cancel anytime.' : 'Billed monthly at \u00A39. Cancel anytime.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pricingCard(bool isAnnual) {
    final isSelected = isAnnual == _isAnnual;
    return InkWell(
      onTap: () => setState(() => _isAnnual = isAnnual),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Text(isAnnual ? 'Annual' : 'Monthly', style: AppTextStyles.body1Medium),
            const SizedBox(height: 8),
            Text(isAnnual ? '\u00A390' : '\u00A39', style: AppTextStyles.amountLarge),
            Text(isAnnual ? 'per year' : 'per month', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            if (isAnnual) ...[const SizedBox(height: 8), Text('Save \u00A318', style: AppTextStyles.body2Medium.copyWith(color: AppColors.primary))],
          ],
        ),
      ),
    );
  }

  Widget _featureItem(_Feature feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(feature.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: AppTextStyles.body1Medium),
                const SizedBox(height: 4),
                Text(feature.description, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(feature.comparison, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final List<_Feature> _features = [
    _Feature(icon: Icons.bolt, title: 'Priority Settlement', description: '2-second guarantee vs 5-second standard', comparison: 'Standard: 5s → Pro: 2s'),
    _Feature(icon: Icons.discount, title: 'Lower Fees', description: '1% + \u00A30.05 vs 1.3% + \u00A30.05 standard', comparison: 'Standard: 1.3% → Pro: 1%'),
    _Feature(
      icon: Icons.history,
      title: 'Unlimited Session History',
      description: 'Full history vs 90 days standard',
      comparison: 'Standard: 90 days → Pro: Unlimited',
    ),
    _Feature(icon: Icons.analytics, title: 'Session Analytics & Export', description: 'CSV and PDF export with branding', comparison: ''),
    _Feature(icon: Icons.sms, title: 'SMS Notifications', description: 'Instant alerts vs email/push only', comparison: 'Standard: Email/Push → Pro: SMS'),
    _Feature(icon: Icons.bedtime, title: 'Quiet Hours', description: 'Schedule non-critical alerts', comparison: ''),
    _Feature(icon: Icons.qr_code, title: 'Custom QR Branding', description: 'Add your logo to payment QR codes', comparison: ''),
    _Feature(
      icon: Icons.headset_mic,
      title: 'Dedicated Support',
      description: 'Priority help vs community support',
      comparison: 'Standard: Community → Pro: Dedicated',
    ),
  ];
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final String comparison;

  _Feature({required this.icon, required this.title, required this.description, required this.comparison});
}
