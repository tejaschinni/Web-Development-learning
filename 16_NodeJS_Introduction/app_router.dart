import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:society_seva/features/auth/presentation/providers/auth_provider.dart';
import 'package:society_seva/features/auth/presentation/providers/registration_provider.dart';
import 'package:society_seva/features/auth/presentation/screens/authenticated_home_screen.dart';
import 'package:society_seva/features/auth/presentation/screens/login_screen.dart';
import 'package:society_seva/features/auth/presentation/screens/otp_flow_screens.dart';
import 'package:society_seva/features/profile/presentation/providers/user_mode_provider.dart';
import 'package:society_seva/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:society_seva/features/profile/presentation/screens/profile_screen.dart';
import 'package:society_seva/features/profile/presentation/screens/phone_number_verification_screen.dart';
import 'package:society_seva/features/location/presentation/screens/location_picker_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/dashboard/seller_dashbard_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/dashboard/seller_orders_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/models/seller_order_ui_model.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_orders_list_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_details_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_accepted_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_mark_preparing_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_ready_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_out_for_delivery_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_completed_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_cancelled_seller_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_cancelled_customer_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/orders/seller_order_timeline_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/listing/seller_listing_screen.dart';
import 'package:society_seva/features/seller/presentation/provider/seller_onboarding_provider.dart';
import 'package:society_seva/features/seller/presentation/screens/listing/add_seller_listing_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/on_boarding/seller_onboarding_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_categories_screen.dart';
import 'package:society_seva/features/shop/presentation/widgets/listing/shop_product_list.dart';
import 'package:society_seva/features/shop/presentation/widgets/seller/shop_all_sellers_list.dart';
import 'package:society_seva/features/society/presentation/screens/society_onboarding_screen.dart';
import 'package:society_seva/features/common/presentation/screens/common_modules_screen.dart';
import 'package:society_seva/features/seller/presentation/screens/on_boarding/seller_modules_screen.dart';
import 'package:society_seva/features/society_admin/presentation/screens/society_admin_modules_screen.dart';
import 'package:society_seva/features/super_admin/presentation/screens/super_admin_modules_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_search_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/category_listing_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/seller_store_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/product_details_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/service_details_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_cart_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_fulfillment_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_checkout_confirmation_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_orders_screen.dart';
import 'package:society_seva/features/shop/presentation/screens/shop_order_tracking_screen.dart'
    as order_tracking;
