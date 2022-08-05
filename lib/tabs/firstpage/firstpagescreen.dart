import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interviewprocess/utils/mycolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apimodel.dart';
import 'apiprovider.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({Key? key}) : super(key: key);

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  bool isLoading = true;
  int selected = -1;
  List<Entry> response1 = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      // do stuff after frame is build
      getdata();
    });
  }

  late Map<String, List<Entry>> categories = {};
  @override
  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getKeys().length > 0) {
      Map<String, List<Entry>> c = {};
      var temp =
          json.decode(pref.getString("categories")!) as Map<String, dynamic>;
      temp.keys.forEach((element) {
        List l = temp[element] as List;
        c[element] = l.map((e) => Entry.fromJson(e)).toList();
        response1.addAll(c[element]!);
      });
      categories = c;
    } else {
      response1 = (await ModelRepo.getModelList())!;
      print(response1.length);
      for (int i = 0; i < response1.length; i++) {
        Entry a = response1.elementAt(i);
        if (categories.containsKey(a.category)) {
          categories[a.category]!.add(a);
        } else {
          categories[a.category] = [a];
        }
      }

      pref.setString("categories", json.encode(categories));
    }
    setState(() {});

    // print(response1![0].api);
    // print(response1[0].description);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Center(child: const Text('OCEAN SOFTWARE')),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getdata();
          },
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addSearchBar(context),
              Expanded(child: buildCard(context)),
            ],
          )),
        ),
      ),
    );
  }

  Widget addSearchBar(BuildContext context) {
    // List<Entry> response1= searchResult.where((s))
    double defaultHeight = MediaQuery.of(context).size.height;
    double defaultWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        color: MyColors.darkblue,
        // height: defaultHeight >= 1024 ? 90.h : 70.h,
        width: defaultWidth,
        child: Card(
            elevation: 1,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),

            child: ListTile(
              // minVerticalPadding: 20.w,
              horizontalTitleGap: 20,
              title: TextField(
                onTap: () {
                  showSearch(context: context, delegate: DataSearch(response1));
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: defaultHeight >= 1024 ? 14 : 17),
                  border: InputBorder.none,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.redAccent,
                  size: 22,
                ),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch(response1));
                },
              ),
            )),
      ),
    );

    //addTabbar();
  }

  Widget buildCard(BuildContext context) {
    var keys = categories.keys;
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body:
            // isLoading
            //     ? Center(child: CircularProgressIndicator()):
            // response1.isEmpty
            //     ? Center(child: Text("No data available"))
            //     :
            SingleChildScrollView(
          child: ListView.separated(
            key: Key('builder ${selected.toString()}'), //attention
            itemCount: keys.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  constraints: BoxConstraints(),
                  // height: 80,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.white,
                        // blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    // elevation: 6,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    child: ExpansionTile(
                      key: Key(index.toString()),
                      initiallyExpanded: index == selected,
                      onExpansionChanged: ((newState) {
                        if (newState)
                          setState(() {
                            // Duration(seconds: 20000);
                            selected = index;
                          });
                        else
                          setState(() {
                            selected = -1;
                          });
                      }),
                      iconColor: Color.fromRGBO(6, 21, 84, 1),
                      collapsedIconColor: Color.fromRGBO(6, 21, 84, 1),
                      expandedCrossAxisAlignment: CrossAxisAlignment.center,
                      expandedAlignment: Alignment.center,
                      title: Text(keys.elementAt(index)),
                      children: categories[keys.elementAt(index)]!
                          .map(
                            (e) => Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(239, 239, 239, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: _buildExpandedRowInternal(e)),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.transparent,
                height: 16,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRow(int index) {
    // displayLoader(context);
    double defalutwidth = MediaQuery.of(context).size.width;
    double defalutheight = MediaQuery.of(context).size.height;
    return response1.isEmpty
        ? Center(child: Text("No data available"))
        : Padding(
            padding: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(response1[index].category),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildExpandedRowInternal(Entry e) {
    double defalutheight = MediaQuery.of(context).size.height;
    double defalutwidth = MediaQuery.of(context).size.width;
    // var email = mList[index].email;
    return Padding(
      // padding: const EdgeInsets.all(20.0),
      padding: EdgeInsets.only(top: 20, bottom: 5, left: 20, right: 10),
      child: Container(
          width: defalutwidth,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 30, width: 250, child: Text(e.api)),
                  SizedBox(
                    height: 2,
                  ),
                  Container(height: 30, width: 250, child: Text(e.description)),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: MyColors.darkgray,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    categories[e.category]!
                        .removeWhere((element) => element.api == e.api);
                  });
                  SharedPreferences.getInstance().then((value) {
                    value.setString("categories", json.encode(categories));
                  });
                },
              ),
            ],
          )),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  DataSearch(this.items);
  late List<Entry> items = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = " ";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: AnimatedIcon(
        size: 30,
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : items
            .where((i) =>
                i.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.access_time),
        title: Text(suggestionList[index].description),
      ),
    );
  }
}
