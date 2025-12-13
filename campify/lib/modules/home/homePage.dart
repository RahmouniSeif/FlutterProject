import 'package:campify/config/routes/app_routes.dart';
import 'package:campify/modules/auth/presentation/pages/login_page.dart';
import 'package:campify/modules/auth/presentation/pages/userProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // Needed for ImageFilter.blur in BackdropFilter
import 'package:shared_preferences/shared_preferences.dart';

// --- COLOR PALETTE (From Tailwind Config) ---
const Color primary = Color(0xFF386641); // Rich green
const Color secondary = Color(0xFF6A994E); // Lighter, friendly green
const Color accent = Color(0xFFA7C957); // Vibrant lime green
const Color backgroundLight = Color(0xFFF7F7F7);
const Color backgroundDark = Color(0xFF121212);
const Color textLightPrimary = Color(0xFF1B1B1B);
const Color textDarkPrimary = Color(0xFFF7F7F7);
const Color textLightSecondary = Color(0xFF575757);
const Color textDarkSecondary = Color(0xFFA3A3A3);
const Color cardLight = Color(0xFFFFFFFF);
const Color cardDark = Color(0xFF1E1E1E);

// Removed the global 'userName' variable as state should be managed locally.

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'CampConnect',
    //   theme: ThemeData(
    //     // NOTE: 'Plus Jakarta Sans' needs to be added to pubspec.yaml and assets
    //     fontFamily: 'Plus Jakarta Sans',
    //     primaryColor: primary,
    //     scaffoldBackgroundColor: backgroundLight,
    //     brightness: Brightness.light,
    //     colorScheme: ColorScheme.light(
    //       primary: primary,
    //       secondary: secondary,
    //       surface: cardLight,
    //       background: backgroundLight,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   darkTheme: ThemeData(
    //     fontFamily: 'Plus Jakarta Sans',
    //     primaryColor: primary,
    //     scaffoldBackgroundColor: backgroundDark,
    //     brightness: Brightness.dark,
    //     colorScheme: ColorScheme.dark(
    //       primary: primary,
    //       secondary: secondary,
    //       surface: cardDark,
    //       background: backgroundDark,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   home: const HomeScreen(),
    // );
  }
}

