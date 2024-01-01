import 'package:flutter/material.dart';
import 'package:movies_db/screens/movies.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/movies_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoviesServices())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie DB',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        theme: ThemeData(
          // textTheme: TextTheme(),
          fontFamily: "Poppins",
          primarySwatch: Colors.blueGrey,
        ),
        home: const MyHomePage(
          title: "Peliculas",
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller = PersistentTabController();
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: [MoviesListScreen(), Container()],
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.movie),
            title: "Peliculas",
            activeColorPrimary: Colors.teal,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.tv),
            title: "Series",
            activeColorPrimary: Colors.teal,
            inactiveColorPrimary: Colors.grey,
          ),
        ],
        resizeToAvoidBottomInset: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        bottomScreenMargin: 55,

        backgroundColor: Colors.black,
        decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: false,
        ),
        navBarStyle:
            NavBarStyle.style9, // Choose the nav bar style with this property
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
