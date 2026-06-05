import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Responsive.isDesktop(context) ? null : _buildDrawer(context),
      body: Responsive(
        mobile: _buildBody(context),
        tablet: Row(
          children: [
            Expanded(flex: 3, child: _buildDrawer(context)),
            Expanded(flex: 7, child: _buildBody(context)),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(flex: 2, child: _buildDrawer(context)),
            Expanded(flex: 8, child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildStatsGrid(context),
          const SizedBox(height: 24),
          Expanded(
            child: _buildRevenueChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Super Admin'),
            accountEmail: Text('admin@primecare.com'),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Branches'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
              context.push('/admin-dashboard/branches');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Staff Management'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
              context.push('/admin-dashboard/staff');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventory'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
              context.push('/admin-dashboard/inventory');
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Reports'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
              context.push('/admin-dashboard/reports');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_laundry_service),
            title: const Text('Machine Operations'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
              context.push('/admin-dashboard/machines');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Expense Tracker'),
            onTap: () {
              if (!Responsive.isDesktop(context)) Navigator.pop(context);
              context.push('/admin-dashboard/expenses');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: Responsive.isMobile(context) ? 2 : 1.5,
      children: [
        _buildStatCard('Total Orders', '1,284', Icons.shopping_basket, Colors.blue),
        _buildStatCard('Revenue', 'KES 450k', Icons.attach_money, Colors.green),
        _buildStatCard('Active Machines', '18/24', Icons.settings, Colors.blueGrey),
        _buildStatCard('Expenses', 'KES 147k', Icons.trending_down, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1),
                  Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text('Chart Placeholder', style: TextStyle(color: Colors.grey.shade400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
