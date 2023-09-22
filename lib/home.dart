import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detailTodo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final body = _bodyController.text;
      final days = int.parse(_daysController.text);

      await supabase.from('dummy').insert({
        'title': title,
        'body': body,
        'days': days
      });

      // After successfully adding data, clear text controllers.
      _titleController.clear();
      _bodyController.clear();
      _daysController.clear();

      fetchData();
    }
  }

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

  // show modal
  Future<void> _showModal() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Data'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _bodyController,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'Body'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Body tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _daysController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Days'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Days tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Days harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog jika dibatalkan
                        },
                        child: Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitForm();
                          Navigator.of(context).pop(); // Tutup dialog setelah mengirim data
                        },
                        child: Text('Tambah'),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Delete Data
  Future<void> _deleteData(int index) async {
    final item = data[index];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Data'),
          content: Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Hapus data dari Supabase
                await supabase
                    .from('dummy')
                    .delete()
                    .eq('id', item['id'])
                    .execute();

                // Hapus item dari daftar data lokal
                setState(() {
                  data.removeAt(index);
                });

                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Update Data
  Future<void> _updateData(int index) async {
    final item = data[index];

    // Tampilkan dialog untuk mengedit data
    await showDialog(
      context: context,
      builder: (context) {
        final _editFormKey = GlobalKey<FormState>();
        final TextEditingController _editTitleController =
            TextEditingController(text: item['title']);
        final TextEditingController _editBodyController =
            TextEditingController(text: item['body']);
        final TextEditingController _editDaysController =
            TextEditingController(text: item['days'].toString());

        return AlertDialog(
          title: Text('Edit Data'),
          content: SingleChildScrollView(
            child: Form(
              key: _editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _editTitleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _editBodyController,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'Body'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Body tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _editDaysController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Days'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Days tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Days harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog jika dibatalkan
                        },
                        child: Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_editFormKey.currentState!.validate()) {
                            // Update data di Supabase
                            final updatedTitle = _editTitleController.text;
                            final updatedBody = _editBodyController.text;
                            final updatedDays =
                                int.parse(_editDaysController.text);

                            final response = await supabase
                                .from('dummy')
                                .update({
                                  'title': updatedTitle,
                                  'body': updatedBody,
                                  'days': updatedDays,
                                })
                                .eq('id', item['id'])
                                .execute();

                            if (response.status == 200) {
                              // Update item di daftar data lokal
                              setState(() {
                                item['title'] = updatedTitle;
                                item['body'] = updatedBody;
                                item['days'] = updatedDays;
                              });

                              Navigator.of(context).pop(); // Tutup dialog setelah mengirim data
                            } else {
                              print(response);
                            }
                          }
                        },
                        child: Text('Simpan'),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ini adalah halaman utama'),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator(),
            if (!isLoading && data.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${item['title']}'),
                          SizedBox(height: 8),
                          Text(
                            'Body: ${item['body'].length > 100 ? item['body'].substring(0, 80) + "..." : item['body']}',
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 8),
                          Text('Days: ${item['days']}'),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteData(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _updateData(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (!isLoading && data.isEmpty)
              Text('Belum ada data dari Supabase'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModal,
        child: Icon(Icons.add, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
