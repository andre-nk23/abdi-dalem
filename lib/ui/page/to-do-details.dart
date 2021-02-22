part of "pages.dart";

class ToDoDetails extends StatefulWidget {
  @override
  _ToDoDetailsState createState() => _ToDoDetailsState();

  final String listTitle;
  final String tagColor;

  ToDoDetails({this.listTitle, this.tagColor});
}

class _ToDoDetailsState extends State<ToDoDetails>
    with TickerProviderStateMixin {
  double percentComplete;
  AnimationController animationBar;
  double barPercent = 0.0;
  Tween<double> animT;
  AnimationController scaleAnimation;
  Stream slides;

  // @override
  // void initState() {
  //   scaleAnimation = AnimationController(
  //       vsync: this,
  //       duration: Duration(milliseconds: 1000),
  //       lowerBound: 0.0,
  //       upperBound: 1.0);

  //   // percentComplete = widget.todoObject.percentComplete();
  //   barPercent = percentComplete;
  //   animationBar =
  //       AnimationController(vsync: this, duration: Duration(milliseconds: 100))
  //         ..addListener(() {
  //           setState(() {
  //             barPercent = animT.transform(animationBar.value);
  //           });
  //         });
  //   animT = Tween<double>(begin: percentComplete, end: percentComplete);
  //   scaleAnimation.forward();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   animationBar.dispose();
  //   scaleAnimation.dispose();
  // }

  // void updateBarPercent() async {
  //   double newPercentComplete = widget.todoObject.percentComplete();
  //   if (animationBar.status == AnimationStatus.forward || animationBar.status == AnimationStatus.completed) {
  //     animT.begin = newPercentComplete;
  //     await animationBar.reverse();
  //   } else {
  //     animT.end = newPercentComplete;
  //     await animationBar.forward();
  //   }
  //   percentComplete = newPercentComplete;
  // }

  @override
  Widget build(BuildContext context) {
    List<TaskObject> toDoTasks = Provider.of<List<TaskObject>>(context);
    final List<TaskObject> toDoTasksFiltered = [];

    toDoTasks.forEach((element){
      if(element.completed == true){
        toDoTasksFiltered.add(element);
      }
    });

    return Stack(
      children: [
        Hero(
          tag: "tag" + widget.listTitle,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).backgroundColor,
                mini: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ToDoAdderBottomSheet(widget.listTitle),
                        );
                      });
                },
                child: Container(
                  child: Icon(
                    FlutterIcons.plus_ant,
                    color: Theme.of(context).backgroundColor,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: Offset(3, 5),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      expandedHeight: MediaQuery.of(context).size.height * 0.09,
                      leading: Material(
                        color: Colors.transparent,
                        type: MaterialType.transparency,
                        child: IconButton(
                            icon: Icon(FlutterIcons.ios_arrow_back_ion,
                                color: Theme.of(context).accentColor),
                            onPressed: () {
                              Get.back();
                            }),
                      )),
                  SliverToBoxAdapter(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.005,
                          decoration: BoxDecoration(
                              color: widget.tagColor != null
                                  ? HexColor(widget.tagColor)
                                  : Theme.of(context).primaryColor)),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.03),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ToDoObjectStream(
                              forNumeric: true,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015),
                            Text(
                              "${widget.listTitle}",
                              style: GoogleFonts.montserrat(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: LinearProgressIndicator(
                                    minHeight: MediaQuery.of(context).size.height * 0.01,
                                    value: (toDoTasksFiltered.length / toDoTasks.length),
                                    backgroundColor: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  ),
                                ),
                                Text("${((toDoTasksFiltered.length / toDoTasks.length) * 100).toString().substring(0,2)}%",
                                    style: GoogleFonts.karla().copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025),
                            ToDoObjectStream(
                              listTitle: widget.listTitle,
                              isMinimized: false,
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              )),
        )
      ],
    );
  }
}
