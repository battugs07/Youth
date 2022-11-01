import 'package:flutter/material.dart';

void ImagePopUp(context, Function onDelete, int index) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.delete),
                  title: new Text('Устгах'),
                  onTap: () {
                    onDelete(index);
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      });
}
