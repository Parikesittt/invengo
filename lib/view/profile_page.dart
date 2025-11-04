import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/page_header.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/theme/theme.dart';
import 'package:invengo/theme/theme_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDark = false;
  void checkTheme() {
    if (Provider.of<ThemeProvider>(context, listen: false).themeData ==
        AppTheme.darkTheme) {
      isDark = true;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkTheme();
      setState(() {}); // update UI setelah checkTheme jalan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            children: [
              PageHeader(
                title: "Profile",
                subtitle: "Manage your account settings",
              ),
              AppContainer(
                child: Column(
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        CircleAvatar(radius: 32, child: Text("JD")),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("John Doe", style: AppTextStyle.h1(context)),
                            Card(
                              color: Color(0xfff3e8fa),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4,
                                ),
                                child: Row(
                                  spacing: 4,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xff60d694),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      width: 8,
                                      height: 8,
                                    ),
                                    Text("Active"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    h(32),
                    Divider(color: Color(0xffe5e7eb)),
                    h(24),
                    ListTile(
                      leading: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 243, 245),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FontAwesomeIcons.envelope,
                          size: 20,
                          color: AppColor.primaryTextLightOpacity80,
                        ),
                      ),
                      title: Text("Email", style: AppTextStyle.cardTitle(context)),
                      subtitle: Text("test@gmail.com"),
                    ),
                    ListTile(
                      leading: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 243, 245),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FontAwesomeIcons.phone,
                          size: 20,
                          color: AppColor.primaryTextLightOpacity80,
                        ),
                      ),
                      title: Text("Phone", style: AppTextStyle.cardTitle(context)),
                      subtitle: Text("+628468454"),
                    ),
                  ],
                ),
              ),
              h(16),
              AppContainer(
                child: ListTile(
                  leading: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Color(0xffefe9fc),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      FontAwesomeIcons.sun,
                      size: 20,
                      color: AppColor.primary,
                    ),
                  ),
                  title: Text("Dark Mode", style: AppTextStyle.cardTitle(context)),
                  subtitle: Text(
                    isDark ? "Enabled" : "Disabled",
                    style: AppTextStyle.sectionSubtitle(context),
                  ),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (v) {
                      setState(() {
                        Provider.of<ThemeProvider>(
                          context,
                          listen: false,
                        ).toogleTheme();
                        isDark = v;
                      });
                    },
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
