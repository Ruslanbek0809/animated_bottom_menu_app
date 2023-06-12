import 'package:animated_bottom_menu/app/app.dart';
import 'package:animated_bottom_menu/application/app_action/app_action_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  bootstrap(() => const App());
}

class AnimatedBottomMenuPage extends StatefulWidget {
  const AnimatedBottomMenuPage({Key? key}) : super(key: key);

  @override
  _AnimatedBottomMenuPageState createState() => _AnimatedBottomMenuPageState();
}

class _AnimatedBottomMenuPageState extends State<AnimatedBottomMenuPage>
    with TickerProviderStateMixin {
  Color mainColor = Colors.blue; //* The main color is adjusted here
  double _dragTargetPosition = 0.0;

  AnimationController? _animationController;
  Animation<double>? _animation;

  List<String> menuList = [
    'Reminder',
    'Camera',
    'Attachment',
    'Text Note',
  ]; //* The number of menu items is adjusted here

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize =
        screenWidth / 6; //* The size of the button is adjusted from here
    _animationController!.addListener(() {
      setState(() {});
    });
    return Scaffold(
      body: BlocConsumer<AppActionCubit, AppActionState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {},
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color:
                  state.isSlided || state.isDragged ? mainColor : Colors.white,
              child: Stack(
                children: [
                  Row(
                    children: [
                      _buildNavItem(
                        Icons.home,
                        0,
                        state.isSlided,
                        state.isDragged,
                      ),
                      _buildNavItem(
                        Icons.search,
                        1,
                        state.isSlided,
                        state.isDragged,
                      ),
                      //* CENTER DRAGGABLE/DRAG TARGET widgets
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<AppActionCubit>()
                                  .isSlidedChanged(false);
                            },
                            child: DragTarget<String>(
                              onAccept: (data) {
                                context
                                    .read<AppActionCubit>()
                                    .isSlidedChanged(true);
                              },
                              onWillAccept: (data) {
                                return data == 'drag';
                              },
                              onLeave: (data) {},
                              builder: (
                                BuildContext context,
                                List<dynamic> accepted,
                                List<dynamic> rejected,
                              ) {
                                return Center(
                                  child: Container(
                                    height: buttonSize,
                                    width: buttonSize,
                                    decoration: BoxDecoration(
                                      color: state.isSlided
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: state.isSlided
                                          ? mainColor
                                          : Colors.transparent,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            bottom: state.isSlided
                                ? _dragTargetPosition
                                : screenWidth / 10,
                            child: Visibility(
                              visible: !state.isSlided,
                              child: CustomPaint(
                                painter: WaterDropAnimation(
                                  radius: 35.0, // Adjust the radius as needed
                                  animationValue: _animation!.value,
                                ),
                                child: Draggable<String>(
                                  data: 'drag',
                                  axis: Axis.vertical,
                                  childWhenDragging: Container(),
                                  feedback: Container(
                                    height: buttonSize,
                                    width: buttonSize,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: mainColor,
                                    ),
                                  ),
                                  onDragStarted: () {
                                    context
                                        .read<AppActionCubit>()
                                        .isDraggedChanged(true);
                                    setState(() {
                                      _animationController!.forward();
                                    });
                                  },
                                  onDragEnd: (DraggableDetails details) {
                                    context
                                        .read<AppActionCubit>()
                                        .isDraggedChanged(false);
                                    setState(() {
                                      _dragTargetPosition = details.offset.dy;
                                      debugPrint(
                                          "Draggable on onDragEnd() _dragTargetPosition => $_dragTargetPosition");
                                      debugPrint(
                                          "Draggable on onDragEnd() details.wasAccepted => ${details.wasAccepted}");
                                      _animationController!.reverse();
                                    });
                                  },
                                  child: Container(
                                    height: buttonSize,
                                    width: buttonSize,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildNavItem(
                        Icons.favorite,
                        3,
                        state.isSlided,
                        state.isDragged,
                      ),
                      _buildNavItem(
                        Icons.person,
                        4,
                        state.isSlided,
                        state.isDragged,
                      ),
                    ],
                  ),
                  Positioned(
                    height: screenHeight / 2,
                    top: screenHeight / 1.65,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: state.isSlided ? 1 : 0,
                      child: Column(
                        children: menuList
                            .map(
                              (menuItem) => Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Text(
                                  menuItem,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(
    IconData icon,
    int index,
    bool isSlided,
    bool isDragged,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Column(
        children: [
          const Expanded(child: SizedBox.shrink()),
          Padding(
            padding: EdgeInsets.only(bottom: screenWidth / 8),
            child: GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Container(
                color: Colors.transparent,
                // _selectedIndex == index ? Colors.blue : Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.bottomCenter,
                child: Icon(
                  icon,
                  size: 28,
                  color: isSlided || isDragged
                      ? Colors.transparent
                      : Colors.purple,
                  // color: _selectedIndex == index ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterDropAnimation extends CustomPainter {
  final double radius;
  final double animationValue;

  WaterDropAnimation({
    required this.radius,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = radius + animationValue * 50;
    final innerRadius = radius + animationValue * 30;

    final outerPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      // ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      // ..color = Colors.blue.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, outerRadius, outerPaint);
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(WaterDropAnimation oldDelegate) {
    return radius != oldDelegate.radius ||
        animationValue != oldDelegate.animationValue;
  }
}
