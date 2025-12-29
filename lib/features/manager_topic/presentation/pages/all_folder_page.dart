import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/manager_topic/bloc/bloc/folder_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/event/folder_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/state/folder_state.dart';
import 'package:japaneseapp/features/manager_topic/data/repositories/folder_repository_impl.dart';
import 'package:japaneseapp/features/manager_topic/presentation/cubit/all_folder_cubit.dart';
import 'package:japaneseapp/features/manager_topic/presentation/cubit/all_folder_state.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/box_folder_grid_widget.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/box_folder_list_widget.dart';
import 'package:japaneseapp/features/manager_topic/presentation/widgets/loading_widget.dart';

class AllFolderPage extends StatelessWidget {
  final db = LocalDbService.instance;

  AllFolderPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider<FolderBloc>(
        create: (_) => FolderBloc(repository: FolderRepositoryImpl(db))..add(FolderInitialEvent()),
        child: BlocConsumer<FolderBloc, FolderState>(
            builder: (context, state){
              if(state is FolderLoading){
                return const Scaffold(
                  body: LoadingWidget(),
                );
              }

              if(state is FolderLoaded){
                return Scaffold(
                  appBar: const CupertinoNavigationBar(
                    backgroundColor: Colors.white,
                    middle: Text('Thư Mục Của Tôi', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),),
                  ),
                  body: BlocProvider<AllFolderCubit>(
                    create: (_) => AllFolderCubit(),
                    child: BlocBuilder<AllFolderCubit, AllFolderState>(
                      builder: (context, stateCubit) {
                        return Container(
                          color: Colors.white,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<AllFolderCubit>().changeShowedType(AllFolderShowedType.list);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      width: 120,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: stateCubit.showedType == AllFolderShowedType.list
                                            ? AppColors.primary
                                            : AppColors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.folderSeemore_tag_flex,
                                          style: TextStyle(
                                            color: stateCubit.showedType == AllFolderShowedType.list
                                                ? AppColors.white
                                                : AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<AllFolderCubit>().changeShowedType(AllFolderShowedType.grid);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      width: 120,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: stateCubit.showedType == AllFolderShowedType.grid
                                            ? AppColors.primary
                                            : AppColors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.folderSeemore_grid,
                                          style: TextStyle(
                                            color: stateCubit.showedType == AllFolderShowedType.grid
                                                ? AppColors.white
                                                : AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 15),
                                      Text(
                                        AppLocalizations.of(context)!.folderSeemore_content,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${state.folders.length} ${AppLocalizations.of(context)!.folderSeemore_subContent}",
                                        style: const TextStyle(color: AppColors.textSecond),
                                      ),
                                      const SizedBox(width: 15),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Expanded(
                                child: stateCubit.showedType == AllFolderShowedType.list
                                    ? ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  itemCount: state.folders.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (_, index) =>
                                      BoxFolderListWidget(folderEntity: state.folders[index]),
                                )
                                    : GridView.count(
                                  padding: const EdgeInsets.all(16),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 14,
                                  children: [
                                    for (var folder in state.folders)
                                      BoxFolderGridWidget(folderEntity: folder),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    )
                  ),
                );
              }

              return Container();
            },
            listener: (context, state){

            }
        ),
    );
  }

}