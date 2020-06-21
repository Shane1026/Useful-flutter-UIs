import 'package:flutter/material.dart';

class ScreenOne extends StatefulWidget {
  ScreenOne({Key key}) : super(key: key);

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  PageController _pageController;
  int pageIndex = 0;

  onTap(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.yellowAccent,
                child: PageView(
                  onPageChanged: (pgeIndex) {
                    print(pgeIndex);
                    setState(() {
                      this.pageIndex = pgeIndex;
                    });
                  },
                  controller: _pageController,
                  children: <Widget>[
                    Scaffold(
                      backgroundColor: Colors.blue,
                    ),
                    Scaffold(
                      backgroundColor: Colors.red,
                    ),
                    Scaffold(
                      backgroundColor: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 70,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 27,
                      backgroundColor:
                          pageIndex == 0 ? Colors.white : Colors.green,
                      child: IconButton(
                        icon: Icon(
                          Icons.home,
                          color: pageIndex == 0 ? Colors.green : Colors.white,
                          size: pageIndex == 0 ? 25 : 35,
                        ),
                        onPressed: () {
                          setState(() {
                            pageIndex = 0;
                            onTap(pageIndex);
                          });
                        },
                      ),
                    ),
                    CircleAvatar(
                      radius: 27,
                      backgroundColor:
                          pageIndex == 1 ? Colors.white : Colors.green,
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: pageIndex == 1 ? Colors.green : Colors.white,
                          size: pageIndex == 1 ? 25 : 35,
                        ),
                        onPressed: () {
                          setState(() {
                            pageIndex = 1;
                            onTap(pageIndex);
                          });
                        },
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          pageIndex == 2 ? Colors.white : Colors.green,
                      child: IconButton(
                        icon: Icon(
                          Icons.person,
                          color: pageIndex == 2 ? Colors.green : Colors.white,
                          size: pageIndex == 2 ? 25 : 35,
                        ),
                        onPressed: () {
                          setState(() {
                            pageIndex = 2;
                            onTap(pageIndex);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
