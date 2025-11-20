import 'package:flutter/material.dart';

class AnimatedListView extends StatefulWidget {
  const AnimatedListView({super.key});

  @override
  State<AnimatedListView> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();

  Tween<Offset> tween = Tween<Offset>(
    begin: const Offset(1, 0),
    end: const Offset(0, 0),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (int i = 0; i < 5; i++) {
        key.currentState?.insertItem(i);
        await Future.delayed(const Duration(milliseconds: 200));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Animated List View",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedList(
          key: key,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          initialItemCount: 0,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: animation.drive(tween),
              child: const ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(5),
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                leading: Icon(Icons.image),
                title: Text("Animation List Item"),
                trailing: Icon(Icons.circle_notifications),
              ),
            );
          },
        ),
      ),
    );
  }
}
