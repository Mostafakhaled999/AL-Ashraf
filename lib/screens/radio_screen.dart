import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:al_ashraf/widgets/circular_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:al_ashraf/widgets/audio_widgets.dart';
import 'package:al_ashraf/models/audio_components.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  _RadioScreenState createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  Future<void> playRadio(String id,int index) async {
    setState(() {
      globalAudioPlayer.intializedAudioId = id;
      globalAudioPlayer.audioUrl = id;
      globalAudioPlayer.audioName = kRadioChannelsName[index];
      globalAudioPlayer.audioAlbumName = 'الإذاعة';
    });
    globalAudioPlayer.initAndPlay();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar:
              CustomWidgets.customAppBar('الإذاعة', appBarColor: Colors.green),
          extendBodyBehindAppBar: false,
          body: Column(
              children: [
            Expanded(
              child: CustomCircularImage(
                imagePath: kRadioScreenImgPath,
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 2,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10),
                itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        elevation: 5,
                        color: kCardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: [
                          Expanded(
                            child: Center(
                              child: AutoSizeText(kRadioChannelsName[index],
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 45)),
                            ),
                          ),
                          ControlButton(
                            audioId: kRadioChannelsFreq[index],
                            initializedAudioId:
                                globalAudioPlayer.intializedAudioId,
                            player: globalAudioPlayer.audioPlayer,
                            initializeAndPlay: (freq) => playRadio(freq,index),
                            iconSize: 60,
                          )
                        ])))),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Icon(Icons.volume_down),
                  Expanded(
                    child: Slider(
                        value: globalAudioPlayer.audioPlayer.volume,
                        activeColor: Colors.green,
                        onChanged: (newVolume) {
                          setState(() {
                            globalAudioPlayer.audioPlayer.setVolume(newVolume);
                          });
                        }),
                  ),
                  Icon(
                    Icons.volume_up,
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
