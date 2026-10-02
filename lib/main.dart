import "package:flutter/material.dart";

void main() {
  runApp(const LiveFlutterApp());
}

class LiveFlutterApp extends StatelessWidget {
  const LiveFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Web Fullscreen",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B132B),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _counter = 0;
  final List<String> _logs = ["System Initialized", "Flutter Web Engine Ready"];

  void _addLog(String msg) {
    setState(() {
      _logs.insert(0, "${DateTime.now().toIso8601String().substring(11, 19)}: $msg");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2541),
        title: Row(
          children: [
            const Icon(Icons.flutter_dash, color: Color(0xFF38BDF8)),
            const SizedBox(width: 10),
            const Text(
              "Flutter Web Fullscreen App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _counter = 0;
                _addLog("Counter reset to 0");
              });
            },
            tooltip: "Reset Counter",
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                _addLog("Switched to Tab $index");
              });
            },
            backgroundColor: const Color(0xFF1C2541),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text("Dashboard"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bolt_outlined),
                selectedIcon: Icon(Icons.bolt),
                label: Text("Actions"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.terminal_outlined),
                selectedIcon: Icon(Icons.terminal),
                label: Text("Logs"),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFF3A506B)),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        onPressed: () {
          setState(() {
            _counter++;
            _addLog("Interacted! Count is now $_counter");
          });
        },
        icon: const Icon(Icons.add),
        label: Text("Interactions: $_counter"),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == 0) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1C2541), Color(0xFF3A506B)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF0284C7),
                    child: Icon(Icons.rocket_launch, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Live Native Flutter Web App",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Compiled on GitHub Actions & running directly inside Google AI Studio.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _statCard("State Value", "$_counter", Icons.touch_app, Colors.cyan),
                const SizedBox(width: 16),
                _statCard("Runtime", "WASM / HTML", Icons.memory, Colors.green),
                const SizedBox(width: 16),
                _statCard("CI/CD Pipeline", "GitHub Action", Icons.sync, Colors.purpleAccent),
              ],
            ),
          ],
        ),
      );
    } else if (_selectedIndex == 1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 72, color: Color(0xFF38BDF8)),
            const SizedBox(height: 16),
            const Text(
              "Full Material 3 Widget Architecture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _counter += 10;
                  _addLog("Supercharge button pressed (+10)");
                });
              },
              icon: const Icon(Icons.bolt),
              label: const Text("Supercharge (+10)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            )
          ],
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _logs.length,
        itemBuilder: (ctx, i) {
          return Card(
            color: const Color(0xFF1C2541),
            child: ListTile(
              leading: const Icon(Icons.code, color: Color(0xFF38BDF8)),
              title: Text(_logs[i], style: const TextStyle(fontFamily: "monospace", fontSize: 13)),
            ),
          );
        },
      );
    }
  }

  Widget _statCard(String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2541),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 4),
            Text(val, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
