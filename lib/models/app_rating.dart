import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class AppRating{

  int _launchTimes = 1;

   Future _getLaunchTimes()async{
    var pref = await SharedPreferences.getInstance();
    if(pref.containsKey('launchTimes')){
      _launchTimes =  pref.getInt('launchTimes')!;
      _launchTimes += 1;
      pref.setInt('launchTimes', _launchTimes);
    }else{
      await pref.setInt('launchTimes', 1);
    }
  }
  Future rate()async{
    await _getLaunchTimes();
    if(_launchTimes % 7 == 0){
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }
}