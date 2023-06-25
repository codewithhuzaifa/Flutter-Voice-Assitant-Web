import 'dart:math';
import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';

final double buttonsize = 80;

class circularFabWidget extends StatefulWidget {
  @override
  State<circularFabWidget> createState() => _circularFabWidgetState();
}

class _circularFabWidgetState extends State<circularFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Flow(
        delegate: flowMenuDelegate(controller: controller),
        children: <IconData>[
          Icons.mic_rounded,
          Icons.stop,
          Icons.menu,
        ].map<Widget>(buidFAB).toList(),
      );

  Widget buidFAB(IconData icon) => SizedBox(
        width: buttonsize,
        height: buttonsize,
        child: FloatingActionButton(
          elevation: 0,
          splashColor: Colors.black,
          backgroundColor: Pallete.secondSuggestionBoxColor,
          child: Icon(
            icon,
            color: Colors.white,
            size: 45,
          ),
          onPressed: () async {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else {
              controller.forward();
            }

            if (icon == Icons.mic_rounded) {
              print('click on mic');
            } else if (icon == Icons.stop) {
              print('Click on stop button');
            }
          },
        ),
      );
}

class flowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  const flowMenuDelegate({required this.controller})
      : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xstart = size.width - buttonsize;
    final ystart = size.height - buttonsize;
    final n = context.childCount;
    for (int i = 0; i < n; i++) {
      final lastitem = i == context.childCount - 1;
      final setvalue = (value) => lastitem ? 0.0 : value;
      final radius = 100 * controller.value;
      final theta = i * pi * 0.5 / (n - 2);
      final x = xstart - setvalue(radius * cos(theta));
      final y = ystart - setvalue(radius * sin(theta));
      context.paintChild(i,
          transform: Matrix4.identity()
            ..translate(x, y, 0)
            ..rotateZ(lastitem ? 0.0 : 180 * (1 - controller.value) * pi / 180)
            ..scale(lastitem
                ? 1.0
                : max(
                    controller.value,
                    0.5,
                  ))
            ..translate(-buttonsize / 2, -buttonsize / 2));
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}



// ZoomIn(
//         delay: Duration(milliseconds: start + 3 * delay),
//         child: FloatingActionButton(
//           backgroundColor: Pallete.firstSuggestionBoxColor,
//           onPressed: () async {
//             if (await speechToText.hasPermission &&
//                 speechToText.isNotListening) {
//               await startListening();
//             } else if (speechToText.isListening) {
//               final speech = await openAIService.isArtPromptAPI(lastWords);
//               if (speech.contains('https')) {
//                 generatedImageUrl = speech;
//                 generatedContent = null;
//                 setState(() {});
//               } else {
//                 generatedImageUrl = null;
//                 generatedContent = speech;
//                 setState(() {});
//                 await systemSpeak(speech);
//               }
//               await stopListening();
//             } else {
//               initSpeechToText();
//             }
//           },
//           child: Icon(
//             speechToText.isListening ? Icons.stop : Icons.mic,
//           ),
//         ),
//       ),