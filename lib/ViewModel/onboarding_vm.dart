import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

//Un (with) mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase, sin heredar de esas clases.
class OnBoardingObservable with ChangeNotifier {
  final int _numPages = 3;
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  
  int get currentPage => _currentPage;
  int get numPages => _numPages;
  PageController get pageController => _pageController;
  String get buttonText => isLastPage ? "Comenzar" : "Siguiente";

  

  set currentPage(int newPage) {
    _currentPage = newPage;
    notifyListeners();
  }

  void loadNextPage() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  bool get isLastPage => _currentPage == _numPages - 1;
}
