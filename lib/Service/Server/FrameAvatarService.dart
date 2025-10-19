import 'dart:collection';

import 'package:japaneseapp/DTO/FrameDTO.dart';
import 'package:japaneseapp/Service/Local/local_db_service.dart';

import '../../Utilities/WeekUtils.dart';
import '../BaseService.dart';

class FrameAvatarService extends BaseService {

  /// Get user score for a period
  Future<List<FrameDTO>> getAllFrame() async {
    final data = await get('/controller/Items/frame/getAllFrame.php');

    if (data is Map<String, dynamic>) {
      if (data.containsKey("error")) {
        return [];
      } else {
        List<FrameDTO> listFrames = [];
        LocalDbService localDbService = LocalDbService.instance;
        for(dynamic frame in data["data"]){
          FrameDTO frameDTO = FrameDTO.fromJson(frame);
          frameDTO.isHaving = await localDbService.userItemsDao.isItemExists(frameDTO.idAvatarFrame);
          listFrames.add(frameDTO);
        }

        return listFrames;
      }
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }

  Future<List<FrameDTO>> getAllAvatar() async {
    final data = await get('/controller/Items/avatar/getAllAvatar.php');

    if (data is Map<String, dynamic>) {
      if (data.containsKey("error")) {
        return [];
      } else {
        List<FrameDTO> listFrames = [];
        LocalDbService localDbService = LocalDbService.instance;
        for(dynamic frame in data["data"]){
          FrameDTO frameDTO = FrameDTO.fromJson(frame);
          frameDTO.isHaving = await localDbService.userItemsDao.isItemExists(frameDTO.idAvatarFrame);
          listFrames.add(frameDTO);
        }

        return listFrames;
      }
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }
}