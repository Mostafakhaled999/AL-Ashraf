import 'dart:io';

import 'package:al_ashraf/widgets/blurry_back_ground.dart';
import 'package:al_ashraf/widgets/custom_widgets.dart';
import 'package:al_ashraf/widgets/drive_widgets.dart';

import 'package:flutter/material.dart';
import 'package:al_ashraf/models/google_drive.dart';
import 'package:al_ashraf/constants/constants.dart';



import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:al_ashraf/models/audio_components.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;

class AudioCardsScreen extends StatefulWidget {
  GoogleDrive driveFolder;
  DriveContent audioData;

  AudioCardsScreen({required this.driveFolder, required this.audioData});

  @override
  _AudioCardsScreenState createState() => _AudioCardsScreenState();
}

class _AudioCardsScreenState extends State<AudioCardsScreen> {
  Future<void> _playAudio(
      String audioId, String audioName, String playLink) async {
    setState(() {
      globalAudioPlayer.intializedAudioId = audioId;
      globalAudioPlayer.audioUrl = playLink;
      //'https://drive.google.com/uc?export=view&id=$audioId';
      globalAudioPlayer.audioName = audioName;
      globalAudioPlayer.audioAlbumName = widget.driveFolder.name;
    });
    globalAudioPlayer.initAndPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.customAppBar(widget.driveFolder.name,
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
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.audioData.contentLength,
                itemBuilder: (context, index) => AudioCard(
                  player: globalAudioPlayer.audioPlayer,
                  initializeAndPlay: (audioId, audioName, playLink) =>
                      _playAudio(audioId, audioName, playLink),
                  driveAudio: widget.audioData.content[index],
                  initializedAudioId: globalAudioPlayer.intializedAudioId,
                ),
              ))
        ],
      ),
    );
  }
}

class AudioCard extends StatelessWidget {
  GoogleDrive driveAudio;
  String initializedAudioId;
  Function initializeAndPlay;
  AudioPlayer player;

  AudioCard({
    required this.player,
    required this.driveAudio,
    required this.initializedAudioId,
    required this.initializeAndPlay,
  });

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
                        child: Text(
                          driveAudio.name.replaceAll('.mp3', ''),
                          maxLines: 2,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 22, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    DownloadShareButtons(
                      driveFile: driveAudio,
                      colMainAligment: MainAxisAlignment.center,
                      rowCrossAligment: CrossAxisAlignment.center,
                      rowMainAligment: MainAxisAlignment.center,
                    ),
                    ControlButton(
                      player: player,
                      initializedAudioId: initializedAudioId,
                      audioName: driveAudio.name,
                      audioId: driveAudio.id,
                      playLink: driveAudio.mainLink??'',
                      initializeAndPlay: initializeAndPlay,
                    )
                  ],
                ),
              ),
              Visibility(
                maintainSize: false,
                visible: (initializedAudioId == driveAudio.id),
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
  String playLink;
  String audioName;
  String initializedAudioId;
  Function initializeAndPlay;
  double iconSize;

  ControlButton(
      {required this.player,
      required this.audioId,
      required this.audioName,
      required this.initializedAudioId,
      required this.initializeAndPlay,
      required this.playLink,
      this.iconSize = 35});

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
                  height: iconSize,
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
                  iconSize: iconSize,
                  onPressed: player.pause,
                );
              }
            } else {
              //not initialized
              return IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                iconSize: iconSize,
                onPressed: () =>
                    initializeAndPlay(audioId, audioName, playLink),
              );
            }
          },
        ),
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
