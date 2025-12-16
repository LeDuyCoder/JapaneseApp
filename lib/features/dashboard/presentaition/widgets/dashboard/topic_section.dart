import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/dashboard/bloc/tabhome_bloc.dart';
import 'package:japaneseapp/features/dashboard/bloc/tabhome_event.dart';
import 'package:japaneseapp/features/dashboard/bloc/tabhome_state.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/topic_widget.dart';

class TopicSection extends StatelessWidget{
  final BuildContext contextDashboard;
  final List<Map<String, dynamic>> data;

  const TopicSection({super.key, required this.data, required this.contextDashboard});

  @override
  Widget build(BuildContext context) {
    print(data);

    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:  data.isNotEmpty
              ? Column(
              children: [
                for (Map<String, dynamic> topicLocal in data)
                  TopicWidget(
                    id: topicLocal["id"],
                    nameTopic: topicLocal["name"],
                    owner: topicLocal["user"],
                    reloadDashBoard: () {
                      contextDashboard.read<TabHomeBloc>().add(FetchTabHomeData());
                    },
                  ),
              ]
          )
              : Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.grey,
                      blurRadius: 10,
                      offset: Offset(0, -2)
                  )
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.topic, size: 48, color: Colors.grey.shade600),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.dashboard_topic_nodata_title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.dashboard_topic_nodata_content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          )
      ),
    );
  }

}