import 'package:society_seva/features/shop/presentation/screens/shop_service_booking_details_screen.dart';
import 'package:society_seva/features/shop/domain/entities/shop_listing.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authControllerProvider);

      return authState.when(
        data: (sessionState) {
          final isAuthenticated = sessionState.isAuthenticated;

          if (state.matchedLocation == '/login') {
            if (isAuthenticated) {
              return container.read(userModeProvider) == UserMode.seller
                  ? '/modules/seller/sellerdashboard'
                  : '/';
            }

            if (isAuthenticated &&
                state.matchedLocation == '/' &&
                container.read(userModeProvider) == UserMode.seller) {
              return '/modules/seller/sellerdashboard';
            }

            final pending = container.read(registrationControllerProvider).valueOrNull;
            if (pending != null) {
              return pending.profileCompletionRequired ? '/complete-profile' : '/verify-otp';
            }

            return null;
          }

          if (state.matchedLocation == '/login' ||
              state.matchedLocation == '/verify-otp' ||
              state.matchedLocation == '/complete-profile') {
            return isAuthenticated ? '/' : null;
          }

          const protectedLocations = {
            '/',
            '/dashboard',
            '/society-onboarding',
            '/profile',
            '/profile/edit',
            '/phone-number',
            '/locations',
            '/modules/seller/sellerdashboard',
            '/modules/common',
            '/modules/seller',
            '/modules/society-admin',
            '/modules/super-admin',
          };

          if (isAuthenticated && protectedLocations.contains(state.matchedLocation)) {
            return null;
          }

          if (state.matchedLocation == '/shop' || state.matchedLocation.startsWith('/shop/')) {
            return isAuthenticated ? null : '/login';
          }

          if (!isAuthenticated && protectedLocations.contains(state.matchedLocation)) {
            container.invalidate(mySellerProfileProvider);
            return '/login';
          }

          return null;
        },
        loading: () => null,
        error: (_, _) {
          const publicAuthLocations = {'/login', '/verify-otp', '/complete-profile'};

          return publicAuthLocations.contains(state.matchedLocation) ? null : '/login';
        },
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthenticatedHomeScreen()),

      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AuthenticatedHomeScreen(bypassResidentGate: true),
      ),

      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      GoRoute(path: '/verify-otp', builder: (context, state) => const OtpVerificationScreen()),

      GoRoute(
        path: '/complete-profile',
        builder: (context, state) => const CompleteProfileScreen(),
      ),

      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),

      GoRoute(path: '/locations', builder: (context, state) => const LocationPickerScreen()),

      GoRoute(path: '/profile/edit', builder: (context, state) => const EditProfileScreen()),

      GoRoute(
        path: '/phone-number',
        builder: (context, state) => const PhoneNumberVerificationScreen(),
      ),

      GoRoute(
        path: '/society-onboarding',
        builder: (context, state) => const SocietyOnboardingScreen(),
      ),

      GoRoute(path: '/modules/common', builder: (context, state) => const CommonModulesScreen()),

      GoRoute(path: '/modules/seller', builder: (context, state) => const SellerModulesScreen()),

      GoRoute(
        path: '/modules/society-admin',
        builder: (context, state) => const SocietyAdminModulesScreen(),
      ),

      GoRoute(
        path: '/modules/super-admin',
        builder: (context, state) => const SuperAdminModulesScreen(),
      ),

      GoRoute(path: '/shop', builder: (context, state) => const ShopScreen(societyId: null)),

      GoRoute(
        path: '/shop/search',
        builder: (context, state) => ShopSearchScreen(initialQuery: state.uri.queryParameters['q']),
      ),

      GoRoute(
        path: '/shop/:listingType/category/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          final listingType = state.pathParameters['listingType']!;
          final societyId = state.extra is String ? state.extra as String : null;

          return CategoryListingScreen(
            categoryId: categoryId,
            categoryName: state.uri.queryParameters['name'] ?? categoryId,
            societyId: societyId,
            listingType: listingType == 'service'
                ? ShopListingType.service
                : ShopListingType.product,
          );
        },
      ),

      GoRoute(
        path: '/shop/categories',
        builder: (context, state) {
          final societyId = state.extra is String ? state.extra as String : null;
          return ShopCategoriesScreen(societyId: societyId);
        },
      ),

      GoRoute(
        path: '/shop/listings',
        builder: (context, state) {
          return ProductList(societyId: state.extra as String?);
        },
      ),

      GoRoute(
        path: '/shop/sellers',
        builder: (context, state) {
          return ShopAllSellersList(societyId: state.extra as String?);
        },
      ),

      GoRoute(
        path: '/shop/seller/:sellerId',
        builder: (context, state) {
          final sellerId = state.pathParameters['sellerId']!;
          final sellerName = sellerId
              .split('-')
              .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
              .join(' ');
          return SellerStoreScreen(sellerId: sellerId, sellerName: sellerName);
        },
      ),

      GoRoute(
        path: '/shop/product/:productId',
        builder: (context, state) => ProductDetailsScreen(
          productId: state.pathParameters['productId']!,
          listing: state.extra is ShopListing ? state.extra as ShopListing : null,
        ),
      ),

      GoRoute(
        path: '/shop/service/:serviceId',
        builder: (context, state) => ServiceDetailsScreen(
          serviceId: state.pathParameters['serviceId']!,
          listing: state.extra is ShopListing ? state.extra as ShopListing : null,
        ),
      ),

      GoRoute(path: '/shop/cart', builder: (context, state) => const ShopCartScreen()),

      GoRoute(
        path: '/shop/fulfilment',
        builder: (context, state) {
          final sellerGroups = state.extra is List<ShopFulfillmentSellerGroup>
              ? state.extra as List<ShopFulfillmentSellerGroup>
              : null;
          return ShopFulfillmentScreen(sellerGroups: sellerGroups);
        },
      ),

      GoRoute(
        path: '/shop/checkout',
        builder: (context, state) => const ShopCheckoutConfirmationScreen(),
      ),

      GoRoute(path: '/shop/orders', builder: (context, state) => const ShopOrdersScreen()),

      GoRoute(
        path: '/shop/orders/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          final extra = state.extra;
          return order_tracking.ShopOrderTrackingScreen(
            orderData: extra is order_tracking.ShopOrderTrackingData
                ? extra
                : order_tracking.ShopOrderTrackingData(
                    orderId: orderId,
                    sellerId: '',
                    sellerName: 'Seller',
                    status: order_tracking.ShopOrderStatus.confirmed,
                    statusTitle: 'Order confirmed',
                    statusDescription: 'Your order has been confirmed.',
                    fulfillmentMethod: order_tracking.ShopTrackingFulfillmentMethod.deliverToMyFlat,
                    fulfillmentTitle: 'Delivery to your flat',
                    fulfillmentDetail: 'Your registered address',
                    items: const [],
                    subtotal: 0,
                    totalAmount: 0,
                    paymentMethodLabel: 'Payment pending',
                    paymentStatusLabel: 'Pending',
                  ),
          );
        },
      ),

      GoRoute(
        path: '/shop/bookings/:bookingId',
        builder: (context, state) {
          final extra = state.extra;
          return ShopServiceBookingDetailsScreen(
            booking: extra is ShopServiceBookingDetails
                ? extra
                : ShopServiceBookingDetails.mock(bookingId: state.pathParameters['bookingId']),
          );
        },
      ),

      GoRoute(
        path: '/modules/seller/onboarding',
        builder: (context, state) {
          final isEdit = state.extra as bool? ?? false;
          return SellerOnboardingScreen(isEdit: isEdit);
        },
      ),

      GoRoute(
        path: '/modules/seller/sellerdashboard',
        builder: (context, state) {
          return SellerDashboardScreen();
        },
      ),
      GoRoute(
        path: '/modules/seller/addListing',
        builder: (context, state) {
          return const AddSellerListingScreen();
        },
      ),
      GoRoute(
        path: '/modules/seller/orders',
        builder: (context, state) {
          return const SellerOrdersListScreen();
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/details',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/accepted',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderAcceptedScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/preparing',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderMarkPreparingScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/ready',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderReadyScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/out-for-delivery',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderOutForDeliveryScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/completed',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderCompletedScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/cancelled-seller',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderCancelledSellerScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/cancelled-customer',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderCancelledCustomerScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/orders/timeline',
        builder: (context, state) {
          final order = state.extra is SellerOrderUiModel
              ? state.extra as SellerOrderUiModel
              : null;
          return SellerOrderTimelineScreen(order: order);
        },
      ),
      GoRoute(
        path: '/modules/seller/listings',
        builder: (context, state) {
          return const MyListingsScreen();
        },
      ),
    ],
  );
}
