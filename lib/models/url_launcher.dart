import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';

class UrlLauncher {
  String url;

  UrlLauncher(this.url) {
    _launchUrl();
  }

  Future<void> _launchUrl() async {
    if (await canLaunch(url)) {
     await launch(url);
    } else {
      Get.showSnackbar(CustomWidgets.customSnackBar('تعذر فتح الرابط'));
    }
  }
}
