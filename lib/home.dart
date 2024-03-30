import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gitapi/repolist.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController ownerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GitHub Repositories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/coder.svg', height: 200),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(
                labelText: 'Enter Owner Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Repolist(
                      owner: ownerController.text.trim(),
                    ),
                  ),
                );
              },
              child: const Text('Show Repositories'),
            ),
          ],
        ),
      ),
    );
  }
}
