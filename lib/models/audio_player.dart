import 'package:just_audio/just_audio.dart';


class GlobalAudioPlayer{
  AudioPlayer audioPlayer = AudioPlayer();
  String intializedAudioId = '';

  Future<bool> initAndPlay(String id) async {

    try {
      await player.setAudioSource(AudioSource.uri(
          Uri.parse(freq)));

      player.play();
    } catch (e) {
      CustomWidgets.customSnackBar('حدث خطأ الرجاء المحاولة لاحقا');
    }
  }
}