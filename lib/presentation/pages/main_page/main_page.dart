import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/pages/post_add_page/post_add_screen.dart';
import 'package:social_media/presentation/pages/explore_page/explore_screen.dart';
import 'package:social_media/presentation/pages/home_page/home_screen.dart';
import 'package:social_media/presentation/pages/message_page/message_screen.dart';
import 'package:social_media/presentation/pages/profile_page/profile_screen.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const AddPostdScreen(),
    const MessageScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: indexChangeNotifier,
          builder: (context, index, _) {
            return IndexedStack(index: index, children: pages);
          }),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int newIndex, _) {
          return BottomNavigationBar(
              currentIndex: newIndex,
              onTap: (index) {
                indexChangeNotifier.value = index;
              },
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedIconTheme: const IconThemeData(color: kBlack),
              unselectedIconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 138, 138, 138)),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Iconsax.home_15,
                      size: 30,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.search_normal_1, size: 30), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.add_circle5, size: 30), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.message_25, size: 30), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Iconsax.profile_circle5, size: 30), label: ''),
              ]);
        },
      ),
    );
  }
}
