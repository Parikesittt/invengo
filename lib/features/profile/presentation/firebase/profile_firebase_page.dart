import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/shared/widgets/app_container.dart';
import 'package:invengo/shared/widgets/button_logo.dart';
import 'package:invengo/shared/widgets/page_header.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/core/services/preference_handler.dart';
import 'package:invengo/core/config/route.dart';
import 'package:invengo/core/theme/theme.dart';
import 'package:invengo/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:invengo/core/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class ProfileFirebasePage extends StatefulWidget {
  const ProfileFirebasePage({super.key});

  @override
  State<ProfileFirebasePage> createState() => _ProfileFirebasePageState();
}

class _ProfileFirebasePageState extends State<ProfileFirebasePage> {
  bool isDark = false;
  bool isLoading = false;
  String? username;
  String? email;
  String? phone;

  Future<void> _loadUserProfile() async {
    try {
      final prefName = await PreferenceHandler.getUsername();
      if (!mounted) return;
      setState(() {
        username = prefName ?? 'Guest';
      });

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final user = await FirebaseService.getUserById(uid);
      if (!mounted) return;
      if (user != null) {
        setState(() {
          username = user.username ?? username;
          email = user.email ?? email;
          phone = user.phoneNumber ?? phone;
        });
      }
    } catch (e) {
    }
  }

  void _checkTheme() {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    if (provider.themeData == AppTheme.darkTheme) {
      isDark = true;
    } else {
      isDark = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTheme();
      if (mounted) setState(() {});
    });
  }

  Future<void> _logout() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    await PreferenceHandler.removeLogin();
    if (!mounted) return;
    setState(() => isLoading = false);
    context.router.replace(const LoginRouteFirebase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 24.0,
            left: 24,
            bottom: 120.0,
            top: 48.0,
          ),
          child: Column(
            children: [
              PageHeader(
                title: "Profile",
                subtitle: "Manage your account settings",
              ),
              h(12),
              AppContainer(
                child: Column(
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          child: Text((username ?? 'G')[0].toUpperCase()),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username ?? 'Guest',
                              style: AppTextStyle.h1(context),
                            ),
                            Card(
                              color: const Color(0xfff3e8fa),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4,
                                ),
                                child: Row(
                                  spacing: 4,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff60d694),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      width: 8,
                                      height: 8,
                                    ),
                                    const Text("Active"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    h(32),
                    const Divider(color: Color(0xffe5e7eb)),
                    h(24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 243, 245),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FontAwesomeIcons.envelope,
                          size: 20,
                          color: AppColor.primaryTextLightOpacity80,
                        ),
                      ),
                      title: Text(
                        "Email",
                        style: AppTextStyle.cardTitle(context),
                      ),
                      subtitle: Text(email ?? '—'),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 243, 245),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FontAwesomeIcons.phone,
                          size: 20,
                          color: AppColor.primaryTextLightOpacity80,
                        ),
                      ),
                      title: Text(
                        "Phone",
                        style: AppTextStyle.cardTitle(context),
                      ),
                      subtitle: Text(phone ?? '—'),
                    ),
                  ],
                ),
              ),
              h(16),
              AppContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text("Appearance", style: AppTextStyle.h4(context)),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xffefe9fc),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FontAwesomeIcons.sun,
                          size: 20,
                          color: AppColor.primary,
                        ),
                      ),
                      title: Text(
                        "Dark Mode",
                        style: AppTextStyle.cardTitle(context),
                      ),
                      subtitle: Text(
                        isDark ? "Enabled" : "Disabled",
                        style: AppTextStyle.sectionSubtitle(context),
                      ),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (v) {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).toogleTheme();
                          setState(() {
                            isDark = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              h(12),
              AppContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text("Settings", style: AppTextStyle.h4(context)),
                    InkWell(
                      onTap: () {
                        context.pushRoute(const EditProfileFirebaseRoute());
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 242, 243, 245),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            FontAwesomeIcons.user,
                            size: 20,
                            color: AppColor.primaryTextLightOpacity80,
                          ),
                        ),
                        title: Text(
                          "Edit Profile",
                          style: AppTextStyle.p(context),
                        ),
                        trailing: const Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              h(16),
              ButtonLogo(
                textButton: "Logout",
                icon: FontAwesomeIcons.rightFromBracket,
                iconColor: Colors.white,
                iconSize: 16,
                bgColor: Colors.red,
                onTap: () async {
                  await _logout();
                },
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
