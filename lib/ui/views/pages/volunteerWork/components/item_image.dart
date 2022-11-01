import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/core/models/volunteer_work.dart';

class ItemImage extends StatelessWidget {
  final VolunteerWork? item;
  const ItemImage({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: item?.image != null
          ? CachedNetworkImage(
              imageUrl: baseUrl + item!.image!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.red,
                ),
              ),
              errorWidget: (context, url, error) => Image.network(
                baseUrl + "/assets/youth/images/noImage.jpg",
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            )
          : Container(
              height: 136,
              child: Image.network(
                baseUrl + "/assets/youth/images/noImage.jpg",
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
    );
  }
}
