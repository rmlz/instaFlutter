import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:instaflutter/app/modules/onboarding/onboarding_store.dart';

class OnboardingPage extends StatefulWidget {
  final String title;
  const OnboardingPage({Key? key, this.title = 'Instaflutter'}) : super(key: key);
  @override
  OnboardingPageState createState() => OnboardingPageState();
}
class OnboardingPageState extends ModularState<OnboardingPage, OnboardingStore> {

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _OnboardingItem(
            image: AssetImage('assets/social_life.png'),
            text: 'Já imaginou você ter uma rede social sem algorítmo?!'
          ),
          _OnboardingItem(
            image: AssetImage('assets/selfie.png'),
            text: 'Aqui você posta e a gente mostra pra quem te segue!'
          ),
          _OnboardingItem(
            image: AssetImage('assets/influencer.png'),
            text: 'Seja o maior influenciador digital do App!',
            child: Column(
              children: [
                SizedBox(height: 24),
                ElevatedButton(
                  child: Text('CADASTRE-SE'),
                  onPressed: () {
                    store.markOnboardingDone();
                    Modular.to.pushReplacementNamed(Constants.Routes.REGISTER);
                  },
                ),
                TextButton(
                  child: Text('Já tem cadastro?'),
                  onPressed: () {
                    store.markOnboardingDone();
                    Modular.to.pushNamed(Constants.Routes.LOGIN);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {

  final ImageProvider image;
  final String text;
  final Widget? child;
  _OnboardingItem({required this.image, required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 96
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Image(image: image, fit: BoxFit.fitWidth),
          ),
          SizedBox(height: 32),
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center
          ),
          child ?? SizedBox.fromSize(size: Size.zero)
        ],
      ),
    );
  }
}
