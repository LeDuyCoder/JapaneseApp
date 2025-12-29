import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/topicdetail/presentation/widgets/delete_dialog_widget.dart';

class MenuDialogWidget extends StatelessWidget{
  final String topicId;
  final String topicName;
  final int amountWord;

  const MenuDialogWidget({super.key, required this.topicName, required this.amountWord, required this.topicId});



  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.18),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.share, color: Colors.blueAccent, size: 44),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.listWord_share_title(topicName),
                  style: TextStyle(
                    fontFamily: "Itim",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.listWord_share_amount_word("$amountWord"),
                  style: TextStyle(
                    fontFamily: "Itim",
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: (){
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteDialogWidget(nameTopic: topicName, idTopic: topicId,);
                            },
                          );
                          
                        },
                        icon: Icon(Icons.delete_outline, color: Colors.white),
                        label: Text(
                          AppLocalizations.of(context)!.listWord_btn_remove,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "Itim",
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.red, width: 2),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}