import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/colors.dart';
import "../shared/custom_button.dart";
import '../shared/styles.dart';
import "package:shared_preferences/shared_preferences.dart";

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

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

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
                    padding: EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: [
                            Spacer(),
                            Opacity(
                              opacity: !_isLastPage() ? 1.0 : 0,
                              child: SimpleButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Screen.LOGIN);
                                  UserPreferences.setPresentationSeen(true);
                                },
                                labelString: 'Saltar',
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
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
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: SvgPicture.asset(
                                      "assets/logo.svg",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .mainForeground,
                                    )),
                                    Spacer(),
                                    Center(
                                      child: Text(
                                        "",
                                        style:
                                            CustomTextStyles.ONBOARDING_TITLE,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                      style: CustomTextStyles.ONBOARDING_BODY,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: SvgPicture.asset(
                                      "assets/logo.svg",
                                      color: Colors.white,
                                    )),
                                    Spacer(),
                                    Center(
                                      child: Text(
                                        "Connect with \nnew people.",
                                        style:
                                            CustomTextStyles.ONBOARDING_TITLE,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",
                                      style: CustomTextStyles.ONBOARDING_BODY,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                        child: SvgPicture.asset(
                                      "assets/logo.svg",
                                      color: Colors.white,
                                    )),
                                    Spacer(),
                                    Center(
                                      child: Text(
                                        "Connect with \nnew people.",
                                        style:
                                            CustomTextStyles.ONBOARDING_TITLE,
                                      ),
                                    ),
                                    Spacer(),
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
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                        Spacer(),
                        Align(
                            alignment: FractionalOffset.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  primary: Colors.black45,
                                  padding: EdgeInsets.all(8),
                                ),
                                onPressed: () {
                                  print("current $_currentPage");
                                  print("");
                                  if (_isLastPage()) {
                                    UserPreferences.setPresentationSeen(true);
                                    Navigator.of(context)
                                        .pushNamed(Screen.HOME);                                      
                                  } else {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  }
                                },
                                child: _isLastPage()
                                    ? Text("Saltar",
                                        style: CustomTextStyles
                                            .ONBOARDING_BTN_TEXT)
                                    : Text("Siguiente",
                                        style: CustomTextStyles
                                            .ONBOARDING_BTN_TEXT))),
                        Spacer()
                      ],
                    )))));
  }
}
