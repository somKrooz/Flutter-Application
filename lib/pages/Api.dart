import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'dart:math';

class Kroozer extends StatefulWidget {
  const Kroozer({super.key});

  @override
  State<Kroozer> createState() => _KroozerState();
}

String url =
    "https://c4.wallpaperflare.com/wallpaper/797/173/143/anime-anime-girls-maid-maid-outfit-vertical-hd-wallpaper-preview.jpg";
String artist = "SOM2KROOZ";
var wallpaperLoc = null;

String tag = "SOM KROOZ";
bool? api = false;
bool? nsfw = false;
String description = "krooz is just good";
String imgPath =
    "/storage/emulated/0/Android/data/com.example.kroozer/files/waifu.jpeg";

bool loading = true;

class _KroozerState extends State<Kroozer> {
  @override
  Widget build(BuildContext context) {
    void WaifuAPi() async {
      final parameters = {
        'Accept-Version': 'v5',
        'height': '>=2000',
        'gif': 'false',
        'is_nsfw': "$nsfw",
      };
      final uri = Uri.http("api.waifu.im", "/search", parameters);
      final response = await http.get(uri);
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        url = data['images'][0]['url'];
        tag = data['images'][0]['tags'][0]['name'].toString().toUpperCase();
        description = data['images'][0]['tags'][0]['description']
            .toString()
            .toLowerCase();
        if (data['images'][0]['artist'] != null) {
          artist = data['images'][0]['artist']['name'].toString().toUpperCase();
        } else {
          artist = "KROOZ";
        }
        loading = true;
      });
    }

    void AnotherAPi() async {
      setState(() {
        loading = false;
      });
      final uri = Uri.http("pic.re", "image.json");
      final response = await http.get(uri);
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        url = "https://${data['file_url']}";
        tag = data['tags'][0].toString().toUpperCase();
        description = data['tags'].toString().toUpperCase();

        data["author"] == null
            ? artist = "KROOZ"
            : artist = data["author"].toString().toUpperCase();

        loading = true;
      });
    }

    Future<void> fetchWaifuImage() async {
      setState(() {
        loading = false;
      });
      api == true ? AnotherAPi() : WaifuAPi();
    }

    void getData() async {
      setState(() {
        loading = false;
      });
      var dir = await getExternalStorageDirectory();
      final response = await http.get(Uri.parse(url));
      final List<int> imageData = response.bodyBytes;

      if (dir != null) {
        final file = File("${dir.path}/waifu.jpeg");
        await file.writeAsBytes(imageData);
        setState(() {
          imgPath = "${dir.path}/waifu.jpeg";
        });
      }
      await Future.delayed(const Duration(seconds: 1), () {
        WallpaperManager.setWallpaperFromFile(imgPath, wallpaperLoc);
      });

      setState(() {
        loading = true;
      });
    }

    void download_file(BuildContext context) async {
      setState(() {
        loading = false;
      });
      final res = await FileDownloader.downloadFile(
        url: url,
        onDownloadCompleted: (path) => {
          setState(
            () {
              loading = true;
            },
          ),
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              shape: BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              content: Text('Download Complete..'),
            ),
          )
        },
      );
      if (res != null) {
        return;
      }
    }

    Future displayButtom(BuildContext context) {
      return showModalBottomSheet(
          context: context,
          backgroundColor: const Color.fromARGB(245, 37, 37, 37),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) => Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 17, 17, 17)),
                        onPressed: () {
                          setState(() {
                            wallpaperLoc = WallpaperManager.HOME_SCREEN;
                          });
                          getData();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              content: Text('Setting HomeScreen Wallpaper..'),
                            ),
                          );
                        },
                        child: const Text(
                          "HomeScreen",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 17, 17, 17)),
                        onPressed: () {
                          setState(() {
                            wallpaperLoc = WallpaperManager.LOCK_SCREEN;
                          });
                          getData();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              content: Text('Setting LockScreen Wallpaper..'),
                            ),
                          );
                        },
                        child: const Text(
                          "LockScreen",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 17, 17, 17)),
                        onPressed: () {
                          setState(() {
                            wallpaperLoc = WallpaperManager.BOTH_SCREEN;
                          });
                          getData();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              content: Text('Setting Both Wallpaper..'),
                            ),
                          );
                        },
                        child: const Text(
                          "Both",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ));
    }

    Future cool(BuildContext context) {
      return showModalBottomSheet(
          context: context,
          backgroundColor: const Color.fromARGB(245, 37, 37, 37),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // CheckboxListTile(
                      //   title: const Text(
                      //     "NSFW(works with Api-1)",
                      //     style: TextStyle(
                      //         color: Colors.white, fontWeight: FontWeight.bold),
                      //   ),
                      //   value: nsfw,
                      //   controlAffinity: ListTileControlAffinity.leading,
                      //   onChanged: (value) => {
                      //     setState(() {
                      //       nsfw = value;
                      //     })
                      //   },
                      // ),
                      CheckboxListTile(
                        title: const Text(
                          "API-2",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        value: api,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) => {
                          setState(() {
                            api = value;
                          })
                        },
                      )
                    ],
                  ),
                );
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 29, 29, 29),
          elevation: 5,
          shadowColor: const Color.fromARGB(255, 8, 8, 8),
          title: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: const Text(
              "KROOZER",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
          toolbarHeight: 30),
      body: Container(
        padding: const EdgeInsets.all(15), //----Further
        color: const Color.fromARGB(255, 17, 17, 17),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(10), //--- Main
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 39, 35, 40),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    tag,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Droid Serif',
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 95, 95, 95),
                      ),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        description, //--Description
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ), ////---name
                Container(
                    height: MediaQuery.of(context).size.height / 1.6, //
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: loading
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: Colors.amber,
                              backgroundColor: Color.fromARGB(255, 29, 29, 29),
                              strokeWidth: 5,
                            )
                                // Image.network(
                                //   "https://media1.tenor.com/m/V_0ti1a3_GoAAAAC/loading-azurlane.gif",
                                //   scale: 3,
                                // ),
                                ),
                          )),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "Artist: $artist",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 17, 17, 17)),
                            onPressed: () {
                              fetchWaifuImage();
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 17, 17, 17)),
                            onPressed: () {
                              download_file(context);
                            },
                            child: const Icon(
                              Icons.download,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 17, 17, 17)),
                            onPressed: () {
                              cool(context);
                            },
                            child: const Icon(
                              /////Dev -----Butn
                              Icons.developer_board_off,
                              color: Colors.white,
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 17, 17, 17)),
                            onPressed: () {
                              displayButtom(context);
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
