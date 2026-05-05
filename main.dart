import 'package:flutter/material.dart';

void main() => runApp(ProSalesApp());

class ProSalesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      home: ProSalesScreen(),
    );
  }
}

class ProSalesScreen extends StatefulWidget {
  @override
  _ProSalesScreenState createState() => _ProSalesScreenState();
}

class _ProSalesScreenState extends State<ProSalesScreen> {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Navy Uniform Set",
      "price": 40.0,
      "img": "https://m.media-amazon.com/images/I/61NlM6uB6GL._AC_UX679_.jpg",
      "category": "Clothing",
    },
    {
      "name": "Olive Green Coverall",
      "price": 45.0,
      "img": "https://m.media-amazon.com/images/I/51p8K6T9IqL._AC_UX679_.jpg",
      "category": "Clothing",
    },
    {
      "name": "Steel-Toe Boot",
      "price": 35.0,
      "img": "https://m.media-amazon.com/images/I/71uK5+I0w0L._AC_UY1000_.jpg",
      "category": "Footwear",
    },
    {
      "name": "Safety Helmet",
      "price": 15.0,
      "img": "https://m.media-amazon.com/images/I/61By8+FOnDL._AC_SL1500_.jpg",
      "category": "Safety",
    },
  ];

  Map<String, int> cart = {};
  double discount = 0.0;
  final double taxRate = 0.08; // 8% Tax (Common in USD markets)

  double get subtotal => cart.entries.fold(0, (sum, item) {
    var product = products.firstWhere((p) => p['name'] == item.key);
    return sum + (product['price'] * item.value);
  });

  double get total => (subtotal - discount) * (1 + taxRate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text(
          "Global Workwear POS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {
              cart.clear();
              discount = 0;
            }),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Side: Product Grid
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) => _buildProductCard(products[i]),
            ),
          ),
          // Right Side: Checkout Panel
          Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
            ),
            child: _buildCheckoutPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> p) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              p['img'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "\$${p['price']}",
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => setState(
                    () => cart[p['name']] = (cart[p['name']] ?? 0) + 1,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Add to Cart"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.blue[800]),
              SizedBox(width: 10),
              Text(
                "Order Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(height: 30),
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      "Cart is empty",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView(
                    children: cart.entries
                        .map(
                          (e) => Card(
                            child: ListTile(
                              title: Text(
                                e.key,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Text("x${e.value}"),
                              leading: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red[300],
                                ),
                                onPressed: () => setState(
                                  () => e.value > 1
                                      ? cart[e.key] = e.value - 1
                                      : cart.remove(e.key),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          Divider(),
          _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          _buildSummaryRow(
            "Tax (8%)",
            "\$${(subtotal * taxRate).toStringAsFixed(2)}",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount \$:"),
              Container(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      setState(() => discount = double.tryParse(v) ?? 0),
                  decoration: InputDecoration(hintText: "0.00", isDense: true),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildSummaryRow(
              "TOTAL",
              "\$${total.toStringAsFixed(2)}",
              isTotal: true,
            ),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // Logic for showing a "Success" message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Payment Completed Successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              "CHECKOUT",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 22 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 26 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
              color: isTotal ? Colors.blue[900] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
