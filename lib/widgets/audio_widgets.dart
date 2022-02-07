import 'package:al_ashraf/widgets/blurry_back_ground.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/constants/constants.dart';
import 'package:al_ashraf/widgets/loading_widget.dart';
import 'package:al_ashraf/widgets/folder_grid_list.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:al_ashraf/models/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:al_ashraf/models/audio_components.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;


class AudioFoldersScreen extends StatelessWidget {
  String folderRootId;
  String screenTitle;

  AudioFoldersScreen({required this.folderRootId, required this.screenTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: GoogleDrive().getDriveContent(folderRootId, kFolderDriveType,false),
          builder: (context, AsyncSnapshot<DriveContent?> snapshot) {
            if (snapshot.hasData) {
              var folderData = snapshot.data!;
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.adaptive.arrow_back),
                                iconSize: 40,
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                screenTitle,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])),
                  FolderGridList(
                    folderNames: folderData.contentNames,
                    folderIds: folderData.contentIds,
                    onPress: (index) => Get.to(() => AudioListScreen(
                      folderId: folderData.contentIds[index],
                      folderName: folderData.contentNames[index],
                    )),
                  )
                ],
              );
            } else {
              return LoadingWidget();
            }
          },
        ),
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
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 120,
        child: Card(
          elevation: 10,
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
  double iconSize;

  ControlButton(
      {required this.player,
        required this.audioId,
        required this.initializedAudioId,
        required this.initializeAndPlay,
        this.iconSize = 35
      });

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
                   width: iconSize,
                   height:iconSize,
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
                  iconSize: iconSize,
                  onPressed: player.play,
                );
              } else {
                //playing
                return IconButton(
                  icon: Icon(Icons.pause, color: Colors.white),
                  iconSize:iconSize,
                  onPressed: player.pause,
                );
              }
            } else {
              //not initialized
              return IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                iconSize: iconSize,
                onPressed:()=>initializeAndPlay(audioId),
              );
            }
          },
        ),
      ),
    );
  }
}

class AudioListScreen extends StatefulWidget {
  String folderId;
  String folderName;

  AudioListScreen({required this.folderId, required this.folderName});

  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}
class _AudioListScreenState extends State<AudioListScreen> {
  Future<void> _playAudio(String id)async{
    setState(() {
      globalAudioPlayer.intializedAudioId = id;
      globalAudioPlayer.audioUrl = 'https://drive.google.com/uc?export=view&id=$id';
    });
    globalAudioPlayer.initAndPlay();
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
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
            backGroundImgPath: kAlkobbaBGImgPath,
          ),
          Container(
            color: Colors.transparent,
            child: FutureBuilder(
              future: GoogleDrive()
                  .getDriveContent(widget.folderId, kAudioFileDriveType,true),
              builder: (context, AsyncSnapshot<DriveContent?> snapshot) {
                if (snapshot.hasData) {
                  var audioData = snapshot.data!;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: audioData.contentNames.length,
                    itemBuilder: (context, index) => AudioCard(
                      player: globalAudioPlayer.audioPlayer,
                      initializeAndPlay: (id)=>_playAudio(id),
                      audioId: audioData.contentIds[index],
                      audioName: audioData.contentNames[index],
                      initializedAudioId: globalAudioPlayer.intializedAudioId,
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

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}
class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch("$_remaining")
                  ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {}
}