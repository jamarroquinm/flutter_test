import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Development UI that let's a user play an animation forward and backward to
/// fine-tune the animation.
///
/// An animation is represented as a [PlayableAnimation] which itself is comprised
/// of an ordered list of [Phase]s that represent transitions forward and backward.
///
/// The [AnimationPlayer] UI displays each phase and shows the phases that have
/// already been played, as well as the progress of the current phase.  The UI
/// also provides buttons to play the next phase or play the previous phase.
///
/// To use [AnimationPlayer], provide a [PlayableAnimation] by creating one with
/// a series of [Phase]s.
///
/// Your animation might also involve user interaction, in which case both this
/// AnimationPlayer and the user's touch events need to be able to move the
/// animation forward and backward. To accomplish this dual control, provide a
/// [PhaseController] to this [AnimationPlayer] and then connect the user's
/// touch events to the [PhaseController]. This way your animation will move
/// when the user interacts with it AND when you press 'prev' and 'next in this
/// AnimationPlayer.
class AnimationPlayer extends StatefulWidget {

  final PlayableAnimation playableAnimation;
  final PhaseController phaseController;

  AnimationPlayer({
    @required this.playableAnimation,
    this.phaseController,
  }) {
    assert(playableAnimation != null);
  }

  @override
  _MultiPhaseAnimationTesterState createState() => _MultiPhaseAnimationTesterState();
}

class _MultiPhaseAnimationTesterState extends State<AnimationPlayer> with TickerProviderStateMixin {

  static const int STANDARD_PHASE_TIME = 250;

  PhaseController phaseController;
  double playbackSpeed = 1.0;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    phaseController = widget.phaseController ?? PhaseController();

