import 'dart:ui';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/blurry_back_ground.dart';
import 'package:al_ashraf/models/url_launcher.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/models/audio_requirement.dart';

class AudioListScreen extends StatefulWidget {
  String folderId;
  String folderName;

  AudioListScreen({required this.folderId, required this.folderName});

  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  final player = AudioPlayer();
  String initializedAudioId = '';

  Future<void> _initAndPlay(String id) async {
    setState(() {
      initializedAudioId = id;
    });
    try {
      await player.setAudioSource(AudioSource.uri(
          Uri.parse('https://drive.google.com/uc?export=view&id=$id')));

      player.play();
    } catch (e) {
      CustomWidgets.customSnackBar('حدث خطأ الرجاء المحاولة لاحقا');
    }
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.customAppBar(widget.folderName,
          fontSize: 22, centerTitle: true),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BlurryBackGround(
            backGroundImgPath: kBackGroundImgPath,
          ),
          Container(
            color: Colors.transparent,
            child: FutureBuilder(
              future: GoogleDrive()
                  .getDriveContent(widget.folderId, kAudioFileDriveType),
              builder: (context, AsyncSnapshot<DriveContent?> snapshot) {
                if (snapshot.hasData) {
                  var audioData = snapshot.data!;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: audioData.contentNames.length,
                    itemBuilder: (context, index) => AudioCard(
                      player: player,
                      initializeAndPlay: (id)=>_initAndPlay(id),
                      audioId: audioData.contentIds[index],
                      audioName: audioData.contentNames[index],
                      initializedAudioId: initializedAudioId,
                    ),
                  );
                } else
                  return LoadingWidget();
              },
            ),
          )
        ],
      ),
    );
  }
}

class AudioCard extends StatelessWidget {
  String audioName;
  String audioId;
  String initializedAudioId;
  Function initializeAndPlay;
  AudioPlayer player;

  AudioCard(
      {required this.player,
      required this.audioName,
      required this.initializedAudioId,
      required this.initializeAndPlay,
      required this.audioId});

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          audioName.replaceAll('.mp3', ''),
                          maxLines: 3,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 22, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        UrlLauncher(
                            'https://drive.google.com/file/d/${audioId}/view');
                      },
                      icon: Icon(Icons.download),
                      iconSize: 25,
                    ),
                    ControlButton(
                      player: player,
                      initializedAudioId: initializedAudioId,
                      audioId: audioId,
                      initializeAndPlay: initializeAndPlay,
                    )
                  ],
                ),
              ),
              Visibility(
                maintainSize: false,
                visible: (initializedAudioId == audioId),
                child: Expanded(
                  flex: 1,
                  child: StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: player.seek,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  AudioPlayer player;
  String audioId;
  String initializedAudioId;
  Function initializeAndPlay;

  ControlButton(
      {required this.player,
      required this.audioId,
      required this.initializedAudioId,
      required this.initializeAndPlay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (audioId == initializedAudioId) {
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  width: 35.0,
                  height: 35.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (playing != true) {
                //paused
                return IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 35.0,
                  onPressed: player.play,
                );
              } else {
                //playing
                return IconButton(
                  icon: Icon(Icons.pause, color: Colors.white),
                  iconSize: 35.0,
                  onPressed: player.pause,
                );
              }
            } else {
              //not initialized
              return IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                iconSize: 35.0,
                onPressed:()=>initializeAndPlay(audioId),
              );
            }
          },
        ),
      ),
    );
  }
}
