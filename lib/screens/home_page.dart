import 'package:athletech/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    Widget tool(IconData icon, String label, String dest) => _ToolIcon(
      icon: icon,
      label: label,
      onTap: () => Navigator.pushNamed(context, dest),
    );

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("AthleTech", style: kAppBarTitleTextStyle),
          backgroundColor: AppColors.appBarColor,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _ActionChip(icon: Icons.favorite_border, label: 'Favorites'),
                          _ActionChip(icon: Icons.history, label: 'History'),
                          _ActionChip(icon: Icons.smart_toy_outlined, label: 'AI'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/banner.png',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(title: 'Tools', onTap: () {}),
                      const SizedBox(height: 8),
                      Padding(
                        padding: AppPaddings.horizontal20Vertical12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tool(Icons.monitor_weight_outlined, 'BMI\n', '/bmi'),
                            tool(Icons.local_fire_department, 'Calorie\nTracker', '/CalorieTracker'),
                            tool(CupertinoIcons.chart_pie, 'Activity\nEntry', '/activity_entry'),
                            tool(Icons.people, 'Social\nFeed', '/social_feed'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _SectionHeader(title: "Today's Highlights", onTap: () {}),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: AppPaddings.all12,
                    children: [
                      _HighlightCard(
                        asset: 'assets/workout_summary.png',
                        title: 'Workout Summary\nCard',
                        onTap: () => Navigator.pushNamed(context, '/workout_summary'), // EKLENDİ
                      ),

                      _HighlightCard(
                        asset: 'assets/achievements.png',
                        title: 'Achievements',
                        onTap: () => Navigator.pushNamed(context, '/achievements'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label, super.key});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label, style: kButtonLightTextStyle),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onTap, super.key});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kButtonLightTextStyle),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: onTap),
      ],
    );
  }
}

class _ToolIcon extends StatelessWidget {
  const _ToolIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = AppColors.buttonColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: backgroundColor,
            child: Icon(icon, size: 32, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: kButtonLightTextStyle,
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.asset,
    required this.title,
    this.onTap,
    super.key,
  });
  final String asset;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardBody = SizedBox(
      width: 180,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Image.asset(asset, fit: BoxFit.cover)),
            Padding(
              padding: AppPaddings.all12,
              child: Text(title, style: kButtonLightTextStyle),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: AppPaddings.onlyLeft12,
      child: onTap == null
          ? cardBody
          : InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: cardBody,
            ),
    );
  }
}
