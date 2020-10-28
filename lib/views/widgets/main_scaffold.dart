import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget actions;
  final bool navigationDrawer;

  MainScaffold({this.title, this.body, this.actions, this.navigationDrawer});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with SingleTickerProviderStateMixin {
  bool darkModeValue;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void toggle() {
    _animationController.isDismissed
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final maxSlide = MediaQuery.of(context).size.width * 0.6;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Stack(
          children: <Widget>[
            Container(),
            Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.title,
                    style: GoogleFonts.ibarraRealNova(
                        fontSize: height > 700 ? 21 : 17,
                        fontWeight: FontWeight.w700),
                  ),
                  
                  centerTitle: true,
                  
                ),
                body: Provider.of<bool>(context)
                    ? Center(
                        child: Text(
                          "You have a network connection error, Please check your connection",
                          textAlign: TextAlign.center,
                        ),
                      )
                    : widget.body,
              ),
          ],
        );
      },
    );
  }
}
