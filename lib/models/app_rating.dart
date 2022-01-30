import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class AppRating{

  int _launchTimes = 1;

   Future _getLaunchTimes()async{
    var pref = await SharedPreferences.getInstance();
    _launchTimes = 1;
    if(pref.containsKey('launchTimes')){
      await pref.setInt('launchTimes', 1);
    }else{
      _launchTimes =  pref.getInt('launchTimes')!;
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