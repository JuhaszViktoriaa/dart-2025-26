import 'package:flutter/material.dart';

class Dadaizmus extends StatelessWidget {
  const Dadaizmus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 206, 111),
        title: Text('dadaista vers'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'dadaista vers',
              style: TextStyle(
                color: Colors.redAccent, fontSize: 26, fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'dadaista vers',
              style: TextStyle(
                color: Colors.redAccent, fontSize: 26, fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
