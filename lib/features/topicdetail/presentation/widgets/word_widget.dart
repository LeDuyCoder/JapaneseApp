import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';
import 'package:japaneseapp/features/topicdetail/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/flash_card_widget.dart';


class WordWidget extends StatelessWidget{
  final List<WordModel> wordEntitys;
  final String topicName;
  final void Function() reloadScreenListWord;

  const WordWidget({super.key, required this.wordEntitys, required this.topicName, required this.reloadScreenListWord});

  void showFlashCardDialog(BuildContext context, WordEntity wordEntity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: FlashCardWidget(wordEntity: wordEntity,),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: const TableBorder(
            horizontalInside: BorderSide(width: 1, color: Colors.grey), // gạch ngang giữa các hàng
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.8), // cột 1 rộng hơn
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    AppLocalizations.of(context)!.listword_Screen_head_col1,
                    style: TextStyle(
                      color: AppColors.textSecond.withOpacity(0.5),
                      fontSize: 18,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    AppLocalizations.of(context)!.listword_Screen_head_col2,
                    style: TextStyle(
                      color: AppColors.textSecond.withOpacity(0.5),
                      fontSize: 18,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.listword_Screen_head_col3,
                      style: TextStyle(
                        color: AppColors.textSecond.withOpacity(0.5),
                        fontSize: 18,
                        fontFamily: "Itim",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Body
            for (WordModel wordItem in wordEntitys)
              TableRow(
                children: [
                  InkWell(
                    onTap: () {
                      showFlashCardDialog(context, wordItem);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${wordItem.word}",
                            style: const TextStyle(
                              color: AppColors.textSecond,
                              fontSize: 18,
                              fontFamily: "Itim",
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "${wordItem.wayread}",
                            style: const TextStyle(
                              color: AppColors.textSecond,
                              fontSize: 18,
                              fontFamily: "Itim",
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      showFlashCardDialog(context, wordItem);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        wordItem.mean,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 18,
                          fontFamily: "Itim",
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      showFlashCardDialog(context, wordItem);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: (wordItem.level / 2) >= 100.0
                          ? Text(
                        AppLocalizations.of(context)!.listword_Screen_Learned,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSucessState),
                      )
                          : Text(
                        "${(wordItem.level / 2)}%",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecond,
                          fontSize: 18,
                          fontFamily: "Itim",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        )

      ],
    );
  }

}