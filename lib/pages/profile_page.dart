import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firebase_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Settings'),
                  content: const Text('Settings functionality will be implemented here.'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.userCircle,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Please sign in',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          }

          return FutureBuilder<Map<String, dynamic>?>(
            future: FirebaseService.getUserProfile(),
            builder: (context, snapshot) {
              final userProfile = snapshot.data;
              final userName = userProfile?['name'] ?? 'User';
              final userEmail = userProfile?['email'] ?? auth.user?.email ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Picture
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Orders', '12'),
                              _buildStatItem('Wishlist', '5'),
                              _buildStatItem('Reviews', '8'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Menu Items
                    _buildMenuSection(
                      'Account',
                      [
                        _buildMenuItem(
                          icon: Icons.person,
                          title: 'Personal Information',
                          subtitle: 'Update your profile details',
                          onTap: () {
                            _showFeatureDialog(context, 'Personal Information');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.location_on,
                          title: 'Shipping Addresses',
                          subtitle: 'Manage your delivery addresses',
                          onTap: () {
                            _showFeatureDialog(context, 'Shipping Addresses');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.payment,
                          title: 'Payment Methods',
                          subtitle: 'Add or update payment options',
                          onTap: () {
                            _showFeatureDialog(context, 'Payment Methods');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildMenuSection(
                      'Orders & Returns',
                      [
                        _buildMenuItem(
                          icon: Icons.shopping_bag,
                          title: 'Order History',
                          subtitle: 'View your past orders',
                          onTap: () {
                            _showFeatureDialog(context, 'Order History');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.assignment_return,
                          title: 'Returns & Refunds',
                          subtitle: 'Manage returns and refunds',
                          onTap: () {
                            _showFeatureDialog(context, 'Returns & Refunds');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.track_changes,
                          title: 'Track Orders',
                          subtitle: 'Track your current orders',
                          onTap: () {
                            _showFeatureDialog(context, 'Track Orders');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildMenuSection(
                      'Support',
                      [
                        _buildMenuItem(
                          icon: Icons.help,
                          title: 'Help Center',
                          subtitle: 'Get help and support',
                          onTap: () {
                            _showFeatureDialog(context, 'Help Center');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.chat,
                          title: 'Contact Us',
                          subtitle: 'Get in touch with our team',
                          onTap: () {
                            _showFeatureDialog(context, 'Contact Us');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.feedback,
                          title: 'Feedback',
                          subtitle: 'Share your feedback with us',
                          onTap: () {
                            _showFeatureDialog(context, 'Feedback');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildMenuSection(
                      'App',
                      [
                        _buildMenuItem(
                          icon: Icons.info,
                          title: 'About Zambeel',
                          subtitle: 'Learn more about our company',
                          onTap: () {
                            context.go('/about');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.privacy_tip,
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                          onTap: () {
                            _showFeatureDialog(context, 'Privacy Policy');
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.description,
                          title: 'Terms of Service',
                          subtitle: 'Read our terms of service',
                          onTap: () {
                            _showFeatureDialog(context, 'Terms of Service');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await auth.signOut();
                                    context.pop();
                                    context.go('/login');
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2563EB),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF6B7280),
      ),
      onTap: onTap,
    );
  }

  void _showFeatureDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature functionality will be implemented in the full version.'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 