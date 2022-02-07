import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

GlobalAudioPlayer globalAudioPlayer = GlobalAudioPlayer();
class GlobalAudioPlayer{
  late AudioPlayer audioPlayer;
  late String intializedAudioId;
  late String audioUrl;
  GlobalAudioPlayer(){
     audioPlayer = AudioPlayer();
     intializedAudioId = '';
     audioUrl = '';
  }


  Future<void> initAndPlay() async {
    try {
      await audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(audioUrl)));
      audioPlayer.play();
    } catch (e) {
     Get.showSnackbar(CustomWidgets.customSnackBar('حدث خطأ الرجاء المحاولة لاحقا'));
    }
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

