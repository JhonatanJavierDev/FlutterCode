import 'package:flutter/material.dart';
import 'package:catalinadev/model/categories/categories.dart';

class CategoriesModel with ChangeNotifier {
  List<Categories> categories = [
    Categories(
        categories: "Komputer",
        catIcon: "assets/images/home/Category1.png",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        sub: null),
    Categories(
        categories: "Handphone",
        catIcon: "assets/images/home/phone.png",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        sub: [
          Sub(
              icon: "assets/images/home/ion_headset-outline.png",
              iconTittle: "SubCategories1"),
          Sub(
              icon: "assets/images/home/teenyicons_lightning-cable-outline.png",
              iconTittle: "SubCategories2"),
          Sub(
              icon: "assets/images/home/bx_bx-memory-card.png",
              iconTittle: "SubCategories3"),
          Sub(
              icon: "assets/images/home/ic_outline-cable.png",
              iconTittle: "SubCategories4"),
        ]),
    Categories(
        categories: "Restaurant",
        catIcon: "assets/images/home/dashicons_food.png",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        sub: [
          Sub(
              icon: "assets/images/home/ion_headset-outline.png",
              iconTittle: "SubCategories1"),
          Sub(
              icon: "assets/images/home/teenyicons_lightning-cable-outline.png",
              iconTittle: "SubCategories2"),
          Sub(
              icon: "assets/images/home/bx_bx-memory-card.png",
              iconTittle: "SubCategories3"),
          Sub(
              icon: "assets/images/home/ic_outline-cable.png",
              iconTittle: "SubCategories4"),
        ]),
    Categories(
        categories: "Sport",
        catIcon: "assets/images/home/volleyball-ball.png",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        sub: [
          Sub(
              icon: "assets/images/home/ion_headset-outline.png",
              iconTittle: "SubCategories1"),
          Sub(
              icon: "assets/images/home/teenyicons_lightning-cable-outline.png",
              iconTittle: "SubCategories2"),
          Sub(
              icon: "assets/images/home/bx_bx-memory-card.png",
              iconTittle: "SubCategories3"),
          Sub(
              icon: "assets/images/home/ic_outline-cable.png",
              iconTittle: "SubCategories4"),
        ]),
    Categories(
        categories: "Game",
        catIcon: "assets/images/home/carbon_game-console.png",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        sub: [
          Sub(
              icon: "assets/images/home/ion_headset-outline.png",
              iconTittle: "SubCategories1"),
          Sub(
              icon: "assets/images/home/teenyicons_lightning-cable-outline.png",
              iconTittle: "SubCategories2"),
          Sub(
              icon: "assets/images/home/bx_bx-memory-card.png",
              iconTittle: "SubCategories3"),
          Sub(
              icon: "assets/images/home/ic_outline-cable.png",
              iconTittle: "SubCategories4"),
        ]),
    Categories(
        categories: "Apparel",
        catIcon: "assets/images/home/si-glyph_t-shirt.png",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
        sub: [
          Sub(
              icon: "assets/images/home/ion_headset-outline.png",
              iconTittle: "SubCategories1"),
          Sub(
              icon: "assets/images/home/teenyicons_lightning-cable-outline.png",
              iconTittle: "SubCategories2"),
          Sub(
              icon: "assets/images/home/bx_bx-memory-card.png",
              iconTittle: "SubCategories3"),
          Sub(
              icon: "assets/images/home/ic_outline-cable.png",
              iconTittle: "SubCategories4"),
        ]),
  ];

  List<Categories> storeCategoryList = [
    Categories(
      categories: "Audio",
      catIcon: "assets/images/home/Category1.png",
      description: "24 Product",
      sub: null,
    ),
    Categories(
      categories: "Electronic",
      catIcon: "assets/images/home/Category1.png",
      description: "24 Product",
      sub: null,
    ),
    Categories(
      categories: "Gadet",
      catIcon: "assets/images/home/Category1.png",
      description: "24 Product",
      sub: null,
    ),
    Categories(
      categories: "Lorem",
      catIcon: "assets/images/home/Category1.png",
      description: "24 Product",
      sub: null,
    ),
    Categories(
      categories: "All Product",
      catIcon: "assets/images/home/Category1.png",
      description: "1024 Product",
      sub: null,
    ),
  ];
}
