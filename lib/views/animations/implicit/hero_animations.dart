import 'package:flutter/material.dart';

class EmojiPerson {
  final String name;
  final String emoji;
  final String age;

  const EmojiPerson({
    required this.name,
    required this.emoji,
    required this.age,
  });
}

class HeroAnimation extends StatefulWidget {
  const HeroAnimation({super.key});
  @override
  State<HeroAnimation> createState() => _HeroAnimationState();
}

class _HeroAnimationState extends State<HeroAnimation> {
  final List<EmojiPerson> people = const [
    EmojiPerson(name: "John", emoji: "👨‍🏭", age: "25"),
    EmojiPerson(name: "Jane", emoji: """
👩‍🏭""", age: "22"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Hero Animation",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];

                return personDetail(context, person);
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile personDetail(BuildContext context, EmojiPerson person) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroDetail(person: person),
          ),
        );
      },
      leading: Hero(
        tag: person.name,
        child: Text(
          person.emoji,
          style: const TextStyle(fontSize: 50),
        ),
      ),
      title: Text(person.name),
      subtitle: Text(person.age),
    );
  }
}

class HeroDetail extends StatelessWidget {
  final EmojiPerson person;
  const HeroDetail({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: heroAnimation(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            person.name,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20, width: double.maxFinite),
          Text(
            "${person.age} years old",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Hero heroAnimation() {
    return Hero(
      /// Enables modification on the flying widget
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        switch (flightDirection) {
          case HeroFlightDirection.push:
            return Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: animation.drive(
                  Tween<double>(
                    begin: 0,
                    end: 1,
                  ).chain(
                    CurveTween(curve: Curves.fastOutSlowIn),
                  ),
                ),
                child: toHeroContext.widget,
              ),
            );
          case HeroFlightDirection.pop:
            return Material(
              color: Colors.transparent,
              child: fromHeroContext.widget,
            );
        }
      },
      tag: person.name,
      child: Material(
        color: Colors.transparent,
        child: Text(
          person.emoji,
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
