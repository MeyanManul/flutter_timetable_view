import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/lane_events.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';
import 'package:flutter_timetable_view/src/views/controller/timetable_view_controller.dart';
import 'package:flutter_timetable_view/src/views/diagonal_scroll_view.dart';
import 'package:flutter_timetable_view/src/views/lane_view.dart';

class TimetableView extends StatefulWidget {
  final List<LaneEvents> laneEventsList;
  final TimetableStyle timetableStyle;

  TimetableView({
    Key? key,
    required this.laneEventsList,
    this.timetableStyle: const TimetableStyle(),
  }) : super(key: key);

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView>
    with TimetableViewController {
  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildCorner(),
        _buildMainContent(context),
        _buildTimelineList(context),
        _buildLaneList(context),
      ],
    );
  }

  Widget _buildCorner() {
    return Positioned(
      left: 0,
      top: 0,
      child: SizedBox(
        width: widget.timetableStyle.laneWidth,
        height: widget.timetableStyle.timeItemHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: widget.timetableStyle.cornerColor),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.timetableStyle.laneWidth,
        top: widget.timetableStyle.timeItemHeight,
      ),
      child: DiagonalScrollView(
        horizontalPixelsStreamController: horizontalPixelsStream,
        verticalPixelsStreamController: verticalPixelsStream,
        onScroll: onScroll,
        maxWidth:
            (widget.timetableStyle.endHour - widget.timetableStyle.startHour) *
                widget.timetableStyle.timeItemWidth,
        maxHeight:
            widget.laneEventsList.length * widget.timetableStyle.laneHeight,
        child: IntrinsicHeight(
          child: Column(
            children: widget.laneEventsList.map((laneEvents) {
              return LaneView(
                events: laneEvents.events,
                timetableStyle: widget.timetableStyle,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: widget.timetableStyle.timeItemHeight,
      padding: EdgeInsets.only(left: widget.timetableStyle.laneWidth),
      color: widget.timetableStyle.timelineColor,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        controller: horizontalScrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (var i = widget.timetableStyle.startHour;
              i < widget.timetableStyle.endHour;
              i += 1)
            i
        ].map((hour) {
          return Container(
            width: widget.timetableStyle.timeItemWidth,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.timetableStyle.timelineBorderColor,
                  width: 0,
                ),
              ),
              color: widget.timetableStyle.timelineItemColor,
            ),
            child: Text(
              Utils.hourFormatter(hour, 0),
              style: TextStyle(color: widget.timetableStyle.timeItemTextColor),
              textAlign: TextAlign.left,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLaneList(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: widget.timetableStyle.laneColor,
      width: widget.timetableStyle.laneWidth,
      padding: EdgeInsets.only(top: widget.timetableStyle.timeItemHeight),
      child: ListView(
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        controller: verticalScrollController,
        shrinkWrap: true,
        children: widget.laneEventsList.map((laneEvents) {
          return Container(
            width: laneEvents.lane.width,
            height: laneEvents.lane.height,
            color: laneEvents.lane.backgroundColor,
            child: Center(
              child: Text(
                laneEvents.lane.name,
                style: laneEvents.lane.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
