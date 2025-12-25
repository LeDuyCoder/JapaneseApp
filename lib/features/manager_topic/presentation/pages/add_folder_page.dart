import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/manager_topic/bloc/add_folder_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/add_folder_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/add_folder_state.dart';
import 'package:japaneseapp/features/manager_topic/data/repositories/folder_repository_impl.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/bottom_sheet_success_widget.dart';

class AddFolderPage extends StatefulWidget{
  const AddFolderPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddFolderPageState();
}

class _AddFolderPageState extends State<AddFolderPage>{
  final db = LocalDbService.instance;
  final TextEditingController nameFolderInput = TextEditingController();
  String? textErrorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (_) => AddFolderBloc(
                repository: FolderRepositoryImpl(db)
            ),
            child: BlocConsumer<AddFolderBloc, AddFolderState>(
                builder: (context, state) {
                  return Scaffold(
                      appBar: AppBar(
                        title: const Text("Tạo Thư Mục"),
                        leading: IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close, size: 40,)),
                        actions: [
                          IconButton(
                            icon: Icon(Icons.done, size: 40, color: AppColors.primary,),
                            onPressed: () async {
                              if(nameFolderInput.text.isEmpty){
                                setState(() {
                                  textErrorName = "Vui lòng nhập tên thư mục";
                                });
                                return;
                              }else{
                                context.read<AddFolderBloc>().add(AddFolder(nameFolderInput.text));
                              }
                            },
                          ),
                        ],
                        centerTitle: true,
                      ),
                      body: Container(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Image.asset("assets/character/hinh15.png", width: 200,),
                            SizedBox(height: 10,),
                            Container(
                              width: 250,
                              child: TextField(
                                controller: nameFolderInput,
                                decoration: InputDecoration(
                                  labelText: "Tên Thư Mục",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.red, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.blue, width: 1),
                                  ),
                                  errorText: textErrorName,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  );
                },
                listener: (context, state){
                  if(state is AddFolderAlready){
                    setState(() {
                      textErrorName = "Tên thư mục đã tồn tại";
                    });
                  }

                  if(state is AddFolderSuccess){
                    showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        builder: (context){
                          return const BottomSheetSuccessWidget();
                        }
                    );
                  }
                }
            )
        )
    );
  }


}