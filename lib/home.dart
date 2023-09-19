import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    try {
      final response = await supabase.from('dummy').select();

      if (response != null && response.isNotEmpty) {
        final fetchedData = response as List<dynamic>;
        setState(() {
          data = fetchedData.cast<Map<String, dynamic>>().toList();
          isLoading = false;
        });
      } else {
        print('Tidak ada data yang ditemukan dari Supabase.');
        isLoading = false;
      }
    } catch (error) {
      print('Terjadi kesalahan saat mengambil data: $error');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ini adalah halaman utama'),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator(),
            if (!isLoading && data.isNotEmpty)
              Column(
                children: data.map((item) => Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${item['title']}'),
                        SizedBox(height: 8),
                        Text('Body: ${item['body']}'),
                        SizedBox(height: 8),
                        Text('Days: ${item['days']}'),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            if (!isLoading && data.isEmpty)
              Text('Belum ada data dari Supabase'),
          ],
        ),
      ),
    );
  }
}