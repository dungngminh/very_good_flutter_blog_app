import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:very_good_blog_app/config/config.dart';
import 'package:very_good_blog_app/features/home/home.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  void _onPageChanged(int newIndex) => setState(() {
        _currentIndex = newIndex;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeView(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Palette.whiteBackgroundColor,
          ),
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onPageChanged(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: _currentIndex == 0
                          ? const Icon(
                              PhosphorIcons.houseFill,
                              size: 32,
                              color: Palette.primaryColor,
                            )
                          : const Icon(
                              PhosphorIcons.houseFill,
                              size: 28,
                              color: Palette.unSelectedColor,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onPageChanged(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: _currentIndex == 1
                          ? const Icon(
                              PhosphorIcons.houseFill,
                              size: 32,
                              color: Palette.primaryColor,
                            )
                          : const Icon(
                              PhosphorIcons.houseFill,
                              size: 28,
                              color: Palette.unSelectedColor,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {},
                    child: const Icon(PhosphorIcons.houseFill),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {},
                    child: const Icon(PhosphorIcons.houseFill),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
