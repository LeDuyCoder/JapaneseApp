import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/manager_topic/bloc/event/add_topic_event.dart';
import 'package:japaneseapp/features/manager_topic/bloc/state/add_topic_state.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/manager_topic/domain/repositories/folder_repository.dart';

class AddTopicBloc extends Bloc<AddTopicEvent, AddTopicState>{
  final FolderRepository repository;

  AddTopicBloc({required this.repository}) : super(AddTopicInitial()) {
    on<LoadAllTopics>(_onLoadTopic);
    on<AddTopic>(_addTopic);
    on<RemoveTopic>(_removeTopic);
  }

  Future<void> _onLoadTopic(LoadAllTopics event, Emitter emit) async {
    emit(AddTopicLoading());

    List<TopicEntity> datas = await repository.getAllTopics();
    List<TopicEntity> dataInFolder = await repository.getTopics(event.folderId);
    List<TopicEntity> dataOutFolder = [];
    for (var topic in datas) {
      if (!dataInFolder.contains(topic)) {
        dataOutFolder.add(topic);
      }
    }
    
    emit(LoadAllTopicsSuccess(dataInFolder, dataOutFolder));
  }

  Future<void> _addTopic(AddTopic event, Emitter emit) async {
    await repository.addTopicToFolder(event.folderId, event.topicId);
    List<TopicEntity> datas = await repository.getAllTopics();
    List<TopicEntity> dataInFolder = await repository.getTopics(event.folderId);
    List<TopicEntity> dataOutFolder = [];
    for (var topic in datas) {
      if (!dataInFolder.contains(topic)) {
        dataOutFolder.add(topic);
      }
    }

    emit(LoadAllTopicsSuccess(dataInFolder, dataOutFolder));
  }

  Future<void> _removeTopic(RemoveTopic event, Emitter emit) async {
    await repository.removeTopic(event.folderId, event.topicId);
    List<TopicEntity> datas = await repository.getAllTopics();
    List<TopicEntity> dataInFolder = await repository.getTopics(event.folderId);
    List<TopicEntity> dataOutFolder = [];
    for (var topic in datas) {
      if (!dataInFolder.contains(topic)) {
        dataOutFolder.add(topic);
      }
    }

    emit(LoadAllTopicsSuccess(dataInFolder, dataOutFolder));
  }
}