import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xff1A1A1D),
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          "Script Dev",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "scriptdev@gmail.com",
          style: TextStyle(
            color: Colors.white54,
          ),
        ),

        const SizedBox(height: 20),

        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
          ),
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text("Edit Profile"),
        )
      ],
    );
  }
}