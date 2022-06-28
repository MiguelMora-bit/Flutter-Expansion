import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/Logo3B.png",
              height: 50.0,
              width: 50.0,
            ),
            Container(
              width: 140,
            ),
            const Expanded(
              child: FittedBox(
                child: Text("            FICHAS"),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Image.asset("assets/loading.gif"),
      ),
    );
  }
}
