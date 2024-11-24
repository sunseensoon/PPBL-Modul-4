import 'package:flutter/material.dart';
import 'models/user.dart';
import 'sqlite_service.dart';
import 'edit_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saham Database',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Saham Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await addSampleData();
      setState(() {});
    });
  }

  Future<void> addSampleData() async {
    List<Saham> listOfSaham = [
      Saham(ticker: "AAPL", open: 150, high: 155, last: 153, change: 2.0),
      Saham(ticker: "GOOG", open: 2800, high: 2900, last: 2850, change: 1.8),
      Saham(ticker: "AMZN", open: 3500, high: 3600, last: 3550, change: -0.2),
    ];

    for (var saham in listOfSaham) {
      await handler.insertSaham(saham);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void addNewSaham() {
    showDialog(
      context: context,
      builder: (context) {
        final tickerController = TextEditingController();
        final openController = TextEditingController();
        final highController = TextEditingController();
        final lastController = TextEditingController();
        final changeController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Saham Baru'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: tickerController,
                  decoration: const InputDecoration(labelText: 'Ticker'),
                ),
                TextField(
                  controller: openController,
                  decoration: const InputDecoration(labelText: 'Open'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: highController,
                  decoration: const InputDecoration(labelText: 'High'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: lastController,
                  decoration: const InputDecoration(labelText: 'Last'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: changeController,
                  decoration: const InputDecoration(labelText: 'Change'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Saham newSaham = Saham(
                  ticker: tickerController.text,
                  open: (double.tryParse(openController.text) ?? 0).toInt(),
                  high: (double.tryParse(highController.text) ?? 0).toInt(),
                  last: (double.tryParse(lastController.text) ?? 0).toInt(),
                  change: double.tryParse(changeController.text) ?? 0,
                );
                await handler.insertSaham(newSaham);
                showSnackbar('Data saham berhasil disimpan');
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void deleteSahamById(int id) async {
    await handler.deleteSaham(id);
    showSnackbar('Data saham berhasil dihapus');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: handler.retrieveSaham(),
        builder: (BuildContext context, AsyncSnapshot<List<Saham>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                final saham = snapshot.data![index];
                return Dismissible(
                  key: ValueKey<int>(saham.tickerId ?? -1),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  onDismissed: (direction) async {
                    if (saham.tickerId != null) {
                      deleteSahamById(saham.tickerId!);
                    }
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(saham.ticker),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Open: ${saham.open}'),
                          Text('High: ${saham.high}'),
                          Text('Last: ${saham.last}'),
                          Text(
                            'Change: ${saham.change}',
                            style: TextStyle(
                              color:
                                  saham.change < 0 ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(saham: saham),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewSaham,
        child: const Icon(Icons.add),
      ),
    );
  }
}
