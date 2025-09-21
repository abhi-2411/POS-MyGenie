import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF329937), // Updated primary color
        scaffoldBackgroundColor: Colors.grey[100],
        // Use the Poppins font family
        fontFamily: 'Poppins',
      ),
      home: const LoyaltyProgramScreen(),
    );
  }
}

class LoyaltyProgramScreen extends StatefulWidget {
  const LoyaltyProgramScreen({super.key});

  @override
  State<LoyaltyProgramScreen> createState() => _LoyaltyProgramScreenState();
}

class _LoyaltyProgramScreenState extends State<LoyaltyProgramScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Add a listener to rebuild the UI when the tab changes
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Logo is now the leading widget
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            height: 46,
            width: 31.73,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.store, color: Color(0xFF329937)),
          ),
        ),
        // Title is centered
        title: Text(
          'Loyalty Program',
          style: TextStyle(
            color: Colors.green[700],
            fontWeight: FontWeight.w600, // Semi-bold
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        // Hamburger menu is now in the actions list
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF329937)),
            onPressed: () {
              // Add drawer functionality here if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                children: [
                  _buildTab(context, 'Conversion', 0),
                  // Decreased indent and endIndent to make the divider longer
                  VerticalDivider(
                    width: 10,
                    thickness: 1,
                    color: Colors.grey[300],
                    indent: 8,
                    endIndent: 8,
                  ),
                  _buildTab(context, 'Redemption', 1),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [ConversionRatePage(), RedemptionPage()],
            ),
          ),
        ],
      ),
    );
  }

  // Custom widget to build a tab with margin and divider logic
  Widget _buildTab(BuildContext context, String text, int index) {
    bool isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          // Removed the horizontal margin to let the divider control spacing
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF329937) : const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
                fontFamily: 'Poppins',
                color: isSelected ? Colors.white : const Color(0xFF828282),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Base Card for Page Content ---
class ContentCard extends StatelessWidget {
  final Widget child;
  const ContentCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: child,
        ),
      ),
    );
  }
}

// --- Conversion Page ---
class ConversionRatePage extends StatefulWidget {
  const ConversionRatePage({super.key});

  @override
  State<ConversionRatePage> createState() => _ConversionRatePageState();
}

class _ConversionRatePageState extends State<ConversionRatePage> {
  final TextEditingController _controller = TextEditingController();
  String _conversionRate = '1.0';

  @override
  void initState() {
    super.initState();
    _controller.text = _conversionRate;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateConversionRate() {
    final double? newRate = double.tryParse(_controller.text);

    if (newRate == null || newRate < 0 || newRate > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid rate between 0 and 100.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _conversionRate = newRate.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conversion rate updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle inputTextStyle = TextStyle(
      fontSize: 14,
      color: Color(0xFF8C8C8C),
    );
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Color(0xFFDCDCDC), width: 1.5),
    );

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Set Conversion Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: inputTextStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              labelText: 'Conversion Rate',
              labelStyle: inputTextStyle,
              hintText: 'Enter the conversion rate',
              hintStyle: inputTextStyle,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20.0,
              ),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: const BorderSide(
                  color: Color(0xFF329937),
                  width: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateConversionRate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF329937),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Update Rate',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Current Rate: $_conversionRate',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Redemption Page ---
class RedemptionPage extends StatefulWidget {
  const RedemptionPage({super.key});

  @override
  State<RedemptionPage> createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage> {
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  double _maxPercentage = 50.0;
  double _maxAmount = 500.0;

  @override
  void initState() {
    super.initState();
    _percentageController.text = _maxPercentage.toStringAsFixed(1);
    _amountController.text = _maxAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _percentageController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _updateRedemptionSettings() {
    final newPercentage =
        double.tryParse(_percentageController.text) ?? _maxPercentage;
    final newAmount = double.tryParse(_amountController.text) ?? _maxAmount;
    setState(() {
      _maxPercentage = newPercentage;
      _maxAmount = newAmount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings updated: ${_maxPercentage.toStringAsFixed(1)}% | ₹${_maxAmount.toStringAsFixed(2)}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Set Redemption Limits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildSliderWithTextField(
            label: 'Max Percentage',
            controller: _percentageController,
            sliderValue: _maxPercentage,
            onSliderChanged: (value) {
              setState(() {
                _maxPercentage = value;
                _percentageController.text = value.toStringAsFixed(1);
              });
            },
            suffixText: '%',
            maxValue: 100.0,
            divisions: 100,
          ),
          const SizedBox(height: 30),
          _buildSliderWithTextField(
            label: 'Max Amount',
            controller: _amountController,
            sliderValue: _maxAmount,
            onSliderChanged: (value) {
              setState(() {
                _maxAmount = value;
                _amountController.text = value.toStringAsFixed(2);
              });
            },
            prefixText: '₹',
            maxValue: 1000.0,
            divisions: 200,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateRedemptionSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF329937),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Update Settings',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Current Max: ${_maxPercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Current Max: ₹${_maxAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderWithTextField({
    required String label,
    required TextEditingController controller,
    required double sliderValue,
    required ValueChanged<double> onSliderChanged,
    required double maxValue,
    required int divisions,
    String? suffixText,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Slider(
                value: sliderValue,
                min: 0.0,
                max: maxValue,
                divisions: divisions,
                label: sliderValue.toStringAsFixed(suffixText == '%' ? 1 : 2),
                activeColor: const Color(0xFF329937),
                onChanged: onSliderChanged,
              ),
            ),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.normal),
                onChanged: (text) {
                  final value = double.tryParse(text);
                  if (value != null && value >= 0 && value <= maxValue) {
                    onSliderChanged(value);
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  prefixText: prefixText,
                  suffixText: suffixText,
                  prefixStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  suffixStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Color(0xFF329937)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
