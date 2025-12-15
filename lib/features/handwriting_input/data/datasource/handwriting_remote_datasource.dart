import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HandwritingRemoteDataSource {
  Future<List<String>> sendHandwriting(
      List<List<Offset>> strokes,
      ) async {
    final ink = strokes.map((stroke) {
      return [
        stroke.map((p) => p.dx.round()).toList(),
        stroke.map((p) => p.dy.round()).toList(),
      ];
    }).toList();

    final response = await http.post(
      Uri.parse(
        'https://inputtools.google.com/request'
            '?itc=ja-t-i0-handwrit&app=translate',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "input_type": 0,
        "requests": [
          {
            "writing_guide": {
              "writing_area_width": 400,
              "writing_area_height": 400
            },
            "ink": ink,
            "language": "ja"
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Handwriting error');
    }

    final data = jsonDecode(response.body);
    return List<String>.from(data[1][0][1]);
  }
}
