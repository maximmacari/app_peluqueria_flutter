import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/colors.dart';
import "../shared/custom_button.dart";
import '../shared/styles.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  bool _isLastPage() {
    return (_currentPage == _numPages - 1);
  }

  void Function() _goHomeScreen() {
    print("Home");
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 24 : 16,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                decoration: BoxDecoration(
                    gradient: ConstantColors.backgroundLinearGradient),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.blue,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                              child: SimpleButton(
                                onPressed: (() => {
                                      if (_isLastPage())
                                        {this._goHomeScreen()}
                                      else
                                        {null}
                                    }),
                                labelString: (!_isLastPage() ? "Saltar" : ""),
                              ),
                            )),
                        Container(
                          height: 500.0,
                          child: PageView(
                            physics: ClampingScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: SvgPicture.asset(
                                      "assets/logo.svg",
                                      color: Theme.of(context).colorScheme.mainForeground,
                                    )),
                                    SizedBox(height: 30),
                                    Center(
                                      child: Text(
                                        "Connect with \nnew people.",
                                        style:
                                            CustomTextStyles.ONBOARDING_TITLE,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                      style: CustomTextStyles.ONBOARDING_BODY,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: SvgPicture.asset(
                                      "assets/logo.svg",
                                      color: Colors.white,
                                    )),
                                    SizedBox(height: 30),
                                    Center(
                                      child: Text(
                                        "Connect with \nnew people.",
                                        style:
                                            CustomTextStyles.ONBOARDING_TITLE,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",
                                      style: CustomTextStyles.ONBOARDING_BODY,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: SvgPicture.asset(
                                      "assets/logo.svg",
                                      color: Colors.white,
                                    )),
                                    SizedBox(height: 30),
                                    Center(
                                      child: Text(
                                        "Connect with \nnew people.",
                                        style:
                                            CustomTextStyles.ONBOARDING_TITLE,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                      style: CustomTextStyles.ONBOARDING_BODY,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                        Expanded(
                            child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      primary: Colors.red,
                                      onPrimary: Colors.pink,
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    ),
                                    onPressed: () {
                                      if (_isLastPage())
                                        _goHomeScreen();
                                      else {
                                        _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut);
                                      }
                                    },
                                    child: Container(
                                        color: Colors.pink,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 4, 4, 4),
                                        child: Row(
                                          children: <Widget>[
                                            _isLastPage()
                                                ? Text("Saltar",
                                                    style: CustomTextStyles
                                                        .ONBOARDING_BTN_TEXT)
                                                : Text("Siguiente",
                                                    style: CustomTextStyles
                                                        .ONBOARDING_BTN_TEXT),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  4, 0, 10, 0),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        )))))
                      ],
                    )))));
  }
}
