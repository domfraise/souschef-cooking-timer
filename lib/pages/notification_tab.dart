import 'package:flutter/material.dart';
import 'package:souschef/model/notification_model.dart';

class NotificationTab extends StatelessWidget {
  final List<NotificationModel> notifications;

  final Function onDismissed;

  NotificationTab(this.notifications, this.onDismissed);

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Recent",
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .subhead
                  //     .copyWith(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: FlatButton.icon(
                  icon: Icon(Icons.clear_all),
                  label: Text(
                    "Clear",
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .subhead
                    //     .copyWith(fontSize: 20),
                  ),
                  onPressed: () {
                    while (notifications.isNotEmpty)
                      onDismissed(notifications.first);
                  },
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, i) {
                return Dismissible(
                    key: Key(notifications[i].hashCode.toString()),
                    onDismissed: (DismissDirection direction) {
                      onDismissed(notifications[i]);
                    },
                    child: Card(
                      child: ListTile(
                          leading: Text(DateTime.now()
                                  .difference(notifications[i].happendAt)
                                  .inMinutes
                                  .toString() +
                              "m ago"),
                          subtitle: Text(notifications[i].action),
                          title: Text(notifications[i].title)),
                    ));
              }),
        )
      ],
    ));
  }
}
