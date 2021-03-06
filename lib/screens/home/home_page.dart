import 'package:flutter/material.dart';
import 'package:notebook/constants/constants.dart';
import 'package:notebook/database/database_helper.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/provider/home_page_provider.dart';
import 'package:notebook/screens/drawer/drawer_page.dart';
import 'package:notebook/screens/home/widgets/app_bar_title_widget.dart';
import 'package:notebook/screens/note/note_add_page.dart';
import 'package:notebook/screens/note/note_update_page.dart';
import 'package:notebook/utils/custom_toast.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greeting;
  DatabaseHelper _db;
  bool isLoading;
  List<NoteBook> noteList;
  List<NoteBook> storeNoteList;
  String noData;



  @override
  void initState() {
    super.initState();
    noData = "No note available, add new";
    noteList = [];
    storeNoteList = [];
    isLoading = true;
    _db = DatabaseHelper();
    greetings();
    fetchNoteList();
  }

  Future<void> fetchNoteList() async {
    var provider = Provider.of<HomePageProvider>(context, listen: false);
    try {
      var notes = await _db.fetchNoteList();
      if (notes.length > 0) {
        provider.notebooks = notes;
        // setState(() {
        //   noteList.addAll(notes);
        //   storeNoteList.addAll(notes);
        //   isLoading = false;
        // });
      }

      provider.isLoading = false;
    } catch (error) {
      provider.isLoading = false;

      // setState(() {
      //   noteList = [];
      //   isLoading = false;
      // });
    }
  }

  void greetings() {
    var timeOfDay = DateTime.now().hour;

    if (timeOfDay >= 0 && timeOfDay < 6) {
      _greeting = 'Good Night';
    } else if (timeOfDay >= 0 && timeOfDay < 12) {
      _greeting = 'Good Morning';
    } else if (timeOfDay >= 12 && timeOfDay < 16) {
      _greeting = 'Good Afternoon';
    } else if (timeOfDay >= 16 && timeOfDay < 21) {
      _greeting = 'Good Evening';
    } else if (timeOfDay >= 21 && timeOfDay < 24) {
      _greeting = 'Good Night';
    }
  }

  Future<void> showMenuSelection(String value, int id, NoteBook mBook) async {
    var provider = Provider.of<HomePageProvider>(context, listen: false);

    switch (value) {
      case 'Delete':
        // setState(() {
        //   isLoading = true;
        // });
        provider.isLoading = true;

        onDelete(id);
        break;

      case 'Edit':
        bool isUpdate =
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NoteUpdatePage(
            noteBook: mBook,
          );
        }));
        if (isUpdate) {
          // setState(() {
          //   isLoading = false;
          // });
          provider.isLoading = false;


          // setState(() {
          //   isLoading = true;
          // });
          provider.isLoading = true;


          noteList = [];
          fetchNoteList();
        }
        break;
    }
  }

  void onDelete(int id) async {
    var provider = Provider.of<HomePageProvider>(context, listen: false);

    int isDeleted = await _db.deleteNote(id);
    if (isDeleted == 1) {
      CustomToast.toast('Note deleted');
      // setState(() {
      //   isLoading = false;
      // });
      provider.isLoading = false;


      // setState(() {
      //   isLoading = true;
      // });
      provider.isLoading = true;


      noteList = [];
      fetchNoteList();
    } else {
      CustomToast.toast('Note not deleted');
      // setState(() {
      //   isLoading = false;
      // });
      provider.isLoading = false;

    }
  }

  void filterSearchResult(String query) {
    noteList.clear();
    if (query.isNotEmpty) {
      List<NoteBook> newList = [];

      for (NoteBook noteBook in storeNoteList) {
        if (noteBook.title.toLowerCase().contains(query.toLowerCase()) ||
            noteBook.content.toLowerCase().contains(query.toLowerCase()) ||
            noteBook.date.toLowerCase().contains(query.toLowerCase())) {
          newList.add(noteBook);
        } else {
          Container(child: Center(child: Text("No data found")));
        }
      }

      if (newList.length <= 0) {
        setState(() {
          noData = "No data found";
        });
      } else {
        setState(() {
          noteList.addAll(newList);
        });
      }
    } else {
      setState(() {
        noteList.addAll(storeNoteList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 20, bottom: 20),
        child: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.add),
            backgroundColor: kColorPrimary,
            onPressed: () async {
              bool isAdded = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return NoteAddPage();
                }),
              );

              if (isAdded == true) {
                setState(() {
                  noteList = [];
                  isLoading = true;
                });
                fetchNoteList();
              }
            }),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: AppBarTitleWidget(
            title: 'Notebook',
            subTitle: '-365',
          ),
        ),
        drawer: Drawer(
          child: DrawerPage(),
        ),
        body: Consumer<HomePageProvider>(
          builder: (_, mProvider, __) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.menu_book,
                            size: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Hello' + ' Champ ',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              _greeting != null
                                  ? Text(
                                      _greeting,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 15, right: 15),
                            height: 55,
                            child: TextField(
                              onChanged: (value) {
                                filterSearchResult(value);
                              },
                              // controller: _editingController,
                              decoration: InputDecoration(
                                labelText: 'Search',
                                prefixIcon: Icon(Icons.search),
                                fillColor: kColorLight,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide:
                                        BorderSide(color: kColorPrimary)),
                                filled: true,
                                contentPadding: EdgeInsets.only(
                                    bottom: 10.0, left: 10.0, right: 10.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          !mProvider.isLoading
                              ? mProvider.notebooks.contains(null) || mProvider.notebooks.length <= 0
                                  ? Container(
                                      child: Center(child: Text(noData)))
                                  : ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 5,
                                      ),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: mProvider.notebooks.length,
                                      itemBuilder: (context, index) {
                                        return noteListItem(mProvider.notebooks[index]);
                                      },
                                    )
                              : Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kColorPrimary),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding noteListItem(NoteBook noteBook) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: kColorLight,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      noteBook.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      noteBook.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      noteBook.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  showMenuSelection(value, noteBook.id, noteBook);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'Edit',
                      child: ListTile(
                          leading: Icon(Icons.edit), title: Text('Update'))),
                  const PopupMenuItem<String>(
                      value: 'Delete',
                      child: ListTile(
                          leading: Icon(Icons.delete), title: Text('Delete'))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
