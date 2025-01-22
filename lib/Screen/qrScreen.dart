import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class qrScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<qrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? result;
  QRViewController? controller;
  bool isScanned = true;
  final ImagePicker _picker = ImagePicker();
  XFile? _image; // Biến lưu trữ ảnh đã chọn

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  // Hàm để chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    // Mở trình chọn ảnh từ thư viện
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // Nếu ảnh được chọn, cập nhật ảnh
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      await _scanQRFromImage(_image!);

    }
  }

  Future<Uint8List?> handleImage() async {
    // Yêu cầu quyền truy cập thư viện
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      print("demoTest2");
      // Lấy tất cả các album
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true, // Chỉ lấy album chính
      );

      if (albums.isNotEmpty) {
        print("demoTest3");
        // Lấy danh sách ảnh trong album đầu tiên (1 ảnh)
        List<AssetEntity> assets = await albums.first.getAssetListPaged(
          page: 0, // Trang đầu tiên
          size: 1, // Chỉ lấy 1 ảnh
        );

        if (assets.isNotEmpty) {
          print("demoTest4");
          // Lấy dữ liệu ảnh dạng Uint8List
          return await assets.first.thumbnailDataWithSize(ThumbnailSize(200, 200)); // 200x200 là kích thước thumbnail
        }
      }
    } else {
      PhotoManager.openSetting();
    }

    // Trả về null nếu không có ảnh
    return null;
  }


  Widget _buildCornerDecoration(Alignment alignment) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: CornerPainter(alignment),
      ),
    );
  }

  void showDialogSuccessSaveData(){
    isScanned = true;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Successfully Save ✔️',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Save data vocabulay success',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(184, 241, 176, 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
      },
    );
  }

  void showDialogErrorSaveData(){
    isScanned = true;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.red, // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Successfully Failse ❌',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                          child: Text(
                            'Save data vocabulay failed becausse it is created',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState((){
                                    isScanned = true;
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "ok",
                                        style: TextStyle(color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
      },
    );
  }

  void showDialogDataFromQR(Map<String, dynamic> data){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text("List Word Shared", style: TextStyle(fontFamily: "indieflower", fontSize: 25)),
                        ),
                        Row(
                          children: [
                            const Text("Device's Name: ", style: TextStyle(fontFamily: "indieflower"),),
                            Text((data["id"] as String).split("-").last, style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Amount word: ", style: TextStyle(fontFamily: "indieflower"),),
                            Text("${(data["listWords"] as List<dynamic>).length} Words", style: TextStyle(fontFamily: "indieflower", fontWeight: FontWeight.bold),)
                          ],
                        ),
                        const SizedBox(height: 10,),
                        const Text("Do You Add List Word ?", style: TextStyle(fontFamily: "indieflower"),),
                        const SizedBox(height: 20,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width*0.3,
                                height: MediaQuery.sizeOf(context).height*0.05,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                    ]
                                ),
                                child: Center(
                                  child: Text("CANCLE", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            SizedBox(width:10,),
                            GestureDetector(
                              onTap: () async {
                                DatabaseHelper db = DatabaseHelper.instance;
                                String nameTopic = "${data["name"]} - ${(data["id"] as String).split("-").last}";

                                if(!(await db.hasTopicName(nameTopic))) {
                                  await db.insertTopic(nameTopic);

                                  List<dynamic> listWords = data["listWords"];
                                  List<Map<String, dynamic>> dataInsert = [];
                                  for (dynamic data in listWords) {
                                    dataInsert.add(
                                        word(data["word"], data["wayread"],
                                            data["mean"], nameTopic, 0).toMap()
                                    );
                                  }
                                  await db.insertDataTopic(dataInsert);
                                  showDialogSuccessSaveData();
                                }else{
                                  showDialogErrorSaveData();
                                }
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width*0.3,
                                height: MediaQuery.sizeOf(context).height*0.05,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(97, 213, 88, 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.green,
                                          offset: Offset(6, 6)
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Text("CONFIRM", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                            SizedBox(width:10,),
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              onPressed: () {
                print("Button pressed");
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // 4 Corner Borders
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.1,
            child: _buildCornerDecoration(Alignment.topLeft),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            right: MediaQuery.of(context).size.width * 0.1,
            child: _buildCornerDecoration(Alignment.topRight),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.1,
            child: _buildCornerDecoration(Alignment.bottomLeft),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            right: MediaQuery.of(context).size.width * 0.1,
            child: _buildCornerDecoration(Alignment.bottomRight),
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              child: FutureBuilder(future: handleImage(), builder: (ctx, snapshot){
                if(snapshot.hasData){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: (){
                        _pickImage();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.grey
                            )
                        ),
                        child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                      ),
                    ); // Hiển thị ảnh từ Uint8List
                  } else {
                    return Text("Không thể tải ảnh.");
                  }
                }
                return const Center();
              })

          ),
        ],
      )
    );
  }

  // Quét QR code từ hình ảnh
  Future<void> _scanQRFromImage(XFile imageFile) async {
    try {
      // Chuyển đổi XFile thành File
      final File image = File(imageFile.path);

      // Đọc ảnh và quét QR code
      final result = await _scanQRCodeFromFile(image);

      if (result != null) {
        // Hiển thị kết quả quét

        Map<String, dynamic> dataQr = jsonDecode(
            gzipDecompress(result));
        if (dataQr.containsKey("id")) {
          showDialogDataFromQR(dataQr);
        }

        print(dataQr);
      }
    } catch (e) {
      print("Error scanning QR code from image: $e");
    }
  }

  // Hàm quét QR code từ ảnh
  Future<String?> _scanQRCodeFromFile(File image) async {
    try {
      // Khởi tạo quét QR
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner();

      // Quét QR từ ảnh
      final barcodes = await barcodeScanner.processImage(inputImage);

      // Lấy kết quả nếu có mã QR
      if (barcodes.isNotEmpty) {
        return barcodes.first.displayValue;
      } else {
        return null; // Không tìm thấy mã QR
      }
    } catch (e) {
      print("Error scanning QR code: $e");
      return null;
    }
  }
  
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(isScanned) {
        if (scanData.code != null) {

          Map<String, dynamic> dataQr = jsonDecode(
              gzipDecompress(scanData.code!));
          if (dataQr.containsKey("id")) {
            isScanned = false;
            showDialogDataFromQR(dataQr);
          }else{}
        }
      }
    });
  }

  String gzipDecompress(String compressedData) {
    List<int> compressedBytes = base64.decode(compressedData);
    List<int> decompressedBytes = const GZipDecoder().decodeBytes(compressedBytes);
    return utf8.decode(decompressedBytes);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class CornerPainter extends CustomPainter {
  final Alignment alignment;

  CornerPainter(this.alignment);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw top-left, top-right, bottom-left, bottom-right
    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height * 0.3);
      path.lineTo(0, 0);
      path.lineTo(size.width * 0.3, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width, size.height * 0.3);
      path.lineTo(size.width, 0);
      path.lineTo(size.width * 0.7, 0);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, size.height * 0.7);
      path.lineTo(0, size.height);
      path.lineTo(size.width * 0.3, size.height);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width, size.height * 0.7);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width * 0.7, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
