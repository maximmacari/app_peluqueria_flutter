import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_auth1/Model/rout_generator.dart';
import 'package:flutter_sms_auth1/Model/user_preferences.dart';
import 'package:flutter_sms_auth1/ViewModel/onboarding_vm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/colors.dart';
import '../shared/styles.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 24 : 16,
      decoration: BoxDecoration(
          color: isActive
              ? ConstantColors.mainColorApp
              : Theme.of(context)
                  .colorScheme
                  .foregroundTxtButtonColor
                  .withOpacity(0.24),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var onboardingObservable = Provider.of<OnBoardingObservable>(context);
    return ChangeNotifierProvider(
      create: (context) => OnBoardingObservable(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                  decoration: BoxDecoration(
                      gradient: Theme.of(context)
                          .colorScheme
                          .mainBackgroundLinearGradient),
                  child: Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Spacer(),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: PageView(
                              physics: ClampingScrollPhysics(),
                              controller: onboardingObservable.pageController,
                              onPageChanged: (int page) {
                                var onboardingVM =
                                    Provider.of<OnBoardingObservable>(context,
                                        listen: false);
                                onboardingVM.currentPage = page;
                              },
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                          child: SvgPicture.asset(
                                        "assets/images/logo.svg",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .foregroundTxtButtonColor,
                                      )),
                                      Spacer(),
                                      Center(
                                        child: Text(
                                          "",
                                          style: CustomTextStyles()
                                              .onboardingTitleStyle(context),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                        style: CustomTextStyles()
                                            .onboardingBodyStyle(context),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                          child: SvgPicture.asset(
                                        "assets/images/logo.svg",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .foregroundTxtButtonColor,
                                      )),
                                      Spacer(),
                                      Center(
                                        child: Text(
                                          "Connect with \nnew people.",
                                          style: CustomTextStyles()
                                              .onboardingTitleStyle(context),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",
                                        style: CustomTextStyles()
                                            .onboardingBodyStyle(context),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                          child: SvgPicture.asset(
                                        "assets/images/logo.svg",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .foregroundTxtButtonColor,
                                      )),
                                      Spacer(),
                                      Center(
                                        child: Text(
                                          "Connect with \nnew people.",
                                          style: CustomTextStyles()
                                              .onboardingTitleStyle(context),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                        style: CustomTextStyles()
                                            .onboardingBodyStyle(context),
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
                              children: [
                                for (var i = 0;
                                    i < onboardingObservable.numPages;
                                    i++)
                                  _indicator(
                                      i == onboardingObservable.currentPage)
                              ]),
                          Spacer(),
                          Align(
                            alignment: FractionalOffset.center,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  primary: ConstantColors.mainColorApp,
                                  padding: EdgeInsets.all(16),
                                ),
                                onPressed: () {
                                  if (onboardingObservable.isLastPage) {
                                    UserPreferences.setPresentationSeen(true);
                                    Navigator.of(context)
                                        .pushNamed(Screen.HOME);
                                  } else {
                                    onboardingObservable.loadNextPage();
                                  }
                                },
                                child: Text(onboardingObservable.buttonText,
                                    style: CustomTextStyles()
                                        .onboardingBtnTextStyle(context)),
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      ))))),
    );
  }
}
