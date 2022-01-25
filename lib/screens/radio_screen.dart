import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/models/audio_components.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:just_audio/just_audio.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  _RadioScreenState createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final AudioPlayer player = AudioPlayer();
  String initializedChannelFreq = '';
  Future<void> initAndPlay(String freq) async {
    setState(() {
      initializedChannelFreq = freq;
    });
    try {
      await player.setAudioSource(AudioSource.uri(
          Uri.parse(freq)));

      player.play();
    } catch (e) {
      CustomWidgets.customSnackBar('حدث خطأ الرجاء المحاولة لاحقا');
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomWidgets.customAppBar('الإذاعة'),
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                CustomCircularImage(imagePath: kRadioScreenImgPath,imageHeightRatio: 0.47,),
                SizedBox(height: 20,)
              ]),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        color: kCardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: AutoSizeText(kRadioChannelsName[index],
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 40)),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ControlButton(audioId: kRadioChannelsFreq[index],
                                initializedAudioId: initializedChannelFreq,
                                player: player,
                                initializeAndPlay: (freq)=>initAndPlay(freq),
                              iconSize: 60,),
                            )
                          ],
                        ),
                      ),
                    ),childCount: kRadioChannelsName.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10)),

            SliverList(delegate: SliverChildListDelegate([
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:Row(
                  children: [
                    Icon(Icons.volume_down),
                    Expanded(
                      child: Slider(
                          value: player.volume,
                          onChanged: (newVolume) {
                            setState(() {
                              player.setVolume(newVolume);
                            });
                          }),
                    ),
                    Icon(
                      Icons.volume_up,
                    ),
                  ],
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