// Converted to StatefulWidget to handle asynchronous data loading
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variable to hold the fetched user name
  String _userNmae = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Asynchronous method to load data from SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Safely fetch the string, defaulting to 'Guest' if not found
      final String? loadedName = prefs.getString("userName");

      // Update the state to rebuild the UI with the loaded name
      setState(() {
        this._userNmae = loadedName ?? 'Guest';
      });
    } catch (e) {
      // Handle potential errors during loading
      setState(() {
        this._userNmae = 'Error';
      });
      print('Error loading SharedPreferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are in dark mode for dynamic colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? textDarkPrimary : textLightPrimary;
    final secondaryTextColor = isDarkMode ? textDarkSecondary : textLightSecondary;
    final cardColor = isDarkMode ? cardDark : cardLight;

    // Apply transparent status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Background Image and Gradient (mimics HTML .absolute h-[45vh])
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: ShaderMask(
              shaderCallback: (rect) {
                // Gradient for fade-out effect at the bottom
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAR3_YtJ7r01cOw6uuPrhbHamZ4K2ZY0VlHgbadI6CJNEILTd36oV27j1o0w4a8LvYFR2uDSNAu7S2HFkeTejc_fmSBXLhNm86VSyAUQ94cNAquAugzguJ7YZl0Y3ERRbKkij4FMkM_z4hH2wpnj7UQBH9bqQVrn5xyrAOFDDAcmBe7OU6n_pIwAwiBndRxDcWkiXQ_PeDb743uwgeFZ283HgbZgWewjfmEbj6NHaX-YjA-rdG4UChOX9awKJvKKVfoYjd9gMdM0nni',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: primary, child: const Center(child: Text("Forest View", style: TextStyle(color: Colors.white)))),
              ),
            ),
          ),
          // 2. Main Scrollable Content
          SafeArea(
            top: false, // Control the top padding manually
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header with large top padding
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10.0,
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: _buildHeader(primaryTextColor, this._userNmae, context), // Pass _userName from state
                  ),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: _buildSearchBar(cardColor, secondaryTextColor, primary),
                  ),
                  // Categories Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: _buildCategoriesGrid(cardColor, primary, secondaryTextColor),
                  ),
                  // Nearby Section
                  _buildSectionHeader(context, 'Nearby You', primary),
                  const SizedBox(height: 8.0),
                  _buildHorizontalCampsiteList(context),
                  const SizedBox(height: 24.0),
                  // Activities Section
                  _buildSectionHeader(context, 'Popular Activities', primary, showSeeAll: false),
                  const SizedBox(height: 8.0),
                  _buildActivityList(cardColor, primaryTextColor, secondaryTextColor),
                  // Space for Bottom Navigation Bar
                  const SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
          // 3. Bottom Navigation Bar (Fixed position)
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(isDarkMode),
    );
  }

  // Updated to accept the user name as a parameter
  Widget _buildHeader(Color primaryTextColor, String userName, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back,',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        // RIGHT SIDE : Profile + Logout Button
        Row(
          children: [
            // // PROFILE IMAGE
            // Container(
            //   height: 48,
            //   width: 48,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(24.0),
            //     color: Colors.white.withOpacity(0.2),
            //     border: Border.all(color: Colors.white54, width: 1.5),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 10,
            //         offset: Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: ClipOval(
            //     child: Image.network(
            //       'https://lh3.googleusercontent.com/aida-public/AB6AXuAVpYf51q-0ZxpUMdlqPGwFUGUrlR6LenzE0ENfWEPxSTRJM7-_46RBXtpR7KWi_cUyuOySXSfEQfQMIOrP0qPKc_J2BgGW4gy4AjHc8aPotOkVWUg8oae0PjXZ7g42SlDKzMc9b6zS1mh-AQfWkrCtemLrbx26GxVtfkEZfVe1i5An5jEuAJUF9ksy45EAj6G-i4zlr9G4uDk1bFH4rdgH0h5a71JQ_n-YUN577D8dE546dqpRNGXzm2lGm7ka0aSUBm-eo7VwNDvg',
            //       fit: BoxFit.cover,
            //       errorBuilder: (context, error, stackTrace) => Icon(Icons.person, color: primaryTextColor),
            //     ),
            //   ),
            // ),

            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.deepOrange],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded),
                color: Colors.white,
                iconSize: 26,
                tooltip: 'Logout',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSearchBar(Color cardColor, Color hintColor, Color focusColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for places or activities...',
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: Icon(Icons.search, color: hintColor),
          filled: true,
          fillColor: cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: focusColor, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(Color cardColor, Color iconColor, Color textColor) {
    final categories = [
      {'name': 'Mountains', 'icon': Icons.filter_hdr},
      {'name': 'Forests', 'icon': Icons.forest},
      {'name': 'Lakes', 'icon': Icons.surfing},
      {'name': 'RV Parks', 'icon': Icons.rv_hookup},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75, // Adjust to fit icon and text
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(category['icon'] as IconData, size: 32, color: iconColor),
            ),
            const SizedBox(height: 8.0),
            Text(
              category['name'].toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color accentColor, {bool showSeeAll = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              // Use primary text color from theme
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          if (showSeeAll)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See all',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCampsiteList(BuildContext context) {
    final campsites = [
      {
        'name': 'Whispering Pines',
        'distance': '12km away',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC4mIhhmxS-liKUnYMfunXMxF7B_dS1TYndAOjqF0nw30FqW1Tx_Y-t8ZRva9yX1v5ytfV2_YO7DdGBW-6HOqT2s2z-QkiqTVlrZmMPGgv2MBOk5vg1jFzHPKh06v0tRfGY2JgR7O-7fkoUPT5F6_10NK_dqxmmFS00RpX89gOszBFiCBFNi29W8KJ-mjwGAtPLeSmojE1k493V2xx09mQvX6YfgwYFoPJVCdSz5AGOzA5oAbGzE_HpVXCpdSnX03jxBsHCUXdCl4wj'
      },
      {
        'name': 'Starlight Valley',
        'distance': '25km away',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA-pHXNlRoZ8Xt3yhOq3YO0h-AGbn3uxRJZ-fs8aHeEKaAx1_1ProRi0O1VM4RZu_445Qau6Py8B6jHB5ymd_ehQjTmgAmj_6aPVs2AMxrCXbL2qXq_IE-cQJnTynZERJLozz4F0lPn8d-Thc78RFoAKG1h74s9NG3XPbWj3SQH3jkldz4-2458sKhteyNEwccDReQpjY99m6ZJQPVgUl7pEMPm1kNUod-rRv7jGxQqqJGoP0H0cTJvqDF9aoNiWk-nK8RZlwyci-Rx'
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: campsites.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemBuilder: (context, index) {
          final campsite = campsites[index];
          return Padding(
            padding: EdgeInsets.only(right: index < campsites.length - 1 ? 16.0 : 0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.66, // w-2/3
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Stack(
                  children: [
                    Image.network(
                      campsite['imageUrl']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(color: secondary, child: Center(child: Text(campsite['name']!, style: const TextStyle(color: Colors.white)))),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12.0,
                      bottom: 12.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campsite['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            campsite['distance']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityList(Color cardColor, Color primaryTextColor, Color secondaryTextColor) {
    final activities = [
      {
        'title': 'Hiking',
        'subtitle': 'Explore scenic trails',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBFFTsRxaxLlMIEz5r8WYZ_ef9p9WWbfqJoqEzj5z3hXgWsJI6hIPIyQ7xQgiUKImpCqpUNB0FMziNPsSuvepSlLWq4roKt_2UxzcKUBhakzrNOvXXmPCkHgUHHOLj8zSIqs6euQTVmza5l1zg3HyVHL9L-0pqVIV9f21g84y7-izHa1ZhEMoTOrg3kIWZsHTDBLWp0ADokeQrlDRJ1BOPZBTU1V68-SmuAtoaom7jqceAO1ysPjiDF0_CAGNuh2ezAesd2Bl7idDrc'
      },
      {
        'title': 'Kayaking',
        'subtitle': 'Paddle through calm waters',
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDDAcl13zPcmGvBru4uHYkeBhvpLLtQ3fssG36nDxIp5K-9UQ26mWP971RvL2qBn7wa4b59RBiFJTRgm3yRlGwxFNxOcp_vP7tP3Z2tH7Ej8TZDlvl9Z1CigBS_F4B-yyMtTPgH3HAbcC6Wy4hyIOsYJ96aHEM7x4Og6vMulCCoebZ_80wft6rI_kIlIegVfHmMgqxUP7vUJhlPQ7b74ACtHbUe7tMEkeAZnekCzocymPRBlqdB5dyTuCHCLzJIyx76OXjOSGubS0cm'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: activities.map((activity) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    activity['imageUrl']!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(width: 64, height: 64, color: accent, child: const Center(child: Icon(Icons.terrain, color: cardLight))),
                  ),
                ),
                title: Text(
                  activity['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                subtitle: Text(
                  activity['subtitle']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: secondaryTextColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: secondaryTextColor),
                onTap: () {
                  // Handle navigation to activity detail
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDarkMode) {
    // Colors dynamically change based on theme
    final navBackgroundColor = isDarkMode ? cardDark.withOpacity(0.8) : cardLight.withOpacity(0.8);
    final navBorderColor = isDarkMode ? Colors.grey[700] : Colors.grey[200];
    final inactiveColor = isDarkMode ? textDarkSecondary : textLightSecondary;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: navBorderColor!, width: 1.0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: navBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', primary, true, () {
                  // Currently on home, do nothing or scroll to top
                }),
                _buildNavItem(Icons.map, 'Discover', inactiveColor, false, () {}),
                _buildNavItem(Icons.favorite, 'Favorites', inactiveColor, false, () {}),
                // 🚀 Implemented Navigation Here
                _buildNavItem(Icons.person, 'Profile', inactiveColor, false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserProfilePage()),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Modified _buildNavItem to accept an onTap callback
  Widget _buildNavItem(IconData icon, String label, Color color, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