    animationController = AnimationController(
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          final phaseProgress = phaseController.playingForward
              ? animationController.value
              : 1.0 - animationController.value;
          phaseController.update(phaseProgress: phaseProgress);
        });
      })
      ..addStatusListener((status) {
        if (AnimationStatus.forward == status) {
          setState(() => phaseController.update(playingForward: true));
        } else if (AnimationStatus.reverse == status) {
          setState(() => phaseController.update(playingForward: false));
        } else if (AnimationStatus.dismissed == status) {
          // no-op
        } else if (AnimationStatus.completed == status) {
          // If we just finished playing forward, increment active phase.
          if (phaseController.playingForward) {
            if (phaseController.activePhase < widget.playableAnimation.phases.length - 1) {
              phaseController.update(
                activePhase: phaseController.activePhase + 1,
                phaseProgress: 0.0,
              );
            } else if (phaseController.phaseProgress < 1.0) {
              phaseController.update(
                phaseProgress: 1.0,
              );
            }
          }
        }
      });

    phaseController.addListener(_onPhaseChange);
  }

  @override
  void dispose() {
    phaseController.removeListener(_onPhaseChange);
    animationController.dispose();
    super.dispose();
  }

  void _onPhaseChange() {
    setState(() {
      final animationPhase = widget.playableAnimation.phases[phaseController.activePhase];
      if (phaseController.playingForward) {
        animationPhase.forward(phaseController.phaseProgress);
      } else {
        if (animationPhase.isUniform) {
          animationPhase.reverse(1.0 - phaseController.phaseProgress);
        } else {
          animationPhase.reverse(phaseController.phaseProgress);
        }
      }
    });
  }

  void _playPhaseForward() {
    if (phaseController.activePhase < widget.playableAnimation.phases.length - 1
        || phaseController.phaseProgress < 1.0) {
      animationController.duration = Duration(milliseconds: (STANDARD_PHASE_TIME / playbackSpeed).round());
      animationController.forward(from: 0.0);
    }
  }

  void _playPreviousPhaseInReverse() {
    if (phaseController.activePhase >= 1 || phaseController.phaseProgress < 1.0) {
      setState(() {
        if ((!phaseController.playingForward && phaseController.phaseProgress < 1.0)
            || (phaseController.playingForward && phaseController.phaseProgress > 0.0)) {
          // Take the phase progress all the way down.
          phaseController.update(
            phaseProgress: 1.0,
            playingForward: false,
          );
        } else {
          // Decrement the entire phase.
          phaseController.update(
            activePhase: phaseController.activePhase - 1,
            phaseProgress: 0.0,
            playingForward: false,
          );
        }

        animationController.duration = Duration(milliseconds: (STANDARD_PHASE_TIME / playbackSpeed).round());
        animationController.reverse(from: 1.0);
      });
    }
  }

  List<Widget> _buildPhaseIndicators() {
    final List<Widget> phases = [];
    for (var i = 0; i < widget.playableAnimation.phases.length; ++i) {
      var percent = 0.0;
      final isActivePhase = i == phaseController.activePhase;

      if (i < phaseController.activePhase) {
        percent = 1.0;
      } else if (phaseController.playingForward && isActivePhase) {
        percent = phaseController.phaseProgress;
      } else if (!phaseController.playingForward && isActivePhase) {
        percent = 1.0 - phaseController.phaseProgress;
      }

      phases.add(
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Forward progress indicator
                    Row(
                      children: [
                        Expanded(
                          flex: (percent * 100).round(),
                          child: Container(
                            height: 5.0,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: ((1.0 - percent) * 100).round(),
                          child: Container(
                            height: 5.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          )
      );
    }

    return phases;
  }

  @override
  Widget build(BuildContext context) {
    final phaseIndicators = _buildPhaseIndicators();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Playback speed slider
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Text(
            'Playback Speed:',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Slider(
              activeColor: Colors.blue,
              value: playbackSpeed,
              min: 0.0,
              max: 2.0,
              onChanged: (newValue) {
                setState(() => playbackSpeed = newValue);
              }
          ),
        ),

        // Phase progress indicators
        Row(
          children: phaseIndicators,
        ),

        // Playback control buttons
        Row(
          children: [
            Expanded(
              child: FlatButton(
                child: Text(
                  '<- Prev',
                ),
                onPressed: () {
                  _playPreviousPhaseInReverse();
                },
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Text(
                  'Next ->',
                ),
                onPressed: () {
                  _playPhaseForward();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A series of [Phase]s such that each [Phase] can be played forward and
/// backward.
class PlayableAnimation {
  final List<Phase> phases;

  PlayableAnimation({
    @required this.phases,
  });
}

/// Use a PhaseController to instruct the AnimationPlayer to advance its
/// playhead to the given Phase and percent.
///
/// A PhaseController provides the inverse control to the AnimationPlayer.
/// Normally, the AnimationPlayer progresses through the Phases based on a
/// running animation. But sometimes your animation is tied to user input
/// so if the user taps on your UI and causes the UI to change independent
/// of the AnimationPlayer, you need to use a PhaseController to synchronize
/// the animation progress with the AnimationPlayer.
class PhaseController extends ChangeNotifier {

  final int phaseCount;
  int _activePhase = 0;
  double _phaseProgress = 0.0;
  bool _playingForward = true;

  PhaseController({
    this.phaseCount = 1,
  }) {
    assert(phaseCount > 0, "Can't control zero animation phases.");
  }

  int get activePhase {
    return _activePhase;
  }

  double get phaseProgress {
    return _phaseProgress;
  }

  bool get playingForward {
    return _playingForward;
  }

  void nextPhase() {
    bool isDirty = false;

    if (!_playingForward) {
      _phaseProgress = 1.0 - _phaseProgress;
      _playingForward = true;
      isDirty = true;
    }

    final phasePosition = _phasePosition();

    if (phasePosition < phaseCount) {
      if (_activePhase < phaseCount - 1) {
        _activePhase++;
        _phaseProgress = 0.0;
        isDirty = true;
      } else if (_phaseProgress < 1.0) {
        _phaseProgress = 1.0;
        isDirty = true;
      }
    }

    if (isDirty) {
      notifyListeners();
    }
  }

  void prevPhase() {
    bool isDirty = false;

    if (_playingForward) {
      _phaseProgress = 1.0 - _phaseProgress;
      _playingForward = false;
      isDirty = true;
    }

    final phasePosition = _phasePosition();

    if (phasePosition > 0) {
      if (phaseProgress < 1.0) {
        _phaseProgress = 1.0;
        isDirty = true;
      } else if (_activePhase >= 1) {
        _activePhase--;
        isDirty = true;
      }
    }

    if (isDirty) {
      notifyListeners();
    }
  }

  double _phasePosition() {
    final double progressVector = playingForward ? phaseProgress : 1.0 - phaseProgress;
    return activePhase + progressVector;
  }

  void update({int activePhase, double phaseProgress, bool playingForward}) {
    final int newActivePhase = activePhase ?? _activePhase;
    final double newPhaseProgress = phaseProgress ?? _phaseProgress;
    final bool newPlayingForward = playingForward ?? _playingForward;

    if (_activePhase != newActivePhase || _phaseProgress != newPhaseProgress || _playingForward != newPlayingForward) {
      _activePhase = newActivePhase;
      _phaseProgress = newPhaseProgress;
      _playingForward = newPlayingForward;
      notifyListeners();
    }
  }
}

/// A transition that supports forward and reverse playback.
///
/// A [Phase] can be created with a single uniform [Transition] or with a
/// forward and reverse [Transition] for bidirectional control.
class Phase<DataType, ViewModelType> {
  final Transition _uniformTransition;
  final Transition _forward;
  final Transition _reverse;

  // A phase that uses the same Transition to go forward and back. A uniform
  // Transition is passed values starting at 0.0 -> 1.0 going forward, and then
  // 1.0 -> 0.0 going in reverse.
  Phase.uniform({
    Transition uniformTransition,
  }) : _uniformTransition = uniformTransition, _forward = null, _reverse = null;

  // A phase that uses 2 different Transitions to go forward vs reverse. Both
  // bidirectional Transitions are passed values starting at 0.0 -> 1.0, regardless
  // of whether it's the forward or reverse Transition.
  Phase.bidirectional({
    Transition forward,
    Transition reverse,
  }) : _forward = forward, _reverse = reverse, _uniformTransition = null;

  bool get isUniform => _uniformTransition != null;

  Transition get forward {
    return null != _uniformTransition ? _uniformTransition : _forward;
  }

  Transition get reverse {
    return null != _uniformTransition ? _uniformTransition : _reverse;
  }
}

typedef Transition = Function(double percent);