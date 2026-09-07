import 'package:flutter/material.dart';

void main() => runApp(const AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'আমার রেসিপি - Admin',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  void login() {
    if (email.text.trim() == 'admin@example.com' && password.text == 'admin123') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email অথবা Password ভুল')));
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.admin_panel_settings, size: 70),
                    const SizedBox(height: 16),
                    const Text('আমার রেসিপি', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Admin Panel', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 28),
                    TextField(controller: email, decoration: const InputDecoration(labelText: 'Admin Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
                    const SizedBox(height: 16),
                    TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock))),
                    const SizedBox(height: 20),
                    FilledButton(onPressed: login, child: const Padding(padding: EdgeInsets.all(12), child: Text('Login'))),
                    const SizedBox(height: 12),
                    const Text('Demo: admin@example.com / admin123', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Recipe {
  Recipe({required this.name, required this.category, required this.country, required this.time, this.featured = false});
  String name;
  String category;
  String country;
  String time;
  bool featured;
}

final List<Recipe> recipes = [
  Recipe(name: 'Chicken Biryani', category: 'ভাত', country: 'Bangladesh', time: '60 min', featured: true),
  Recipe(name: 'Ilish Bhaja', category: 'মাছ', country: 'Bangladesh', time: '25 min'),
  Recipe(name: 'Chicken Curry', category: 'মাংস', country: 'India', time: '45 min'),
];

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;

  void addRecipe() {
    final name = TextEditingController();
    final category = TextEditingController();
    final country = TextEditingController();
    final time = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('নতুন Recipe যোগ করুন'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Recipe name')),
              TextField(controller: category, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: country, decoration: const InputDecoration(labelText: 'Country')),
              TextField(controller: time, decoration: const InputDecoration(labelText: 'Cooking time')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty) return;
              setState(() {
                recipes.add(Recipe(
                  name: name.text.trim(),
                  category: category.text.trim().isEmpty ? 'অন্যান্য' : category.text.trim(),
                  country: country.text.trim().isEmpty ? 'Bangladesh' : country.text.trim(),
                  time: time.text.trim().isEmpty ? '30 min' : time.text.trim(),
                ));
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget recipesPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes'), actions: [IconButton(onPressed: addRecipe, icon: const Icon(Icons.add))]),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recipes.length,
        itemBuilder: (context, i) {
          final r = recipes[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(r.name),
              subtitle: Text('${r.category} • ${r.country} • ${r.time}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(r.featured ? Icons.star : Icons.star_border),
                  IconButton(onPressed: () => setState(() => recipes.removeAt(i)), icon: const Icon(Icons.delete)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categoriesPage() {
    const categories = ['ভাত', 'মাছ', 'মাংস', 'সবজি', 'ডাল', 'ভর্তা', 'নাস্তা', 'মিষ্টি', 'পানীয়'];
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: categories.length,
        itemBuilder: (context, i) => Card(child: ListTile(leading: const Icon(Icons.category), title: Text(categories[i]))),
      ),
    );
  }

  Widget settingsPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('বর্তমানে এটি Demo Admin Panel।'),
            SizedBox(height: 8),
            Text('পরের ধাপে Supabase যুক্ত করলে User App-এর Recipe, ছবি, Category এবং Featured Recipe অনলাইনে নিয়ন্ত্রণ করা যাবে।'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [recipesPage(), categoriesPage(), settingsPage()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.category), label: 'Categories'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
