import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OnlineStatusWidget extends StatefulWidget {
  final Widget
      child; // The child widget where you want to display the online status.

  const OnlineStatusWidget({required this.child});

  @override
  _OnlineStatusWidgetState createState() => _OnlineStatusWidgetState();
}

class _OnlineStatusWidgetState extends State<OnlineStatusWidget> {
  late Stream<ConnectivityResult> connectivityStream;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    connectivityStream = Connectivity().onConnectivityChanged;
    connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        isOnline = (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          isOnline = (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi);
        }

        return Column(
          children: [
            widget.child,
          ],
        );
      },
    );
  }
}
