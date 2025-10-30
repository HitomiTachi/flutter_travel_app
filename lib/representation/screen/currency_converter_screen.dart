import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterScreen extends StatefulWidget {
  static const String routeName = '/currency_converter_screen';

  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _tipPercentController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'VND';
  double _exchangeRate = 0;
  double _convertedAmount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Tip calculator
  double _tipAmount = 0;
  double _totalAmount = 0;
  double _tipPercent = 15.0;

  // Popular currencies
  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'USD - Đô la Mỹ', 'flag': '🇺🇸'},
    {'code': 'EUR', 'name': 'EUR - Euro', 'flag': '🇪🇺'},
    {'code': 'GBP', 'name': 'GBP - Bảng Anh', 'flag': '🇬🇧'},
    {'code': 'JPY', 'name': 'JPY - Yên Nhật', 'flag': '🇯🇵'},
    {'code': 'CNY', 'name': 'CNY - Nhân dân tệ', 'flag': '🇨🇳'},
    {'code': 'KRW', 'name': 'KRW - Won Hàn Quốc', 'flag': '🇰🇷'},
    {'code': 'SGD', 'name': 'SGD - Đô la Singapore', 'flag': '🇸🇬'},
    {'code': 'THB', 'name': 'THB - Baht Thái', 'flag': '🇹🇭'},
    {'code': 'VND', 'name': 'VND - Đồng Việt Nam', 'flag': '🇻🇳'},
    {'code': 'AUD', 'name': 'AUD - Đô la Úc', 'flag': '🇦🇺'},
    {'code': 'CAD', 'name': 'CAD - Đô la Canada', 'flag': '🇨🇦'},
    {'code': 'CHF', 'name': 'CHF - Franc Thụy Sĩ', 'flag': '🇨🇭'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedCurrencies();
    _amountController.addListener(_onAmountChanged);
    _billController.addListener(_onBillChanged);
    _tipPercentController.text = '15';
    _tipPercentController.addListener(_onTipChanged);
    _fetchExchangeRate();
  }

  void _loadSavedCurrencies() {
    final savedFrom = LocalStorageHelper.getValue('saved_from_currency');
    final savedTo = LocalStorageHelper.getValue('saved_to_currency');
    if (savedFrom != null) _fromCurrency = savedFrom.toString();
    if (savedTo != null) _toCurrency = savedTo.toString();
    setState(() {});
  }

  void _saveCurrencies() {
    LocalStorageHelper.setValue('saved_from_currency', _fromCurrency);
    LocalStorageHelper.setValue('saved_to_currency', _toCurrency);
  }

  Future<void> _fetchExchangeRate() async {
    if (_fromCurrency == _toCurrency) {
      setState(() {
        _exchangeRate = 1.0;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sử dụng ExchangeRate-API (free tier: 1500 requests/month)
      final response = await http
          .get(
            Uri.parse(
              'https://api.exchangerate-api.com/v4/latest/$_fromCurrency',
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        final rate = rates[_toCurrency] as double? ?? 0.0;

        setState(() {
          _exchangeRate = rate;
          _isLoading = false;
        });
        _onAmountChanged();
      } else {
        setState(() {
          _errorMessage = 'Không thể tải tỷ giá. Vui lòng thử lại.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối. Vui lòng kiểm tra internet.';
        _isLoading = false;
      });
    }
  }

  void _onAmountChanged() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _convertedAmount = amount * _exchangeRate;
    });
  }

  void _onBillChanged() {
    _calculateTip();
  }

  void _onTipChanged() {
    final percent = double.tryParse(_tipPercentController.text) ?? 0;
    setState(() {
      _tipPercent = percent;
    });
    _calculateTip();
  }

  void _calculateTip() {
    final billAmount = double.tryParse(_billController.text) ?? 0;
    final percent = double.tryParse(_tipPercentController.text) ?? 0;

    setState(() {
      _tipAmount = billAmount * (percent / 100);
      _totalAmount = billAmount + _tipAmount;
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _amountController.text = _convertedAmount.toStringAsFixed(2);
      _onAmountChanged();
    });
    _fetchExchangeRate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _billController.dispose();
    _tipPercentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Đổi tiền & Máy tính',
      implementLeading: true,
      child: Column(
        children: [
          const SizedBox(height: kMediumPadding),
          TabBar(
            controller: _tabController,
            labelColor: ColorPalette.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorPalette.primaryColor,
            tabs: const [
              Tab(text: 'Đổi tiền tệ'),
              Tab(text: 'Tính tiền tip'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildCurrencyConverter(), _buildTipCalculator()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyConverter() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exchange Rate Card
          Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tỷ giá',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorPalette.subTitleColor,
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _fetchExchangeRate,
                        iconSize: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoading
                      ? 'Đang tải...'
                      : _errorMessage != null
                      ? _errorMessage!
                      : '1 $_fromCurrency = ${_exchangeRate.toStringAsFixed(4)} $_toCurrency',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: kMediumPadding),

          // From Currency
          _buildCurrencySelector(
            label: 'Từ',
            currency: _fromCurrency,
            amount: _amountController,
            onCurrencyChanged: (currency) {
              setState(() {
                _fromCurrency = currency;
              });
              _saveCurrencies();
              _fetchExchangeRate();
            },
          ),

          const SizedBox(height: kMediumPadding),

          // Swap Button
          Center(
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.swap_vert, color: Colors.white),
              ),
              onPressed: _swapCurrencies,
            ),
          ),

          const SizedBox(height: kMediumPadding),

          // To Currency
          _buildCurrencySelector(
            label: 'Sang',
            currency: _toCurrency,
            amount: TextEditingController(
              text: _convertedAmount.toStringAsFixed(2),
            ),
            readOnly: true,
            onCurrencyChanged: (currency) {
              setState(() {
                _toCurrency = currency;
              });
              _saveCurrencies();
              _fetchExchangeRate();
            },
          ),

          const SizedBox(height: kMediumPadding),

          // Quick amounts
          _buildQuickAmounts(),

          const SizedBox(height: kMediumPadding),

          // Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tỷ giá được cập nhật theo thời gian thực từ ExchangeRate-API',
                    style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector({
    required String label,
    required String currency,
    required TextEditingController amount,
    required Function(String) onCurrencyChanged,
    bool readOnly = false,
  }) {
    final currencyInfo = _currencies.firstWhere((c) => c['code'] == currency);
    final flag = currencyInfo['flag'] ?? '';

    return Container(
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: ColorPalette.subTitleColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amount,
                  readOnly: readOnly,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showCurrencyPicker(onCurrencyChanged),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ColorPalette.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorPalette.primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(
                        currency,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: ColorPalette.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmounts() {
    final quickAmounts = [100, 500, 1000, 5000];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: quickAmounts.map((amount) {
        return InkWell(
          onTap: () {
            _amountController.text = amount.toString();
            _onAmountChanged();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              '$_fromCurrency $amount',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipCalculator() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill Amount
          _buildInputCard(
            title: 'Số tiền hóa đơn',
            controller: _billController,
            prefix: _fromCurrency,
          ),

          const SizedBox(height: kMediumPadding),

          // Tip Percent
          Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phần trăm tip (%)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorPalette.subTitleColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tipPercentController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _tipPercent,
                  min: 0,
                  max: 30,
                  divisions: 60,
                  activeColor: ColorPalette.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _tipPercent = value;
                      _tipPercentController.text = value.toStringAsFixed(0);
                    });
                    _calculateTip();
                  },
                ),
                Wrap(
                  spacing: 8,
                  children: [10, 15, 18, 20].map((percent) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _tipPercent = percent.toDouble();
                          _tipPercentController.text = percent.toString();
                        });
                        _calculateTip();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _tipPercent == percent
                              ? ColorPalette.primaryColor
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _tipPercent == percent
                                ? ColorPalette.primaryColor
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _tipPercent == percent
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: kMediumPadding),

          // Results
          Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorPalette.primaryColor,
                  ColorPalette.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildResultRow('Tiền tip:', _tipAmount),
                const Divider(color: Colors.white70, height: 24),
                _buildResultRow('Tổng cộng:', _totalAmount, isTotal: true),
              ],
            ),
          ),

          const SizedBox(height: kMediumPadding),

          // Split bill
          Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chia đều hóa đơn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [2, 3, 4, 5, 6].map((people) {
                    final perPerson = _totalAmount / people;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$people người',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${perPerson.toStringAsFixed(0)} $_fromCurrency',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required String prefix,
  }) {
    return Container(
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: ColorPalette.subTitleColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: '$prefix ',
              prefixStyle: const TextStyle(
                fontSize: 20,
                color: ColorPalette.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} $_fromCurrency',
          style: TextStyle(
            fontSize: isTotal ? 20 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showCurrencyPicker(Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Chọn loại tiền tệ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _currencies.length,
                itemBuilder: (context, index) {
                  final currency = _currencies[index];
                  final isSelected =
                      currency['code'] == _fromCurrency ||
                      currency['code'] == _toCurrency;
                  return ListTile(
                    leading: Text(
                      currency['flag'] ?? '',
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(
                      currency['name'] ?? '',
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? ColorPalette.primaryColor
                            : Colors.black87,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: ColorPalette.primaryColor,
                          )
                        : null,
                    onTap: () {
                      onSelected(currency['code']!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
