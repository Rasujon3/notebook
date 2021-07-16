import 'package:flutter/material.dart';
import 'package:notebook/constants/constants.dart';
import 'package:notebook/database/database_helper.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/screens/home/widgets/app_bar_title_widget.dart';
import 'package:notebook/utils/custom_toast.dart';
import 'package:notebook/utils/date_formatter.dart';

class NoteUpdatePage extends StatefulWidget {
  final NoteBook noteBook;

  NoteUpdatePage({this.noteBook});

  @override
  _NoteUpdatePageState createState() => _NoteUpdatePageState();
}

class _NoteUpdatePageState extends State<NoteUpdatePage> {
  DatabaseHelper _db;
  String _date;
  TextEditingController _titleController;
  TextEditingController _contentController;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _db = DatabaseHelper();
    _date = DateFormatter.getDateInFormat(
        DateTime.now().toString().substring(0, 10));
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    //  update value
    if (widget.noteBook.title != null && widget.noteBook.title != "") {
      _titleController.text = widget.noteBook.title;
    }

    if (widget.noteBook.content != null && widget.noteBook.content != "") {
      _contentController.text = widget.noteBook.content;
    }

    if (widget.noteBook.date != null && widget.noteBook.date != "") {
      _date = widget.noteBook.date;
    } else {
      _date = DateFormatter.getDateInFormat(
          DateTime.now().toString().substring(0, 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorBlue,
        title: AppBarTitleWidget(
          title: 'Note Update',
          subTitle: '',
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
          child: !isLoading
              ? Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: Colors.grey[50],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Text(
                                        'Note Title*',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 32, right: 32),
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: _titleController,
                                      // enabled: false,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffbcbcbc),
                                          fontFamily: 'NunitoSans',
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff575757),
                                        fontFamily: 'NunitoSans',
                                      ),
                                      showCursor: true,
                                      cursorColor: kColorBlue,
                                      cursorWidth: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.grey[50],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Text(
                                        'Note Content*',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 32, right: 32),
                                    child: TextFormField(
                                      maxLines: null,
                                      controller: _contentController,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffbcbcbc),
                                          fontFamily: 'NunitoSans',
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff575757),
                                        fontFamily: 'NunitoSans',
                                      ),
                                      showCursor: true,
                                      cursorColor: kColorBlue,
                                      cursorWidth: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.grey[50],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Text(
                                        'Note Date*',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 32, right: 32),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(_date),
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime(2050),
                                        ).then((DateTime value) {
                                          if (value != null) {
                                            setState(() {
                                              _date =
                                                  DateFormatter.getDateInFormat(
                                                      value
                                                          .toString()
                                                          .substring(0, 10));
                                            });
                                          }
                                        });
                                      },
                                      trailing:
                                          Icon(Icons.calendar_today_rounded),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: GestureDetector(
                        onTap: () async {
                          if (_titleController.text == "") {
                            CustomToast.toast('Please enter the title');
                          } else if (_contentController.text == "") {
                            CustomToast.toast('Please enter the content');
                          } else if (_date == null) {
                            CustomToast.toast('Please select note date');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            NoteBook note = NoteBook(
                              id: widget.noteBook.id,
                              title: _titleController.text,
                              content: _contentController.text,
                              date: _date,
                            );
                            var isAdded = await _db.updateNote(note);

                            if (isAdded != null) {
                              setState(() {
                                isLoading = false;
                              });
                              CustomToast.toast(
                                  'Note has been successfully updated');
                              Navigator.pop(context, true);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              CustomToast.toast(
                                  'Note can not be update right now');
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: kColorPrimary,
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              'Update Note'.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'Poppins', color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kColorPrimary),
                  ),
                )),
    );
  }
}
