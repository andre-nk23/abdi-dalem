part of 'widgets.dart';

class ListAdderBottomSheet extends StatefulWidget {
  final ColorSelection colorSelectionLocal = new ColorSelection();
  final User currentUser;
  final FirebaseFirestore firestore;
  final DocumentReference toDoCollection;

  ListAdderBottomSheet({this.currentUser, this.firestore, this.toDoCollection});

  @override
  _ListAdderBottomSheetState createState() => _ListAdderBottomSheetState();
}

class _ListAdderBottomSheetState extends State<ListAdderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    TextEditingController listNameController = new TextEditingController();
    String selectedColor;
    Widget errorText;

    return SingleChildScrollView(
      child: BottomSheet(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autofocus: true,
                  controller: listNameController,
                  decoration: InputDecoration(
                      fillColor: HexColor("C4C4C4"),
                      border: InputBorder.none,
                      hintText: "Type task list name...",
                      hintStyle: GoogleFonts.montserrat(
                          color: Theme.of(context).accentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                  style: GoogleFonts.montserrat(
                      color: Theme.of(context).accentColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                  onChanged: (val) {},
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text("Choose your list color",
                    style: GoogleFonts.montserrat(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            widget.colorSelectionLocal.colorSelection.length,
                        itemBuilder: (context, index) {
                          return IconButton(
                            padding: EdgeInsets.all(0),
                            color: HexColor(widget
                                .colorSelectionLocal.colorSelection[index]),
                            icon: Icon(Icons.circle,
                                size:
                                    MediaQuery.of(context).size.height * 0.04),
                            onPressed: () {
                              selectedColor = widget
                                  .colorSelectionLocal.colorSelection[index];
                            },
                          );
                        })),
                errorText ?? Text(''),
                DefaultButton(
                  method: () async {
                    DatabaseServices().createToDoList(context, listNameController.text, selectedColor);
                  },
                  title: "Confirm",
                )
              ],
            ),
          );
        },
        onClosing: () {},
      ),
    );
  }
}
