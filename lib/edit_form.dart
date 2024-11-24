import 'package:flutter/material.dart';
import 'models/user.dart';

class EditPage extends StatelessWidget {
  final Saham saham;
  EditPage({super.key, required this.saham});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit data Saham: ${saham.ticker}'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: saham.ticker,
              decoration: InputDecoration(labelText: 'Ticker'),
              style: TextStyle(fontSize: 22.0),
            ),
            TextFormField(
              initialValue: saham.open.toString(),
              decoration: InputDecoration(labelText: 'Open'),
              style: TextStyle(fontSize: 22.0),
            ),
            TextFormField(
              initialValue: saham.high.toString(),
              decoration: InputDecoration(labelText: 'High'),
              style: TextStyle(fontSize: 22.0),
            ),
            TextFormField(
              initialValue: saham.last.toString(),
              decoration: InputDecoration(labelText: 'Last'),
              style: TextStyle(fontSize: 22.0),
            ),
            TextFormField(
              initialValue: saham.change.toString(),
              decoration: InputDecoration(labelText: 'Change'),
              style: TextStyle(fontSize: 22.0),
            ),
            ElevatedButton(
              onPressed: () {
                // Save or update functionality here
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
