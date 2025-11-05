import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Screen/addWordScreen.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';

class AddTopicDialog extends StatefulWidget {
  final TextEditingController nameTopicInput;
  final TextEditingController nameFolderInput;

  AddTopicDialog({super.key})
      : nameTopicInput = TextEditingController(),
        nameFolderInput = TextEditingController();

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isLoading = false;
  String? textErrorName;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCancel() {
    setState(() {
      textErrorName = null;
      widget.nameFolderInput.clear();
    });
    Navigator.pop(context);
  }

  Future<void> _handleCreate() async {
    setState(() => isLoading = true);

    if (await LocalDbService.instance.topicDao
        .hasTopicName(widget.nameTopicInput.text)) {
      setState(() {
        textErrorName = AppLocalizations.of(context)!.popup_add_topic_exit;
        isLoading = false;
      });
      return;
    }

    final nameTopic = widget.nameTopicInput.text;
    widget.nameFolderInput.clear();

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => addWordScreen(
          topicName: nameTopic,
          setIsLoad: () => setState(() => isLoading = false),
          reload: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: AppColors.primary, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.popup_add_topic,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 100,
                    child: TextField(
                      onChanged: (String value){
                        if(textErrorName != ""){
                          setState(() {
                            textErrorName = "";
                          });
                        }
                      },
                      controller: widget.nameTopicInput,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .popup_add_topic_hint,
                        hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 18.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFC1C1C1), width: 2.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFC1C1C1), width: 2.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorText: textErrorName,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _handleCancel,
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: Text(
                          AppLocalizations.of(context)!
                              .popup_add_topic_btn_cancle,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _handleCreate,
                        icon: const Icon(Icons.check_circle,
                            color: Colors.white),
                        label: Text(
                          AppLocalizations.of(context)!
                              .popup_add_topic_btn_create,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}