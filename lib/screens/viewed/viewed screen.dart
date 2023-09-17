import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:vegetables_app/Widget/Empty%20Screen.dart';
import 'package:vegetables_app/Widget/back%20widget.dart';
import 'package:vegetables_app/Widget/text_widget.dart';
import 'package:vegetables_app/provider/Viewed%20provider.dart';
import 'package:vegetables_app/screens/viewed/view%20widget.dart';
import 'package:vegetables_app/servecis/global%20method.dart';
import 'package:vegetables_app/servecis/utils.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';

  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyScreenState createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProvider>(context);
    final viewedItemsList =
    viewedProvider.getViewedlistItems.values.toList().reversed.toList();
    Color color = Utils(context).color;
    if(viewedItemsList.isEmpty)
      {
        return
          Emptyscreen(
            title:'Your history is empty',
            subtitle:'No products has been viewed yet!',
            buttontext:'Shop now',
            imagepath:'assets/images/history.png',
          );
      }else
        {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    warningDialog(title: 'Empty your history?', subtitle: 'Are you sure?', fct: () {
                      viewedProvider.clearHistory();

                    }, context: context);
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                )
              ],
              leading: const Backwidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: true,
              title: Textwidget(
                text: 'History',
                color: color,
                textsize: 24.0,
              ),
              backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            ),
            body: ListView.builder(
                itemCount:viewedItemsList.length ,
                itemBuilder: (ctx, index) {
                  return Padding
                    (padding:EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                    child:ChangeNotifierProvider.value
                      (
                      value: viewedItemsList[index],
                        child: ViewedRecentlyWidget()
                    ),
                  );
                }),
          );
        }


    }
  }

