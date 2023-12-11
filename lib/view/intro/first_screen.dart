import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                // physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                scrollDirection: Axis.horizontal,
                children: const [
                  PageWidget(
                    title: "Save money",
                    description: "Have all your finances in one place!",
                    imagePath: "1",
                    initialPageIndicator: 0,
                    offSetBegin: -2,
                    offSetEnd: -1,
                  ),
                  PageWidget(
                    title: "Check your wallet",
                    description:
                        "Manage your money and invest with just one tap!",
                    imagePath: "2",
                    initialPageIndicator: 1,
                    offSetBegin: 2,
                    offSetEnd: -1,
                  ),
                  PageWidget(
                    title: "Have access anywhere!",
                    description:
                        "Reach your financial goal within your first year!  ",
                    imagePath: "3",
                    initialPageIndicator: 2,
                    offSetBegin: -2,
                    offSetEnd: 0,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: Colors.indigo.shade400,
                        ),
                        child: Text(
                          currentPage == 2 ? "Get Started" : "Continue",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class PageWidget extends StatefulWidget {
  final String title;
  final String description;
  final String imagePath;
  final int initialPageIndicator;
  final double offSetBegin;
  final double offSetEnd;
  const PageWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.imagePath,
      required this.initialPageIndicator,
      required this.offSetBegin,
      required this.offSetEnd});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideTransitionAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    slideTransitionAnimation = Tween(
      begin: Offset(widget.offSetBegin, widget.offSetEnd),
      end: Offset.zero,
    ).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            "Financy",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1200),
            tween: Tween<double>(begin: 0, end: 350),
            curve: Curves.linear,
            builder: (context, value, child) {
              return SizedBox(
                // color: Colors.red,
                width: MediaQuery.sizeOf(context).width,
                height: value,
                child: Image.asset(
                  "assets/images/${widget.imagePath}.png",
                  fit: BoxFit.contain,
                ),
              );
            }),
        const SizedBox(
          height: 20,
        ),
        SmoothPageIndicator(
          controller: PageController(
            initialPage: widget.initialPageIndicator,
          ), // PageController
          count: 3,
          effect: const WormEffect(
            dotWidth: 12,
            dotHeight: 7,
          ), // your preferred effect
          onDotClicked: (index) {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 2500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: SlideTransition(
            position: slideTransitionAnimation,
            child: Text(
              widget.description.toString(),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
