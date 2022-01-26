import 'package:flutter/material.dart';

class ShowImageScreen extends StatelessWidget {
  final String imagePath;
  const ShowImageScreen(this.imagePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Hero(
        tag: imagePath,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
