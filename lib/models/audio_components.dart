import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

GlobalAudioPlayer globalAudioPlayer = GlobalAudioPlayer();
class GlobalAudioPlayer{
  late AudioPlayer audioPlayer;
  late String intializedAudioId;
  late String audioUrl;
  late String audioAlbumName;
  late String audioName;
  GlobalAudioPlayer(){
     audioPlayer = AudioPlayer();
     intializedAudioId = '';
     audioUrl = '';
  }
  static Future initializeBackGroundAudio()async{
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  Future<void> initAndPlay() async {
    try {
      await audioPlayer.setAudioSource(AudioSource.uri(
          Uri.parse(audioUrl),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: intializedAudioId,
          // Metadata to display in the notification:
          album: audioAlbumName,
          title: audioName,
          artist: "صلاح الدين القوصى",
          artUri: Uri.parse('https://alashraf-almahdia.net/wp-content/uploads/2017/09/cropped-cropped-21442237_10159403050085323_1868876561_n-1.png'),
        ),
      ),);
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

