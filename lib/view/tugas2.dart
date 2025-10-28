import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/preferences/preference_handler.dart';
import 'package:invengo/route.dart';
import 'package:invengo/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Tugas2Widget extends StatelessWidget {
  const Tugas2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Lengkap"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            onPressed: () {
              PreferenceHandler.removeLogin();
              context.router.replace(const LoginRoute());
            },
            icon: Icon(Icons.logout),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Center(
            child: Text(
              "Parikesit",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Spacer(),
                Icon(Icons.email),
                SizedBox(width: 12),
                Text("parikesit@gmail.com"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [Spacer(), Icon(Icons.phone), Text("+62814958546")],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      "Postingan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      "Followers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et tortor quis magna varius euismod id quis lorem. Integer at efficitur ligula, ac varius neque. Duis non diam maximus, egestas metus finibus, congue lacus. Curabitur nisi libero, ornare a dictum quis, hendrerit ut enim. Vestibulum sem risus, accumsan non diam eget, semper ullamcorper magna. Quisque laoreet quam in risus aliquet, facilisis maximus ipsum ultricies. Etiam cursus ligula sapien, vel vulputate nisi interdum ut. Maecenas rutrum rutrum tortor quis auctor. Etiam vitae dictum sem. In hac habitasse platea dictumst. Pellentesque elementum ipsum neque, id rutrum velit lobortis vitae. Nulla quis eros bibendum, interdum nisi ac, varius nisi.",
              ),
            ),
          ),
          // Padding(padding: EdgeInsets.all(12.0), child: Text("Ini deskripsi")),
          Spacer(),
          Container(
            width: 800,
            height: 60,
            margin: EdgeInsets.only(top: 12.0),
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              // gradient: LinearGradient(
              //   colors: [Colors.lightGreen, Colors.yellow, Colors.green],
              // ),
            ),
            child: Center(
              child: Text(
                "Terima kasih telah mengunjungi profil saya!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
