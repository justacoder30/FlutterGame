import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoadingGame extends StatelessWidget {
  const LoadingGame({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 10,

            ),
            SizedBox(height: 10,),
            Text('Loading...',style: TextStyle(fontSize: 20,color: Colors.blue),)
          ],
        ),

      ),
    );
  }
}
