import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Executive Dashboard', style: TextStyle(letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Responsive.isDesktop(context) ? null : _buildModernDrawer(context, ref),
      body: ordersAsync.when(
        data: (orders) {
          final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.totalPrice);
          return Responsive(
            mobile: _buildBody(context, orders.length, totalRevenue),
            tablet: Row(
              children: [
                Expanded(flex: 3, child: _buildModernDrawer(context, ref)),
                Expanded(flex: 7, child: _buildBody(context, orders.length, totalRevenue)),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(flex: 2, child: _buildModernDrawer(context, ref)),
                Expanded(flex: 8, child: _buildBody(context, orders.length, totalRevenue)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, int totalOrders, double revenue) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 24),
          _buildStatsGrid(context, totalOrders, revenue),
          const SizedBox(height: 24),
          _buildActivitySection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good Morning, Admin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -1)),
        Text('Here is what\'s happening with PrimeCare today.', style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildModernDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.secondary,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('PRIMECARE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ),
          ),
          _buildDrawerItem(Icons.grid_view_rounded, 'Dashboard', true, () {}),
          _buildDrawerItem(Icons.storefront_rounded, 'Branches', false, () => context.push('/admin-dashboard/branches')),
          _buildDrawerItem(Icons.people_alt_rounded, 'Staff', false, () => context.push('/admin-dashboard/staff')),
          _buildDrawerItem(Icons.person_search_rounded, 'Customers', false, () => context.push('/admin-dashboard/customers')),
          _buildDrawerItem(Icons.inventory_2_rounded, 'Inventory', false, () => context.push('/admin-dashboard/inventory')),
          _buildDrawerItem(Icons.settings_suggest_rounded, 'Machines', false, () => context.push('/admin-dashboard/machines')),
          _buildDrawerItem(Icons.receipt_long_rounded, 'Expenses', false, () => context.push('/admin-dashboard/expenses')),
          const Spacer(),
          const Divider(color: Colors.white10),
          _buildDrawerItem(Icons.logout_rounded, 'Logout', false, () async {
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) context.go('/login');
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 22),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.05),
    );
  }

  Widget _buildStatsGrid(BuildContext context, int totalOrders, double revenue) {
    final int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('Revenue', 'KES ${revenue.toStringAsFixed(0)}', Icons.payments_rounded, Colors.green),
        _buildStatCard('Orders', '$totalOrders', Icons.shopping_bag_rounded, Colors.blue),
        _buildStatCard('Active', '12', Icons.loop_rounded, Colors.orange),
        _buildStatCard('Rating', '4.9', Icons.star_rounded, Colors.amber),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Operations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.more_horiz, color: AppColors.textLight),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(Icons.query_stats_rounded, size: 60, color: Colors.grey.shade200),
                const SizedBox(height: 16),
                const Text('Analytics are being updated in real-time', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
