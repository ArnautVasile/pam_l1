import 'package:flutter/material.dart';
import 'theme.dart'; // Import the text theme file
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  double _numberOfMonths = 1;
  double _monthlyPayment = 0;

  void _calculateMonthlyPayment() {
    print("e");
    final double loanAmount = double.tryParse(_amountController.text) ?? 0;
    final double annualInterestRate =
        double.tryParse(_percentController.text) ?? 0;
    final int numberOfMonths = _numberOfMonths.toInt();

    if (loanAmount <= 0 || annualInterestRate <= 0 || numberOfMonths <= 0) {
      setState(() {
        _monthlyPayment = 0;
      });
      return;
    }

    final double monthlyInterestRate = annualInterestRate / 100 / 12;
    final double numerator = monthlyInterestRate * loanAmount;
    final num denominator = 1 - pow((1 + monthlyInterestRate), -numberOfMonths);
    final double monthlyPayment = numerator / denominator;

    setState(() {
      _monthlyPayment = monthlyPayment;
    });
  }

  void _handleSliderChange(double value) {
    setState(() {
      _numberOfMonths = value; // Update the slider value
      _calculateMonthlyPayment();
    });
    //  print('Slider value in MyApp: $_sliderValue'); // Handle the value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              child: Center(
                child: Text('Loan Calculator 2024', style: MyText.titleHeader),
              ),
            ),
            SizedBox(height: 40), // Add spacing before the slider

            SizedBox(
              width: 353,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter amount', style: MyText.inputTitle),
                  MyInputField(
                    hintText: 'Amount',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20), // Add spacing before the slider

                  Text('Enter the number of months', style: MyText.inputTitle),
                  SizedBox(height: 10),

                  SliderWithBorder(
                      value: _numberOfMonths,
                      onValueChanged: _handleSliderChange),
                  SizedBox(height: 20),

                  Text('Enter % per month', style: MyText.inputTitle),
                  MyInputField(
                    hintText: null,
                    controller: _percentController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),

            SizedBox(height: 60),
            RoundedBoxWithText(monthlyPayment: _monthlyPayment),
            // Text("${_monthlyPayment}"),
            SizedBox(height: 25),

            CustomButton(
              text: 'Calculate',
              onPressed: () {
                _calculateMonthlyPayment();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SliderWithBorder extends StatefulWidget {
  final double value;
  final ValueChanged<double> onValueChanged;

  const SliderWithBorder(
      {super.key, this.value = 1, required this.onValueChanged});

  @override
  _SliderWithBorderState createState() => _SliderWithBorderState();
}

class _SliderWithBorderState extends State<SliderWithBorder> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value; // Initialize _value with the initial value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.center, // Center-align the slider and text
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Color(0xFF1427C5),
            thumbShape: AppSliderShape(),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: _value,
            min: 1, // Minimum value for the slider
            max: 60, // Maximum value for the slider
            onChanged: (val) {
              setState(() {
                _value = val;
              });
              widget.onValueChanged(val);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5.0), // Adjust horizontal padding to center text
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Align text at the start and end
            children: [
              Text('1', style: MyText.sliderIndicator), // Start text
              Text(_value.round().toString() + " luni",
                  style: MyText.sliderIndicator), // End text
            ],
          ),
        ),
      ],
    );
  }
}

class AppSliderShape extends SliderComponentShape {
  const AppSliderShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(10, 20);
  }

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
  }) {
    final Canvas canvas = context.canvas;

    final paintWhite = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final paintBlue = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1427C5);

    canvas.drawCircle(center, 12, paintWhite);
    canvas.drawCircle(center, 7, paintBlue);
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1427C5),
        padding: EdgeInsets.symmetric(horizontal: 140, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18, // Font size
            color: Colors.white),
      ),
    );
  }
}

class RoundedBoxWithText extends StatelessWidget {
  final double monthlyPayment;
  const RoundedBoxWithText({super.key, required this.monthlyPayment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 204,
      width: 353,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Use mainAxisAlignment.spaceBetween
        children: [
          Container(
            //de centrat
            //   height: 110,
            alignment:
                Alignment.center, // Add alignment to center the text vertically
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: const Text(
              'You will pay\n the approximate amount\n monthly:',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, color: Colors.black, fontFamily: "CeraPro"),
            ),
          ),
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                '${monthlyPayment.toStringAsFixed(3)} €',
                //'3.943€',
                style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF1427C5),
                    fontFamily: "CeraPro"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
