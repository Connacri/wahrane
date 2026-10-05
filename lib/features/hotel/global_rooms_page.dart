import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:wahrane/features/hotel/book_page.dart';

class GlobalRooms extends StatefulWidget {
  const GlobalRooms({Key? key}) : super(key: key);

  @override
  _global_roomsState createState() => _global_roomsState();
}

class _global_roomsState extends State<GlobalRooms> {
  late DateTime _selectedDate;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333A47),
      appBar: AppBar(
        title: const Text('Ajouter Une Annonce'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AddBook();
              }));
            },
            icon: const Icon(Icons.add),
          )
        ],
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return IconButton(
        //       icon: const Icon(Icons.add),
        //       onPressed: () {
        //       },
        //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //     );
        //   },
        // ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Calendar Timeline',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.tealAccent[100]),
                ),
              ),
            ),
            CalendarTimeline(
              initialDate: //DateTime.now(),
                  _selectedDate,
              //DateTime(2022, 1, 01),// date de first view
              firstDate: //DateTime.now(),
                  DateTime(2020, 1,
                      22), //date du commencement du calendrier general maximum
              showYears: true,
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              //onDateSelected: (date) => print(date),
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Colors.teal[200],
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotsColor: const Color(0xFF333A47),

              selectableDayPredicate: (date) => date.day != 23,
              locale:
                  'en_ISO', //********************************************en_ISO
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.teal[200])),
                  child: const Text('Aujourd\'hui',
                      style: TextStyle(color: Color(0xFF333A47))),
                  onPressed: () => setState(() => _resetSelectedDate()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('Booking').get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    //  final List<DocumentSnapshot> documents = snapshot.data.docs;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      children: data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 2,
                          semanticContainer: true,
                          color: Colors.white70,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  child: ShaderMask(
                                    shaderCallback: (rect) {
                                      return const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                      ).createShader(Rect.fromLTRB(
                                          0, 0, rect.width, rect.height));
                                    },
                                    blendMode: BlendMode.darken,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: data['themb'],
                                      /*placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(),
                                            ),*/
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  //height: 60,
                                  //color: Colors.black45,

                                  child: ListTile(
                                    title: Text(
                                      data['Name'].toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                    subtitle: Text(
                                      data['Room'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2,
                        semanticContainer: true,
                        color: Colors.white70,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: data['themb'],
                                    /*placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(),
                                            ),*/
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                //height: 60,
                                //color: Colors.black45,

                                child: ListTile(
                                  title: Text(
                                    data['Name'].toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                  subtitle: Text(
                                    data['Room'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
