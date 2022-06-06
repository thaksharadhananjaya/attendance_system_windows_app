// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:attended/bloc/guest_bloc.dart';
import 'package:attended/models/guest_model.dart';
import 'package:attended/util/comfirmDailogBox.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config.dart';
import '../util/decoration.dart';

class User extends StatefulWidget {
  const User({Key key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final GlobalKey<ScaffoldState> scfoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<GlobalKey> repaintKey = [];
  File imgFile;
  String base64Img;
  bool isLoading = false;
  GuestBloc guestBloc;
  int indexCategory = 0;
  String cusID;
  bool isSearch = false;
  String dropdownValue = 'All';
  @override
  void initState() {
    super.initState();

    guestBloc = GuestBloc(0, null);
    guestBloc.add(FetchGuest());
  }

  TextEditingController textEditingControllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scfoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [buildSearch(context), buildFiltter()],
          ),
          buidGuestList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: buildAddDialogBox,
        backgroundColor: primeryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox buildFiltter() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      height: 50,
      child: DropdownButtonFormField<String>(
        focusColor: Colors.transparent,
        value: dropdownValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black87)),
        ),
        items: <String>['All', 'Attended', 'Not Attended']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (text) {
          textEditingControllerSearch.clear();
          setState(() {
            dropdownValue = text;
            if (text == "All") {
              guestBloc = GuestBloc(0, null);
              guestBloc.add(FetchGuest());
            } else if (text == "Attended") {
              guestBloc = GuestBloc(1, null);
              guestBloc.add(FetchGuest());
            } else {
              print(text);
              guestBloc = GuestBloc(2, null);
              guestBloc.add(FetchGuest());
            }
          });
        },
      ),
    );
  }

  Container buildSearch(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 80,
      margin: const EdgeInsets.only(left: 16, top: 32, right: 24),
      child: TextFormField(
        controller: textEditingControllerSearch,
        autofocus: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z., 0-9]")),
        ],
        onFieldSubmitted: (text) {
          if (isSearch) {
            textEditingControllerSearch.clear();
            setState(() {
              isSearch = false;
              guestBloc = GuestBloc(0, null);
              guestBloc.add(FetchGuest());
            });
          } else {
            setState(() {
              if (textEditingControllerSearch.text.isNotEmpty) {
                isSearch = true;
                guestBloc = GuestBloc(0, textEditingControllerSearch.text);
                guestBloc.add(FetchGuest());
              }
            });
          }
        },
        decoration: InputDecoration(
            labelText: "Search",
            suffixIcon: IconButton(
                hoverColor: Colors.transparent,
                onPressed: () {
                  if (isSearch) {
                    textEditingControllerSearch.clear();
                    setState(() {
                      isSearch = false;
                      guestBloc = GuestBloc(0, null);
                      guestBloc.add(FetchGuest());
                    });
                  } else {
                    setState(() {
                      if (textEditingControllerSearch.text.isNotEmpty) {
                        isSearch = true;
                        guestBloc =
                            GuestBloc(0, textEditingControllerSearch.text);
                        guestBloc.add(FetchGuest());
                      }
                    });
                  }
                },
                icon: Icon(isSearch ? Icons.close : Icons.search)),
            counterText: "",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black87)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 8)),
        maxLength: 150,
      ),
    );
  }

  Future buildAddDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController textEditingControllerName =
              TextEditingController();
          TextEditingController textEditingControllerRegion =
              TextEditingController();
          TextEditingController textEditingControllerInv =
              TextEditingController();

          return Builder(builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add New Guest",
                      ),
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              imgFile = null;
                              base64Img = null;
                            },
                          ))
                    ],
                  ),
                  titlePadding:
                      const EdgeInsets.only(left: 16, top: 0, bottom: 6),
                  content: Form(
                    key: formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildForm(
                            textEditingControllerName,
                            textEditingControllerRegion,
                            textEditingControllerInv),
                        buildUserPhoto(setState)
                      ],
                    ),
                  ),
                  actions: [
                    SizedBox(
                      height: 40,
                      width: 100,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: primeryColor,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState.validate()) {
                                    addGuest(
                                        textEditingControllerName.text,
                                        textEditingControllerRegion.text,
                                        int.parse(
                                            textEditingControllerInv.text),
                                        context,
                                        setState);
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)))
                              : const Text(
                                  "Add",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                    )
                  ],
                );
              }),
            );
          });
        });
  }

  SizedBox buildForm(
    TextEditingController textEditingControllerName,
    TextEditingController textEditingControllerRegion,
    TextEditingController textEditingControllerInv,
  ) {
    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 80,
            child: TextFormField(
              controller: textEditingControllerName,
              autofocus: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z. ]")),
              ],
              validator: (text) {
                if (text.isEmpty) {
                  return 'Enter Name';
                }
                return null;
              },
              decoration: CustomDecoration.decoration('Name'),
              maxLength: 150,
            ),
          ),
          SizedBox(
            height: 80,
            child: TextFormField(
              controller: textEditingControllerInv,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              decoration: CustomDecoration.decoration('Invitaion No'),
              maxLength: 10,
            ),
          ),
          SizedBox(
            height: 80,
            child: TextFormField(
              controller: textEditingControllerRegion,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z. ]")),
              ],

              /* validator: (text) {
                              if (text!.isEmpty) {
                                return 'Enter Region';
                              }
                              return null;
                            }, */
              decoration: CustomDecoration.decoration('Region'),
              maxLength: 20,
            ),
          ),
        ],
      ),
    );
  }

  Container buildUserPhoto(StateSetter setState) {
    return Container(
      width: 200,
      height: 250,
      margin: const EdgeInsets.only(left: 32),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey,
          image: imgFile != null
              ? DecorationImage(image: FileImage(imgFile), fit: BoxFit.fill)
              : null),
      child: GestureDetector(
        onTap: () {
          getImage(setState);
        },
        child: Stack(
          children: [
            Visibility(
              visible: imgFile == null,
              child: const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 120,
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.grey[300]?.withOpacity(0.7)),
                  child: Text(
                    imgFile != null ? "Change Photo" : "Select Photo",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black54),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getImage(StateSetter setState) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg'],
        dialogTitle: "Attended System");

    if (result != null) {
      setState(() {
        imgFile = File(result.files.single.path);
        base64Img = base64Encode(imgFile.readAsBytesSync());
      });
    }
  }

  Widget buidGuestList() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height - 170,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder(
            bloc: guestBloc,
            builder: (context, state) {
              if (state is LoadedGuest) {
                return LazyLoadScrollView(
                  onEndOfPage: () => guestBloc.add(FetchGuest()),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.guestList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = state.guestList[index];
                      return buildCard(index, data);
                    },
                  ),
                );
              }
              int itmCount = height ~/ 100;
              return ListView.builder(
                  itemCount: itmCount,
                  padding: const EdgeInsets.only(top: 24),
                  itemBuilder: (context, index) {
                    return const CardLoading(
                      height: 80,
                      margin: EdgeInsets.all(8),
                      borderRadius: 15,
                    );
                  });
            }),
      ),
    );
  }

  Container buildCard(int index, Guest data) {
    repaintKey.add(GlobalKey());
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: index % 2 == 0
              ? ThemeData().primaryColor.withOpacity(0.27)
              : ThemeData().primaryColor.withOpacity(0.15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: data.image == 0
                        ? DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              "https://ajstyle.lk/attend/images/${data.id}.jpg",
                            ))
                        : null),
                child: Visibility(
                  visible: data.image == 1,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 120,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.id.toString().padLeft(6, '0'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(data.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(data.region,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  data.attendTime == null
                      ? const Text("Not Attend",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))
                      : Text(
                          "Attend On ${data.attendTime.toString()}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onTap: () => buildQRDialogBox(data.id, data.name, data.region),
                child: CircleAvatar(
                  backgroundColor: ThemeData().primaryColor,
                  foregroundColor: Colors.white,
                  radius: 28,
                  child: const Icon(
                    Icons.print,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onTap: null,
                child: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  radius: 28,
                  child: Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onTap: () {
                  buildDeleteBox(data);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  radius: 28,
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> buildDeleteBox(Guest data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => ComfirmDailogBox(
            yesButton: FlatButton(
                onPressed: () {
                  delete(data.id);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                )),
            icon: const Icon(
              Icons.delete,
              size: 40,
              color: Colors.white,
            )));
  }

  Future buildQRDialogBox(int id, String name, String region) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final GlobalKey repaintKey = GlobalKey();

          return Builder(builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Invitation QR",
                    ),
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ))
                  ],
                ),
                titlePadding:
                    const EdgeInsets.only(left: 16, top: 0, bottom: 6),
                content: SizedBox(
                  height: 300,
                  width: 300,
                  child: RepaintBoundary(
                    key: repaintKey,
                    child: QrImage(
                      data: id.toString(),
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                        onPressed: () async {
                          String path = await FilePicker.platform
                              .getDirectoryPath(dialogTitle: "Save QR Code");

                          if (path != null) {
                            try {
                              RenderRepaintBoundary boundary =
                                  repaintKey.currentContext.findRenderObject();
                              var image = await boundary.toImage();
                              ByteData byteData = await image.toByteData(
                                  format: ImageByteFormat.png);
                              Uint8List pngBytes =
                                  byteData.buffer.asUint8List();

                              final file = await File(
                                      '$path/${id.toString().padLeft(6, '0')}.png')
                                  .create();
                              await file.writeAsBytes(pngBytes);
                              Flushbar(
                                message: 'QR Save Success!',
                                messageColor: Colors.green,
                                duration: const Duration(seconds: 4),
                                icon: const Icon(
                                  Icons.info_rounded,
                                  color: Colors.green,
                                ),
                              ).show(context);
                            } on FileSystemException catch (e) {
                              Flushbar(
                                title: 'QR Save Faild!',
                                titleColor: Colors.red,
                                message: 'No Permission Granted',
                                messageColor: Colors.red,
                                duration: const Duration(seconds: 4),
                                icon: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ).show(context);
                            } catch (e) {
                              Flushbar(
                                title: 'QR Save Faild!',
                                titleColor: Colors.red,
                                message: 'No Permission Granted',
                                messageColor: Colors.red,
                                duration: const Duration(seconds: 4),
                                icon: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ).show(context);
                            }
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> addGuest(String name, String region, int invNum,
      BuildContext context, StateSetter setter) async {
    setter(() {
      isLoading = true;
    });
    if (invNum == "") invNum = null;
    try {
      var response = await http.post(Uri.parse("$url/add_user.php"), body: {
        'key': accessKey,
        'image': base64Img.toString(),
        'name': name,
        'region': region,
        'invNum': invNum.toString(),
      });
      setter(() {
        isLoading = false;
      });
      //isLoading = false;
      if (response.statusCode == 201) {
        guestBloc.add(ReloadGuest());
        Flushbar(
          message: 'New Guest Added',
          messageColor: Colors.green,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
      } else if (response.statusCode == 422) {
        Flushbar(
          message: 'Invitation No Already Used. Try Another!',
          messageColor: Colors.orange,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.orange,
          ),
        ).show(context);
      } else {
        Flushbar(
          message: 'Insert Failed!',
          messageColor: Colors.red,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      }
    } catch (e) {
      setter(() {
        isLoading = false;
      });
      Flushbar(
        message: 'No Internet Connection!',
        messageColor: Colors.red,
        duration: const Duration(seconds: 4),
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }
  }

  delete(int id) async {
    try {
      var response = await http.post(Uri.parse("$url/delete_guest.php"), body: {
        'key': accessKey,
        'id': id.toString(),
      });
      print(response.statusCode);
      if (response.statusCode == 201) {
        guestBloc.add(ReloadGuest());
        Flushbar(
          message: 'Delete Successfull!',
          messageColor: Colors.orange,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            Icons.info_rounded,
            color: Colors.orange,
          ),
        ).show(context);
      } else {
        Flushbar(
          message: 'Delete Failed!',
          messageColor: Colors.red,
          duration: const Duration(seconds: 4),
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      }
    } catch (e) {
      print("error" + e.toString());
    }
  }
}
