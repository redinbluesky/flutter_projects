import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';
import '../../restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  }) : super(key: key);

  factory ProductCard.fromModel({required RestaurantProductModel model}) {
    print(model.imgUrl);
    return ProductCard(
        image: Image.network(
          'http://$ip${model.imgUrl}',
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price);
  }

  /*

   */

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image,
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '₩ ${price.toString()}',
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
