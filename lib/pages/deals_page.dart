import 'package:flutter/material.dart';
import '../services/openfood_deals_service.dart';
import '../theme/theme_colors.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({Key? key}) : super(key: key);

  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  final OpenFoodDealsService _dealsService = OpenFoodDealsService();
  List<Map<String, dynamic>> _deals = [];
  String _currentCategory = 'snacks';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeals();
  }

  // Load deals: try cache first, then fetch new if needed
  Future<void> _loadDeals() async {
    setState(() {
      _isLoading = true;
    });

    final deals = await _dealsService.fetchGroceryDeals(category: _currentCategory);

    setState(() {
      _deals = deals;
      _isLoading = false;
    });
  }

  void _onCategoryChanged(String? newCategory) {
    if (newCategory != null) {
      setState(() {
        _currentCategory = newCategory;
      });
      _loadDeals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Grocery Deals'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ThemeColor.background,
        foregroundColor: ThemeColor.textPrimary, // Text color
      ),
      body: Column(
        children: [
          // Category dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButton<String>(
              value: _currentCategory,
              isExpanded: true,
              dropdownColor: ThemeColor.background, // dropdown background
              iconEnabledColor: ThemeColor.primary, // arrow icon color
              style: TextStyle(color: ThemeColor.textPrimary), // selected text
              items: const [
                DropdownMenuItem(value: 'snacks', child: Text('Snacks')),
                DropdownMenuItem(value: 'beverages', child: Text('Drinks')),
                DropdownMenuItem(value: 'fruits', child: Text('Fruits')),
                DropdownMenuItem(value: 'vegetables', child: Text('Vegetables')),
              ],
              onChanged: _onCategoryChanged,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: ThemeColor.primary),
                  SizedBox(height: 20),
                  Text(
                  'Fetching grocery deals...',
                  style: TextStyle(color: ThemeColor.textPrimary),                
                  ),
                ],
              ),
            )
                : _deals.isEmpty
                ? Center(
              child: Text(
                '😢 No deals found. Try another category!',
                style: TextStyle(fontSize: 18, color: ThemeColor.textPrimary),
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadDeals,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _deals.length,
                itemBuilder: (context, index) {
                  final deal = _deals[index];
                  return Card(
                    color: ThemeColor.background,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green[50],
                        child: Icon(Icons.shopping_cart, color: Colors.green[800]),
                      ),
                      title: Text(
                        deal['title'] ?? 'Unknown Product',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.textPrimary, 
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal['brand'] ?? 'Unknown Brand',
                            style: TextStyle(color: ThemeColor.textSecondary), // 🔹 Brand text color
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Store: ${deal['store'] ?? 'Various stores'}',
                            style: TextStyle(color: ThemeColor.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${deal['discount'] ?? '5'}% OFF',
                            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.local_offer, color: Colors.redAccent),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeColor.background,
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: ThemeColor.textSecondary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, color: ThemeColor.textSecondary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer,  color: ThemeColor.primary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home, color: ThemeColor.textSecondary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search,  color: ThemeColor.textSecondary), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person,  color: ThemeColor.textSecondary), label: ''),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/settings');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/notifications');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/deals');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/search');
          } else if (index == 5) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
