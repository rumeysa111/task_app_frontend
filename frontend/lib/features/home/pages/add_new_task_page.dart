// Gerekli kütüphaneler ve dosyalar import ediliyor.
import 'package:flex_color_picker/flex_color_picker.dart'; // Renk seçici widget'ı için.
import 'package:flutter/material.dart'; // Flutter'ın temel UI bileşenleri.
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc ve Cubit durum yönetimi için.
import 'package:intl/intl.dart'; // Tarih biçimlendirme işlemleri için.
import 'package:task_app/features/auth/cubit/auth_cubit.dart'; // Kullanıcı yetkilendirme için AuthCubit.
import 'package:task_app/features/home/cubit/task_cubit.dart';
import 'package:task_app/features/home/pages/home_page.dart'; // Görev ekleme işlemi için AddNewTaskCubit.

/// Bu sınıf yeni bir görev eklemek için bir sayfa oluşturuyor.
/// StatefulWidget kullanılarak durum değişiklikleri yönetiliyor.
class AddNewTaskPage extends StatefulWidget {
  // Sayfa oluşturmak için bir statik metod tanımlanıyor.
  // Bu metodla başka yerden bu sayfa kolayca çağrılabilir.
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const AddNewTaskPage());

  // Yapıcı metot.
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

// Sayfanın durumunu (state) yöneten sınıf.
class _AddNewTaskPageState extends State<AddNewTaskPage> {
  // Form alanları için kontrolörler tanımlanıyor.
  TextEditingController titleController = TextEditingController(); // Başlık.
  TextEditingController descriptionController =
      TextEditingController(); // Açıklama.

  // Başlangıç değerleri atanıyor.
  DateTime selectedDate = DateTime.now(); // Varsayılan tarih (bugün).
  Color selectedColor =
      const Color.fromRGBO(246, 222, 194, 1); // Varsayılan renk.
  final formKey = GlobalKey<FormState>(); // Form doğrulama anahtarı.

  // Yeni bir görev oluşturma fonksiyonu.
  void createNewTask() async {
    // Form validasyonunu kontrol et.
    if (formKey.currentState!.validate()) {
      // Kullanıcı bilgilerini AuthCubit'ten al.
      AuthLoggedIn user = context.read<AuthCubit>().state as AuthLoggedIn;

      // Görev oluşturmak için AddNewTaskCubit çağrılıyor.
      await context.read<TaskCubit>().createNewTask(
            uid:user.user.id ,
            title: titleController.text.trim(), // Başlık.
            description: descriptionController.text.trim(), // Açıklama.
            color: selectedColor, // Renk.
            token: user.user.token, // Kullanıcı kimliği.
            dueAt: selectedDate, // Son tarih.
          );
    }
  }
  @override
  void dispose() {
    // TODO: implement Dispose(),
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfanın üst kısmında bir AppBar var.
      appBar: AppBar(
        title: const Text("Add new task :)"), // Sayfa başlığı.
        actions: [
          // Tarih seçmek için bir buton.
          GestureDetector(
            onTap: () async {
              // Tarih seçici dialog'u açılıyor.
              final _selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(), // Bugünden önceki tarih seçilemez.
                lastDate: DateTime.now()
                    .add(const Duration(days: 90)), // 90 gün sonrası.
              );
              if (_selectedDate != null) {
                setState(() {
                  selectedDate = _selectedDate; // Seçilen tarih atanıyor.
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // Seçili tarihi göster.
              child: Text(DateFormat("MM-d-y").format(selectedDate)),
            ),
          ),
        ],
      ),

      // Sayfanın gövdesi.
      body: BlocConsumer<TaskCubit, TasksState>(
        listener: (context, state) {
          if(state is TasksError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }

          else if (state is AddNewTaskSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Task added successfully")),
            );
            Navigator.pushAndRemoveUntil(context,HomePage.route(),(_)=>false);
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(
                20.0), // Ekranın içeriği çevresindeki boşluk.
            child: Form(
              key: formKey, // Form anahtarı atanıyor.
              child: Column(
                children: [
                  // Başlık için bir TextFormField.
                  TextFormField(
                    controller: titleController, // Kontrolör atanıyor.
                    decoration:
                        InputDecoration(hintText: "Title"), // İpucu metni.
                    validator: (value) {
                      // Boş bırakılırsa hata mesajı göster.
                      if (value == null || value.trim().isEmpty) {
                        return "Title cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10), // Alanlar arasında boşluk.

                  // Açıklama için bir TextFormField.
                  TextFormField(
                    controller: descriptionController, // Kontrolör atanıyor.
                    decoration: InputDecoration(hintText: "Description"),
                    maxLines: 4, // Çok satırlı metin kutusu.
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Renk seçici.
                  ColorPicker(
                    heading: const Text("Select Color"), // Başlık.
                    subheading:
                        const Text("Select a different shade"), // Alt başlık.
                    onColorChanged: (Color color) {
                      setState(() {
                        selectedColor = color; // Seçilen rengi güncelle.
                      });
                    },
                    pickersEnabled: const {
                      ColorPickerType.wheel:
                          true, // Sadece renk çarkını etkinleştir.
                    },
                    color: selectedColor, // Varsayılan renk.
                  ),
                  const SizedBox(height: 10),

                  // Görev ekleme butonu.
                  ElevatedButton(
                    onPressed:  
                      createNewTask, // Görev ekleme fonksiyonunu çağır.
                    
                    child: Text(
                      "Submit", // Buton yazısı.
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
