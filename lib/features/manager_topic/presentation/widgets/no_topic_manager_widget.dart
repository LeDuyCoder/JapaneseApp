import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/manager_topic/presentation/pages/add_topic_page.dart';

class NoTopicManagerWidget extends StatelessWidget {
  final int folderId;
  final void Function()? reloadPage;

  const NoTopicManagerWidget({super.key, required this.folderId, this.reloadPage});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width - 50,
              height: 380,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(221, 221, 221, 0.4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/character/hinh14.png", width: 200,),
                  SizedBox(height: 10,),
                  Text(AppLocalizations.of(context)!.folderManager_nodata_title, style: TextStyle(fontSize: 20),),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTopicPage(folderId: folderId)));
                      if(reloadPage != null) {
                        reloadPage!();
                      }
                    },
                    child: Container(
                        width: 200,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.folderManager_nodata_button, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),),
                          ],
                        )
                    ),
                  )

                ],
              ),
            )
          ],
        )
    );
  }
}