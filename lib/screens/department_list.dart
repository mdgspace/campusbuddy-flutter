import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DepartmentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Container(),
            leading: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text(
                    "Academic Departments & Centres",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              background: Padding(
                padding: EdgeInsets.all(70),
                child: SvgPicture.asset(
                  'assets/icon.svg',
                  color: Colors.white,
                ),
              ),
            ),
            expandedHeight: 250,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  // elevation: ,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: SvgPicture.asset(
                      'assets/icon.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0XFF3B3B3B),
                    ),
                    title: Text(
                      'Item #$index',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                );
              },
              childCount: 1000,
            ),
          )
        ],
      ),
    );
  }
}
