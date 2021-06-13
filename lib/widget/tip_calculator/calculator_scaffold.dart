import 'package:flutter/material.dart';
import '../../style.dart';

// Cannot pass a stateful widget into another widget b/c the
// passed widget will never get rebuilt since its saved to a variable.
// Will need to use a different state management such as notifier.
class CalculatorScaffold extends StatefulWidget {
  final bool isSavable;
  final Function onSaved;
  final Widget step1;
  final Widget step2;
  final Widget step3;
  final Widget step4;
  final String header;
  final scrollController = ScrollController();

  CalculatorScaffold(
      {this.isSavable,
      this.onSaved,
      this.header,
      this.step1,
      this.step2,
      this.step3,
      this.step4});

  @override
  _CalculatorScaffoldState createState() => _CalculatorScaffoldState();
}

class _CalculatorScaffoldState extends State<CalculatorScaffold> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    print("CalculatorScaffold build");
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      // floatingActionButton: widget.isSavable
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           FocusScope.of(context).unfocus();
      //           widget.scrollController.jumpTo(0);
      //           widget.onSaved();

      //           final snackBar =
      //               SnackBar(content: Text("Payment saved to history"));

      //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //         },
      //         child: Icon(Icons.bookmarks_outlined),
      //         backgroundColor: Colors.teal,
      //         tooltip: "Save Payments To History",
      //       )
      //     : null,
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _index,
        // Remove continue/cancel buttons
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Container();
        },
        // onStepCancel: _index == 0
        //     ? null
        //     : () {
        //         if (_index > 0) {
        //           setState(() {
        //             _index -= 1;
        //           });
        //         }
        //       },
        // onStepContinue: _index == 3
        //     ? null
        //     : () {
        //         if (_index <= 2 || (_index == 3 && widget.isSavable)) {
        //           setState(() {
        //             _index += 1;
        //           });
        //         }
        //       },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        steps: <Step>[
          Step(
            title: const Text('Tip'),
            state: widget.isSavable ? StepState.complete : StepState.indexed,
            isActive: _index == 0,
            content: Container(
              alignment: Alignment.centerLeft,
              child: widget.step1,
            ),
          ),
          Step(
            title: Text('Split'),
            subtitle: const Text('Optional'),
            isActive: _index == 1,
            content: Container(
              alignment: Alignment.centerLeft,
              child: widget.step2,
            ),
          ),
          Step(
            title: Text('Info'),
            subtitle: const Text('Optional'),
            isActive: _index == 2,
            content: Container(
              alignment: Alignment.centerLeft,
              child: widget.step3,
            ),
          ),
          Step(
            title: Text('Save'),
            subtitle: const Text('Optional'),
            state: widget.isSavable ? StepState.indexed : StepState.disabled,
            isActive: _index == 3,
            content: Container(
              alignment: Alignment.centerLeft,
              child: widget.step4,
            ),
          ),
        ],
      ),
    );
  }
}
