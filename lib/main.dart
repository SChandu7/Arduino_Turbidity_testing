import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const TurbidityApp());
}

class TurbidityApp extends StatelessWidget {
  const TurbidityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TurbidityMonitor(),
    );
  }
}

class TurbidityMonitor extends StatefulWidget {
  const TurbidityMonitor({super.key});

  @override
  State<TurbidityMonitor> createState() => _TurbidityMonitorState();
}

class _TurbidityMonitorState extends State<TurbidityMonitor> {
  double turbidity = 3.0;
  String status = "Pure";
  bool isFetching = false;

  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();

    fetchTurbidity(); // <-- Fetch immediately on start

    Future.delayed(const Duration(seconds: 5), () {
      setState(() => isFetching = true);
      Timer.periodic(const Duration(seconds: 3), (_) => fetchTurbidity());
    });
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  Future<void> fetchTurbidity() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://8671a5f8-6323-4a16-9356-a2dd53e7078c-00-2m041txxfet0b.pike.replit.dev/receive_arduino/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          history.clear();
          for (var entry in data.reversed) {
            String newTurbidity = entry['result'].toString(); // Treat as string
            String rawTime = entry['time'];
            DateTime parsedTime = DateTime.parse(rawTime).toLocal();
            String formattedTime = "${parsedTime.year >= 2000 ? 'AD' : 'BC'}, "
                "${_monthName(parsedTime.month)} ${parsedTime.day}, "
                "${parsedTime.hour.toString().padLeft(2, '0')}:${parsedTime.minute.toString().padLeft(2, '0')}";
            String newStatus = getStatusFromString(
                newTurbidity); // You may want to update this

            history.add({
              "time": formattedTime,
              "value": newTurbidity,
              "status": newStatus,
              "source": "Sensor"
            });
          }
          // Show the latest value on the main screen
          if (history.isNotEmpty) {
            turbidity = history.first["value"]; // Now a string
            status = history.first["status"];
          }
        });
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("FAILED TO FETCH: $e");
    }
  }

  String getStatus(double value) {
    if (value <= 5) return "Pure";
    if (value <= 20) return "Slightly Dirty";
    return "Polluted";
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Pure":
        return Colors.green;
      case "Slightly Dirty":
        return Colors.orange;
      case "Polluted":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Pure":
        return Icons.check_circle;
      case "Slightly Dirty":
        return Icons.warning;
      case "Polluted":
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  String getStatusFromString(String value) {
    // You can customize this logic as needed
    // For now, just return the value itself
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Turbidity Sensor"),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Current Turbidity",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    history.isNotEmpty
                        ? "${history.first["value"]} NTU"
                        : "Loading...",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Icon(
                    getStatusIcon(status),
                    color: getStatusColor(status),
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 22,
                      color: getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isFetching ? "Live Data Mode" : "Showing Default Values...",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Water Quality Chart",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(color: Colors.black26),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1.5),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFE3F2FD)),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "NTU Range",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Water Quality",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("0 – 5", textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Pure", textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("6 – 20", textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Slightly Dirty",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("21+", textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Polluted",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blue.shade100,
        padding: const EdgeInsets.all(10),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
          icon: const Icon(Icons.history),
          label: const Text(
            "View History",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

// 📄 2. History Screen
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> entries = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  Future<void> fetchSensorData() async {
    const url =
        "https://8671a5f8-6323-4a16-9356-a2dd53e7078c-00-2m041txxfet0b.pike.replit.dev/receive_arduino/";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> loadedEntries = [];

        for (var item in data.reversed) {
          String result = item["result"].toString();
          String rawTime = item["time"];
          DateTime parsedTime = DateTime.parse(rawTime).toLocal();

          String formattedTime =
  "${parsedTime.year}, "
  "${_monthName(parsedTime.month)} ${parsedTime.day}, "
  "${_formatHour(parsedTime.hour)}:"
  "${parsedTime.minute.toString().padLeft(2, '0')}:"
  "${parsedTime.second.toString().padLeft(2, '0')} "
  "${parsedTime.hour >= 12 ? 'PM' : 'AM'}";


          loadedEntries.add({
            "result": result,
            "time": formattedTime,
          });
        }

        setState(() {
          entries = loadedEntries;
          loading = false;
        });
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        loading = false;
      });
    }
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  String _formatHour(int hour) {
    int h = hour % 12;
    return (h == 0 ? 12 : h).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Result History"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? const Center(child: Text("No data found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final item = entries[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.analytics),
                        title: Text("Result: ${item["result"]}"),
                        subtitle: Text("Time: ${item["time"]}"),
                      ),
                    );
                  },
                ),
    );
  }
}
