import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/customer/home_screen.dart';
import '../../presentation/screens/customer/service_selection_screen.dart';
import '../../presentation/screens/customer/item_selection_screen.dart';
import '../../presentation/screens/customer/order_summary_screen.dart';
import '../../presentation/screens/customer/order_tracking_screen.dart';
import '../../presentation/screens/customer/profile_screen.dart';
import '../../presentation/screens/customer/support_screen.dart';
import '../../presentation/screens/customer/receipts_screen.dart';
import '../../presentation/screens/admin/dashboard_screen.dart';
import '../../presentation/screens/admin/inventory_screen.dart';
import '../../presentation/screens/admin/reports_screen.dart';
import '../../presentation/screens/admin/branch_management_screen.dart';
import '../../presentation/screens/admin/staff_management_screen.dart';
import '../../presentation/screens/admin/machine_management_screen.dart';
import '../../presentation/screens/admin/expense_tracker_screen.dart';
import '../../presentation/screens/staff/staff_home_screen.dart';
import '../../presentation/screens/rider/rider_home_screen.dart';
import '../../presentation/screens/admin/customer_management_screen.dart';
import '../../presentation/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/customer-home',
      builder: (context, state) => const CustomerHomeScreen(),
      routes: [
        GoRoute(
          path: 'service-selection',
          builder: (context, state) => const ServiceSelectionScreen(),
        ),
        GoRoute(
          path: 'item-selection',
          builder: (context, state) => const ItemSelectionScreen(),
        ),
        GoRoute(
          path: 'order-summary',
          builder: (context, state) => const OrderSummaryScreen(),
        ),
        GoRoute(
          path: 'order-tracking/:orderId',
          builder: (context, state) => OrderTrackingScreen(
            orderId: state.pathParameters['orderId'] ?? '',
          ),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'support',
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          path: 'receipts',
          builder: (context, state) => const ReceiptsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          path: 'inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: 'reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: 'branches',
          builder: (context, state) => const BranchManagementScreen(),
        ),
        GoRoute(
          path: 'staff',
          builder: (context, state) => const StaffManagementScreen(),
        ),
        GoRoute(
          path: 'customers',
          builder: (context, state) => const CustomerManagementScreen(),
        ),
        GoRoute(
          path: 'machines',
          builder: (context, state) => const MachineManagementScreen(),
        ),
        GoRoute(
          path: 'expenses',
          builder: (context, state) => const ExpenseTrackerScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/staff-home',
      builder: (context, state) => const StaffHomeScreen(),
    ),
    GoRoute(
      path: '/rider-home',
      builder: (context, state) => const RiderHomeScreen(),
    ),
  ],
);
