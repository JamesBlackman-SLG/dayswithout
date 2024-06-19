import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Days Without',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Days Without'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime date = DateTime.now();
  final GlobalKey<AnimatedCircleState> circleKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 231, 208, 33),
        title: Center(child: Text(widget.title)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 231, 208, 33),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 2,
            colors: [Colors.red, Color.fromARGB(255, 231, 208, 33)],
          ),
        ),
        child: Center(
          child: AnimatedCircle(
            key: circleKey,
            date: date,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 231, 208, 33),
        onPressed: () {
          setState(() {
            date = DateTime.now();
          });
          if (circleKey.currentState != null) {
            circleKey.currentState!.replayAnimation();
          }
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AnimatedCircle extends StatefulWidget {
  final DateTime date;

  const AnimatedCircle({super.key, required this.date});
  @override
  AnimatedCircleState createState() => AnimatedCircleState();
}

class AnimatedCircleState extends State<AnimatedCircle>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeInOutCubicEmphasized))
      ..addListener(() {
        setState(() {});
      });

    _animationController!.forward();
  }

  void replayAnimation() {
    _animationController!.reset();
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    final daysWithout = widget.date.difference(DateTime(2023, 09, 10)).inDays;
    final double yearsWithout = daysWithout / 365;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = constraints.maxWidth * 0.9;

        return Container(
          width: _scaleAnimation!.value * maxSize,
          height: _scaleAnimation!.value * maxSize,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 231, 208, 33),
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.black,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$daysWithout Days',
                  style: TextStyle(
                      fontSize: _scaleAnimation!.value * maxSize * 0.15),
                ),
                Text(
                  '${yearsWithout.toStringAsFixed(2)} Years',
                  style: TextStyle(
                      fontSize: _scaleAnimation!.value * maxSize * 0.1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
